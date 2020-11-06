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
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/native-image-installable-svm-java{java_version}-{platform}-{version}.jar"],
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
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/native-image-installable-svm-java{java_version}-{platform}-{version}.jar"],
        "sha": {
            "8": {
                "darwin-amd64": "a8f975e276485d09d073b3534dcb955cb5e8740292e294cd7a1b4f83c6991e21",
                "linux-amd64": "20dfff539bbae464b6d07303cca6f85534a66344b3bd14dff2bb5d09572b815d",
            },
            "11": {
                "darwin-amd64": "ebf81045af7408e0eddf879f3ccf0171377e219155bbbe78ed9182c2a290b346",
                "linux-amd64": "dfee7b7872bc4448ce6df6732adcd01e2758de1133233dabf921d8e98f5f79c9",
            }
        }
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
            }
        }
    },
}

_graal_wasm_version_configs = {
    "20.1.0": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/wasm-installable-svm-java{java_version}-{platform}-{version}.jar"],
        "sha": {
            "8": {
                "darwin-amd64": "6f1fbe88dbe80dcb658119b692e34bcacefbf884bae18ab49e5d047da6c330b7",
                "linux-amd64": "911ab2f86ac5c797665c6687a54382596f6c563eb3cad9b3a6ba3246f4e92bc5",
            },
            "11": {
                "darwin-amd64": "31a04a9c976fd08c368129a3f727128f7eb33fb3d7faee14df86b453563a01cc",
                "linux-amd64": "cb23ae8f420032359a504b060bb60315b2d0ff20ae096e2d169b8f6edfde15f5",
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

    # download native image JAR
    native_image_config = _graal_native_image_version_configs[version]
    native_image_sha = native_image_config["sha"][java_version][platform]
    native_image_urls = [url.format(**format_args) for url in native_image_config["urls"]]

    # download WASM JAR
    wasm_config = _graal_wasm_version_configs[version]
    wasm_sha = wasm_config["sha"][java_version][platform]
    wasm_urls = [url.format(**format_args) for url in wasm_config["urls"]]

    ctx.download(
        url = native_image_urls,
        sha256 = native_image_sha,
        output = "native-image-installer.jar",
    )

    ctx.download(
        url = wasm_urls,
        sha256 = wasm_sha,
        output = "wasm-installer.jar",
    )

    exec_result = ctx.execute(["bin/gu", "install", "--local-file", "native-image-installer.jar"], quiet=False)
    if exec_result.return_code != 0:
        fail("Unable to install native image:\n{stdout}\n{stderr}".format(stdout=exec_result.stdout, stderr=exec_result.stderr))
    exec_result = ctx.execute(["bin/gu", "install", "--local-file", "wasm-installer.jar"], quiet=False)
    if exec_result.return_code != 0:
        fail("Unable to install WASM tool:\n{stdout}\n{stderr}".format(stdout=exec_result.stdout, stderr=exec_result.stderr))

    ctx.file("BUILD", """exports_files(glob(["**/*"]))""")
    ctx.file("WORKSPACE", "workspace(name = \"{name}\")".format(name = ctx.name))


graal_bindist_repository = repository_rule(
    attrs = {
        "version": attr.string(mandatory = True),
        "java_version": attr.string(mandatory = True),
    },
    implementation = _graal_bindist_repository_impl,
)
