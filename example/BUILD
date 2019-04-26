load("@rules_graal//graal:graal.bzl", "graal_binary")

java_library(
    name = "main",
    #main_class = "Main",
    srcs = glob(["Main.java"]),
)

graal_binary(
    name = "main-native",
    deps = [":main"],
    main_class = "Main",
)