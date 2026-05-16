import java.util.Scanner;

// đọc số có 3 chữ số thành chữ
public class NumberToWords {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.print("Nhập số nguyên từ 100 đến 999: ");
        int number = sc.nextInt();

        if(number < 100 || number > 999){
            System.out.println("Số không hợp lệ!");
        }
        else {
            int tram = number / 100;
            int chuc = (number / 10) % 10;
            int donvi = number % 10;

            String[] ones = {"", "một", "hai", "ba", "bốn", "năm", "sáu", "bảy", "tám", "chín"};

            //phần trăm
            String result = ones[tram] + " trăm";

            if (chuc == 0 && donvi == 0) {
                //kết thúc
            } else if (chuc == 0) {
                result = result + "lẻ" + ones[donvi];
            } else if (chuc == 1) {
                result += " mười";
                if (donvi == 4) {
                    result += " bốn";
                } else if (donvi == 5) {
                    result += " lăm";
                }
            } else {
                result += ones[chuc] + " mươi ";
                if (donvi == 1) {
                    result += " mốt";
                } else if (donvi == 4) {
                    result += " tư";
                } else if (donvi == 5) {
                    result += " lăm";
                } else {
                    result += ones[donvi];
                }
            }
        System.out.println(result);
        }
        sc.close();
    }
}
