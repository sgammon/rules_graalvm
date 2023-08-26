resolved = [
     {
          "original_rule_class": "@com_grail_bazel_toolchain//toolchain:rules.bzl%toolchain",
          "definition_information": "Repository llvm instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:115:19: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/com_grail_bazel_toolchain/toolchain/rules.bzl:300:14: in llvm_toolchain\nRepository rule toolchain defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/com_grail_bazel_toolchain/toolchain/rules.bzl:272:28: in <toplevel>\n",
          "original_attributes": {
               "name": "llvm",
               "generator_name": "llvm",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "toolchain_roots": {
                    "": "@llvm_llvm//"
               },
               "llvm_versions": {
                    "": "15.0.6"
               }
          },
          "repositories": [
               {
                    "rule_class": "@com_grail_bazel_toolchain//toolchain:rules.bzl%toolchain",
                    "attributes": {
                         "name": "llvm",
                         "generator_name": "llvm",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "toolchain_roots": {
                              "": "@llvm_llvm//"
                         },
                         "llvm_versions": {
                              "": "15.0.6"
                         }
                    },
                    "output_tree_hash": "b8c1a4978e94a4d2beec0ed91b6f5d813a768a534aebd6011e69f5beed349ad2"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk11_linux_aarch64_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:532:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:205:10: in remote_jdk11_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk11_linux_aarch64_toolchain_config_repo",
               "generator_name": "remotejdk11_linux_aarch64_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_linux_aarch64//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk11_linux_aarch64_toolchain_config_repo",
                         "generator_name": "remotejdk11_linux_aarch64_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_linux_aarch64//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "f817d64408c5484cf564d5fdc24f11c3f601835818645f6de7ab4c56eaf4056f"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk11_win_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:532:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:285:10: in remote_jdk11_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk11_win_toolchain_config_repo",
               "generator_name": "remotejdk11_win_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_win//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk11_win_toolchain_config_repo",
                         "generator_name": "remotejdk11_win_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_win//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "f6c7a48666a77c098017285e46d511074ce3de7ff4e9808bc592fd49228681b2"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk11_macos_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:532:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:253:10: in remote_jdk11_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk11_macos_toolchain_config_repo",
               "generator_name": "remotejdk11_macos_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_macos//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk11_macos_toolchain_config_repo",
                         "generator_name": "remotejdk11_macos_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_macos//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "4b40216fabc2f6c17810749b3bf713065a39e05ff547dac45c395be6391709af"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk11_linux_ppc64le_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:532:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:221:10: in remote_jdk11_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk11_linux_ppc64le_toolchain_config_repo",
               "generator_name": "remotejdk11_linux_ppc64le_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:ppc\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_linux_ppc64le//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk11_linux_ppc64le_toolchain_config_repo",
                         "generator_name": "remotejdk11_linux_ppc64le_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:ppc\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_linux_ppc64le//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "b5938368c9f92a6f5045ffca11214afb8ec9256686bec9245714376aa66b67d1"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk11_linux_s390x_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:532:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:237:10: in remote_jdk11_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk11_linux_s390x_toolchain_config_repo",
               "generator_name": "remotejdk11_linux_s390x_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:s390x\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_linux_s390x//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk11_linux_s390x_toolchain_config_repo",
                         "generator_name": "remotejdk11_linux_s390x_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:s390x\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_linux_s390x//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "10df692cd4259131687761221fcb989c660f1c6e9376feba066b4fdc80bdc048"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk11_macos_aarch64_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:532:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:269:10: in remote_jdk11_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk11_macos_aarch64_toolchain_config_repo",
               "generator_name": "remotejdk11_macos_aarch64_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_macos_aarch64//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk11_macos_aarch64_toolchain_config_repo",
                         "generator_name": "remotejdk11_macos_aarch64_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_macos_aarch64//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "a762e337f24b8b511c520c1101b81cc02082e3fd25e58140dfa47eb7342161ce"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk11_linux_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:532:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:189:10: in remote_jdk11_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk11_linux_toolchain_config_repo",
               "generator_name": "remotejdk11_linux_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_linux//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk11_linux_toolchain_config_repo",
                         "generator_name": "remotejdk11_linux_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_linux//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "8e1033ec85367ff2067aa4aa175c76d9cab0f81b9d0d4f10b7743e953331b892"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk17_macos_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:533:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:382:10: in remote_jdk17_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk17_macos_toolchain_config_repo",
               "generator_name": "remotejdk17_macos_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_macos//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk17_macos_toolchain_config_repo",
                         "generator_name": "remotejdk17_macos_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_macos//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "8fc6087c6e654d2ff8ce626db7d0902fcf08d111f3c9f737ab19355b67d59c80"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk17_linux_s390x_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:533:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:350:10: in remote_jdk17_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk17_linux_s390x_toolchain_config_repo",
               "generator_name": "remotejdk17_linux_s390x_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:s390x\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_linux_s390x//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk17_linux_s390x_toolchain_config_repo",
                         "generator_name": "remotejdk17_linux_s390x_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:s390x\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_linux_s390x//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "b862fb5fa8587c3b1443eeb858a974af46c3f71ad339147f857e37697dd06bc8"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk17_linux_ppc64le_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:533:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:366:10: in remote_jdk17_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk17_linux_ppc64le_toolchain_config_repo",
               "generator_name": "remotejdk17_linux_ppc64le_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:ppc\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_linux_ppc64le//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk17_linux_ppc64le_toolchain_config_repo",
                         "generator_name": "remotejdk17_linux_ppc64le_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:ppc\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_linux_ppc64le//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "34ebbe42ccc37481247f25b20d1e441017040d2b65a2fd6282c94fe58e17b11c"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk17_linux_aarch64_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:533:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:334:10: in remote_jdk17_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk17_linux_aarch64_toolchain_config_repo",
               "generator_name": "remotejdk17_linux_aarch64_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_linux_aarch64//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk17_linux_aarch64_toolchain_config_repo",
                         "generator_name": "remotejdk17_linux_aarch64_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_linux_aarch64//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "57763b4c6342c2729b70ccf1676a75726a4775a6e6468c86462f7247c968ecd7"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk11_win_arm64_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:532:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:301:10: in remote_jdk11_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk11_win_arm64_toolchain_config_repo",
               "generator_name": "remotejdk11_win_arm64_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:arm64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_win_arm64//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk11_win_arm64_toolchain_config_repo",
                         "generator_name": "remotejdk11_win_arm64_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:arm64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_win_arm64//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "383e78f7a5b828401c8b5a470bc3676797a189fe9641856f243c35e282e4384c"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk17_linux_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:533:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:318:10: in remote_jdk17_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk17_linux_toolchain_config_repo",
               "generator_name": "remotejdk17_linux_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_linux//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk17_linux_toolchain_config_repo",
                         "generator_name": "remotejdk17_linux_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_linux//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "9cd805ebc7702094002f5373bee54fb0b9bba1ece881b83ff48c0586ddaa10d5"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk20_linux_aarch64_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:534:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:462:10: in remote_jdk20_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk20_linux_aarch64_toolchain_config_repo",
               "generator_name": "remotejdk20_linux_aarch64_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_linux_aarch64//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk20_linux_aarch64_toolchain_config_repo",
                         "generator_name": "remotejdk20_linux_aarch64_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_linux_aarch64//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "46c1e8ce83320d997156077b209ecbd9a9dc964fcc68b1d0a920597904267819"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk20_linux_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:534:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:446:10: in remote_jdk20_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk20_linux_toolchain_config_repo",
               "generator_name": "remotejdk20_linux_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_linux//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk20_linux_toolchain_config_repo",
                         "generator_name": "remotejdk20_linux_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_linux//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "56bca5eb20b42c86545caa59487effc162066b25be5aba05fe08c6ef9eccec90"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk17_win_arm64_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:533:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:428:10: in remote_jdk17_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk17_win_arm64_toolchain_config_repo",
               "generator_name": "remotejdk17_win_arm64_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:arm64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_win_arm64//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk17_win_arm64_toolchain_config_repo",
                         "generator_name": "remotejdk17_win_arm64_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:arm64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_win_arm64//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "78dfb0f7dab651cbc675d9dfe42e28b363ec26c3e5dc9a57b94833852f91deda"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk17_win_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:533:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:413:10: in remote_jdk17_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk17_win_toolchain_config_repo",
               "generator_name": "remotejdk17_win_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_win//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk17_win_toolchain_config_repo",
                         "generator_name": "remotejdk17_win_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_win//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "224a8c9f9e2f5e5cbb9efff01aa2555019675d3e1c9b93a7b4a83dfd7f5b69d5"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk17_macos_aarch64_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:533:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:398:10: in remote_jdk17_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk17_macos_aarch64_toolchain_config_repo",
               "generator_name": "remotejdk17_macos_aarch64_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_macos_aarch64//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk17_macos_aarch64_toolchain_config_repo",
                         "generator_name": "remotejdk17_macos_aarch64_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_macos_aarch64//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "f698cb98820064a11248ba634c70c6df5b57382ee5f8a1b589007e5b73bfc6f8"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk20_win_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:534:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:509:10: in remote_jdk20_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk20_win_toolchain_config_repo",
               "generator_name": "remotejdk20_win_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_win//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk20_win_toolchain_config_repo",
                         "generator_name": "remotejdk20_win_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_win//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "26b81f5d62d1f237e048bc644d1d296d25e734b296b4f34803d65d7c22d2a6ca"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk20_macos_aarch64_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:534:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:494:10: in remote_jdk20_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk20_macos_aarch64_toolchain_config_repo",
               "generator_name": "remotejdk20_macos_aarch64_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_macos_aarch64//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk20_macos_aarch64_toolchain_config_repo",
                         "generator_name": "remotejdk20_macos_aarch64_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_macos_aarch64//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "5f488c8a476c60416d448aeb8569983551ce721d393672cf3dee5df7ab26ff61"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk20_macos_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:534:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:478:10: in remote_jdk20_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "remotejdk20_macos_toolchain_config_repo",
               "generator_name": "remotejdk20_macos_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_macos//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "remotejdk20_macos_toolchain_config_repo",
                         "generator_name": "remotejdk20_macos_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_macos//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "b97edafaf14ed9ce2a1dea71573717a626126e3073cac8b3f1db2e0c6fa0a43c"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:local_java_repository.bzl%_local_java_repository_rule",
          "definition_information": "Repository local_jdk instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:145:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:531:19: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:76:10: in local_jdk_repo\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/local_java_repository.bzl:286:32: in local_java_repository\nRepository rule _local_java_repository_rule defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/local_java_repository.bzl:250:46: in <toplevel>\n",
          "original_attributes": {
               "name": "local_jdk",
               "generator_name": "local_jdk",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file_content": "load(\"@rules_java//java:defs.bzl\", \"java_runtime\")\n\npackage(default_visibility = [\"//visibility:public\"])\n\nexports_files([\"WORKSPACE\", \"BUILD.bazel\"])\n\nfilegroup(\n    name = \"jre\",\n    srcs = glob(\n        [\n            \"jre/bin/**\",\n            \"jre/lib/**\",\n        ],\n        allow_empty = True,\n        # In some configurations, Java browser plugin is considered harmful and\n        # common antivirus software blocks access to npjp2.dll interfering with Bazel,\n        # so do not include it in JRE on Windows.\n        exclude = [\"jre/bin/plugin2/**\"],\n    ),\n)\n\nfilegroup(\n    name = \"jdk-bin\",\n    srcs = glob(\n        [\"bin/**\"],\n        # The JDK on Windows sometimes contains a directory called\n        # \"%systemroot%\", which is not a valid label.\n        exclude = [\"**/*%*/**\"],\n    ),\n)\n\n# This folder holds security policies.\nfilegroup(\n    name = \"jdk-conf\",\n    srcs = glob(\n        [\"conf/**\"],\n        allow_empty = True,\n    ),\n)\n\nfilegroup(\n    name = \"jdk-include\",\n    srcs = glob(\n        [\"include/**\"],\n        allow_empty = True,\n    ),\n)\n\nfilegroup(\n    name = \"jdk-lib\",\n    srcs = glob(\n        [\"lib/**\", \"release\"],\n        allow_empty = True,\n        exclude = [\n            \"lib/missioncontrol/**\",\n            \"lib/visualvm/**\",\n        ],\n    ),\n)\n\njava_runtime(\n    name = \"jdk\",\n    srcs = [\n        \":jdk-bin\",\n        \":jdk-conf\",\n        \":jdk-include\",\n        \":jdk-lib\",\n        \":jre\",\n    ],\n    version = {RUNTIME_VERSION},\n)\n",
               "java_home": "",
               "version": ""
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:local_java_repository.bzl%_local_java_repository_rule",
                    "attributes": {
                         "name": "local_jdk",
                         "generator_name": "local_jdk",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file_content": "load(\"@rules_java//java:defs.bzl\", \"java_runtime\")\n\npackage(default_visibility = [\"//visibility:public\"])\n\nexports_files([\"WORKSPACE\", \"BUILD.bazel\"])\n\nfilegroup(\n    name = \"jre\",\n    srcs = glob(\n        [\n            \"jre/bin/**\",\n            \"jre/lib/**\",\n        ],\n        allow_empty = True,\n        # In some configurations, Java browser plugin is considered harmful and\n        # common antivirus software blocks access to npjp2.dll interfering with Bazel,\n        # so do not include it in JRE on Windows.\n        exclude = [\"jre/bin/plugin2/**\"],\n    ),\n)\n\nfilegroup(\n    name = \"jdk-bin\",\n    srcs = glob(\n        [\"bin/**\"],\n        # The JDK on Windows sometimes contains a directory called\n        # \"%systemroot%\", which is not a valid label.\n        exclude = [\"**/*%*/**\"],\n    ),\n)\n\n# This folder holds security policies.\nfilegroup(\n    name = \"jdk-conf\",\n    srcs = glob(\n        [\"conf/**\"],\n        allow_empty = True,\n    ),\n)\n\nfilegroup(\n    name = \"jdk-include\",\n    srcs = glob(\n        [\"include/**\"],\n        allow_empty = True,\n    ),\n)\n\nfilegroup(\n    name = \"jdk-lib\",\n    srcs = glob(\n        [\"lib/**\", \"release\"],\n        allow_empty = True,\n        exclude = [\n            \"lib/missioncontrol/**\",\n            \"lib/visualvm/**\",\n        ],\n    ),\n)\n\njava_runtime(\n    name = \"jdk\",\n    srcs = [\n        \":jdk-bin\",\n        \":jdk-conf\",\n        \":jdk-include\",\n        \":jdk-lib\",\n        \":jre\",\n    ],\n    version = {RUNTIME_VERSION},\n)\n",
                         "java_home": "",
                         "version": ""
                    },
                    "output_tree_hash": "6c1cc6c19afddcd1ba1b080dc512f19f6442d68f702560638ef03686275aea54"
               }
          ]
     },
     {
          "original_rule_class": "//internal:graalvm_bindist.bzl%_toolchain_config",
          "definition_information": "Repository graalvm_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:155:23: in _setup_rules_graalvm_repositories\n  /Volumes/VAULTROOM/rules_graalvm/graalvm/repositories.bzl:50:24: in graalvm_repository\n  /Volumes/VAULTROOM/rules_graalvm/internal/graalvm_bindist.bzl:649:26: in graalvm_repository\nRepository rule _toolchain_config defined at:\n  /Volumes/VAULTROOM/rules_graalvm/internal/graalvm_bindist.bzl:576:36: in <toplevel>\n",
          "original_attributes": {
               "name": "graalvm_toolchain_config_repo",
               "generator_name": "graalvm_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"graalvm_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"gvm\",\n    target_compatible_with = [],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@rules_graalvm//graalvm/toolchain:toolchain\",\n    toolchain = \"@graalvm//:jdk\",\n    visibility = [\"//visibility:public\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@graalvm//:jdk\",\n    visibility = [\"//visibility:public\"],\n)\n\ntoolchain(\n    name = \"bootstrap_runtime_toolchain\",\n    # These constraints are not required for correctness, but prevent fetches of remote JDK for\n    # different architectures. As every Java compilation toolchain depends on a bootstrap runtime in\n    # the same configuration, this constraint will not result in toolchain resolution failures.\n    exec_compatible_with = [],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:bootstrap_runtime_toolchain_type\",\n    toolchain = \"@graalvm//:jdk\",\n    visibility = [\"//visibility:public\"],\n)\n\n"
          },
          "repositories": [
               {
                    "rule_class": "//internal:graalvm_bindist.bzl%_toolchain_config",
                    "attributes": {
                         "name": "graalvm_toolchain_config_repo",
                         "generator_name": "graalvm_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"graalvm_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"gvm\",\n    target_compatible_with = [],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@rules_graalvm//graalvm/toolchain:toolchain\",\n    toolchain = \"@graalvm//:jdk\",\n    visibility = [\"//visibility:public\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@graalvm//:jdk\",\n    visibility = [\"//visibility:public\"],\n)\n\ntoolchain(\n    name = \"bootstrap_runtime_toolchain\",\n    # These constraints are not required for correctness, but prevent fetches of remote JDK for\n    # different architectures. As every Java compilation toolchain depends on a bootstrap runtime in\n    # the same configuration, this constraint will not result in toolchain resolution failures.\n    exec_compatible_with = [],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:bootstrap_runtime_toolchain_type\",\n    toolchain = \"@graalvm//:jdk\",\n    visibility = [\"//visibility:public\"],\n)\n\n"
                    },
                    "output_tree_hash": "00e9a2a8a7e42fc4bd1edb23dddc02d4d5570a07d6c4e5f991c899b8432f8fdd"
               }
          ]
     }
]