CREATE TABLE Employee (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    department VARCHAR(50),
    salary NUMERIC(15,2),
    hire_date DATE
);

INSERT INTO Employee (full_name, department, salary, hire_date) VALUES
('Nguyễn Văn An', 'IT', 15000000, '2023-05-10'),
('Trần Bình An', 'Marketing', 5000000, '2022-12-15'),
('Lê Văn Cường', 'IT', 12000000, '2023-01-20'),
('Phạm Thùy Chi', 'HR', 5500000, '2023-11-05'),
('Đặng Quốc Bảo', 'IT', 10000000, '2024-02-01'),
('Hoàng Thanh tâm', 'Sales', 7000000, '2023-08-25');

UPDATE Employee 
SET salary = salary * 1.1
WHERE department = 'IT';

DELETE FROM Employee 
WHERE salary < 6000000;

SELECT * FROM Employee 
WHERE full_name ILIKE '%An%';
-- Dấu % có nghĩa là "bất cứ ký tự nào trước hoặc sau chữ An"

SELECT * FROM Employee 
WHERE hire_date BETWEEN '2023-01-01' AND '2023-12-31';