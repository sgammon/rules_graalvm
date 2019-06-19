# rules_graal

Turn a JVM binary into a native binary.

## Usage

You'll need to first load the rules in your WORKSPACE file.

``` python
git_repository(
    name = "rules_graal",
    commit = "<<pick-a-recent-commit-sha>>",
    remote = "git://github.com/andyscott/rules_graal",
)

load("@rules_graal//graal:graal_bindist.bzl", "graal_bindist_repository")

graal_bindist_repository(
    name = "graal",
    version = "19.0.0",
)
```

Then, in a build file:

```python
load("@rules_graal//graal:graal.bzl", "graal_binary")

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
