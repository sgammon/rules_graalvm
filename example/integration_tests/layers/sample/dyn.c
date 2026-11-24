/*
 * Trivial dynamic library used by the `cc_deps_dynamic` sanity sample.
 *
 * The function is exported with default visibility so the produced `libdyn.so`
 * carries a real symbol; the layer references it via a `cc_deps_dynamic` entry
 * which causes `-ldyn` on the link line.
 *
 * For the rules-level sanity check we only validate that the layer's `.so` ends
 * up with a `NEEDED libdyn.so` entry, that `<layer>.runtime_libs/libdyn.so` is
 * staged adjacent, and that the consumer image's RPATH points at the staged dir.
 * Whether anything actually calls `dyn_meaning()` at runtime is out of scope
 * here — the real-world validation lives in HEATWAVE.
 */

int dyn_meaning(void) {
    return 42;
}
