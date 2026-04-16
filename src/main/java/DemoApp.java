
public class DemoApp {
    public static void main(String[] args) {
            System.out.println("Demo app is running...");
            try {
                Thread.sleep(2000); // simulate workload
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println("Finished.");
    }
}

