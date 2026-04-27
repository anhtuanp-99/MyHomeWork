CREATE TABLE employees(
	emp_id SERIAL PRIMARY KEY,
	emp_name VARCHAR(100),
	job_level INT,
	salary NUMERIC
);

-- Công ty muốn cập nhật mức lương mới cho từng nhân viên dựa trên job_level:

-- Level 1 → tăng 5%
-- Level 2 → tăng 10%
-- Level 3 → tăng 15%
-- Tạo Procedure adjust_salary(p_emp_id INT, OUT p_new_salary NUMERIC) để:
-- 		Nhận emp_id của nhân viên
-- 		Cập nhật lương theo quy tắc trên
-- 		Trả về p_new_salary (lương mới) sau khi cập nhật
-- 		Thực thi thử:
-- 		CALL adjust_salary(3, p_new_salary);
-- 		SELECT p_new_salary

INSERT INTO employees(emp_name, job_level, salary) VALUES
('Tuấn', 3, 30000000),
('Dũng', 1, 20000000),
('Vỹ', 2, 25000000),
('Tâm', 1, 15000000);

DROP TABLE employees;
SELECT * FROM employees;

CREATE OR REPLACE PROCEDURE adjust_salary(
	IN p_emp_id INT,
	OUT p_new_salary NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
	v_current_salary NUMERIC;
	v_current_job_level INT;
	v_rate NUMERIC;
BEGIN
	-- Validate input
	IF p_emp_id IS NULL OR p_emp_id <= 0 THEN
		RAISE EXCEPTION 'Mã khách hàng % không hợp lệ!', p_emp_id
		USING ERRCODE = 'P0001';
	END IF;
	
	-- Lấy thông tin
	SELECT salary, job_level INTO v_current_salary, v_current_job_level
	FROM employees
	WHERE emp_id = p_emp_id;

	-- Kiểm tra tồn tại
	IF NOT FOUND THEN
		RAISE EXCEPTION 'Mã nhân viên % không tồn tại!', p_emp_id
		USING ERRCODE = 'P0003';
	END IF;

	-- Thuật toán
	IF v_current_job_level = 1 THEN
		v_rate := 0.05;
	ELSEIF v_current_job_level = 2 THEN
		v_rate := 0.1;
	ELSEIF v_current_job_level = 3 THEN
		v_rate := 0.15;
	ELSE
		RAISE EXCEPTION 'Job level % không hợp lệ, chỉ nhận 1, 2, 3', v_current_job_level
		USING ERRCODE = 'P0005';
	END IF;

	-- Cập nhật lương mới
	UPDATE employees
	SET salary = salary * ( 1 + v_rate )
	WHERE emp_id = p_emp_id
	RETURNING salary INTO p_new_salary;

	RAISE NOTICE 'Nhân viên: %, lương mới %', p_emp_id, p_new_salary;
END;
$$;

CALL adjust_salary(2, NULL);

DO $$
DECLARE
	v_new_salary NUMERIC;
BEGIN
	CALL adjust_salary(3, v_new_salary);
	RAISE NOTICE 'Lương mới của nhân viên 3 = %', v_new_salary;
END;
$$;