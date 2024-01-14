package graalvm.testing;

public final class NativeTestRunner {
    private static final String discoveryProperty = "bazel.graalvm.testing.discovery";
    private static final String entryWrapped = "bazel.graalvm.testing.wrappedEntry";
    private static final String bazelSuite = "bazel.test_suite";

    public static void main(String[] args) {
        NativeTestLauncher.exec(
            System.getProperty(entryWrapped),
            System.getProperty(bazelSuite),
            "true".equals(System.getProperty(discoveryProperty)),
            args
        );
    }
}
