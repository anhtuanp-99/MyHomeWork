import java.util.Scanner;
public class MonthDays {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.print("Mời chọn tháng 1 -> 12: ");
        int month = sc.nextInt();

        switch (month) {
            case 1:
                System.out.println("Tháng 1 có 31 ngày");
                break;
            case 2:
                System.out.println("Tháng 2 có 28 hoặc 29 ngày");
                break;
            case 3:
                System.out.println("Tháng 3 có 31 ngày");
                break;
            case 4:
                System.out.println("Tháng 4 có 30 ngày");
                break;
            case 5:
                System.out.println("Tháng 5 có 31 ngày");
                break;
            case 6:
                System.out.println("Tháng 6 có 30 ngày");
                break;
            case 7:
                System.out.println("Tháng 7 có 31 ngày");
                break;
            case 8:
                System.out.println("Tháng 8 có 31 ngày");
                break;
            case 9:
                System.out.println("Tháng 9 có 30 ngày");
                break;
            case 10:
                System.out.println("Tháng 10 có 31 ngày");
                break;
            case 11:
                System.out.println("Tháng 11 có 30 ngày");
                break;
            case 12:
                System.out.println("Tháng 12 có 31 ngày");
                break;
            default:
                System.out.println("Tháng không hợp lệ.");
        }

        sc.close();
    }
}