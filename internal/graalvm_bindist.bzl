"Describes binary distribution coordinates for GraalVM releases."

load(
    "@bazel_skylib//lib:versions.bzl",
    "versions",
)
load(
    "//internal:jdk_build_file.bzl",
    _JDK_BUILD_TEMPLATE = "JDK_BUILD_TEMPLATE",
)

_graal_archive_internal_prefixes = {
    "darwin-amd64": "graalvm-ce-java{java_version}-{version}/Contents/Home",
    "linux-amd64": "graalvm-ce-java{java_version}-{version}",
}

_graal_v2_archive_internal_prefixes = {
    "macos": "Contents/Home",
    "linux": "",
    "windows": "",
}

_graal_version_configs = {
    "19.0.0": {
        "urls": ["https://github.com/oracle/graal/releases/download/vm-{version}/graalvm-ce-{platform}-{version}.tar.gz"],
        "sha256": {
            "8": {
                "darwin-amd64": "fc652566e61b9b774c120da1aea0ae3e28f198d55a297524dcc97b9a83525a79",
                "linux-amd64": "7ad124cdb19cbaa962f6d2f26d1e3eccfeb93afabbf8e81cb65976519f15730c",
            },
        },
    },
    "19.3.1": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/graalvm-ce-java{java_version}-{platform}-{version}.tar.gz"],
        "sha256": {
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
        "sha256": {
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
        "sha256": {
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
        "sha256": {
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
    "22.1.0": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/graalvm-ce-java{java_version}-{platform}-{version}.tar.gz"],
        "sha": {
            "11": {
                "darwin-aarch64": "06bc19a0b1e93aa3df5e15c08e97f8cef624cb6070eeae40a69a51ec7fd41152",
                "darwin-amd64": "c4c9df94ca47b83b582758b87d39042732ba0193fc63f1ab93f6818005a1fe6b",
                "linux-aarch64": "050a4d471247d91935f7f485e92d678f0163e1d6209e26e8fe75d7c924f73e71",
                "linux-amd64": "78c628707007bb97b09562932ee16f50beb1c3fa4a36e4311a0465a4a718e683",
            },
            "17": {
                "darwin-aarch64": "06075cd390bd261721392cd6fd967b1d28c0500d1b5625272ea906038e5cd533",
                "darwin-amd64": "b9327fa73531a822d9a27d25980396353869eefbd73fdcef89b4fceb9f529c75",
                "linux-aarch64": "05128e361ed44beebc89495faaa504b0b975bf93aa5e512e217b3cf5e42dfada",
                "linux-amd64": "f11d46098efbf78465a875c502028767e3de410a31e45d92a9c5cf5046f42aa2",
            },
        },
    },
    "ce-22.3.2": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/graalvm-ce-java{java_version}-{platform}-{version}.tar.gz"],
        "sha256": {
            "11": {
                "macos-x64": "da3c52cc68ce0fb4dcc27dba3c59beadafb7588fec9e9d2812f5bc7c7d00ab63",
                "linux-x64": "0e638d2b7406fabc15a1079fc65431a4f33f6f754da77e4073de8433b40e7c4a",
                "linux-aarch64": "506c99fef656653ccbc57facb9f200303bfcc21ea29679e7391046d0990493da",
                "windows-x64": "ce02ce51f3339895cfeef5afe5e6caf6a61a165534a4995981de837f4da2e3c6",
            },
            "17": {
                "macos-x64": "470d538e34dc168255ee8ceadca74aab4b028ec6c699c4bd8e0226b0a7d3f155",
                "linux-x64": "e5a5868c9b498643fadebfba2040e4d9a19a13ea58ec77cec8d64ab6ee691d1e",
                "windows-x64": "23fcc0ef9d245fc087d2bcefb321d2ef13a87dd10bfc04b2a98c55db7b401732",
            },
        },
    },
    "oracle-17.0.7": {
        "urls": ["https://download.oracle.com/graalvm/{java_version}/archive/graalvm-jdk-{version}_{platform}_bin.tar.gz"],
        "prefix": {
            "macos": "graalvm-jdk-17.0.8+9.1",
            "linux": "graalvm-jdk-17.0.8+9.1",
            "windows": "graalvm-jdk-17.0.8+9.1",
        },
        "sha256": {
            "macos-x64": "325c1c5adce1e8b569e87f1e4dffe852f73e7c25e720ea15977f2ca1d7dba1bb",
            "macos-aarch64": "c73d2917c1b681679d90a7e3851b553c328e4028137e19adb301040fe0d43cfd",
            "linux-x64": "2d6696aa209daa098c51fefc51906aa7bf0dbe28dcc560ef738328352564181b",
            "linux-aarch64": "10cb0b61571befb20bf7c11ac4e10ff4e4801065a64ae425b39f34d401e352b1",
            "windows-x64": "ea90259f08c7e358bed62c2b48d68d295aa7be38ab3cb922d74bab284e717f64",
        },
    },
    "oracle-20.0.1": {
        "urls": ["https://download.oracle.com/graalvm/{java_version}/archive/graalvm-jdk-{version}_{platform}_bin.{archive}"],
        "prefix": {
            "macos": "graalvm-jdk-20.0.1+9.1",
            "linux": "graalvm-jdk-20.0.1+9.1",
            "windows": "graalvm-jdk-20.0.1+9.1",
        },
        "sha256": {
            "macos-x64": "b6f14aae4f9d6a1514446f6f2b83685e796ec083a205b613a9873b29454333ef",
            "macos-aarch64": "b94877df825ccefbe8b6751e087d54aa9b8129f9d2919d29ea18e00900392da1",
            "linux-x64": "0aef42ae97bc98acbd11dce81018a7916250fced6ee9f95a934816813e48e4f4",
            "linux-aarch64": "890596363a864bdbe55c6a9678a87384e62660056b6951c385cceaae4807fbb8",
            "windows-x64": "d5b915df33d0f959d2d51e67eb1bfa94666443b6e66fa5c7be2b4933ece3cf61",
        },
    },
    "oracle-20.0.2": {
        "urls": ["https://download.oracle.com/graalvm/{java_version}/archive/graalvm-jdk-{version}_{platform}_bin.{archive}"],
        "prefix": {
            "macos": "graalvm-jdk-20.0.2+9.1",
            "linux": "graalvm-jdk-20.0.2+9.1",
            "windows": "graalvm-jdk-20.0.2+9.1",
        },
        "sha256": {
            "macos-x64": "72c74c3702437824cba3db3435897cce3643e9443acac59f6cfd43f9444b1004",
            "macos-aarch64": "f1b1068672feef3dc66cba8ccccc14d623b26e284870a156bb10ea3ea51af706",
            "linux-x64": "242862bfd2fd2633950a8d85dd1fb4d0307c35cbc7445089aa593a931c8b17db",
            "linux-aarch64": "890596363a864bdbe55c6a9678a87384e62660056b6951c385cceaae4807fbb8",
            "windows-x64": "3ec83085b54a8de7d0c0ca893d225718cf6ff514f406af6d31a615da63ae9019",
        },
    },
    "oracle-latest": {
        "urls": ["https://download.oracle.com/graalvm/{java_version}/latest/graalvm-jdk-{java_version}_{platform}_bin.{archive}"],
        "prefix": {
            "macos": "graalvm-jdk-{version}",
            "linux": "graalvm-jdk-{version}",
            "windows": "graalvm-jdk-{version}",
        },
        "sha256": {
            "macos-x64": None,
            "macos-aarch64": None,
            "linux-x64": None,
            "linux-aarch64": None,
            "windows-x64": None,
        },
    },
}

_graal_native_image_version_configs = {
    "19.0.0": {
        "urls": ["https://github.com/oracle/graal/releases/download/vm-{version}/native-image-installable-svm-{platform}-{version}.jar"],
        "sha256": {
            "8": {
                "darwin-amd64": "4fa035b31cfd3d86d464e9a67b652c69a0cceb88c6b2f2ce629c55ca2113c786",
                "linux-amd64": "1c794a3c038f4e6bb90542cf13ba3c6c793dcd193462bf56b8713fd24386e344",
            },
        },
    },
    "19.3.1": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/native-image-installable-svm-java{java_version}-{platform}-{version}.jar"],
        "sha256": {
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
        "sha256": {
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
        "sha256": {
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
        "sha256": {
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
    },
    "22.1.0": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/native-image-installable-svm-java{java_version}-{platform}-{version}.jar"],
        "sha": {
            "11": {
                "darwin-aarch64": "21f84ccf7b979dccc9091032fe76b5737b38e0092f282107cef75143dadb3bdb",
                "darwin-amd64": "e0758687f4bd46f15fcee9b0a5bdd65d702ec81c41d465ee7229d3f4465bcf13",
                "linux-aarch64": "12715793b223ce1db7ec7d0a339f0b578a0c9fb6dcc6607044e5af4fd33b25a7",
                "linux-amd64": "36e4a2a9a73a19b03883f9e783bc8bde7c214bb0fa4b617379cb81798de425bf",
            },
            "17": {
                "darwin-aarch64": "beabecdd5b87e7536772d4dfe70abf4c5dd9847e87615464cf309138d21c39af",
                "darwin-amd64": "e6bfe208bb28cd1d98da55e00fa705890a7f69286b919947b07d18cc9bb9c270",
                "linux-aarch64": "6e10f6953ec8b9509c7a7d0194d57f265cf2a05dcb8f3272a6a8e847bda49cda",
                "linux-amd64": "d81eecea15ebbf4f24850860c14104eaf6f8ae74574330e22afac533b8f96738",
            },
        },
    },
    "22.3.2": {
        "urls": ["https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-{version}/native-image-installable-svm-java{java_version}-{platform}-{version}.jar"],
        "sha256": {
            "11": {
                "darwin-amd64": "ae542383b033576e26d0431b0b62b4f7c048fee3b209dad2a257c4ae6345f1fb",
                "linux-amd64": "7093522c446e16e7d3db81fbec858ef487709d6f58fe1ee3b654676629d786aa",
                "linux-aarch64": "6594b5b5558542cd3f30f235967209809924ea2d3fbb75e9a43db7035370416b",
                "windows-amd64": "b6be28b7841a5e1e7221c4dd96e5cd6dfcf5d99152564e08e43f02b4b891982c",
            },
            "17": {
                "darwin-amd64": "f3325ba7fbbcb865c3cc38ee531398482344fae2dd364073391568b0e5b0a77a",
                "linux-amd64": "c70dedcf87f4aad917a5e35a972e7b1bd33f91d4eec35c4dfa4cb4123ad06a2a",
                "linux-aarch64": "20f69183baeabc3270d056f3caa57bdccb3b0ea130e8773725130f2e60184563",
                "windows-amd64": "b6be28b7841a5e1e7221c4dd96e5cd6dfcf5d99152564e08e43f02b4b891982c",
            },
        },
    },
}

_COMPONENTS = struct(**{
    "WASM": "wasm",
    "JS": "js",
    "RUBY": "ruby",
    "PYTHON": "python",
    "ESPRESSO": "espresso",
    "LLVM": "llvm",
})

def _get_platform(ctx, newdist):
    arch_labels = {
        "x86_64": "x64",
        "amd64": "x64",
        "aarch64": "aarch64",
    }
    if not newdist:
        if ctx.os.name == "linux":
            return "linux-amd64"
        elif ctx.os.name == "mac os x":
            return "darwin-amd64"
        else:
            fail("Unsupported operating system: " + ctx.os.name)
    elif ctx.os.name == "linux":
        return ("linux-%s" % (arch_labels[ctx.os.arch] or ctx.os.arch), "linux", "tar.gz")
    elif ctx.os.name == "mac os x":
        return ("macos-%s" % (arch_labels[ctx.os.arch] or ctx.os.arch), "macos", "tar.gz")
    elif "windows" in ctx.os.name:
        return ("windows-%s" % (arch_labels[ctx.os.arch] or ctx.os.arch), "windows", "zip")
    else:
        fail("Unsupported operating system: " + ctx.os.name)

def _check_version(version, java_version, newdist):
    java_version_numeric = int(java_version)
    gvm_version_major = None

    if version != "latest":
        gvm_version_major = int(version.split(".")[0])

    if newdist:
        # rule 1: java less than 17 is not supported in the new distribution
        if java_version_numeric < 17:
            fail("Modern GraalVM distribution not available for Java version: '%s'" % java_version)

    elif gvm_version_major and gvm_version_major > 22:
        fail("Legacy GraalVM distributions not available at version '%s'" % version)

def _toolchain_config_impl(ctx):
    ctx.file("WORKSPACE", "workspace(name = \"{name}\")\n".format(name = ctx.name))
    ctx.file("BUILD.bazel", ctx.attr.build_file)

def _graal_postinstall_actions(ctx, os):
    cmd = "bin/gu"
    if os == "windows":
        cmd = "bin\\gu.cmd"
    if ctx.attr.setup_actions and len(ctx.attr.setup_actions) > 0:
        for action in ctx.attr.setup_actions:
            if not action.startsWith("gu "):
                fail("GraalVM setup action did not start with 'gu'. Please only run GraalVM updater commands.")

            action_cmd = action.replace("gu ", "").split(" ")
            exec_result = ctx.execute([cmd] + action_cmd, quiet = False)
            if exec_result.return_code != 0:
                fail("Unable to run GraalVM setup action '{cmd}':\n{stdout}\n{stderr}".format(
                    cmd = action,
                    stdout = exec_result.stdout,
                    stderr = exec_result.stderr,
                ))

def _relative_binpath(tail, name, tail_override = None):
    tail_fmt = ""
    if len(tail) > 0 or (tail_override != None and len(tail_override) > 0):
        tail_fmt = tail_override or tail
    return "bin/%s%s" % (name, tail_fmt)

def _render_alias(name, actual):
    return """
alias(
    name = "{name}",
    actual = "{actual}",
)
""".format(
        name = name,
        actual = actual,
    )

def _render_bin_alias(name, actual):
    return _render_alias(name, ":bin-%s" % actual)

def _render_bin_target(name, path):
    return """
alias(
    name = "bin-{name}",
    actual = ":{path}",
)
""".format(
        name = name,
        path = path,
    )

def _graal_bindist_repository_impl(ctx):
    if ctx.attr.distribution == None:
        platform, os, archive = _get_platform(ctx, False)
        version = ctx.attr.version
        java_version = ctx.attr.java_version
        format_args = {
            "version": version,
            "platform": platform,
            "java_version": java_version,
            "archive": archive,
        }

        _check_version(ctx.attr.version, ctx.attr.java_version, False)

        # download graal
        config = _graal_version_configs[version]
        sha = config["sha256"][java_version][platform]
        urls = [url.format(**format_args) for url in config["urls"]]
        archive_internal_prefix = _graal_archive_internal_prefixes[platform].format(**format_args)

        ctx.download_and_extract(
            url = urls,
            sha256 = sha,
            stripPrefix = archive_internal_prefix,
        )

        # download native image
        native_image_config = _graal_native_image_version_configs[version]
        native_image_sha = native_image_config["sha256"][java_version][platform]
        native_image_urls = [url.format(**format_args) for url in native_image_config["urls"]]

        ctx.download(
            url = native_image_urls,
            sha256 = native_image_sha,
            output = "native-image-installer.jar",
        )

        cmd = "bin/gu"
        if os == "windows":
            cmd = "bin\\gu.cmd"

        exec_result = ctx.execute([cmd, "install", "--local-file", "native-image-installer.jar"], quiet = False)
        if exec_result.return_code != 0:
            fail("Unable to install native image:\n{stdout}\n{stderr}".format(stdout = exec_result.stdout, stderr = exec_result.stderr))

        ctx.file("BUILD", """exports_files(glob(["**/*"]))""")
        ctx.file("WORKSPACE", "workspace(name = \"{name}\")".format(name = ctx.name))
        _graal_postinstall_actions(ctx, os)

    else:
        platform, os, archive = _get_platform(ctx, True)
        version = ctx.attr.version
        distribution = ctx.attr.distribution
        java_version = ctx.attr.java_version

        # new gvm distribution check
        _check_version(ctx.attr.version, ctx.attr.java_version, True)
        ctx.report_progress("Downloading GraalVM")

        dist_names = {
            "ce": "ce",
            "community": "ce",
            "oracle": "oracle",
            "gvm": "oracle",
        }
        dist_name = dist_names[ctx.attr.distribution]
        if not dist_name:
            fail("Cannot find distribution name for GraalVM: " + ctx.attr.distribution)

        # resolve & download vm
        dist_tag = "{dist}-{version}".format(dist = dist_name, version = ctx.attr.version)
        version = ctx.attr.version
        java_version = ctx.attr.java_version
        format_args = {
            "version": version,
            "platform": platform,
            "java_version": java_version,
            "archive": archive,
        }

        # download graal
        config = _graal_version_configs[dist_tag]
        if platform not in config["sha256"]:
            fail("Platform %s not supported at GraalVM version '%s' (distribution '%s'). Available: %s." % (
                platform,
                version,
                distribution,
                ", ".join(config["sha256"].keys()),
            ))

        sha = None
        if platform in config["sha256"]:
            sha = config["sha256"][platform]
        elif ctx.attr.sha256:
            sha = ctx.attr.sha256

        urls = [url.format(**format_args) for url in config["urls"]]
        prefix = config["prefix"][os]
        archive_internal_prefix = _graal_v2_archive_internal_prefixes[os].format(**format_args)
        effective_prefix = "%s/%s" % (prefix, archive_internal_prefix)

        ctx.download_and_extract(
            url = urls,
            sha256 = sha or ctx.attr.sha256,
            stripPrefix = effective_prefix,
        )

        bin_tail = ""
        shell_tail = ""
        if os == "windows":
            bin_tail = "exe"
            shell_tail = "cmd"

        # pluck `gu` because we need to use it
        gu_cmd = _relative_binpath(bin_tail, "gu", shell_tail)
        _bin_paths = [
            ("gu", gu_cmd),
            ("native-image", _relative_binpath(bin_tail, "native-image", shell_tail)),
            ("java", _relative_binpath(bin_tail, "java")),
            ("javac", _relative_binpath(bin_tail, "javac")),
            ("polyglot", _relative_binpath(bin_tail, "polyglot")),
            ("js", _relative_binpath(bin_tail, "js")),
        ]

        _conditional_paths = [
            (_COMPONENTS.WASM, "wasm", _relative_binpath(bin_tail, "wasm")),
            (_COMPONENTS.PYTHON, "python", _relative_binpath(bin_tail, "python")),
            (_COMPONENTS.RUBY, "ruby", _relative_binpath(bin_tail, "ruby")),
            (_COMPONENTS.LLVM, "lli", _relative_binpath(bin_tail, "lli")),
        ]

        all_components = []
        if ctx.attr.components and len(ctx.attr.components) > 0:
            ctx.report_progress("Downloading GraalVM components")
            exec_result = ctx.execute([gu_cmd, "install"] + ctx.attr.components, quiet = False)
            if exec_result.return_code != 0:
                fail("Unable to install GraalVM components:\n{stdout}\n{stderr}".format(stdout = exec_result.stdout, stderr = exec_result.stderr))

            all_components.extend(ctx.attr.components)
            _bin_paths.extend(
                [(n, v) for (k, n, v) in _conditional_paths if k in all_components]
            )

        if ctx.name in ["native-image", "toolchain_native_image", "toolchain_gvm", "entry", "bootstrap_runtime_toolchain", "toolchain", "jdk", "jre", "jre-lib"]:
            fail("Cannot use name '%s' for repository name: It will clash with other targets" % ctx.name)

        ctx_alias = ctx.name
        if ctx.name == "graalvm":
            ctx_alias = "gvm_entry"

        ## render bin targets and aliases
        rendered_bin_targets = "\n".join([_render_bin_target(n, p) for (n, p) in _bin_paths])
        rendered_bin_aliases = "\n".join([_render_bin_alias(n, n) for (n, p) in _bin_paths])

        bootstrap_toolchain_alias = """
alias(
    name = "bootstrap_runtime_toolchain",
    actual = "@{repo}//:bootstrap_runtime_toolchain",
    visibility = ["//visibility:public"],
)
""".format(
            repo = ctx.attr.toolchain_config,
        )

        # if we're running on Bazel before 7, we need to omit the bootstrap toolchain, because
        # it doesn't yet exist in Bazel's internals.
        if not versions.is_at_least("7", versions.get()):
            bootstrap_toolchain_alias = ""

        toolchain_aliases_template = """
# Entry Aliases
alias(
    name = "entry",
    actual = ":bin/java",
)
alias(
    name = "graalvm",
    actual = ":entry",
)
alias(
    name = "{name}",
    actual = ":entry",
)

# Toolchains
alias(
    name = "toolchain",
    actual = "@{repo}//:toolchain",
    visibility = ["//visibility:public"],
)
{bootstrap_toolchain_alias}
alias(
    name = "toolchain_gvm",
    actual = "@{repo}//:gvm",
    visibility = ["//visibility:public"],
)
alias(
    name = "toolchain_native_image",
    actual = "@{repo}//:native_image",
    visibility = ["//visibility:public"],
)

# Tool Aliases
{rendered_bin_aliases}
        """.format(
            name = ctx_alias,
            repo = ctx.attr.toolchain_config,
            bootstrap_toolchain_alias = bootstrap_toolchain_alias,
            rendered_bin_aliases = rendered_bin_aliases,
        )

        ctx.file(
            "BUILD.bazel",
            """
exports_files(glob(["**/*"]))

# Tool Targets
{rendered_bin_targets}

# Toolchain
{toolchain}

# Aliases
{aliases}
""".format(
            toolchain = _JDK_BUILD_TEMPLATE.format(RUNTIME_VERSION = java_version),
            aliases = ctx.attr.enable_toolchain and toolchain_aliases_template or "",
            rendered_bin_targets = rendered_bin_targets,
        ))

        ctx.file("WORKSPACE.bazel", """
workspace(name = \"{name}\")
""".format(name = ctx.name))

        _graal_postinstall_actions(ctx, os)
        # Done.

_graalvm_bindist_repository = repository_rule(
    attrs = {
        "version": attr.string(mandatory = True),
        "java_version": attr.string(mandatory = True),
        "distribution": attr.string(mandatory = False),
        "toolchain_prefix": attr.string(mandatory = False),
        "components": attr.string_list(mandatory = False),
        "setup_actions": attr.string_list(mandatory = False),
        "enable_toolchain": attr.bool(mandatory = False),
        "toolchain_config": attr.string(mandatory = True),
        "sha256": attr.string(mandatory = False),
    },
    implementation = _graal_bindist_repository_impl,
)

_toolchain_config = repository_rule(
    local = True,
    implementation = _toolchain_config_impl,
    attrs = {
        "build_file": attr.string(),
    },
)

def graalvm_repository(
        name,
        java_version,
        version = "latest",
        distribution = "oracle",
        toolchain = True,
        toolchain_prefix = "graalvm",
        target_compatible_with = [],
        components = [],
        setup_actions = [],
        register_all = False,
        **kwargs):
    """Declare a GraalVM distribution repository, and optionally a Java toolchain to match.

    To register and use the GraalVM distribution as a toolchain, follow the Toolchains guide in the docs
    (`docs/toolchain.md`).

    If `distribution` is set to `oracle`, an Oracle GraalVM installation is downloaded. This variant of
    GraalVM may be subject to different license obligations; please consult Oracle's docs for more info.

    Oracle GraalVM distributions are downloaded directly from Oracle, which provides a `latest` download
    endpoint. Set `version` to `latest` (the default value) to download the latest available version of
    GraalVM matching the provided `java_version`.

    When installing the `latest` version of GraalVM, it is probably ideal to provide your own `sha256`.
    In this case, the `rules_graalvm` package does not provide an SHA256 hash otherwise.

    Args:
        name: Name of the VM repository.
        java_version: Java version to use/declare.
        version: Version of the GraalVM release.
        distribution: Which GVM distribution to download - `ce`, `community`, or `oracle`.
        toolchain: Whether to create a Java toolchain from this GVM installation.
        toolchain_prefix: Name prefix to use for the toolchain; defaults to `graalvm`.
        target_compatible_with: Compatibility tags to apply.
        components: Components to install in the target GVM installation.
        setup_actions: GraalVM Updater commands that should be run; pass complete command strings that start with "gu".
        register_all: Register all GraalVM repositories and use `target_compatible_with` (experimental).
        **kwargs: Passed to the underlying bindist repository rule.
    """

    # if we're running on Bazel before 7, we need to omit the bootstrap toolchain, because
    # it doesn't yet exist in Bazel's internals.
    bootstrap_runtime_toolchain = ""
    if versions.is_at_least("7", versions.get()):
        bootstrap_runtime_toolchain = """
toolchain(
    name = "bootstrap_runtime_toolchain",
    # These constraints are not required for correctness, but prevent fetches of remote JDK for
    # different architectures. As every Java compilation toolchain depends on a bootstrap runtime in
    # the same configuration, this constraint will not result in toolchain resolution failures.
    exec_compatible_with = {target_compatible_with},
    target_settings = [":version_or_prefix_version_setting"],
    toolchain_type = "@bazel_tools//tools/jdk:bootstrap_runtime_toolchain_type",
    toolchain = "{toolchain}",
    visibility = ["//visibility:public"],
)
""".format(
            prefix = toolchain_prefix or "graalvm",
            version = java_version,
            target_compatible_with = target_compatible_with,
            toolchain = "@{repo}//:jdk".format(repo = name),
        )

    if toolchain:
        _toolchain_config(
            name = name + "_toolchain_config_repo",
            build_file = """
config_setting(
    name = "prefix_version_setting",
    values = {{"java_runtime_version": "{prefix}_{version}"}},
    visibility = ["//visibility:private"],
)
config_setting(
    name = "version_setting",
    values = {{"java_runtime_version": "{version}"}},
    visibility = ["//visibility:private"],
)
alias(
    name = "version_or_prefix_version_setting",
    actual = select({{
        ":version_setting": ":version_setting",
        "//conditions:default": ":prefix_version_setting",
    }}),
    visibility = ["//visibility:private"],
)
toolchain(
    name = "gvm",
    target_compatible_with = {target_compatible_with},
    target_settings = [":version_or_prefix_version_setting"],
    toolchain_type = "@rules_graalvm//graalvm/toolchain:graalvm",
    toolchain = "{toolchain}",
    visibility = ["//visibility:public"],
)
toolchain(
    name = "native_image",
    target_compatible_with = {target_compatible_with},
    target_settings = [":version_or_prefix_version_setting"],
    toolchain_type = "@rules_graalvm//graalvm/toolchain:graalvm_native_image",
    toolchain = "{toolchain}",
    visibility = ["//visibility:public"],
)
toolchain(
    name = "toolchain",
    target_compatible_with = {target_compatible_with},
    target_settings = [":version_or_prefix_version_setting"],
    toolchain_type = "@bazel_tools//tools/jdk:runtime_toolchain_type",
    toolchain = "{toolchain}",
    visibility = ["//visibility:public"],
)
{bootstrap_runtime_toolchain}
""".format(
                prefix = toolchain_prefix or "graalvm",
                version = java_version,
                target_compatible_with = target_compatible_with,
                toolchain = "@{repo}//:jdk".format(repo = name),
                bootstrap_runtime_toolchain = bootstrap_runtime_toolchain,
            ),
        )

    if not register_all:
        # register a specific GraalVM version at the host OS/arch pair
        _graalvm_bindist_repository(
            name = name,
            version = version,
            java_version = java_version,
            distribution = distribution,
            components = components,
            setup_actions = setup_actions,
            enable_toolchain = toolchain,
            toolchain_config = "%s_toolchain_config_repo" % name,
            **kwargs
        )
    else:
        fail("GraalVM rules `register_all` is not supported yet.")
