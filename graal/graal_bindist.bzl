_graal_archive_internal_prefixs = {
    "darwin-amd64": "graalvm-ce-java{java_version}-{version}/Contents/Home",
    "linux-amd64": "graalvm-ce-java{java_version}-{version}",
}

_graal_version_configs = {
    "19.0.0": {
        "urls": ["https://github.com/oracle/graal/releases/download/vm-{version}/graalvm-ce-{platform}-{version}.tar.gz"],
        "sha": {
            "8": {
                "darwin-amd64": "fc652566e61b9b774c120da1aea0ae3e28f198d55a297524dcc97b9a83525a79",
                "linux-amd64": "7ad124cdb19cbaa962f6d2f26d1e3eccfeb93afabbf8e81cb65976519f15730c",
            },
        },
    },
    "19.3.1": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/graalvm-ce-java{java_version}-{platform}-{version}.tar.gz"],
        "sha": {
            "8": {
                "darwin-amd64": "eba3765174f0279ae2dc57c84fc0eb324da778dbfdcc03c6fa8381fe3728aef9",
                "linux-amd64": "815385a1c35a1db54b9b9622059c9e8e5155460f65c3d713e55d3a84222c9194",
            },
            "11": {
                "darwin-amd64": "b3ea6cf6545332f667b2cc742bbff9949d47e49eecea06334d14f0b69aa1a3f3",
                "linux-amd64": "691f0577c75c4ba0fb50916087925e6eb8a5a73de51994a37eee022d1e2c9e7d",
            },
        },
    },
    "20.0.0": {
        "url_template": "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/graalvm-{edition}-java{java_version}-{platform}-{version}.tar.gz",
        "sha": {
            "8-ce": {
                "darwin-amd64": "e3d35fdfe4f62022c42029c052f2b8277b3d896496cf45c2e82d251f5d49701a",
                "linux-amd64": "16ef8d89f014b4d295b7ca0c54343eab3c7d24e18b2d376665f5b12bb643723d",
            },
            "11-ce": {
                "darwin-amd64": "8ba1205bb08cab04f1efc72423674d5816efbc3b22e482709c508788d87a692a",
                "linux-aarch64": "dd230410722d3a7ac25c1318adccddec3f5d85af92aef5906a8e2d755bb2168a",
                "linux-amd64": "d16c4a340a4619d98936754caeb6f49ee7a61d809c5a270e192b91cbc474c726",
            },
        },
    },
    "20.1.0": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/graalvm-ce-java{java_version}-{platform}-{version}.tar.gz"],
        "sha": {
            "8": {
                "darwin-amd64": "3b9fd8ce84c9162a188fde88907c66990db22af0ff6ae2c04430113253a9a634",
                "linux-amd64": "4fac212b37cd548831fd6587dd4d59dc068068815aa20323b47fde9529d6bb6e",
            },
            "11": {
                "darwin-amd64": "04efcb7bdd2e94715d0f3fddcc754594da032887e6aec94a3701bd4774d1a92e",
                "linux-amd64": "18f2dc19652c66ccd5bd54198e282db645ea894d67357bf5e4121a9392fc9394",
            }
        }
    },
}

_graal_native_image_version_configs = {
    "19.0.0": {
        "urls": ["https://github.com/oracle/graal/releases/download/vm-{version}/native-image-installable-svm-{platform}-{version}.jar"],
        "sha": {
            "8": {
                "darwin-amd64": "4fa035b31cfd3d86d464e9a67b652c69a0cceb88c6b2f2ce629c55ca2113c786",
                "linux-amd64": "1c794a3c038f4e6bb90542cf13ba3c6c793dcd193462bf56b8713fd24386e344",
            },
        },
    },
    "19.3.1": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/native-image-installable-svm-java{java_version}-{platform}-{version}.jar"],
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
    },
    "20.0.0": {
        "url_template": "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/native-image-installable-svm-java{java_version}-{platform}-{version}.jar",
        "sha": {
            "8": {
                "darwin-amd64": "e42f59bc774b06ebbd8f7defe4460ac5a84aa20d60676f900c7e83b22ef3d4a5",
                "linux-amd64": "9aee17470ce750eb2454625988c59de86a79b14b811e78085553385bfa7adaff",
            },
            "11": {
                "darwin-amd64": "f7b53adde9c92fe1fac120eb45bb2fe9aab4000bfd9073673d62bcd6b40999af",
                "linux-amd64": "5e110d42a818b14324779b1d3e6ecfc50065ab9cd90e2e6905be5f922500d8c3",
                "linux-aarch64": "a796fcfdf8b01ff1eaf74d5603182b548f39bca0e4c54ca1682db8a2fcc338b7",
            },
        },
    },
    "20.1.0": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/graalvm-ce-java{java_version}-{platform}-{version}.tar.gz"],
        "sha": {
            "8": {
                "darwin-amd64": "3b9fd8ce84c9162a188fde88907c66990db22af0ff6ae2c04430113253a9a634",
                "linux-amd64": "4fac212b37cd548831fd6587dd4d59dc068068815aa20323b47fde9529d6bb6e",
            },
            "11": {
                "darwin-amd64": "04efcb7bdd2e94715d0f3fddcc754594da032887e6aec94a3701bd4774d1a92e",
                "linux-amd64": "18f2dc19652c66ccd5bd54198e282db645ea894d67357bf5e4121a9392fc9394",
            }
        }
    },
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
    format_args = {
        "version": version,
        "platform": platform,
        "java_version": java_version,
    }

    #Download graal
    config = _graal_version_configs[version]
    sha = config["sha"][java_version][platform]
    urls = [url.format(**format_args) for url in config["urls"]]
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
    },
    implementation = _graal_bindist_repository_impl,
)
