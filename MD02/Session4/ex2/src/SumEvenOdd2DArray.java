import java.util.Scanner;
// Tính tổng các số chẵn và tổng các số lẻ trong mảng 2 chiều
public class SumEvenOdd2DArray {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.print("Nhập số hàng: ");
        int row = Integer.parseInt(sc.nextLine());

        System.out.print("Nhập số cột: ");
        int col = Integer.parseInt(sc.nextLine());

        int[][] arr = new int[row][col];

        for(int i = 0; i < row; i++){
            for(int j = 0; j < col; j++){
                System.out.printf("Phần tử thứ [%d][%d]", i, j);
                arr[i][j] = Integer.parseInt(sc.nextLine());
            }
        }
        System.out.println();

        int sumEven = 0;
        int sumOdd = 0;
        for(int i = 0; i < row; i++){
            for(int j = 0; j < col; j++){
                int value = arr[i][j];
                if(value % 2 == 0){
                    sumEven += value;
                }
                else {
                    sumOdd += value;
                }
            }
        }

        System.out.println("======Kết quả======");
        System.out.println("Tổng các số chẵn: " + sumEven);
        System.out.println("Tổng các số lẻ: " + sumOdd);

        sc.close();
    }
}
