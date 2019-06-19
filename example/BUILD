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


graal_binary(
    name = "main-native-reflectioncfg",
    deps = [":main"],
    initialize_at_build_time=["Main"],
    reflection_configuration = "reflection.cfg",
    main_class = "Main",
)


