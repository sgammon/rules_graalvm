import org.graalvm.nativeimage.IsolateThread;
import org.graalvm.nativeimage.c.function.CEntryPoint;

public class Main {
    public static void main(String args[]) {
        System.out.println("Hello, GraalVM!");
    }

    @CEntryPoint(name = "sample_meaning")
    public static int meaning(IsolateThread thread) {
        return 42;
    }
}
