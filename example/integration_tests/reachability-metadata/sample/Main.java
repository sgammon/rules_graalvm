import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Uses Apache Commons Logging, which discovers its {@code LogFactory} implementation reflectively
 * (via {@code Class.forName} on {@code org.apache.commons.logging.impl.LogFactoryImpl}). A native
 * image therefore needs reachability metadata for those classes -- which Commons Logging does NOT
 * ship itself.
 *
 * <p>The {@code sample-with-metadata} target builds with
 * {@code resolve_upstream_reachability_metadata = True} and runs. The
 * {@code sample-without-metadata} target builds the same code with it off: it then fails at runtime
 * with {@code LogConfigurationException} caused by
 * {@code ClassNotFoundException: org.apache.commons.logging.impl.LogFactoryImpl}.
 */
public final class Main {
    public static void main(String[] args) {
        Log log = LogFactory.getLog(Main.class);
        log.info("hello from commons-logging on a GraalVM native image");
        System.out.println("OK: commons-logging resolved its factory: " + log.getClass().getName());
    }

    private Main() {}
}
