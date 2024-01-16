package graalvm.testing;

import org.graalvm.junit.platform.NativeImageJUnitLauncher;
import org.junit.platform.launcher.Launcher;
import org.junit.platform.launcher.TestExecutionListener;
import org.junit.platform.launcher.TestPlan;

public final class NativeTestLauncher extends NativeImageJUnitLauncher {
    public NativeTestLauncher(Launcher launcher, TestPlan testPlan) {
        super(launcher, testPlan);
    }

    public static void exec(String entry, String suite, boolean discovery, String[] args) {
        NativeImageJUnitLauncher.main();
    }
}
