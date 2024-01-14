
package graalvm.testing;

import org.graalvm.nativeimage.hosted.Feature;
import java.util.Collections;
import java.util.List;

public final class NativeTestFeature implements Feature {
    @Override
    public List<Class<? extends Feature>> getRequiredFeatures() {
        return Collections.singletonList(
            org.graalvm.junit.platform.JUnitPlatformFeature.class
        );
    }
}
