import java.util.Scanner;

public class FractionSum {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // Nhập phân số thứ nhất
        System.out.print("Nhập tử số phân số thứ nhất: ");
        int num1 = scanner.nextInt();
        System.out.print("Nhập mẫu số phân số thứ nhất: ");
        int den1 = scanner.nextInt();
        while (den1 == 0) {
            System.out.print("Mẫu số phải khác 0. Nhập lại mẫu số phân số thứ nhất: ");
            den1 = scanner.nextInt();
        }

        // Nhập phân số thứ hai
        System.out.print("Nhập tử số phân số thứ hai: ");
        int num2 = scanner.nextInt();
        System.out.print("Nhập mẫu số phân số thứ hai: ");
        int den2 = scanner.nextInt();
        while (den2 == 0) {
            System.out.print("Mẫu số phải khác 0. Nhập lại mẫu số phân số thứ hai: ");
            den2 = scanner.nextInt();
        }

        // Tính tổng
        int resultNum = num1 * den2 + num2 * den1;
        int resultDen = den1 * den2;

        // Rút gọn phân số
        int gcd = findGCD(Math.abs(resultNum), Math.abs(resultDen));
        resultNum /= gcd;
        resultDen /= gcd;

        // Nếu mẫu số âm, chuyển dấu lên tử số
        if (resultDen < 0) {
            resultNum = -resultNum;
            resultDen = -resultDen;
        }

        // In kết quả
        System.out.println("Tổng hai phân số: " + resultNum + "/" + resultDen);

        scanner.close();
    }

    // Hàm tìm ước chung lớn nhất
    public static int findGCD(int a, int b) {
        while (b != 0) {
            int temp = b;
            b = a % b;
            a = temp;
        }
        return a;
    }
}