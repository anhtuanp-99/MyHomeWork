import java.util.ArrayList;
import java.util.Scanner;
public class EvenOddStablePartition {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.print("Nhập số phần tử của mảng:");
        int n = Integer.parseInt(sc.nextLine());

        if(n <= 0){
            System.out.println("Mảng không có phần tử");
            sc.close();
            return;
        }

        // khai báo
        int[] arr = new int[n];
        System.out.print("Nhập các phần tử của mảng:");
        for (int i = 0; i < n; i++){
            System.out.printf("Phần tử thứ %d: ",i + 1);
            arr[i] = Integer.parseInt(sc.nextLine());
        }

        // tách chẵn lẻ
        ArrayList<Integer> evenList = new ArrayList<>();
        ArrayList<Integer> oddList = new ArrayList<>();
        for(int value : arr){
            if (value % 2 == 0){
                evenList.add(value);
            }else {
                oddList.add(value);
            }
        }

        // ghép kết quả
        int index = 0;
        for (int even : evenList){
            arr[index++] = even;
        }
        for (int odd : oddList){
            arr[index++] = odd;
        }

        // in mảng đã sắp xếp
        System.out.println("\nMảng sau khi sắp xếp chẵn trước lẻ sau theo thứ tự: ");
        for (int num : arr) {
            System.out.print(num + " ");
        }

        sc.close();
    }
}
