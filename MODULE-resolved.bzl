resolved = [
     {
          "original_rule_class": "local_repository",
          "original_attributes": {
               "name": "bazel_tools",
               "path": "/var/tmp/_bazel_sam/install/390a4167f0067c542bcf5eb75f068fab/embedded_tools"
          },
          "native": "local_repository(name = \"bazel_tools\", path = __embedded_dir__ + \"/\" + \"embedded_tools\")"
     },
     {
          "original_rule_class": "@contrib_rules_jvm~0.13.0//java/private:zip_repository.bzl%zip_repository",
          "definition_information": "Repository contrib_rules_jvm_deps instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:185:27: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/contrib_rules_jvm~0.13.0/repositories.bzl:44:10: in contrib_rules_jvm_deps\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\nRepository rule zip_repository defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/contrib_rules_jvm~0.13.0/java/private/zip_repository.bzl:15:33: in <toplevel>\n",
          "original_attributes": {
               "name": "contrib_rules_jvm_deps",
               "generator_name": "contrib_rules_jvm_deps",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "path": "@contrib_rules_jvm~0.13.0//java/private:contrib_rules_jvm_deps.zip"
          },
          "repositories": [
               {
                    "rule_class": "@contrib_rules_jvm~0.13.0//java/private:zip_repository.bzl%zip_repository",
                    "attributes": {
                         "name": "contrib_rules_jvm_deps",
                         "generator_name": "contrib_rules_jvm_deps",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "path": "@contrib_rules_jvm~0.13.0//java/private:contrib_rules_jvm_deps.zip"
                    },
                    "output_tree_hash": "e66afc388abfccb88c61d88a2ffc30b8b13ff55bef151199e62d21d03565e84e"
               }
          ]
     },
     {
          "original_rule_class": "@rules_jvm_external~5.3//:coursier.bzl%pinned_coursier_fetch",
          "definition_information": "Repository rules_jvm_external_deps instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:181:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_jvm_external~5.3/repositories.bzl:23:18: in rules_jvm_external_deps\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_jvm_external~5.3/private/rules/maven_install.bzl:133:30: in maven_install\nRepository rule pinned_coursier_fetch defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_jvm_external~5.3/coursier.bzl:1166:40: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_jvm_external_deps",
               "generator_name": "rules_jvm_external_deps",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "repositories": [
                    "{ \"repo_url\": \"https://repo1.maven.org/maven2\" }",
                    "{ \"repo_url\": \"https://maven.google.com\" }"
               ],
               "artifacts": [
                    "{ \"group\": \"com.google.auth\", \"artifact\": \"google-auth-library-credentials\", \"version\": \"1.17.0\" }",
                    "{ \"group\": \"com.google.auth\", \"artifact\": \"google-auth-library-oauth2-http\", \"version\": \"1.17.0\" }",
                    "{ \"group\": \"com.google.cloud\", \"artifact\": \"google-cloud-core\", \"version\": \"2.18.1\" }",
                    "{ \"group\": \"com.google.cloud\", \"artifact\": \"google-cloud-storage\", \"version\": \"2.22.3\" }",
                    "{ \"group\": \"com.google.code.gson\", \"artifact\": \"gson\", \"version\": \"2.10.1\" }",
                    "{ \"group\": \"com.google.googlejavaformat\", \"artifact\": \"google-java-format\", \"version\": \"1.17.0\" }",
                    "{ \"group\": \"com.google.guava\", \"artifact\": \"guava\", \"version\": \"32.0.0-jre\" }",
                    "{ \"group\": \"org.apache.maven\", \"artifact\": \"maven-artifact\", \"version\": \"3.9.2\" }",
                    "{ \"group\": \"software.amazon.awssdk\", \"artifact\": \"s3\", \"version\": \"2.20.78\" }"
               ],
               "fetch_sources": False,
               "fetch_javadoc": False,
               "generate_compat_repositories": False,
               "maven_install_json": "@rules_jvm_external~5.3//:rules_jvm_external_deps_install.json",
               "override_targets": {},
               "strict_visibility": True,
               "strict_visibility_value": [
                    "//visibility:private"
               ],
               "jetify": False,
               "jetify_include_list": [
                    "*"
               ],
               "additional_netrc_lines": [],
               "use_credentials_from_home_netrc_file": False,
               "fail_if_repin_required": True,
               "use_starlark_android_rules": False,
               "aar_import_bzl_label": "@build_bazel_rules_android//android:rules.bzl",
               "duplicate_version_warning": "warn"
          },
          "repositories": [
               {
                    "rule_class": "@rules_jvm_external~5.3//:coursier.bzl%pinned_coursier_fetch",
                    "attributes": {
                         "name": "rules_jvm_external_deps",
                         "generator_name": "rules_jvm_external_deps",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "repositories": [
                              "{ \"repo_url\": \"https://repo1.maven.org/maven2\" }",
                              "{ \"repo_url\": \"https://maven.google.com\" }"
                         ],
                         "artifacts": [
                              "{ \"group\": \"com.google.auth\", \"artifact\": \"google-auth-library-credentials\", \"version\": \"1.17.0\" }",
                              "{ \"group\": \"com.google.auth\", \"artifact\": \"google-auth-library-oauth2-http\", \"version\": \"1.17.0\" }",
                              "{ \"group\": \"com.google.cloud\", \"artifact\": \"google-cloud-core\", \"version\": \"2.18.1\" }",
                              "{ \"group\": \"com.google.cloud\", \"artifact\": \"google-cloud-storage\", \"version\": \"2.22.3\" }",
                              "{ \"group\": \"com.google.code.gson\", \"artifact\": \"gson\", \"version\": \"2.10.1\" }",
                              "{ \"group\": \"com.google.googlejavaformat\", \"artifact\": \"google-java-format\", \"version\": \"1.17.0\" }",
                              "{ \"group\": \"com.google.guava\", \"artifact\": \"guava\", \"version\": \"32.0.0-jre\" }",
                              "{ \"group\": \"org.apache.maven\", \"artifact\": \"maven-artifact\", \"version\": \"3.9.2\" }",
                              "{ \"group\": \"software.amazon.awssdk\", \"artifact\": \"s3\", \"version\": \"2.20.78\" }"
                         ],
                         "fetch_sources": False,
                         "fetch_javadoc": False,
                         "generate_compat_repositories": False,
                         "maven_install_json": "@rules_jvm_external~5.3//:rules_jvm_external_deps_install.json",
                         "override_targets": {},
                         "strict_visibility": True,
                         "strict_visibility_value": [
                              "//visibility:private"
                         ],
                         "jetify": False,
                         "jetify_include_list": [
                              "*"
                         ],
                         "additional_netrc_lines": [],
                         "use_credentials_from_home_netrc_file": False,
                         "fail_if_repin_required": True,
                         "use_starlark_android_rules": False,
                         "aar_import_bzl_label": "@build_bazel_rules_android//android:rules.bzl",
                         "duplicate_version_warning": "warn"
                    },
                    "output_tree_hash": "25853ff54c28691ac2db1899935977599717997929cd6961f768e0b5d9a50f17"
               }
          ]
     },
     {
          "original_rule_class": "@com_grail_bazel_toolchain//toolchain:rules.bzl%toolchain",
          "definition_information": "Repository llvm instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:126:19: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/com_grail_bazel_toolchain/toolchain/rules.bzl:300:14: in llvm_toolchain\nRepository rule toolchain defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/com_grail_bazel_toolchain/toolchain/rules.bzl:272:28: in <toplevel>\n",
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
          "original_rule_class": "local_config_platform",
          "original_attributes": {
               "name": "local_config_platform"
          },
          "native": "local_config_platform(name = 'local_config_platform')"
     },
     {
          "original_rule_class": "@bazel_tools//tools/sh:sh_configure.bzl%sh_config",
          "definition_information": "Repository bazel_tools~sh_configure_extension~local_config_sh instantiated at:\n  <builtin>: in <toplevel>\nRepository rule sh_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/sh/sh_configure.bzl:72:28: in <toplevel>\n",
          "original_attributes": {
               "name": "bazel_tools~sh_configure_extension~local_config_sh"
          },
          "repositories": [
               {
                    "rule_class": "@bazel_tools//tools/sh:sh_configure.bzl%sh_config",
                    "attributes": {
                         "name": "bazel_tools~sh_configure_extension~local_config_sh"
                    },
                    "output_tree_hash": "e36855460b514225eac75f4abe2cb992c5455b7077a9028d213d269d11490744"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk20_win_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk20_win_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_win//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk20_win_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_win//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "b86daea8f9871eee8750a71c6662ad414a7166e4a20ad08d5564d6063d9cbed2"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk17_macos_aarch64_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk17_macos_aarch64_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_macos_aarch64//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk17_macos_aarch64_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_macos_aarch64//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "446339866956e95389079b814bfe8a95bfad9b80d46a56e54cac9dc2add2d78b"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk17_win_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk17_win_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_win//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk17_win_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_win//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "b4a5c31d7a0e044f0b85fc9cfc509dc742b91f06c62d714d03364edfa693d9aa"
               }
          ]
     },
     {
          "original_rule_class": "@bazel_tools//tools/cpp:cc_configure.bzl%cc_autoconf_toolchains",
          "definition_information": "Repository bazel_tools~cc_configure_extension~local_config_cc_toolchains instantiated at:\n  <builtin>: in <toplevel>\nRepository rule cc_autoconf_toolchains defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/cpp/cc_configure.bzl:47:41: in <toplevel>\n",
          "original_attributes": {
               "name": "bazel_tools~cc_configure_extension~local_config_cc_toolchains"
          },
          "repositories": [
               {
                    "rule_class": "@bazel_tools//tools/cpp:cc_configure.bzl%cc_autoconf_toolchains",
                    "attributes": {
                         "name": "bazel_tools~cc_configure_extension~local_config_cc_toolchains"
                    },
                    "output_tree_hash": "2c6c2998e70208a29847dd5420b3aff0b1e2f5ac956a0911addd090e92b83969"
               }
          ]
     },
     {
          "original_rule_class": "@rules_cc~0.0.8//cc/private/toolchain:cc_configure.bzl%cc_autoconf_toolchains",
          "definition_information": "Repository rules_cc~0.0.8~cc_configure~local_config_cc_toolchains instantiated at:\n  <builtin>: in <toplevel>\nRepository rule cc_autoconf_toolchains defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_cc~0.0.8/cc/private/toolchain/cc_configure.bzl:47:41: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_cc~0.0.8~cc_configure~local_config_cc_toolchains"
          },
          "repositories": [
               {
                    "rule_class": "@rules_cc~0.0.8//cc/private/toolchain:cc_configure.bzl%cc_autoconf_toolchains",
                    "attributes": {
                         "name": "rules_cc~0.0.8~cc_configure~local_config_cc_toolchains"
                    },
                    "output_tree_hash": "908ea7cca76edd60210961326e4d8ca5da1769fb23d5a06df6912119b40a62c0"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk11_linux_ppc64le_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:532:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:221:10: in remote_jdk11_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository remotejdk11_linux_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:532:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:189:10: in remote_jdk11_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk20_macos_aarch64_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk20_macos_aarch64_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_macos_aarch64//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk20_macos_aarch64_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_macos_aarch64//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "758c0375434dcc36c4f78258a868cdbcd192d517914674b05c3575572042d730"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk11_macos_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:532:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:253:10: in remote_jdk11_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository remotejdk11_linux_s390x_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:532:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:237:10: in remote_jdk11_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository remotejdk11_linux_aarch64_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:532:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:205:10: in remote_jdk11_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository remotejdk11_win_arm64_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:532:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:301:10: in remote_jdk11_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository remotejdk20_win_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:534:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:509:10: in remote_jdk20_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository remotejdk11_win_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:532:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:285:10: in remote_jdk11_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository remotejdk11_macos_aarch64_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:532:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:269:10: in remote_jdk11_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository remotejdk17_linux_s390x_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:533:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:350:10: in remote_jdk17_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository remotejdk17_linux_ppc64le_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:533:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:366:10: in remote_jdk17_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "original_rule_class": "@rules_python~0.24.0//python/extensions/private:pythons_hub.bzl%hub_repo",
          "definition_information": "Repository rules_python~0.24.0~python~pythons_hub instantiated at:\n  <builtin>: in <toplevel>\nRepository rule hub_repo defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_python~0.24.0/python/extensions/private/pythons_hub.bzl:112:27: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_python~0.24.0~python~pythons_hub",
               "default_python_version": "3.11",
               "toolchain_prefixes": [
                    "_0000_python_3_11_"
               ],
               "toolchain_python_versions": [
                    "3.11"
               ],
               "toolchain_set_python_version_constraints": [
                    "False"
               ],
               "toolchain_user_repository_names": [
                    "python_3_11"
               ]
          },
          "repositories": [
               {
                    "rule_class": "@rules_python~0.24.0//python/extensions/private:pythons_hub.bzl%hub_repo",
                    "attributes": {
                         "name": "rules_python~0.24.0~python~pythons_hub",
                         "default_python_version": "3.11",
                         "toolchain_prefixes": [
                              "_0000_python_3_11_"
                         ],
                         "toolchain_python_versions": [
                              "3.11"
                         ],
                         "toolchain_set_python_version_constraints": [
                              "False"
                         ],
                         "toolchain_user_repository_names": [
                              "python_3_11"
                         ]
                    },
                    "output_tree_hash": "b3d4923c23a64be01a21959543afa9f282d3a44b995c9c4d7872393d76a4f969"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk17_linux_aarch64_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:533:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:334:10: in remote_jdk17_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk20_macos_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk20_macos_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_macos//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk20_macos_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_macos//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "26bd7a0740a42e5071f342a471ebe4bc5e4dddad4cba48c4698c09a4f2785df4"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk17_linux_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:533:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:318:10: in remote_jdk17_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository remotejdk17_win_arm64_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:533:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:428:10: in remote_jdk17_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository remotejdk17_win_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:533:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:413:10: in remote_jdk17_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository remotejdk17_macos_aarch64_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:533:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:398:10: in remote_jdk17_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository remotejdk20_macos_aarch64_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:534:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:494:10: in remote_jdk20_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository remotejdk17_macos_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:533:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:382:10: in remote_jdk17_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk20_linux_aarch64_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk20_linux_aarch64_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_linux_aarch64//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk20_linux_aarch64_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_linux_aarch64//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "87286094ce99092e9e9a9e1521ceaee3100a23a05a525ce8421f013cb21ce5aa"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk20_macos_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:534:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:478:10: in remote_jdk20_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository remotejdk20_linux_aarch64_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:534:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:462:10: in remote_jdk20_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository remotejdk20_linux_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:534:23: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:446:10: in remote_jdk20_repos\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:57:22: in remote_java_repository\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
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
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk11_win_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk11_win_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_win//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk11_win_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_win//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "3ad3d266889440dfb4634a76c5ebe583f73f905ce712dd70bb3890b4466c1fbc"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk11_macos_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk11_macos_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_macos//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk11_macos_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_macos//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "48e134409740942042219dfdd972ba5e68a25a716e4adbd1eeae9270b01ae706"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk11_linux_s390x_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk11_linux_s390x_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:s390x\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_linux_s390x//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk11_linux_s390x_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:s390x\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_linux_s390x//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "d7eb669db0d46fd4617a8b4c35404bc45b144a40fb6f7422503a7d0c61409464"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk11_linux_ppc64le_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk11_linux_ppc64le_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:ppc\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_linux_ppc64le//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk11_linux_ppc64le_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:ppc\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_linux_ppc64le//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "6aa035dfc2b88227ea51881c15a2a7471a0f819974fcb9cfc0456efe7c11c113"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk11_linux_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk11_linux_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_linux//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk11_linux_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_linux//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "33872f91b4b8ae4cf505c35839962e3459f0f605f40aa60e868e05b0b7eba579"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk11_linux_aarch64_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk11_linux_aarch64_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_linux_aarch64//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk11_linux_aarch64_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_linux_aarch64//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "20cec870010445df9b2670646c3055f6990b6af1b05a2e2fc3524ea37ac81c25"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk17_linux_s390x_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk17_linux_s390x_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:s390x\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_linux_s390x//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk17_linux_s390x_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:s390x\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_linux_s390x//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "f366e5db39722afe13a087111d9bd839f2b8e136eb876ed7c3249b598c134d10"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk17_linux_aarch64_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk17_linux_aarch64_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_linux_aarch64//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk17_linux_aarch64_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_linux_aarch64//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "461f7b1eed7ab4346abba4c4519d0be174d00b4ab06777350dcfc34f1f2f15f6"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk11_win_arm64_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk11_win_arm64_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:arm64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_win_arm64//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk11_win_arm64_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:arm64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_win_arm64//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "744aefd9b34d5bd0b85537877ec951dd9eeb09673d5e509024316d9ccd52ad81"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk17_linux_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk17_linux_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_linux//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk17_linux_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_linux//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "d8fc59c374b01b16f38ca3049cb75ad36efde121d92404d5253c9be8b88b1176"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk11_macos_aarch64_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk11_macos_aarch64_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_macos_aarch64//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk11_macos_aarch64_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_11\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"11\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:aarch64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk11_macos_aarch64//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "9f307272be4f981ab18056521552bb668ddbacfbc8aa0b74954ea87809941b49"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk20_linux_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk20_linux_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_linux//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk20_linux_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk20_linux//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "419ddae5169764a2baa942562d911f9ac8bb1910ab87470e25a3391125c4aae7"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk17_win_arm64_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk17_win_arm64_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:arm64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_win_arm64//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk17_win_arm64_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:windows\", \"@platforms//cpu:arm64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_win_arm64//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "57165f6b6d82cd2df10ffea9bc865b0aa1c666a70efa8e64bb3d83a78a818932"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk17_macos_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk17_macos_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_macos//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk17_macos_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:macos\", \"@platforms//cpu:x86_64\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_macos//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "ab51a51953bae92f1fb7650a67852e4f73e53a57325e8f6302b795ac1800f0f4"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
          "definition_information": "Repository rules_java~6.4.0~toolchains~remotejdk17_linux_ppc64le_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/remote_java_repository.bzl:27:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~remotejdk17_linux_ppc64le_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:ppc\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_linux_ppc64le//:jdk\",\n)\n"
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:remote_java_repository.bzl%_toolchain_config",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~remotejdk17_linux_ppc64le_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"remotejdk_17\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"17\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [\"@platforms//os:linux\", \"@platforms//cpu:ppc\"],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@remotejdk17_linux_ppc64le//:jdk\",\n)\n"
                    },
                    "output_tree_hash": "ebd9f54e5f472540b6b08ea54c54a5beb91f2d762e8e99243fc5a82733035624"
               }
          ]
     },
     {
          "original_rule_class": "@rules_java~6.4.0//toolchains:local_java_repository.bzl%_local_java_repository_rule",
          "definition_information": "Repository local_jdk instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:156:28: in _setup_rules_graalvm_repositories\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:531:19: in rules_java_dependencies\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/java/repositories.bzl:76:10: in local_jdk_repo\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/utils.bzl:240:18: in maybe\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/local_java_repository.bzl:286:32: in local_java_repository\nRepository rule _local_java_repository_rule defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/local_java_repository.bzl:250:46: in <toplevel>\n",
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
          "original_rule_class": "@rules_java~6.4.0//toolchains:local_java_repository.bzl%_local_java_repository_rule",
          "definition_information": "Repository rules_java~6.4.0~toolchains~local_jdk instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _local_java_repository_rule defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_java~6.4.0/toolchains/local_java_repository.bzl:250:46: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_java~6.4.0~toolchains~local_jdk",
               "build_file_content": "load(\"@rules_java//java:defs.bzl\", \"java_runtime\")\n\npackage(default_visibility = [\"//visibility:public\"])\n\nexports_files([\"WORKSPACE\", \"BUILD.bazel\"])\n\nfilegroup(\n    name = \"jre\",\n    srcs = glob(\n        [\n            \"jre/bin/**\",\n            \"jre/lib/**\",\n        ],\n        allow_empty = True,\n        # In some configurations, Java browser plugin is considered harmful and\n        # common antivirus software blocks access to npjp2.dll interfering with Bazel,\n        # so do not include it in JRE on Windows.\n        exclude = [\"jre/bin/plugin2/**\"],\n    ),\n)\n\nfilegroup(\n    name = \"jdk-bin\",\n    srcs = glob(\n        [\"bin/**\"],\n        # The JDK on Windows sometimes contains a directory called\n        # \"%systemroot%\", which is not a valid label.\n        exclude = [\"**/*%*/**\"],\n    ),\n)\n\n# This folder holds security policies.\nfilegroup(\n    name = \"jdk-conf\",\n    srcs = glob(\n        [\"conf/**\"],\n        allow_empty = True,\n    ),\n)\n\nfilegroup(\n    name = \"jdk-include\",\n    srcs = glob(\n        [\"include/**\"],\n        allow_empty = True,\n    ),\n)\n\nfilegroup(\n    name = \"jdk-lib\",\n    srcs = glob(\n        [\"lib/**\", \"release\"],\n        allow_empty = True,\n        exclude = [\n            \"lib/missioncontrol/**\",\n            \"lib/visualvm/**\",\n        ],\n    ),\n)\n\njava_runtime(\n    name = \"jdk\",\n    srcs = [\n        \":jdk-bin\",\n        \":jdk-conf\",\n        \":jdk-include\",\n        \":jdk-lib\",\n        \":jre\",\n    ],\n    version = {RUNTIME_VERSION},\n)\n",
               "java_home": "",
               "version": ""
          },
          "repositories": [
               {
                    "rule_class": "@rules_java~6.4.0//toolchains:local_java_repository.bzl%_local_java_repository_rule",
                    "attributes": {
                         "name": "rules_java~6.4.0~toolchains~local_jdk",
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
          "definition_information": "Repository graalvm_toolchain_config_repo instantiated at:\n  /Volumes/VAULTROOM/rules_graalvm/WORKSPACE.bzlmod:123:27: in <toplevel>\n  /Volumes/VAULTROOM/rules_graalvm/internal/repositories.bzl:166:23: in _setup_rules_graalvm_repositories\n  /Volumes/VAULTROOM/rules_graalvm/internal/graalvm_bindist.bzl:479:26: in graalvm_repository\nRepository rule _toolchain_config defined at:\n  /Volumes/VAULTROOM/rules_graalvm/internal/graalvm_bindist.bzl:406:36: in <toplevel>\n",
          "original_attributes": {
               "name": "graalvm_toolchain_config_repo",
               "generator_name": "graalvm_toolchain_config_repo",
               "generator_function": "_setup_rules_graalvm_repositories",
               "generator_location": None,
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"graalvm_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"gvm\",\n    target_compatible_with = [],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@rules_graalvm//graalvm/toolchain:graalvm\",\n    toolchain = \"@graalvm//:jdk\",\n    visibility = [\"//visibility:public\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@graalvm//:jdk\",\n    visibility = [\"//visibility:public\"],\n)\n\ntoolchain(\n    name = \"bootstrap_runtime_toolchain\",\n    # These constraints are not required for correctness, but prevent fetches of remote JDK for\n    # different architectures. As every Java compilation toolchain depends on a bootstrap runtime in\n    # the same configuration, this constraint will not result in toolchain resolution failures.\n    exec_compatible_with = [],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:bootstrap_runtime_toolchain_type\",\n    toolchain = \"@graalvm//:jdk\",\n    visibility = [\"//visibility:public\"],\n)\n\n"
          },
          "repositories": [
               {
                    "rule_class": "//internal:graalvm_bindist.bzl%_toolchain_config",
                    "attributes": {
                         "name": "graalvm_toolchain_config_repo",
                         "generator_name": "graalvm_toolchain_config_repo",
                         "generator_function": "_setup_rules_graalvm_repositories",
                         "generator_location": None,
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"graalvm_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"gvm\",\n    target_compatible_with = [],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@rules_graalvm//graalvm/toolchain:graalvm\",\n    toolchain = \"@graalvm//:jdk\",\n    visibility = [\"//visibility:public\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@graalvm//:jdk\",\n    visibility = [\"//visibility:public\"],\n)\n\ntoolchain(\n    name = \"bootstrap_runtime_toolchain\",\n    # These constraints are not required for correctness, but prevent fetches of remote JDK for\n    # different architectures. As every Java compilation toolchain depends on a bootstrap runtime in\n    # the same configuration, this constraint will not result in toolchain resolution failures.\n    exec_compatible_with = [],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:bootstrap_runtime_toolchain_type\",\n    toolchain = \"@graalvm//:jdk\",\n    visibility = [\"//visibility:public\"],\n)\n\n"
                    },
                    "output_tree_hash": "d68e71f832073a2e6ebe4a81516e4497472a16b4323efb82d01ba94d06a69019"
               }
          ]
     },
     {
          "original_rule_class": "//internal:graalvm_bindist.bzl%_toolchain_config",
          "definition_information": "Repository _main~graalvm~graalvm_toolchain_config_repo instantiated at:\n  <builtin>: in <toplevel>\nRepository rule _toolchain_config defined at:\n  /Volumes/VAULTROOM/rules_graalvm/internal/graalvm_bindist.bzl:406:36: in <toplevel>\n",
          "original_attributes": {
               "name": "_main~graalvm~graalvm_toolchain_config_repo",
               "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"graalvm_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"gvm\",\n    target_compatible_with = [],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@rules_graalvm//graalvm/toolchain:graalvm\",\n    toolchain = \"@graalvm//:jdk\",\n    visibility = [\"//visibility:public\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@graalvm//:jdk\",\n    visibility = [\"//visibility:public\"],\n)\n\ntoolchain(\n    name = \"bootstrap_runtime_toolchain\",\n    # These constraints are not required for correctness, but prevent fetches of remote JDK for\n    # different architectures. As every Java compilation toolchain depends on a bootstrap runtime in\n    # the same configuration, this constraint will not result in toolchain resolution failures.\n    exec_compatible_with = [],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:bootstrap_runtime_toolchain_type\",\n    toolchain = \"@graalvm//:jdk\",\n    visibility = [\"//visibility:public\"],\n)\n\n"
          },
          "repositories": [
               {
                    "rule_class": "//internal:graalvm_bindist.bzl%_toolchain_config",
                    "attributes": {
                         "name": "_main~graalvm~graalvm_toolchain_config_repo",
                         "build_file": "\nconfig_setting(\n    name = \"prefix_version_setting\",\n    values = {\"java_runtime_version\": \"graalvm_20\"},\n    visibility = [\"//visibility:private\"],\n)\nconfig_setting(\n    name = \"version_setting\",\n    values = {\"java_runtime_version\": \"20\"},\n    visibility = [\"//visibility:private\"],\n)\nalias(\n    name = \"version_or_prefix_version_setting\",\n    actual = select({\n        \":version_setting\": \":version_setting\",\n        \"//conditions:default\": \":prefix_version_setting\",\n    }),\n    visibility = [\"//visibility:private\"],\n)\ntoolchain(\n    name = \"gvm\",\n    target_compatible_with = [],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@rules_graalvm//graalvm/toolchain:graalvm\",\n    toolchain = \"@graalvm//:jdk\",\n    visibility = [\"//visibility:public\"],\n)\ntoolchain(\n    name = \"toolchain\",\n    target_compatible_with = [],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:runtime_toolchain_type\",\n    toolchain = \"@graalvm//:jdk\",\n    visibility = [\"//visibility:public\"],\n)\n\ntoolchain(\n    name = \"bootstrap_runtime_toolchain\",\n    # These constraints are not required for correctness, but prevent fetches of remote JDK for\n    # different architectures. As every Java compilation toolchain depends on a bootstrap runtime in\n    # the same configuration, this constraint will not result in toolchain resolution failures.\n    exec_compatible_with = [],\n    target_settings = [\":version_or_prefix_version_setting\"],\n    toolchain_type = \"@bazel_tools//tools/jdk:bootstrap_runtime_toolchain_type\",\n    toolchain = \"@graalvm//:jdk\",\n    visibility = [\"//visibility:public\"],\n)\n\n"
                    },
                    "output_tree_hash": "828d1fcc293915acf475f5580de21af386837195013e43f3dd02e2f33267acf4"
               }
          ]
     },
     {
          "original_rule_class": "@rules_python~0.24.0//python/pip_install:pip_repository.bzl%pip_hub_repository_bzlmod",
          "definition_information": "Repository rules_python~0.24.0~pip~pip instantiated at:\n  <builtin>: in <toplevel>\nRepository rule pip_hub_repository_bzlmod defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_python~0.24.0/python/pip_install/pip_repository.bzl:368:44: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_python~0.24.0~pip~pip",
               "repo_name": "pip",
               "whl_library_alias_names": [
                    "certifi",
                    "cffi",
                    "charset_normalizer",
                    "cryptography",
                    "deprecated",
                    "idna",
                    "pycparser",
                    "pygithub",
                    "pyjwt",
                    "pynacl",
                    "requests",
                    "semver",
                    "urllib3",
                    "wrapt"
               ]
          },
          "repositories": [
               {
                    "rule_class": "@rules_python~0.24.0//python/pip_install:pip_repository.bzl%pip_hub_repository_bzlmod",
                    "attributes": {
                         "name": "rules_python~0.24.0~pip~pip",
                         "repo_name": "pip",
                         "whl_library_alias_names": [
                              "certifi",
                              "cffi",
                              "charset_normalizer",
                              "cryptography",
                              "deprecated",
                              "idna",
                              "pycparser",
                              "pygithub",
                              "pyjwt",
                              "pynacl",
                              "requests",
                              "semver",
                              "urllib3",
                              "wrapt"
                         ]
                    },
                    "output_tree_hash": "0eefabdc57ccadcc8050c105e8eab40477812703f416e3ae07fc1262fb91b88a"
               }
          ]
     },
     {
          "original_rule_class": "@rules_python~0.24.0//python:pip.bzl%whl_library_alias",
          "definition_information": "Repository rules_python~0.24.0~pip~pip_pygithub instantiated at:\n  <builtin>: in <toplevel>\nRepository rule whl_library_alias defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_python~0.24.0/python/pip.bzl:320:36: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_python~0.24.0~pip~pip_pygithub",
               "default_version": "3.11",
               "version_map": {
                    "3.11": "pip_311_"
               },
               "wheel_name": "pygithub"
          },
          "repositories": [
               {
                    "rule_class": "@rules_python~0.24.0//python:pip.bzl%whl_library_alias",
                    "attributes": {
                         "name": "rules_python~0.24.0~pip~pip_pygithub",
                         "default_version": "3.11",
                         "version_map": {
                              "3.11": "pip_311_"
                         },
                         "wheel_name": "pygithub"
                    },
                    "output_tree_hash": "3f819ee0b71fc6f8af2ddd5a3ae3d2043ee283bb9842864914f825a3269d9475"
               }
          ]
     },
     {
          "original_rule_class": "@bazel_tools//tools/cpp:cc_configure.bzl%cc_autoconf",
          "definition_information": "Repository bazel_tools~cc_configure_extension~local_config_cc instantiated at:\n  <builtin>: in <toplevel>\nRepository rule cc_autoconf defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/cpp/cc_configure.bzl:109:30: in <toplevel>\n",
          "original_attributes": {
               "name": "bazel_tools~cc_configure_extension~local_config_cc"
          },
          "repositories": [
               {
                    "rule_class": "@bazel_tools//tools/cpp:cc_configure.bzl%cc_autoconf",
                    "attributes": {
                         "name": "bazel_tools~cc_configure_extension~local_config_cc"
                    },
                    "output_tree_hash": "337666cbecf2f90e3e56f9ea92c22202f6f64fcd4e22e5e498e3da156d823d56"
               }
          ]
     },
     {
          "original_rule_class": "@rules_python~0.24.0//python/pip_install:pip_repository.bzl%whl_library",
          "definition_information": "Repository rules_python~0.24.0~pip~pip_311_semver instantiated at:\n  <builtin>: in <toplevel>\nRepository rule whl_library defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_python~0.24.0/python/pip_install/pip_repository.bzl:715:30: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_python~0.24.0~pip~pip_311_semver",
               "repo": "pip_311",
               "requirement": "semver==3.0.1     --hash=sha256:2a23844ba1647362c7490fe3995a86e097bb590d16f0f32dfc383008f19e4cdf     --hash=sha256:9ec78c5447883c67b97f98c3b6212796708191d22e4ad30f4570f840171cbce1",
               "download_only": False,
               "enable_implicit_namespace_pkgs": False,
               "environment": {},
               "extra_pip_args": [],
               "isolated": True,
               "pip_data_exclude": [],
               "python_interpreter": "",
               "python_interpreter_target": "@rules_python~0.24.0~python~python_3_11_aarch64-apple-darwin//:bin/python3",
               "quiet": True,
               "repo_prefix": "pip_311_",
               "timeout": 600
          },
          "repositories": [
               {
                    "rule_class": "@rules_python~0.24.0//python/pip_install:pip_repository.bzl%whl_library",
                    "attributes": {
                         "name": "rules_python~0.24.0~pip~pip_311_semver",
                         "repo": "pip_311",
                         "requirement": "semver==3.0.1     --hash=sha256:2a23844ba1647362c7490fe3995a86e097bb590d16f0f32dfc383008f19e4cdf     --hash=sha256:9ec78c5447883c67b97f98c3b6212796708191d22e4ad30f4570f840171cbce1",
                         "download_only": False,
                         "enable_implicit_namespace_pkgs": False,
                         "environment": {},
                         "extra_pip_args": [],
                         "isolated": True,
                         "pip_data_exclude": [],
                         "python_interpreter": "",
                         "python_interpreter_target": "@rules_python~0.24.0~python~python_3_11_aarch64-apple-darwin//:bin/python3",
                         "quiet": True,
                         "repo_prefix": "pip_311_",
                         "timeout": 600
                    },
                    "output_tree_hash": "43a040c226ea3ae4fbda5f137472005b6cc54a4138f7c367ad7f9b42e460101b"
               }
          ]
     },
     {
          "original_rule_class": "@rules_python~0.24.0//python/pip_install:pip_repository.bzl%whl_library",
          "definition_information": "Repository rules_python~0.24.0~pip~pip_311_pygithub instantiated at:\n  <builtin>: in <toplevel>\nRepository rule whl_library defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_python~0.24.0/python/pip_install/pip_repository.bzl:715:30: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_python~0.24.0~pip~pip_311_pygithub",
               "repo": "pip_311",
               "requirement": "pygithub==1.59.1     --hash=sha256:3d87a822e6c868142f0c2c4bf16cce4696b5a7a4d142a7bd160e1bdf75bc54a9     --hash=sha256:c44e3a121c15bf9d3a5cc98d94c9a047a5132a9b01d22264627f58ade9ddc217",
               "download_only": False,
               "enable_implicit_namespace_pkgs": False,
               "environment": {},
               "extra_pip_args": [],
               "isolated": True,
               "pip_data_exclude": [],
               "python_interpreter": "",
               "python_interpreter_target": "@rules_python~0.24.0~python~python_3_11_aarch64-apple-darwin//:bin/python3",
               "quiet": True,
               "repo_prefix": "pip_311_",
               "timeout": 600
          },
          "repositories": [
               {
                    "rule_class": "@rules_python~0.24.0//python/pip_install:pip_repository.bzl%whl_library",
                    "attributes": {
                         "name": "rules_python~0.24.0~pip~pip_311_pygithub",
                         "repo": "pip_311",
                         "requirement": "pygithub==1.59.1     --hash=sha256:3d87a822e6c868142f0c2c4bf16cce4696b5a7a4d142a7bd160e1bdf75bc54a9     --hash=sha256:c44e3a121c15bf9d3a5cc98d94c9a047a5132a9b01d22264627f58ade9ddc217",
                         "download_only": False,
                         "enable_implicit_namespace_pkgs": False,
                         "environment": {},
                         "extra_pip_args": [],
                         "isolated": True,
                         "pip_data_exclude": [],
                         "python_interpreter": "",
                         "python_interpreter_target": "@rules_python~0.24.0~python~python_3_11_aarch64-apple-darwin//:bin/python3",
                         "quiet": True,
                         "repo_prefix": "pip_311_",
                         "timeout": 600
                    },
                    "output_tree_hash": "8fc04e103c56317fa0bd3f371479c411d2d89bc60737b70d76a651845ab9dc02"
               }
          ]
     },
     {
          "original_rule_class": "@rules_python~0.24.0//python/pip_install:pip_repository.bzl%whl_library",
          "definition_information": "Repository rules_python~0.24.0~pip~pip_311_requests instantiated at:\n  <builtin>: in <toplevel>\nRepository rule whl_library defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_python~0.24.0/python/pip_install/pip_repository.bzl:715:30: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_python~0.24.0~pip~pip_311_requests",
               "repo": "pip_311",
               "requirement": "requests==2.31.0     --hash=sha256:58cd2187c01e70e6e26505bca751777aa9f2ee0b7f4300988b709f44e013003f     --hash=sha256:942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1",
               "download_only": False,
               "enable_implicit_namespace_pkgs": False,
               "environment": {},
               "extra_pip_args": [],
               "isolated": True,
               "pip_data_exclude": [],
               "python_interpreter": "",
               "python_interpreter_target": "@rules_python~0.24.0~python~python_3_11_aarch64-apple-darwin//:bin/python3",
               "quiet": True,
               "repo_prefix": "pip_311_",
               "timeout": 600
          },
          "repositories": [
               {
                    "rule_class": "@rules_python~0.24.0//python/pip_install:pip_repository.bzl%whl_library",
                    "attributes": {
                         "name": "rules_python~0.24.0~pip~pip_311_requests",
                         "repo": "pip_311",
                         "requirement": "requests==2.31.0     --hash=sha256:58cd2187c01e70e6e26505bca751777aa9f2ee0b7f4300988b709f44e013003f     --hash=sha256:942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1",
                         "download_only": False,
                         "enable_implicit_namespace_pkgs": False,
                         "environment": {},
                         "extra_pip_args": [],
                         "isolated": True,
                         "pip_data_exclude": [],
                         "python_interpreter": "",
                         "python_interpreter_target": "@rules_python~0.24.0~python~python_3_11_aarch64-apple-darwin//:bin/python3",
                         "quiet": True,
                         "repo_prefix": "pip_311_",
                         "timeout": 600
                    },
                    "output_tree_hash": "a5321ae60d6789f9cd33218927706527c3d83caa775126e2fffd6d85f6a8203c"
               }
          ]
     },
     {
          "original_rule_class": "@bazel_tools//tools/osx:xcode_configure.bzl%xcode_autoconf",
          "definition_information": "Repository bazel_tools~xcode_configure_extension~local_config_xcode instantiated at:\n  <builtin>: in <toplevel>\nRepository rule xcode_autoconf defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/osx/xcode_configure.bzl:294:33: in <toplevel>\n",
          "original_attributes": {
               "name": "bazel_tools~xcode_configure_extension~local_config_xcode",
               "xcode_locator": "@bazel_tools//tools/osx:xcode_locator.m",
               "remote_xcode": ""
          },
          "repositories": [
               {
                    "rule_class": "@bazel_tools//tools/osx:xcode_configure.bzl%xcode_autoconf",
                    "attributes": {
                         "name": "bazel_tools~xcode_configure_extension~local_config_xcode",
                         "xcode_locator": "@bazel_tools//tools/osx:xcode_locator.m",
                         "remote_xcode": ""
                    },
                    "output_tree_hash": "dc0ea9739aedbe5a01d97225f84a97091cc31933c06626f0e5e1bfc8fa61120b"
               }
          ]
     }
]