resolved = [
     {
          "original_rule_class": "@rules_jvm_external~5.3//:coursier.bzl%pinned_coursier_fetch",
          "definition_information": "Repository rules_jvm_external~5.3~maven~stardoc_maven instantiated at:\n  <builtin>: in <toplevel>\nRepository rule pinned_coursier_fetch defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_jvm_external~5.3/coursier.bzl:1166:40: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_jvm_external~5.3~maven~stardoc_maven",
               "repositories": [
                    "{ \"repo_url\": \"https://repo1.maven.org/maven2\" }"
               ],
               "artifacts": [
                    "{ \"group\": \"com.beust\", \"artifact\": \"jcommander\", \"version\": \"1.82\" }",
                    "{ \"group\": \"com.google.escapevelocity\", \"artifact\": \"escapevelocity\", \"version\": \"1.1\" }",
                    "{ \"group\": \"com.google.guava\", \"artifact\": \"guava\", \"version\": \"31.1-jre\" }",
                    "{ \"group\": \"com.google.truth\", \"artifact\": \"truth\", \"version\": \"1.1.3\" }",
                    "{ \"group\": \"junit\", \"artifact\": \"junit\", \"version\": \"4.13.2\" }"
               ],
               "fetch_sources": True,
               "fetch_javadoc": False,
               "generate_compat_repositories": False,
               "maven_install_json": "@stardoc~0.6.2//:maven_install.json",
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
               "fail_if_repin_required": True,
               "use_starlark_android_rules": False,
               "aar_import_bzl_label": "@build_bazel_rules_android//android:rules.bzl",
               "duplicate_version_warning": "warn"
          },
          "repositories": [
               {
                    "rule_class": "@rules_jvm_external~5.3//:coursier.bzl%pinned_coursier_fetch",
                    "attributes": {
                         "name": "rules_jvm_external~5.3~maven~stardoc_maven",
                         "repositories": [
                              "{ \"repo_url\": \"https://repo1.maven.org/maven2\" }"
                         ],
                         "artifacts": [
                              "{ \"group\": \"com.beust\", \"artifact\": \"jcommander\", \"version\": \"1.82\" }",
                              "{ \"group\": \"com.google.escapevelocity\", \"artifact\": \"escapevelocity\", \"version\": \"1.1\" }",
                              "{ \"group\": \"com.google.guava\", \"artifact\": \"guava\", \"version\": \"31.1-jre\" }",
                              "{ \"group\": \"com.google.truth\", \"artifact\": \"truth\", \"version\": \"1.1.3\" }",
                              "{ \"group\": \"junit\", \"artifact\": \"junit\", \"version\": \"4.13.2\" }"
                         ],
                         "fetch_sources": True,
                         "fetch_javadoc": False,
                         "generate_compat_repositories": False,
                         "maven_install_json": "@stardoc~0.6.2//:maven_install.json",
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
                         "fail_if_repin_required": True,
                         "use_starlark_android_rules": False,
                         "aar_import_bzl_label": "@build_bazel_rules_android//android:rules.bzl",
                         "duplicate_version_warning": "warn"
                    },
                    "output_tree_hash": "e2a01ae6efc0a735d20fb6d0c4d4da70dee89077024d74ca20da01433f0f51c5"
               }
          ]
     },
     {
          "original_rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_archive",
          "definition_information": "Repository rules_license~0.0.7 instantiated at:\n  <builtin>: in <toplevel>\nRepository rule http_archive defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/http.bzl:379:31: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_license~0.0.7",
               "urls": [
                    "https://github.com/bazelbuild/rules_license/releases/download/0.0.7/rules_license-0.0.7.tar.gz"
               ],
               "integrity": "sha256-RTHezLkTY5ww5cdRKgVNXYdWmNrrddjPkPKEN1/nw2A=",
               "strip_prefix": "",
               "remote_patches": {},
               "remote_patch_strip": 0
          },
          "repositories": [
               {
                    "rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_archive",
                    "attributes": {
                         "url": "",
                         "urls": [
                              "https://github.com/bazelbuild/rules_license/releases/download/0.0.7/rules_license-0.0.7.tar.gz"
                         ],
                         "sha256": "",
                         "integrity": "sha256-RTHezLkTY5ww5cdRKgVNXYdWmNrrddjPkPKEN1/nw2A=",
                         "netrc": "",
                         "auth_patterns": {},
                         "canonical_id": "",
                         "strip_prefix": "",
                         "add_prefix": "",
                         "type": "",
                         "patches": [],
                         "remote_patches": {},
                         "remote_patch_strip": 0,
                         "patch_tool": "",
                         "patch_args": [
                              "-p0"
                         ],
                         "patch_cmds": [],
                         "patch_cmds_win": [],
                         "build_file_content": "",
                         "workspace_file_content": "",
                         "name": "rules_license~0.0.7"
                    },
                    "output_tree_hash": "e0c9cd868bc6884b8d00161efd067517376270cb92a4778e35dff2c25672e1f0"
               }
          ]
     },
     {
          "original_rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_file",
          "definition_information": "Repository rules_jvm_external~5.3~maven~com_google_guava_listenablefuture_9999_0_empty_to_avoid_conflict_with_guava instantiated at:\n  <builtin>: in <toplevel>\nRepository rule http_file defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/http.bzl:473:28: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_jvm_external~5.3~maven~com_google_guava_listenablefuture_9999_0_empty_to_avoid_conflict_with_guava",
               "downloaded_file_path": "com/google/guava/listenablefuture/9999.0-empty-to-avoid-conflict-with-guava/listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar",
               "sha256": "b372a037d4230aa57fbeffdef30fd6123f9c0c2db85d0aced00c91b974f33f99",
               "urls": [
                    "https://repo1.maven.org/maven2/com/google/guava/listenablefuture/9999.0-empty-to-avoid-conflict-with-guava/listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar",
                    "https://maven.google.com/com/google/guava/listenablefuture/9999.0-empty-to-avoid-conflict-with-guava/listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar"
               ]
          },
          "repositories": [
               {
                    "rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_file",
                    "attributes": {
                         "executable": False,
                         "downloaded_file_path": "com/google/guava/listenablefuture/9999.0-empty-to-avoid-conflict-with-guava/listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar",
                         "sha256": "b372a037d4230aa57fbeffdef30fd6123f9c0c2db85d0aced00c91b974f33f99",
                         "integrity": "",
                         "canonical_id": "",
                         "url": "",
                         "urls": [
                              "https://repo1.maven.org/maven2/com/google/guava/listenablefuture/9999.0-empty-to-avoid-conflict-with-guava/listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar",
                              "https://maven.google.com/com/google/guava/listenablefuture/9999.0-empty-to-avoid-conflict-with-guava/listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar"
                         ],
                         "netrc": "",
                         "auth_patterns": {},
                         "name": "rules_jvm_external~5.3~maven~com_google_guava_listenablefuture_9999_0_empty_to_avoid_conflict_with_guava"
                    },
                    "output_tree_hash": "fd6cef071c4190006b3ce4689960ede682cb4e0ba4f2433e1bc387bfc9ed6438"
               }
          ]
     },
     {
          "original_rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_file",
          "definition_information": "Repository rules_jvm_external~5.3~maven~com_google_guava_failureaccess_1_0_1 instantiated at:\n  <builtin>: in <toplevel>\nRepository rule http_file defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/http.bzl:473:28: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_jvm_external~5.3~maven~com_google_guava_failureaccess_1_0_1",
               "downloaded_file_path": "com/google/guava/failureaccess/1.0.1/failureaccess-1.0.1.jar",
               "sha256": "a171ee4c734dd2da837e4b16be9df4661afab72a41adaf31eb84dfdaf936ca26",
               "urls": [
                    "https://repo1.maven.org/maven2/com/google/guava/failureaccess/1.0.1/failureaccess-1.0.1.jar",
                    "https://maven.google.com/com/google/guava/failureaccess/1.0.1/failureaccess-1.0.1.jar"
               ]
          },
          "repositories": [
               {
                    "rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_file",
                    "attributes": {
                         "executable": False,
                         "downloaded_file_path": "com/google/guava/failureaccess/1.0.1/failureaccess-1.0.1.jar",
                         "sha256": "a171ee4c734dd2da837e4b16be9df4661afab72a41adaf31eb84dfdaf936ca26",
                         "integrity": "",
                         "canonical_id": "",
                         "url": "",
                         "urls": [
                              "https://repo1.maven.org/maven2/com/google/guava/failureaccess/1.0.1/failureaccess-1.0.1.jar",
                              "https://maven.google.com/com/google/guava/failureaccess/1.0.1/failureaccess-1.0.1.jar"
                         ],
                         "netrc": "",
                         "auth_patterns": {},
                         "name": "rules_jvm_external~5.3~maven~com_google_guava_failureaccess_1_0_1"
                    },
                    "output_tree_hash": "5c1354a3b61ad53729f9e43a2bd746fc1ea26e94a1cdb5324028cd6c139cecdf"
               }
          ]
     },
     {
          "original_rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_file",
          "definition_information": "Repository rules_jvm_external~5.3~maven~com_google_escapevelocity_escapevelocity_1_1 instantiated at:\n  <builtin>: in <toplevel>\nRepository rule http_file defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/http.bzl:473:28: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_jvm_external~5.3~maven~com_google_escapevelocity_escapevelocity_1_1",
               "downloaded_file_path": "com/google/escapevelocity/escapevelocity/1.1/escapevelocity-1.1.jar",
               "sha256": "37e76e4466836dedb864fb82355cd01c3bd21325ab642d89a0f759291b171231",
               "urls": [
                    "https://repo1.maven.org/maven2/com/google/escapevelocity/escapevelocity/1.1/escapevelocity-1.1.jar"
               ]
          },
          "repositories": [
               {
                    "rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_file",
                    "attributes": {
                         "executable": False,
                         "downloaded_file_path": "com/google/escapevelocity/escapevelocity/1.1/escapevelocity-1.1.jar",
                         "sha256": "37e76e4466836dedb864fb82355cd01c3bd21325ab642d89a0f759291b171231",
                         "integrity": "",
                         "canonical_id": "",
                         "url": "",
                         "urls": [
                              "https://repo1.maven.org/maven2/com/google/escapevelocity/escapevelocity/1.1/escapevelocity-1.1.jar"
                         ],
                         "netrc": "",
                         "auth_patterns": {},
                         "name": "rules_jvm_external~5.3~maven~com_google_escapevelocity_escapevelocity_1_1"
                    },
                    "output_tree_hash": "eab74c1d15ec277df9d01e8487be26b2b7de476cb5eb836e47d2071421e89d69"
               }
          ]
     },
     {
          "original_rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_file",
          "definition_information": "Repository rules_jvm_external~5.3~maven~com_google_j2objc_j2objc_annotations_1_3 instantiated at:\n  <builtin>: in <toplevel>\nRepository rule http_file defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/http.bzl:473:28: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_jvm_external~5.3~maven~com_google_j2objc_j2objc_annotations_1_3",
               "downloaded_file_path": "com/google/j2objc/j2objc-annotations/1.3/j2objc-annotations-1.3.jar",
               "sha256": "21af30c92267bd6122c0e0b4d20cccb6641a37eaf956c6540ec471d584e64a7b",
               "urls": [
                    "https://repo1.maven.org/maven2/com/google/j2objc/j2objc-annotations/1.3/j2objc-annotations-1.3.jar"
               ]
          },
          "repositories": [
               {
                    "rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_file",
                    "attributes": {
                         "executable": False,
                         "downloaded_file_path": "com/google/j2objc/j2objc-annotations/1.3/j2objc-annotations-1.3.jar",
                         "sha256": "21af30c92267bd6122c0e0b4d20cccb6641a37eaf956c6540ec471d584e64a7b",
                         "integrity": "",
                         "canonical_id": "",
                         "url": "",
                         "urls": [
                              "https://repo1.maven.org/maven2/com/google/j2objc/j2objc-annotations/1.3/j2objc-annotations-1.3.jar"
                         ],
                         "netrc": "",
                         "auth_patterns": {},
                         "name": "rules_jvm_external~5.3~maven~com_google_j2objc_j2objc_annotations_1_3"
                    },
                    "output_tree_hash": "36e72378146aa8dcf1a17ce0c1c1c1f58f04abfe1e543c74f4d84d4fa0b21daa"
               }
          ]
     },
     {
          "original_rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_file",
          "definition_information": "Repository rules_jvm_external~5.3~maven~com_google_code_findbugs_jsr305_3_0_2 instantiated at:\n  <builtin>: in <toplevel>\nRepository rule http_file defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/http.bzl:473:28: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_jvm_external~5.3~maven~com_google_code_findbugs_jsr305_3_0_2",
               "downloaded_file_path": "com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar",
               "sha256": "766ad2a0783f2687962c8ad74ceecc38a28b9f72a2d085ee438b7813e928d0c7",
               "urls": [
                    "https://repo1.maven.org/maven2/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar",
                    "https://maven.google.com/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar"
               ]
          },
          "repositories": [
               {
                    "rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_file",
                    "attributes": {
                         "executable": False,
                         "downloaded_file_path": "com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar",
                         "sha256": "766ad2a0783f2687962c8ad74ceecc38a28b9f72a2d085ee438b7813e928d0c7",
                         "integrity": "",
                         "canonical_id": "",
                         "url": "",
                         "urls": [
                              "https://repo1.maven.org/maven2/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar",
                              "https://maven.google.com/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar"
                         ],
                         "netrc": "",
                         "auth_patterns": {},
                         "name": "rules_jvm_external~5.3~maven~com_google_code_findbugs_jsr305_3_0_2"
                    },
                    "output_tree_hash": "194733b732588eda88f4ccf0a63f7699598ca1a09876921f93eb7ae91289994a"
               }
          ]
     },
     {
          "original_rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_file",
          "definition_information": "Repository rules_jvm_external~5.3~maven~com_google_guava_guava_31_1_jre instantiated at:\n  <builtin>: in <toplevel>\nRepository rule http_file defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/http.bzl:473:28: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_jvm_external~5.3~maven~com_google_guava_guava_31_1_jre",
               "downloaded_file_path": "com/google/guava/guava/31.1-jre/guava-31.1-jre.jar",
               "sha256": "a42edc9cab792e39fe39bb94f3fca655ed157ff87a8af78e1d6ba5b07c4a00ab",
               "urls": [
                    "https://repo1.maven.org/maven2/com/google/guava/guava/31.1-jre/guava-31.1-jre.jar"
               ]
          },
          "repositories": [
               {
                    "rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_file",
                    "attributes": {
                         "executable": False,
                         "downloaded_file_path": "com/google/guava/guava/31.1-jre/guava-31.1-jre.jar",
                         "sha256": "a42edc9cab792e39fe39bb94f3fca655ed157ff87a8af78e1d6ba5b07c4a00ab",
                         "integrity": "",
                         "canonical_id": "",
                         "url": "",
                         "urls": [
                              "https://repo1.maven.org/maven2/com/google/guava/guava/31.1-jre/guava-31.1-jre.jar"
                         ],
                         "netrc": "",
                         "auth_patterns": {},
                         "name": "rules_jvm_external~5.3~maven~com_google_guava_guava_31_1_jre"
                    },
                    "output_tree_hash": "769e17860ae561f2f3fdd7b8c290661cf74b392ccf7ab8d8f7d18870c373a8da"
               }
          ]
     },
     {
          "original_rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_file",
          "definition_information": "Repository rules_jvm_external~5.3~maven~com_google_errorprone_error_prone_annotations_2_11_0 instantiated at:\n  <builtin>: in <toplevel>\nRepository rule http_file defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/http.bzl:473:28: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_jvm_external~5.3~maven~com_google_errorprone_error_prone_annotations_2_11_0",
               "downloaded_file_path": "com/google/errorprone/error_prone_annotations/2.11.0/error_prone_annotations-2.11.0.jar",
               "sha256": "721cb91842b46fa056847d104d5225c8b8e1e8b62263b993051e1e5a0137b7ec",
               "urls": [
                    "https://repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/2.11.0/error_prone_annotations-2.11.0.jar"
               ]
          },
          "repositories": [
               {
                    "rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_file",
                    "attributes": {
                         "executable": False,
                         "downloaded_file_path": "com/google/errorprone/error_prone_annotations/2.11.0/error_prone_annotations-2.11.0.jar",
                         "sha256": "721cb91842b46fa056847d104d5225c8b8e1e8b62263b993051e1e5a0137b7ec",
                         "integrity": "",
                         "canonical_id": "",
                         "url": "",
                         "urls": [
                              "https://repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/2.11.0/error_prone_annotations-2.11.0.jar"
                         ],
                         "netrc": "",
                         "auth_patterns": {},
                         "name": "rules_jvm_external~5.3~maven~com_google_errorprone_error_prone_annotations_2_11_0"
                    },
                    "output_tree_hash": "e95f6c4624d58b3d362cee5642303fbf6af62a523ff921cebdc1b4be973e2f29"
               }
          ]
     },
     {
          "original_rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_file",
          "definition_information": "Repository rules_jvm_external~5.3~maven~com_beust_jcommander_1_82 instantiated at:\n  <builtin>: in <toplevel>\nRepository rule http_file defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/http.bzl:473:28: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_jvm_external~5.3~maven~com_beust_jcommander_1_82",
               "downloaded_file_path": "com/beust/jcommander/1.82/jcommander-1.82.jar",
               "sha256": "deeac157c8de6822878d85d0c7bc8467a19cc8484d37788f7804f039dde280b1",
               "urls": [
                    "https://repo1.maven.org/maven2/com/beust/jcommander/1.82/jcommander-1.82.jar"
               ]
          },
          "repositories": [
               {
                    "rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_file",
                    "attributes": {
                         "executable": False,
                         "downloaded_file_path": "com/beust/jcommander/1.82/jcommander-1.82.jar",
                         "sha256": "deeac157c8de6822878d85d0c7bc8467a19cc8484d37788f7804f039dde280b1",
                         "integrity": "",
                         "canonical_id": "",
                         "url": "",
                         "urls": [
                              "https://repo1.maven.org/maven2/com/beust/jcommander/1.82/jcommander-1.82.jar"
                         ],
                         "netrc": "",
                         "auth_patterns": {},
                         "name": "rules_jvm_external~5.3~maven~com_beust_jcommander_1_82"
                    },
                    "output_tree_hash": "f9d7bc14198a00a3f054daf552c6791eedd7cd475d7aa6763931f294f31fa40e"
               }
          ]
     },
     {
          "original_rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_file",
          "definition_information": "Repository rules_jvm_external~5.3~maven~org_checkerframework_checker_qual_3_13_0 instantiated at:\n  <builtin>: in <toplevel>\nRepository rule http_file defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/http.bzl:473:28: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_jvm_external~5.3~maven~org_checkerframework_checker_qual_3_13_0",
               "downloaded_file_path": "org/checkerframework/checker-qual/3.13.0/checker-qual-3.13.0.jar",
               "sha256": "3ea0dcd73b4d6cb2fb34bd7ed4dad6db327a01ebad7db05eb7894076b3d64491",
               "urls": [
                    "https://repo1.maven.org/maven2/org/checkerframework/checker-qual/3.13.0/checker-qual-3.13.0.jar"
               ]
          },
          "repositories": [
               {
                    "rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_file",
                    "attributes": {
                         "executable": False,
                         "downloaded_file_path": "org/checkerframework/checker-qual/3.13.0/checker-qual-3.13.0.jar",
                         "sha256": "3ea0dcd73b4d6cb2fb34bd7ed4dad6db327a01ebad7db05eb7894076b3d64491",
                         "integrity": "",
                         "canonical_id": "",
                         "url": "",
                         "urls": [
                              "https://repo1.maven.org/maven2/org/checkerframework/checker-qual/3.13.0/checker-qual-3.13.0.jar"
                         ],
                         "netrc": "",
                         "auth_patterns": {},
                         "name": "rules_jvm_external~5.3~maven~org_checkerframework_checker_qual_3_13_0"
                    },
                    "output_tree_hash": "b22ff85e04902372d265404e87d21e57566fffcbc5a464d01b75a28695e9cfa2"
               }
          ]
     },
     {
          "original_rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_archive",
          "definition_information": "Repository protobuf~21.7 instantiated at:\n  <builtin>: in <toplevel>\nRepository rule http_archive defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/http.bzl:379:31: in <toplevel>\n",
          "original_attributes": {
               "name": "protobuf~21.7",
               "urls": [
                    "https://github.com/protocolbuffers/protobuf/releases/download/v21.7/protobuf-all-21.7.zip"
               ],
               "integrity": "sha256-VJOiH17T/FAuZv7GuUScBqVRztYwAvpIkDxA36jeeko=",
               "strip_prefix": "protobuf-21.7",
               "remote_patches": {
                    "https://bcr.bazel.build/modules/protobuf/21.7/patches/add_module_dot_bazel.patch": "sha256-q3V2+eq0v2XF0z8z+V+QF4cynD6JvHI1y3kI/+rzl5s=",
                    "https://bcr.bazel.build/modules/protobuf/21.7/patches/add_module_dot_bazel_for_examples.patch": "sha256-O7YP6s3lo/1opUiO0jqXYORNHdZ/2q3hjz1QGy8QdIU=",
                    "https://bcr.bazel.build/modules/protobuf/21.7/patches/relative_repo_names.patch": "sha256-RK9RjW8T5UJNG7flIrnFiNE9vKwWB+8uWWtJqXYT0w4=",
                    "https://bcr.bazel.build/modules/protobuf/21.7/patches/add_missing_files.patch": "sha256-Hyne4DG2u5bXcWHNxNMirA2QFAe/2Cl8oMm1XJdkQIY="
               },
               "remote_patch_strip": 1
          },
          "repositories": [
               {
                    "rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_archive",
                    "attributes": {
                         "url": "",
                         "urls": [
                              "https://github.com/protocolbuffers/protobuf/releases/download/v21.7/protobuf-all-21.7.zip"
                         ],
                         "sha256": "",
                         "integrity": "sha256-VJOiH17T/FAuZv7GuUScBqVRztYwAvpIkDxA36jeeko=",
                         "netrc": "",
                         "auth_patterns": {},
                         "canonical_id": "",
                         "strip_prefix": "protobuf-21.7",
                         "add_prefix": "",
                         "type": "",
                         "patches": [],
                         "remote_patches": {
                              "https://bcr.bazel.build/modules/protobuf/21.7/patches/add_module_dot_bazel.patch": "sha256-q3V2+eq0v2XF0z8z+V+QF4cynD6JvHI1y3kI/+rzl5s=",
                              "https://bcr.bazel.build/modules/protobuf/21.7/patches/add_module_dot_bazel_for_examples.patch": "sha256-O7YP6s3lo/1opUiO0jqXYORNHdZ/2q3hjz1QGy8QdIU=",
                              "https://bcr.bazel.build/modules/protobuf/21.7/patches/relative_repo_names.patch": "sha256-RK9RjW8T5UJNG7flIrnFiNE9vKwWB+8uWWtJqXYT0w4=",
                              "https://bcr.bazel.build/modules/protobuf/21.7/patches/add_missing_files.patch": "sha256-Hyne4DG2u5bXcWHNxNMirA2QFAe/2Cl8oMm1XJdkQIY="
                         },
                         "remote_patch_strip": 1,
                         "patch_tool": "",
                         "patch_args": [
                              "-p0"
                         ],
                         "patch_cmds": [],
                         "patch_cmds_win": [],
                         "build_file_content": "",
                         "workspace_file_content": "",
                         "name": "protobuf~21.7"
                    },
                    "output_tree_hash": "521931f7403feb3e78f82bfcb1a2fcff13327db9fb58980bb356f3d65622db5b"
               }
          ]
     },
     {
          "original_rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_archive",
          "definition_information": "Repository rules_pkg~0.7.0 instantiated at:\n  <builtin>: in <toplevel>\nRepository rule http_archive defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/http.bzl:379:31: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_pkg~0.7.0",
               "urls": [
                    "https://github.com/bazelbuild/rules_pkg/releases/download/0.7.0/rules_pkg-0.7.0.tar.gz"
               ],
               "integrity": "sha256-iimOgydi7aGDBZfWT+fbWBeKqEzVkm121bdE1lWJQcI=",
               "strip_prefix": "",
               "remote_patches": {
                    "https://bcr.bazel.build/modules/rules_pkg/0.7.0/patches/module_dot_bazel.patch": "sha256-4OaEPZwYF6iC71ZTDg6MJ7LLqX7ZA0/kK4mT+4xKqiE="
               },
               "remote_patch_strip": 0
          },
          "repositories": [
               {
                    "rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_archive",
                    "attributes": {
                         "url": "",
                         "urls": [
                              "https://github.com/bazelbuild/rules_pkg/releases/download/0.7.0/rules_pkg-0.7.0.tar.gz"
                         ],
                         "sha256": "",
                         "integrity": "sha256-iimOgydi7aGDBZfWT+fbWBeKqEzVkm121bdE1lWJQcI=",
                         "netrc": "",
                         "auth_patterns": {},
                         "canonical_id": "",
                         "strip_prefix": "",
                         "add_prefix": "",
                         "type": "",
                         "patches": [],
                         "remote_patches": {
                              "https://bcr.bazel.build/modules/rules_pkg/0.7.0/patches/module_dot_bazel.patch": "sha256-4OaEPZwYF6iC71ZTDg6MJ7LLqX7ZA0/kK4mT+4xKqiE="
                         },
                         "remote_patch_strip": 0,
                         "patch_tool": "",
                         "patch_args": [
                              "-p0"
                         ],
                         "patch_cmds": [],
                         "patch_cmds_win": [],
                         "build_file_content": "",
                         "workspace_file_content": "",
                         "name": "rules_pkg~0.7.0"
                    },
                    "output_tree_hash": "a6527d9eedb6b248cf5aa52983e7998df6edde85adb7870de5869483ea59dfc0"
               }
          ]
     },
     {
          "original_rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_archive",
          "definition_information": "Repository zlib~1.2.13 instantiated at:\n  <builtin>: in <toplevel>\nRepository rule http_archive defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/http.bzl:379:31: in <toplevel>\n",
          "original_attributes": {
               "name": "zlib~1.2.13",
               "urls": [
                    "https://github.com/madler/zlib/archive/refs/tags/v1.2.13.zip"
               ],
               "integrity": "sha256-woVpUbvzDjCGGs43ZVldhroT8s8BJ52QH2xiJYxX9P8=",
               "strip_prefix": "zlib-1.2.13",
               "remote_patches": {
                    "https://bcr.bazel.build/modules/zlib/1.2.13/patches/add_build_file.patch": "sha256-Z2ig1F01/dfdG63H+GwYRMcGbW/zAGIUWnKKrwKSEaQ=",
                    "https://bcr.bazel.build/modules/zlib/1.2.13/patches/module_dot_bazel.patch": "sha256-Nc7xP02Dl6yHQvkiZWSQnlnw1T277yS4cJxxONWJ/Ic="
               },
               "remote_patch_strip": 0
          },
          "repositories": [
               {
                    "rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_archive",
                    "attributes": {
                         "url": "",
                         "urls": [
                              "https://github.com/madler/zlib/archive/refs/tags/v1.2.13.zip"
                         ],
                         "sha256": "",
                         "integrity": "sha256-woVpUbvzDjCGGs43ZVldhroT8s8BJ52QH2xiJYxX9P8=",
                         "netrc": "",
                         "auth_patterns": {},
                         "canonical_id": "",
                         "strip_prefix": "zlib-1.2.13",
                         "add_prefix": "",
                         "type": "",
                         "patches": [],
                         "remote_patches": {
                              "https://bcr.bazel.build/modules/zlib/1.2.13/patches/add_build_file.patch": "sha256-Z2ig1F01/dfdG63H+GwYRMcGbW/zAGIUWnKKrwKSEaQ=",
                              "https://bcr.bazel.build/modules/zlib/1.2.13/patches/module_dot_bazel.patch": "sha256-Nc7xP02Dl6yHQvkiZWSQnlnw1T277yS4cJxxONWJ/Ic="
                         },
                         "remote_patch_strip": 0,
                         "patch_tool": "",
                         "patch_args": [
                              "-p0"
                         ],
                         "patch_cmds": [],
                         "patch_cmds_win": [],
                         "build_file_content": "",
                         "workspace_file_content": "",
                         "name": "zlib~1.2.13"
                    },
                    "output_tree_hash": "b45b65dd8a6d9e35bf1ab266fb8af85c7e29aab649e9871f753638d07f09f185"
               }
          ]
     }
]