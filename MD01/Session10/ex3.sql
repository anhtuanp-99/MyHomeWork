CREATE TABLE employees(
	employee_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	position VARCHAR(100),
	salary NUMERIC(10,2) NOT NULL CHECK(salary > 0) 
);


CREATE TABLE employees_log(
	log_id SERIAL PRIMARY KEY,
	employee_id INT NOT NULL,
	operation VARCHAR(10) NOT NULL CHECK(operation IN ('INSERT', 'UPDATE', 'DELETE')),
	old_data JSONB,
	new_data JSONB,
	change_time TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Yêu cầu tạo một Trigger để ghi lại mọi thay đổi (thêm mới, sửa, xóa) vào bảng 
SELECT * FROM employees;
SELECT * FROM employees_log;

CREATE OR REPLACE FUNCTION log_employee_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
BEGIN
	CASE TG_OP
		WHEN 'INSERT' THEN
			INSERT INTO employees_log(employee_id, operation, old_data, new_data) 
			VALUES (NEW.employee_id, 'INSERT', NULL, to_jsonb(NEW));
			
		WHEN 'UPDATE' THEN
			INSERT INTO employees_log(employee_id, operation, old_data, new_data)
			VALUES (NEW.employee_id, 'UPDATE', to_jsonb(OLD), to_jsonb(NEW));

		WHEN 'DELETE' THEN
			INSERT INTO employees_log(employee_id, operation, old_data, new_data)
			VALUES (OLD.employee_id, 'DELETE', to_jsonb(OLD), NULL);
	END CASE;

	RETURN NULL;

EXCEPTION
	WHEN OTHERS THEN
		RAISE LOG 'Lỗi trong trigger log_employee_change !';
		RAISE;
END;
$$;

-- Tạo trigger
CREATE TRIGGER trg_log_employee_change
AFTER INSERT OR UPDATE OR DELETE ON employees
FOR EACH ROW
EXECUTE FUNCTION log_employee_change();

INSERT INTO employees (name, position, salary) VALUES
('Nguyễn Văn A', 'Developer', 1500.00),
('Trần Thị B',   'Manager',  2500.00);

SELECT * FROM employees;
SELECT * FROM employees_log;

UPDATE employees
SET salary = 1800
WHERE employee_id = 1;

SELECT * FROM employees_log
WHERE employee_id = 1;

DELETE FROM employees
WHERE employee_id = 2;
-- LOG HOẠT ĐỘNG CHÍNH XÁC
