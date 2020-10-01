# rules_graal

Turn a JVM binary into a native binary.

## Usage

You'll need to first load the rules in your WORKSPACE file.

``` python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_graal",
    sha256 = "<zip file sha256sum>",
    strip_prefix = "rules_graal-master",
    urls = [
        "https://github.com/andyscott/rules_graal/archive/<git commit sha>.zip",
    ],
)

load("@rules_graal//graal:graal_bindist.bzl", "graal_bindist_repository")

graal_bindist_repository(
    name = "graal",
    java_version = "8", # 11 is also a valid option.
    version = "19.3.1",
)
```

Then, in a build file:

```python
load("@rules_graal//graal:graal.bzl", "graal_binary")
load("@rules_java//java:defs.bzl", "java_library")

java_library(
    name = "main",
    srcs = glob(["Main.java"]),
)

graal_binary(
    name = "main-native",
    deps = [":main"],
    main_class = "Main",
)
```
