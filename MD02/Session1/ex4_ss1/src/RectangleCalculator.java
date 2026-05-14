import java.util.Scanner;

public class RectangleCalculator {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // Khai báo các biến
        float width, height;
        float area, perimeter;

        // Nhập chiều rộng
        System.out.print("Nhập chiều rộng hình chữ nhật: ");
        width = scanner.nextFloat();

        // Nhập chiều cao
        System.out.print("Nhập chiều cao hình chữ nhật: ");
        height = scanner.nextFloat();

        // Tính diện tích và chu vi
        area = width * height;
        perimeter = 2.0f * (width + height);

        // In kết quả

        System.out.println("Chiều rộng = " + width);
        System.out.println("Chiều cao  = " + height);
        System.out.println("Diện tích = " + area);
        System.out.println("Chu vi    = " + perimeter);

        scanner.close();
    }
}