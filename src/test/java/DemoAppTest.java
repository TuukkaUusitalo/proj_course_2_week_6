import static org.junit.jupiter.api.Assertions.*;

class DemoAppTest {

    @org.junit.jupiter.api.Test
    void main() {
        // Testataan, että main-metodi ei heitä poikkeuksia
        try {
            DemoApp.main(new String[]{});
        } catch (Exception e) {
            fail("Main method threw an exception: " + e.getMessage());
        }
    }

}