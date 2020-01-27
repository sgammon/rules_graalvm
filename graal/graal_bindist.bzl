_graal_archive_internal_prefixs = {
    "darwin-amd64": "graalvm-ce-java{java_version}-{version}/Contents/Home",
    "linux-amd64": "graalvm-ce-java{java_version}-{version}",
}

_graal_version_configs = {
    "19.0.0": {
        "url_template": "https://github.com/oracle/graal/releases/download/vm-{version}/graalvm-{edition}-{platform}-{version}.tar.gz",
        "sha": {
            "8-ce": {
                "darwin-amd64": "fc652566e61b9b774c120da1aea0ae3e28f198d55a297524dcc97b9a83525a79",
                "linux-amd64": "7ad124cdb19cbaa962f6d2f26d1e3eccfeb93afabbf8e81cb65976519f15730c",
            },
        },
    },
    "19.3.1": {
        "url_template": "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/graalvm-{edition}-java{java_version}-{platform}-{version}.tar.gz",
        "sha": {
            "8-ce": {
                "darwin-amd64": "eba3765174f0279ae2dc57c84fc0eb324da778dbfdcc03c6fa8381fe3728aef9",
                "linux-amd64": "815385a1c35a1db54b9b9622059c9e8e5155460f65c3d713e55d3a84222c9194",
            },
            "11-ce": {
                "darwin-amd64": "b3ea6cf6545332f667b2cc742bbff9949d47e49eecea06334d14f0b69aa1a3f3",
                "linux-amd64": "691f0577c75c4ba0fb50916087925e6eb8a5a73de51994a37eee022d1e2c9e7d",
            },
        },
    }
}

_graal_native_image_version_configs = {
    "19.0.0": {
        "url_template": "https://github.com/oracle/graal/releases/download/vm-{version}/native-image-installable-svm-{platform}-{version}.jar",
        "sha": {
            "8": {
                "darwin-amd64": "4fa035b31cfd3d86d464e9a67b652c69a0cceb88c6b2f2ce629c55ca2113c786",
                "linux-amd64": "1c794a3c038f4e6bb90542cf13ba3c6c793dcd193462bf56b8713fd24386e344",
            },
        },
    },
    "19.3.1": {
        "url_template": "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/native-image-installable-svm-java{java_version}-{platform}-{version}.jar",
        "sha": {
            "8": {
                "darwin-amd64": "266d295456dfc588fae52ef2c26cd7e745e6fa0681271e677cad2dd9a1b09461",
                "linux-amd64": "3fd2e5b5299c8ce7c939235b4d01df990aeb236f127f98fbf19b588c521793fa",
            },
            "11": {
                "darwin-amd64": "6bd2bace9773a2ac7ff8182a36f84507678e71f94bf3f0c4646a091100644e13",
                "linux-amd64": "fef2e2c71a5408855026e022ae15fda50cb52769aa7d0ec008837f49196ee16a",
            },
        },
    }
}

def _get_platform(ctx):
    if ctx.os.name == "linux":
        return "linux-amd64"
    elif ctx.os.name == "mac os x":
        return "darwin-amd64"
    else:
        fail("Unsupported operating system: " + ctx.os.name)

def _graal_bindist_repository_impl(ctx):
    platform = _get_platform(ctx)
    version = ctx.attr.version
    java_version = ctx.attr.java_version
    edition = ctx.attr.edition
    url_template_override = ctx.attr.url_template
    fingerprint_overrides = ctx.attr.fingerprints
    format_args = {
        "version": version,
        "platform": platform,
        "java_version": java_version,
        "edition": edition,
    }

    #Download graal
    config = _graal_version_configs[version]
    if edition == "ce":
      if fingerprint_overrides == None:
        sha = config["sha"]["%s-ce" % java_version][platform]
      else:
        sha = fingerprint_overrides[java_version][platform]
      if url_template_override == None:
        urls = [config["url_template"].format(**format_args)]
      else:
        urls = [url_template_override.format(**format_args)]
    elif edition == "ee":
      if fingerprint_overrides == None:
        fail("Must provide fingerprint overrides when using GraalVM EE. Use the `fingerprints={}` arg, " +
             "with keys denoting the Java version ('8', for example).")
      elif url_template_override == None:
        fail("Must provide a custom URL download template for use with GraalVM EE. You can use the format " +
             "variables `version` (GraalVM version), `platform` (OS), `java_version`, and `edition`.")
      sha = fingerprint_overrides[java_version][platform]
      urls = [url_template_override.format(**format_args)]

    archive_internal_prefix = _graal_archive_internal_prefixs[platform].format(**format_args)

    ctx.download_and_extract(
        url = urls,
        sha256 = sha,
        stripPrefix = archive_internal_prefix,
    )

    # download native image
    native_image_config = _graal_native_image_version_configs[version]
    native_image_sha = native_image_config["sha"][java_version][platform]
    native_image_urls = [url.format(**format_args) for url in native_image_config["urls"]]

    ctx.download(
        url = native_image_urls,
        sha256 = native_image_sha,
        output = "native-image-installer.jar"
    )

    exec_result = ctx.execute(["bin/gu", "install", "--local-file", "native-image-installer.jar"], quiet=False)
    if exec_result.return_code != 0:
        fail("Unable to install native image:\n{stdout}\n{stderr}".format(stdout=exec_result.stdout, stderr=exec_result.stderr))

    ctx.file("BUILD", """exports_files(glob(["**/*"]))""")
    ctx.file("WORKSPACE", "workspace(name = \"{name}\")".format(name = ctx.name))

graal_bindist_repository = repository_rule(
    attrs = {
        "version": attr.string(mandatory = True),
        "java_version": attr.string(mandatory = True),
        "edition": attr.string(mandatory = False, default="ce"),
        "url_template": attr.string(mandatory = False),
        "fingerprints": attr.string_dict(mandatory = False),
    },
    implementation = _graal_bindist_repository_impl,
)
