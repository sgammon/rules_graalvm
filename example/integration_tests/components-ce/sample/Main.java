import org.graalvm.polyglot.Context;

import java.io.BufferedOutputStream;
import java.io.OutputStream;


public class Main {
    public static void main(String args[]) {
        OutputStream myOut = new BufferedOutputStream(System.out);
        Context context = Context.newBuilder("js")
                .out(myOut)
                .allowAllAccess(true)
                .build();
        context.eval("js", "42");
        context.close();
    }
}
