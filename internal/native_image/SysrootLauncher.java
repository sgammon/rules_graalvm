package build.bazel.rules_graalvm;

import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/**
 * Runs {@code native-image} with the C toolchain's sysroot made absolute.
 *
 * <p>A hermetic C toolchain (for example toolchains_llvm with a fetched sysroot) carries its libc and headers
 * in a sysroot, which its own compile and link actions pass as a flag relative to the execution root.
 * {@code native-image} invokes the C compiler itself, from its own temporary directory, so the sysroot must be
 * passed as an absolute path; this launcher resolves it against the action's working directory, without a
 * shell.
 *
 * <pre>sysroot_launcher &lt;native-image&gt; &lt;sysroot&gt; &lt;native-image arguments...&gt;</pre>
 */
public final class SysrootLauncher {

    private SysrootLauncher() {}

    public static void main(String[] args) throws Exception {
        if (args.length < 2) {
            throw new IllegalArgumentException("usage: sysroot_launcher <native-image> <sysroot> <arguments...>");
        }
        List<String> command = new ArrayList<>();
        command.add(Path.of(args[0]).toAbsolutePath().toString());
        command.addAll(List.of(args).subList(2, args.length));
        command.add("-H:CCompilerOption=--sysroot=" + Path.of(args[1]).toAbsolutePath());
        Process process = new ProcessBuilder(command).inheritIO().start();
        System.exit(process.waitFor());
    }
}
