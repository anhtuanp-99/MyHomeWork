import java.util.Scanner;
//Sắp Xếp Mảng Giảm Dần và Tìm Kiếm Số
public class SelectionSortAndSearch {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        //Nhập kích thước mảng
        System.out.print("Nhập số lượng phần tử của mảng: ");
        int n = Integer.parseInt(sc.nextLine());
        int[] arr = new int[n];

        //Nhập các phần tử
        System.out.println("Nhập các phần tử của mảng:");
        for(int i = 0; i < n; i++){
            System.out.printf("Phần tử thứ %d:", i + 1);
            arr[i] = Integer.parseInt(sc.nextLine());
        }

        //Sắp xếp mảng giảm dần bằng Selection Sort
        selectionSortDescending(arr);

        // Hiển thị mảng đã sắp xếp
        System.out.println("Mảng sau khi sắp xếp giảm dần:");
        printArray(arr);

        // Nhập số cần tìm
        System.out.println("\nNhập số cần tìm\n");
        int target = Integer.parseInt(sc.nextLine());

        // Tìm kiếm tuyến tính
        int linearResult = linearSearch(arr, target);
        System.out.println("\nTìm kiến tuyến tính");
        if (linearResult != -1){
            System.out.printf("Tìm thấy %d tại vị trí %d", target, linearResult + 1);
        } else {
            System.out.println("Không tìm thấy " + target);
        }

        // Tìm kiếm nhị phân
        int binaryResult = binarySearchDescending(arr, target);
        System.out.println("\nTìm kiếm nhị phân");
        if(binaryResult != -1){
            System.out.printf("Tìm thấy %d tại vị trí %d", target, binaryResult + 1);
        } else {
            System.out.println("Không tìm thấy " + target);
        }

        sc.close();
    }

    //Sắp xếp mảng theo thứ tự giảm dần bằng thuật toán Selection Sort
    public static void selectionSortDescending(int[] arr){
        int n = arr.length;
        for (int i = 0; i < n -1; i++){
            int maxIdx = i;
            for(int j = i + 1; j < n; j ++){
                if(arr[j] > arr[maxIdx]){
                    maxIdx = j;
                }
            }
        // hoán đổi
        int temp = arr[i];
        arr[i] = arr[maxIdx];
        arr[maxIdx] = temp;
        }
    }

    //Tìm kiếm tuyến tính: duyệt từng phần tử cho đến khi gặp target
    public static int linearSearch(int[] arr, int target){
        for(int i = 0; i < arr.length; i++){
            if(arr[i] == target){
                return i;
            }
        }
        return -1;
    }

    //Tìm kiếm nhị phân trên mảng đã sắp xếp GIẢM DẦN.
    public static int binarySearchDescending(int[] arr, int target){
        int left = 0;
        int right = arr.length -1;
        while (left <= right){
            int mid = (left + right) / 2;
            if(arr[mid] == target) {
                return mid;
            } else if(target > arr[mid]){
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return -1;
    }

    // in mảng ra màn hình
    public static void printArray(int[] arr){
        for (int num : arr){
            System.out.print(num + " ");
        }
        System.out.println();
    }


}

