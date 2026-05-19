import java.util.Scanner;
//sắp xếp mảng số nguyên theo thứ tự giảm dần bằng thuật toán Bubble Sort
public class BubbleSortDescending {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println("Nhập số lượng phần tử trong mảng: ");
        int n = Integer.parseInt(sc.nextLine());

        int[] arr = new int[n];
        for(int i = 0; i < n; i++){
            System.out.printf("Phần tử thứ %d: ", i);
            arr[i] = Integer.parseInt(sc.nextLine());
        }

        //Thuật toán
        for(int i = 0; i < n -1; i++){
            for(int j = 0; j < n - 1 - i; j++){
                if(arr[j] < arr[j + 1]){
                    int temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                }
            }
        }

        System.out.println("\nMảng sau khi đã sắp xếp giảm dần: ");
        for(int i = 0; i < n; i++){
            System.out.printf(arr[i] + " ");
        }
        System.out.println();

        sc.close();
    }

}


