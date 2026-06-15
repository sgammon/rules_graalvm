package api;

import org.graalvm.nativeimage.IsolateThread;
import org.graalvm.nativeimage.c.function.CEntryPoint;
import org.graalvm.nativeimage.c.type.CCharPointer;
import org.graalvm.nativeimage.c.type.CTypeConversion;

public final class SharedApi {

    private SharedApi() {}

    @CEntryPoint(name = "shared_api_meaning")
    public static int meaning(IsolateThread thread) {
        return 42;
    }

    @CEntryPoint(name = "shared_api_greet")
    public static int greet(IsolateThread thread, CCharPointer outBuf, int outBufLen) {
        String greeting = "hello from native-image";
        byte[] bytes = greeting.getBytes();
        int n = Math.min(bytes.length, Math.max(0, outBufLen - 1));
        for (int i = 0; i < n; i++) {
            outBuf.write(i, bytes[i]);
        }
        outBuf.write(n, (byte) 0);
        return n;
    }
}
