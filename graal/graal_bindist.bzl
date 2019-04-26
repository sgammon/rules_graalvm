_graal_urls = [
    "https://github.com/oracle/graal/releases/download/vm-{version}/graalvm-ce-{version}-{platform}.tar.gz",
]

_graal_archive_internal_prefixs = {
    "macos-amd64": "graalvm-ce-{version}/Contents/Home",
    "linux-amd64": "graalvm-ce-{version}",
}

_graal_version_configs = {
    "1.0.0-rc16": {
        "sha": {
            "macos-amd64": "e464bb24daafc5994412d115a7aa292d3fc3f9826f627832aa18197814bb4fb0",
            "linux-amd64": "2333a2a9a9e2352d4b92acda92f3ff747aa6e1987140300af7c875d82648e904",
        },
    },
}

def _get_platform(ctx):
    if ctx.os.name == "linux":
        return "linux-amd64"
    elif ctx.os.name == "mac os x":
        return "macos-amd64"
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
    ctx.file("BUILD", """exports_files(glob(["**/*"]))""")
    ctx.file("WORKSPACE", "workspace(name = \"{name}\")".format(name = ctx.name))

graal_bindist_repository = repository_rule(
    attrs = {
        "version": attr.string(mandatory = True),
    },
    implementation = _graal_bindist_repository_impl,
)