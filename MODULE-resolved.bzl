resolved = [
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
                    "gevent",
                    "greenlet",
                    "grequests",
                    "idna",
                    "pycparser",
                    "pygithub",
                    "pyjwt",
                    "pynacl",
                    "requests",
                    "semver",
                    "setuptools",
                    "urllib3",
                    "wrapt",
                    "zope_event",
                    "zope_interface"
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
                              "gevent",
                              "greenlet",
                              "grequests",
                              "idna",
                              "pycparser",
                              "pygithub",
                              "pyjwt",
                              "pynacl",
                              "requests",
                              "semver",
                              "setuptools",
                              "urllib3",
                              "wrapt",
                              "zope_event",
                              "zope_interface"
                         ]
                    },
                    "output_tree_hash": "13fcc404cf3a995550d1f8ed53ae337effac392e3f18b1d1e9b5dcabbbeef046"
               }
          ]
     },
     {
          "original_rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_archive",
          "definition_information": "Repository rules_python~0.24.0~python~python_3_11_aarch64-apple-darwin_coverage instantiated at:\n  <builtin>: in <toplevel>\nRepository rule http_archive defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/bazel_tools/tools/build_defs/repo/http.bzl:379:31: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_python~0.24.0~python~python_3_11_aarch64-apple-darwin_coverage",
               "urls": [
                    "https://files.pythonhosted.org/packages/67/d7/cd8fe689b5743fffac516597a1222834c42b80686b99f5b44ef43ccc2a43/coverage-7.2.7-cp311-cp311-macosx_11_0_arm64.whl"
               ],
               "sha256": "5baa06420f837184130752b7c5ea0808762083bf3487b5038d68b012e5937dbe",
               "type": "zip",
               "patches": [
                    "@rules_python~0.24.0//python/private:coverage.patch"
               ],
               "patch_args": [
                    "-p1"
               ],
               "build_file_content": "\nfilegroup(\n    name = \"coverage\",\n    srcs = [\"coverage/__main__.py\"],\n    data = glob([\"coverage/*.py\", \"coverage/**/*.py\", \"coverage/*.so\"]),\n    visibility = [\"@python_3_11_aarch64-apple-darwin//:__subpackages__\"],\n)\n    "
          },
          "repositories": [
               {
                    "rule_class": "@bazel_tools//tools/build_defs/repo:http.bzl%http_archive",
                    "attributes": {
                         "url": "",
                         "urls": [
                              "https://files.pythonhosted.org/packages/67/d7/cd8fe689b5743fffac516597a1222834c42b80686b99f5b44ef43ccc2a43/coverage-7.2.7-cp311-cp311-macosx_11_0_arm64.whl"
                         ],
                         "sha256": "5baa06420f837184130752b7c5ea0808762083bf3487b5038d68b012e5937dbe",
                         "integrity": "",
                         "netrc": "",
                         "auth_patterns": {},
                         "canonical_id": "",
                         "strip_prefix": "",
                         "add_prefix": "",
                         "type": "zip",
                         "patches": [
                              "@rules_python~0.24.0//python/private:coverage.patch"
                         ],
                         "remote_patches": {},
                         "remote_patch_strip": 0,
                         "patch_tool": "",
                         "patch_args": [
                              "-p1"
                         ],
                         "patch_cmds": [],
                         "patch_cmds_win": [],
                         "build_file_content": "\nfilegroup(\n    name = \"coverage\",\n    srcs = [\"coverage/__main__.py\"],\n    data = glob([\"coverage/*.py\", \"coverage/**/*.py\", \"coverage/*.so\"]),\n    visibility = [\"@python_3_11_aarch64-apple-darwin//:__subpackages__\"],\n)\n    ",
                         "workspace_file_content": "",
                         "name": "rules_python~0.24.0~python~python_3_11_aarch64-apple-darwin_coverage"
                    },
                    "output_tree_hash": "0fd6b9451013837a0a46e0dbe8b5f00200abc5638111dd54ce3b1313733dbb86"
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
               "extra_pip_args": [
                    "--no-binary",
                    "grequests"
               ],
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
                         "extra_pip_args": [
                              "--no-binary",
                              "grequests"
                         ],
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
          "original_rule_class": "@rules_python~0.24.0//python/pip_install:pip_repository.bzl%whl_library",
          "definition_information": "Repository rules_python~0.24.0~pip~pip_311_pygithub instantiated at:\n  <builtin>: in <toplevel>\nRepository rule whl_library defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_python~0.24.0/python/pip_install/pip_repository.bzl:715:30: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_python~0.24.0~pip~pip_311_pygithub",
               "repo": "pip_311",
               "requirement": "pygithub==1.59.1     --hash=sha256:3d87a822e6c868142f0c2c4bf16cce4696b5a7a4d142a7bd160e1bdf75bc54a9     --hash=sha256:c44e3a121c15bf9d3a5cc98d94c9a047a5132a9b01d22264627f58ade9ddc217",
               "download_only": False,
               "enable_implicit_namespace_pkgs": False,
               "environment": {},
               "extra_pip_args": [
                    "--no-binary",
                    "grequests"
               ],
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
                         "extra_pip_args": [
                              "--no-binary",
                              "grequests"
                         ],
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
          "definition_information": "Repository rules_python~0.24.0~pip~pip_311_semver instantiated at:\n  <builtin>: in <toplevel>\nRepository rule whl_library defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_python~0.24.0/python/pip_install/pip_repository.bzl:715:30: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_python~0.24.0~pip~pip_311_semver",
               "repo": "pip_311",
               "requirement": "semver==3.0.1     --hash=sha256:2a23844ba1647362c7490fe3995a86e097bb590d16f0f32dfc383008f19e4cdf     --hash=sha256:9ec78c5447883c67b97f98c3b6212796708191d22e4ad30f4570f840171cbce1",
               "download_only": False,
               "enable_implicit_namespace_pkgs": False,
               "environment": {},
               "extra_pip_args": [
                    "--no-binary",
                    "grequests"
               ],
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
                         "extra_pip_args": [
                              "--no-binary",
                              "grequests"
                         ],
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
          "definition_information": "Repository rules_python~0.24.0~pip~pip_311_grequests instantiated at:\n  <builtin>: in <toplevel>\nRepository rule whl_library defined at:\n  /private/var/tmp/_bazel_sam/096d0fb8d9b4b97d25f3c6f4e987e69a/external/rules_python~0.24.0/python/pip_install/pip_repository.bzl:715:30: in <toplevel>\n",
          "original_attributes": {
               "name": "rules_python~0.24.0~pip~pip_311_grequests",
               "repo": "pip_311",
               "requirement": "grequests==0.7.0     --hash=sha256:4733edfcece027de25ae8eff86a87f563d7e829fdacbf3ce8b3aeea507694287     --hash=sha256:5c33f14268df5b8fa1107d8537815be6febbad6ec560524d6a404b7778cf6ba6",
               "download_only": False,
               "enable_implicit_namespace_pkgs": False,
               "environment": {},
               "extra_pip_args": [
                    "--no-binary",
                    "grequests"
               ],
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
                         "name": "rules_python~0.24.0~pip~pip_311_grequests",
                         "repo": "pip_311",
                         "requirement": "grequests==0.7.0     --hash=sha256:4733edfcece027de25ae8eff86a87f563d7e829fdacbf3ce8b3aeea507694287     --hash=sha256:5c33f14268df5b8fa1107d8537815be6febbad6ec560524d6a404b7778cf6ba6",
                         "download_only": False,
                         "enable_implicit_namespace_pkgs": False,
                         "environment": {},
                         "extra_pip_args": [
                              "--no-binary",
                              "grequests"
                         ],
                         "isolated": True,
                         "pip_data_exclude": [],
                         "python_interpreter": "",
                         "python_interpreter_target": "@rules_python~0.24.0~python~python_3_11_aarch64-apple-darwin//:bin/python3",
                         "quiet": True,
                         "repo_prefix": "pip_311_",
                         "timeout": 600
                    },
                    "output_tree_hash": "ef87f0d6b49d12267461cb05bcbf03c39f8fed72adbf76730d516c245fd4cc95"
               }
          ]
     }
]