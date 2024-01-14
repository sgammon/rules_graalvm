"JUnit5 test support."

load("@rules_java//java:defs.bzl", "java_test")

def java_junit5_test(name, srcs, test_package, deps = [], runtime_deps = [], **kwargs):
    """Define a JUnit 5 test.

    Args:
        name: Name of the test target.
        srcs: Sources for the test.
        test_package: The package to test.
        deps: List of dependencies.
        runtime_deps: List of runtime dependencies.
        **kwargs: Additional arguments to pass to java_test.
    """

    FILTER_KWARGS = [
        "main_class",
        "use_testrunner",
        "args",
    ]

    for arg in FILTER_KWARGS:
        if arg in kwargs.keys():
            kwargs.pop(arg)

    junit_console_args = []
    if test_package:
        junit_console_args.extend([
            "--select-package", test_package
        ])
    else:
        junit_console_args.append("--scan-class-path")

    java_test(
        name = name,
        srcs = srcs,
        use_testrunner = False,
        main_class = "org.junit.platform.console.ConsoleLauncher",
        args = junit_console_args,
        deps = deps + [
             "@maven_gvm//:org_junit_jupiter_junit_jupiter_api",
             "@maven_gvm//:org_junit_jupiter_junit_jupiter_params",
             "@maven_gvm//:org_junit_jupiter_junit_jupiter_engine",
        ],
        runtime_deps = runtime_deps + [
             "@maven_gvm//:org_junit_platform_junit_platform_console",
        ],
        **kwargs
    )
