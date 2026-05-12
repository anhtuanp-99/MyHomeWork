import java.util.Scanner;
public class CircleArea {
    public static void main(String[] args) {
        final double PI = 3.14;

        //Tạo đối tượng Scanner để đọc dữ liệu từ bàn phím
        Scanner scanner = new Scanner(System.in);

        //Nhập bán kính từ người dùng
        System.out.print("Nhập bán kính: ");
        double radius = scanner.nextDouble();

        //Tính diện tích
        double area = PI * radius * radius;

        //In ra kết quả với 2 chữ số thập phân
        System.out.printf("Diện tích : %.2f%n", area);

        // Đóng scanner
        scanner.close();
    }
}

