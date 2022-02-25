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
    "20.2.0": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/graalvm-ce-java{java_version}-{platform}-{version}.tar.gz"],
        "sha": {
            "8": {
                "darwin-amd64": "a1f524788354cfd2434566f0de972372f4a7743919bae49a9d508f2080385e7b",
                "linux-amd64": "60951c774c708caeebd1fa3886c05aa1260d81c7595ede0c9c3e689be7fcc4e8",
            },
            "11": {
                "darwin-amd64": "e9df2caace6f90fcfbc623c184ef1bbb053de20eb4cf5b002d708c609340ba7a",
                "linux-amd64": "5db74b5b8888712d2ac3cd7ae2a8361c2aa801bc94c801f5839351aba5064e29",
            },
        },
    },
    "21.0.0": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/graalvm-ce-java{java_version}-{platform}-{version}.tar.gz"],
        "sha": {
            "8": {
                "darwin-amd64": "9192d8370b544c0efd36ef744f5933bd2d694d0cc9cb5e7f53d3b7e58f433b3e",
                "linux-amd64": "326c5a9ba2f6a6b28023c1fef9c4c6fb6acf9cd87b0fcb6916e0527633bd01a3",
            },
            "11": {
                "darwin-amd64": "0e6b9af45d0ba40d8e61b16708361f794e17430f5098760bd03584ebcc950fa9",
                "linux-amd64": "4cdb5b9d0142cdaf5565fd20c5cde176d9b7c9dfd278267cab318f64f2923dbc",
            },
        },
    },
    "21.3.0": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/graalvm-ce-java{java_version}-{platform}-{version}.tar.gz"],
        "sha": {
            "11": {
                "darwin-amd64": "6c2bf7f6e5fab901e8a2284a0dbec6ce214bde65aa80cfeb90bfef8eabb5f862",
                "linux-amd64": "3a1bc8eaf0518c128aaacb987ceb0b0e288776f48af630c11c01fd31122d93fa",
            },
            "17": {
                "darwin-amd64": "60236506920cc84a07ea7602f4514d05da2c07c7176e0634652f8a9c5ad677aa",
                "linux-amd64": "11d8039e0a7a31b799a6f20a0e806e4128730e9a2595a7ffdec1443539d4c3f6",
            },
        },
    },
    "22.0.0.2": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/graalvm-ce-java{java_version}-{platform}-{version}.tar.gz"],
        "sha": {
            "11": {
                "darwin-amd64": "8280159b8a66c51a839c8079d885928a7f759d5da0632f3af7300df2b63a6323",
                "linux-aarch64": "1cc0263d95f642dada4e290dca7f49c0456cefa7b690b67e3e5c159b537b2c58",
                "linux-amd64": "bc86083bb7e2778c7e4fe4f55d74790e42255b96f7806a7fefa51d06f3bc7103",
            },
            "17": {
                "darwin-amd64": "d54af9d1f4d0d351827395a714ed84d2489b023b74a9c13a431cc9d31d1e8f9a",
                "linux-aarch64": "c7d78387d2a144944f26773697c1b61d3478a081a1c5e7fc20f47f1f5f3c82c7",
                "linux-amd64": "4f743e0ed3d974b7d619ca2ed6014554e8c12e5ebbb38b9bc9e820b182169bd4",
            },
        },
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
    "20.2.0": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/native-image-installable-svm-java{java_version}-{platform}-{version}.jar"],
        "sha": {
            "8": {
                "darwin-amd64": "4852abafe92e13cb6bf655bba4ba36721b93324ccc6777504f34c70094c583fb",
                "linux-amd64": "6b5403e27282847acce180f0ae9637c3f26678f27047bbd5dfed92a5bef73ab2",
            },
            "11": {
                "darwin-amd64": "d60c321d6e680028f37954121eeebff0839a0a49a4436e5b41c636c3dd951de3",
                "linux-amd64": "92b429939f12434575e4d586f79c5b686d322f29211d1608ed6055a97a35925c",
            },
        },
    },
    "21.0.0": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/native-image-installable-svm-java{java_version}-{platform}-{version}.jar"],
        "sha": {
            "8": {
                "darwin-amd64": "f006e001d195de80cd71b28518f230815b6c00e8d3762148f4b23c09097debc7",
                "linux-amd64": "8f6976b2a9a40d35df50402a3e893af41a6a6bc01301851a91672106d313f842",
            },
            "11": {
                "darwin-amd64": "68d95999312e96c8cd070a8ba1d9724bc4d4fbe03e29da2c392e021a5f393fb5",
                "linux-amd64": "c70b00b4eabcc0140505acab756c394a88be7980634706cce11f53e09658707c",
            },
        },
    },
    "21.3.0": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/native-image-installable-svm-java{java_version}-{platform}-{version}.jar"],
        "sha": {
            "11": {
                "darwin-amd64": "038ac1168b909cfb5e4d6437ee02a5aa8126cbb835aba7a3e6ab72042162e8d5",
                "linux-amd64": "8958d4e0cad07340db0cf9e871776809e2f08fe0c93960f728fec75c4a96764f",
            },
            "17": {
                "darwin-amd64": "80ac09d45f8822413b9f16297da60da196013bbcfbc4bc7721f1257885ebe063",
                "linux-amd64": "df488a04b5405c6443c90e94710cd3bd2be9adcb3768f91429aa494168d52440",
            },
        },
    },
    "22.0.0.2": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/native-image-installable-svm-java{java_version}-{platform}-{version}.jar"],
        "sha": {
            "11": {
                "darwin-amd64": "03c27de6cce61ee8073e89252212457f3fbac2c0bc9bfa4acbff12176476c176",
                "linux-aarch64": "51d41e890a5aabf8e7b9d4f4e0f88206ee70a261f7dbb0315d51770ab8f3009e",
                "linux-amd64": "8504a3441f5b28b8fd625f676674a9216f082ae63a4e30d43930c80f9672e71d",
            },
            "17": {
                "darwin-amd64": "007fa742cd139d447f83d776b6d78e717c9df11d56a61061a5937547c20028b7",
                "linux-aarch64": "798947d0a93988929d2b8e3555f7c65225e789124cd99fbc0c3aae5f350175db",
                "linux-amd64": "8c25f650d58c2649c97061cb806dfaec9e685d5d2b80afc7cf72fe61d6891831",
            },
        },
    }
}

def _get_platform(ctx):
    res = ctx.execute(["uname", "-p"])
    arch = "amd64"
    if res.return_code == 0:
        uname = res.stdout.strip()
        if uname == "arm":
            arch = "arm64"
        elif uname == "aarch64":
            arch = "aarch64"

    if ctx.os.name == "linux":
        return "linux-%s" % arch
    elif ctx.os.name == "mac os x":
        if arch == "arm64" or arch == "aarch64":
            print("GraalVM has no distribution yet for ARM-based macOS. Using `amd64` instead.")
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
        output = "native-image-installer.jar",
    )

    exec_result = ctx.execute(["bin/gu", "install", "--local-file", "native-image-installer.jar"], quiet = False)
    if exec_result.return_code != 0:
        fail("Unable to install native image:\n{stdout}\n{stderr}".format(stdout = exec_result.stdout, stderr = exec_result.stderr))

    ctx.file("BUILD", """exports_files(glob(["**/*"]))""")
    ctx.file("WORKSPACE", "workspace(name = \"{name}\")".format(name = ctx.name))

graal_bindist_repository = repository_rule(
    attrs = {
        "version": attr.string(mandatory = True),
        "java_version": attr.string(mandatory = True),
    },
    implementation = _graal_bindist_repository_impl,
)
