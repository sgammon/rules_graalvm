_graal_urls = [
    "https://github.com/oracle/graal/releases/download/vm-{version}/graalvm-ce-{platform}-{version}.tar.gz",
]

_graal_archive_internal_prefixs = {
    "darwin-amd64": "graalvm-ce-{version}/Contents/Home",
    "linux-amd64": "graalvm-ce-{version}",
}

_graal_version_configs = {
    "19.0.0": {
        "sha": {
            "darwin-amd64": "fc652566e61b9b774c120da1aea0ae3e28f198d55a297524dcc97b9a83525a79",
            "linux-amd64": "7ad124cdb19cbaa962f6d2f26d1e3eccfeb93afabbf8e81cb65976519f15730c",
        },
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
    format_args = {
        "version": version,
        "platform": platform,
    }
    config = _graal_version_configs[version]
    sha = config["sha"][platform]
    urls = [url.format(**format_args) for url in _graal_urls]
    archive_internal_prefix = _graal_archive_internal_prefixs[platform].format(**format_args)

    ctx.download_and_extract(
        url = urls,
        sha256 = sha,
        stripPrefix = archive_internal_prefix,
    )
    exec_result = ctx.execute(["bin/gu", "install", "native-image"], quiet=False)
    if exec_result.return_code != 0:
        fail("Unable to install native image:\n{stdout}\n{stderr}".format(stdout=exec_result.stdout, stderr=exec_result.stderr))

    ctx.file("BUILD", """exports_files(glob(["**/*"]))""")
    ctx.file("WORKSPACE", "workspace(name = \"{name}\")".format(name = ctx.name))

graal_bindist_repository = repository_rule(
    attrs = {
        "version": attr.string(mandatory = True),
    },
    implementation = _graal_bindist_repository_impl,
)
