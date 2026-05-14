import java.util.Scanner;

public class ArithmeticOperators {
    public static void main(String[] args) {
        // Tạo đối tượng Scanner để nhập liệu từ bàn phím
        Scanner scanner = new Scanner(System.in);

        // Khai báo hai biến số nguyên
        int firstNumber, secondNumber;

        // Nhập giá trị cho firstNumber
        System.out.print("Nhập số nguyên thứ nhất: ");
        firstNumber = scanner.nextInt();

        // Nhập giá trị cho secondNumber
        System.out.print("Nhập số nguyên thứ hai: ");
        secondNumber = scanner.nextInt();

        // Thực hiện các phép toán
        int sum        = firstNumber + secondNumber;
        int difference = firstNumber - secondNumber;
        int product    = firstNumber * secondNumber;
        int quotient   = firstNumber / secondNumber;
        int remainder  = firstNumber % secondNumber;

        // In kết quả
        System.out.println("firstNumber = " + firstNumber);
        System.out.println("secondNumber = " + secondNumber);
        System.out.println("Tổng (firstNumber + secondNumber) = " + sum);
        System.out.println("Hiệu (firstNumber - secondNumber) = " + difference);
        System.out.println("Tích (firstNumber * secondNumber) = " + product);
        System.out.println("Thương (firstNumber / secondNumber) = " + quotient);
        System.out.println("Phần dư (firstNumber % secondNumber) = " + remainder);

        scanner.close();
    }
}