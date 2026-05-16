import java.util.Scanner;
// tính tổng các chữ số của một số nguyên
public class SumOfDigits {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.print("Nhập số nguyên: ");
        int number = sc.nextInt();

        // xử lí số âm
        int temp = Math.abs(number);

        int sum = 0;

        while (temp > 0){
            int digit = temp % 10;
            sum += digit;
            temp = temp / 10;
        }
        // kết quar
        System.out.println("Tổng là: " + sum);

        sc.close();
    }
}
