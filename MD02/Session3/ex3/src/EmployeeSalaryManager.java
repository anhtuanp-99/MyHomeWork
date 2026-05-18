import java.util.Scanner;
import java.util.ArrayList;
//Quản lý lương nhân viên
public class EmployeeSalaryManager {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        ArrayList<Double> salaries = new ArrayList<>();
        int choice;
        int countEmployee = 0;


        do{
            System.out.println("========Menu========");
            System.out.println("1. Nhập lương nhân viên");
            System.out.println("2. Hiển thị thống kê");
            System.out.println("3. Tính tổng tiền thưởng nhân viên");
            System.out.println("4. Thoát");

            System.out.print("Mời chọn chức năng: ");
            choice = Integer.parseInt(sc.nextLine());

            switch (choice) {
                case 1:
                    System.out.println("Nhập lương nhân viên giá trị từ 0 đến 500 triệu. Gõ -1 để kết thúc");
                    while(true){
                        double salary;
                        if(sc.hasNextDouble()){
                            salary = Double.parseDouble(sc.nextLine());
                        }
                        else{
                            System.out.println("Vui lòng nhập số. Hãy thử lại");
                            continue;
                        }

                        if(salary == -1){
                            break; // kết thúc và thoát vòng lặp
                        }

                        if(salary < 0 || salary > 500000000){
                            System.out.println("Lương không hợp lệ từ (0 đến 500 triệu!");
                            continue;
                        }

                        salaries.add(salary); // thêm lương vào danh sách

                        String level;
                        if(salary < 5000000){
                            level = "Thu nhập thấp";
                        }
                        else if(salary < 15000000){
                            level = "Thu nhập trung bình";
                        }
                        else if(salary < 50000000){
                            level = "Thu nhập khá";
                        }
                        else {
                            level = "Thu nhập cao";
                        }

                        System.out.printf("Lương %.2f: %s%n", salary, level);
                    }

                    //Thống kê
                    if(!salaries.isEmpty()){
                        double total = 0, max = Double.MIN_VALUE, min = Double.MAX_VALUE;
                        for(double s : salaries){
                            total += s;
                            if(s > max) max = s;
                            if(s < min) min = s;
                        }
                    System.out.println("========Kết quả========");
                    System.out.println("Tổng số nhân viên: " + salaries.size());
                    System.out.printf("Tổng lương: %.2f%n", total);
                    System.out.printf("Lương cao nhất: %.2f%n", max);
                    System.out.printf("Lương thấp nhất: %.2f%n", min);
                    }
                    else {
                        System.out.println("Chưa có nhân viên nào được nhập");
                    }
                    break;

                case 2:
                      if(salaries.isEmpty()){
                          System.out.println("Chưa có dữ liệu!");
                          continue;
                      }
                      else{
                          double total = 0, max = Double.MIN_VALUE, min = Double.MAX_VALUE;
                          for(double s : salaries){
                              total += s;
                              if(s > max) max = s;
                              if(s < min) min = s;
                          }
                          double average = total / salaries.size(); // lương trung bình
                          System.out.println("=========Thống kê========");
                          System.out.println("Số nhân viên: " + salaries.size());
                          System.out.printf("Tổng lương: %.2f%n", total);
                          System.out.printf("Lương trung bình: %.2f%n", average);
                          System.out.printf("Lương cao nhất: %.2f%n", max);
                          System.out.printf("Lương thấp nhất: %.2f%n", min);
                      }
                    break;

                case 3: // Tính tổng số tiền thưởng cho nhân viên
                    if(salaries.isEmpty()){
                        System.out.println("Chưa có dữ liệu.");
                    }
                    else {
                        double totalBonus = 0;
                        for(double s : salaries){
                            double bonusRate;
                            if(s < 5000000){
                                bonusRate = 0.05;
                            }
                            else if(s < 15000000){
                                bonusRate = 0.1;
                            }
                            else if(s < 50000000){
                                bonusRate = 0.15;
                            }
                            else if(s < 100000000){
                                bonusRate = 0.2;
                            }
                            else {
                                bonusRate = 0.25;
                            }
                            totalBonus += s * bonusRate;
                        }
                        System.out.printf("Tổng tiền thưởng cho tất cả nhân viên: %,.2f%n", totalBonus);
                    }
                    break;

                case 4:
                    System.out.println("Kết thúc chương trình.");
                    System.exit(0);
                    break;

                default:
                    System.out.println("Lựa chọn không hợp lệ. Vui lòng nhập lại");
            }

        }while (true);
    }
}
