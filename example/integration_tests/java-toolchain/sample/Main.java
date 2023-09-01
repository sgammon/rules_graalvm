
import org.graalvm.home.Version;


public class Main {
    public static void main(String args[]) {
        System.out.println("Hello, GraalVM: " + Version.getCurrent().toString());
    }
}
