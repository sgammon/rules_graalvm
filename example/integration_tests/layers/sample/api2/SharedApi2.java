package api2;

import org.graalvm.nativeimage.IsolateThread;
import org.graalvm.nativeimage.c.function.CEntryPoint;

public final class SharedApi2 {

    private SharedApi2() {}

    @CEntryPoint(name = "shared_api2_double")
    public static int doubleIt(IsolateThread thread, int x) {
        return x * 2;
    }
}
