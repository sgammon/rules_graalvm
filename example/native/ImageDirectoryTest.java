import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

public final class ImageDirectoryTest {
    public static void main(String[] args) throws Exception {
        Path directory = Path.of(args[0]).toAbsolutePath();
        String name = System.getProperty("os.name").startsWith("Windows") ? "hello.exe" : "hello";
        String manifest = Files.readString(directory.resolve("build-artifacts.json"));
        if (!manifest.contains('"' + name + '"')) {
            throw new AssertionError("Missing executable in Native Image build artifacts: " + manifest);
        }
        Process process = new ProcessBuilder(directory.resolve(name).toString()).start();
        String greeting = new String(process.getInputStream().readAllBytes(), StandardCharsets.UTF_8).trim();
        if (process.waitFor() != 0 || !greeting.equals("Hello, GraalVM!")) {
            throw new AssertionError("Unexpected image output: " + greeting);
        }
    }
}
