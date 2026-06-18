package dev.elide.tools.graalvm.reachability;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;
import org.graalvm.reachability.DirectoryConfiguration;
import org.graalvm.reachability.internal.FileSystemRepository;

/**
 * Resolves GraalVM reachability metadata for a set of Maven coordinates into a resource jar,
 * delegating to the canonical {@code org.graalvm.buildtools:graalvm-reachability-metadata} library
 * so resolution matches the Gradle/Maven {@code native-build-tools} plugins. Invoked as a build
 * action by the {@code reachability_metadata} rule (//internal/reachability:reachability.bzl).
 *
 * <pre>Resolver --repository repo.zip --coordinates coords.txt --output out.jar</pre>
 */
public final class Resolver {

    // Fixed entry timestamp (2010-01-01Z) so the produced jar is byte-reproducible.
    private static final long FIXED_TIME = 1262304000000L;

    public static void main(String[] args) throws IOException {

        if (args.length != 6) {
            throw new IllegalArgumentException("--repository, --coordinates and --output are required");
        }

        Path repository = null;
        Path coordinates = null;
        Path output = null;
        for (int i = 0; i < args.length; i += 2) {
            String arg = args[i];
            if (arg.equals("--repository")) {
                repository = Path.of(args[i + 1]);
            } else if (arg.equals("--coordinates")) {
                coordinates = Path.of(args[i + 1]);
            } else if (arg.equals("--output")) {
                output = Path.of(args[i + 1]);
            } else {
                throw new IllegalArgumentException("Unknown argument: " + arg);
            }
        }
        if (repository == null || coordinates == null || output == null) {
            throw new IllegalArgumentException("--repository, --coordinates and --output are required");
        }

        Path outputPath = output.toAbsolutePath().normalize();
        Path work = outputPath.resolveSibling("." + outputPath.getFileName() + ".work");
        deleteTree(work);
        Files.createDirectories(work);
        try {
            Path metadataRoot = unzip(repository, work.resolve("repo"));

            List<String> gavs = new ArrayList<>();
            for (String line : Files.readAllLines(coordinates)) {
                if (!line.isBlank()) {
                    gavs.add(line.trim());
                }
            }

            FileSystemRepository repo = new FileSystemRepository(metadataRoot);
            Set<DirectoryConfiguration> configs = repo.findConfigurationsFor(query -> {
                query.forArtifacts(gavs);
                // Match the Gradle/Maven plugins, which do this unconditionally: when the exact
                // version is untested, fall back to the module's latest tested config (releases lag,
                // so pinned versions are routinely newer than the repo's tested set).
                query.useLatestConfigWhenVersionIsUntested();
            });

            Path staging = work.resolve("staging");
            Files.createDirectories(staging);
            DirectoryConfiguration.copy(configs, staging);

            zipTree(staging, outputPath);
        } finally {
            deleteTree(work);
        }
    }

    private static Path unzip(Path zip, Path out) throws IOException {
        Files.createDirectories(out);
        try (ZipInputStream in = new ZipInputStream(new BufferedInputStream(Files.newInputStream(zip)))) {
            for (ZipEntry e; (e = in.getNextEntry()) != null; ) {
                Path target = out.resolve(e.getName()).normalize();
                if (!target.startsWith(out)) {
                    throw new IOException("Refusing to extract outside output dir: " + e.getName());
                }
                if (e.isDirectory()) {
                    Files.createDirectories(target);
                } else {
                    Files.createDirectories(target.getParent());
                    Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
                }
            }
        }
        return out;
    }

    private static void zipTree(Path dir, Path jar) throws IOException {
        if (jar.getParent() != null) {
            Files.createDirectories(jar.getParent());
        }
        List<Path> files;
        try (var walk = Files.walk(dir)) {
            files = walk.filter(Files::isRegularFile).sorted(Comparator.naturalOrder())
                    .collect(Collectors.toList());
        }
        try (ZipOutputStream zos =
                new ZipOutputStream(new BufferedOutputStream(Files.newOutputStream(jar)))) {
            for (Path file : files) {
                ZipEntry entry = new ZipEntry(dir.relativize(file).toString().replace('\\', '/'));
                entry.setTime(FIXED_TIME);
                zos.putNextEntry(entry);
                Files.copy(file, zos);
                zos.closeEntry();
            }
        }
    }

    private static void deleteTree(Path root) throws IOException {
        if (Files.exists(root)) {
            try (var paths = Files.walk(root)) {
                List<Path> sorted = paths.sorted(Comparator.reverseOrder()).collect(Collectors.toList());
                for (Path path : sorted) {
                    Files.delete(path);
                }
            }
        }
    }

    private Resolver() {}
}
