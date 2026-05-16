
import java.util.Scanner;
public class TriangleCheck {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.print("Nhập cạnh thứ nhất: ");
        int a = sc.nextInt();

        System.out.print("Nhập cạnh thứ hai: ");
        int b = sc.nextInt();

        System.out.print("Nhập cạnh thứ ba: ");
        int c = sc.nextInt();

        if(a + b < c || a + c < b || b + c < a){
            System.out.println("Ba cạnh không tạo thành tam giác");
        }
        else if(a <= 0 || b <= 0 || c<= 0){
            System.out.println("Ba cạnh không tạo thành tam giác");
        }
        else{
            if(a == b  && b == c){
                System.out.println("Tam giác đều");
            }
            else if (a == b || b == c || a == c){
                if(isRightTriangle(a, b, c)){
                    System.out.println("Tam giác vuông cân");
                }
                else{
                    System.out.println("Tam giác cân");
                }
            }
            else{
                System.out.println("Tam giác thường");
            }
        }
        sc.close();
    }
    // hàm kiểm tra tam giác vuông
    private static boolean isRightTriangle(int a, int b, int c){
        return a * a + b * b == c * c || a * a + c * c == b * b || c * c + b * b == a * a;
    }
}

