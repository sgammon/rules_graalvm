package example.testing;

import static org.junit.jupiter.api.Assertions.assertEquals;
import example.testing.Something;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Disabled;

public class SomethingTest {
    @Test
    public void testMath() {
        assertEquals(3, 1 + 2);
    }

    @Test
    @Disabled
    public void testFails() {
        assertEquals(4, 1 + 2);
    }

    // @Test
    // public void testSomething() {
    //     assertEquals(3, Something.add(1, 2));
    // }

    // @Test
    // public void testSomethingThatFails() {
    //     assertEquals(9, Something.add(1, 2));
    // }
}
