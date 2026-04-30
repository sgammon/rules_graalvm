public class Main {
    public static void main(String args[]) {
        String vmName = System.getProperty("java.vm.name");
        String vmVendor = System.getProperty("java.vm.vendor");
        String vmVersion = System.getProperty("java.vm.version");
        String osName = System.getProperty("os.name");
        String osArch = System.getProperty("os.arch");

        System.out.printf(
                "Hello, %s %s (%s) — %s %s%n",
                vmVendor, vmName, vmVersion, osName, osArch
        );
    }
}
