CREATE TABLE employees(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	department VARCHAR(50),
	salary NUMERIC(10, 2),
	bonus NUMERIC(10, 2) DEFAULT 0
);

INSERT INTO employees(name, department, salary) VALUES
('Nguyen Van A', 'HR', 4000),
('Tran Thi B', 'IT', 6000),
('Le Van C', 'Finance',10500),
('Pham Van D', 'IT', 8000),
('Do Van E', 'HR', 12000);

ALTER TABLE employees ADD COLUMN IF NOT EXISTS status VARCHAR(20);

SELECT * FROM employees;

-- Tạo Procedure
CREATE OR REPLACE PROCEDURE update_employee_status(
	IN p_emp_id INT,
	OUT p_status TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
	v_current_salary NUMERIC(10, 2);
	v_new_status VARCHAR(20);
BEGIN
	-- Validate input
	IF p_emp_id IS NULL OR p_emp_id <= 0 THEN
		RAISE EXCEPTION 'Mã nhân viên % không hợp lệ!', p_emp_id
		USING ERRCODE = 'P0001';
	END IF;

	-- Lấy thông tin và Kiểm tra tồn tại
	PERFORM 1 FROM employees WHERE id = p_emp_id;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'Mã nhân viên % không tồn tại!', p_emp_id
		USING ERRCODE = 'P0003';
	END IF;

	-- Lấy thông tin và kiểm tra điều kiện
	SELECT salary INTO v_current_salary
	FROM employees
	WHERE id = p_emp_id;

	IF v_current_salary < 5000 THEN
		v_new_status = 'Junior';
	ELSIF v_current_salary < 10000 THEN
		v_new_status = 'Mid-level';
	ELSE
		v_new_status = 'Senior';
	END IF;

	-- Cập nhật thông tin
	UPDATE employees
	SET status = v_new_status
	WHERE id = p_emp_id
	RETURNING status INTO p_status;
	
	RAISE NOTICE 'Nhân viên %, trình độ %', p_emp_id, p_status;

END;
$$;

CALL update_employee_status(2, NULL);
	
DO 
$$
DECLARE
	v_id INT := 1;
	v_status TEXT;
BEGIN
	CALL update_employee_status(v_id, v_status);
	RAISE NOTICE 'Nhân viên % trình độ %',v_id, v_status;
END;
$$;
