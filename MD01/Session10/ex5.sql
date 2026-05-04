CREATE TABLE customers(
	customer_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	email VARCHAR(255),
	phone VARCHAR(20),
	address TEXT
);

CREATE TABLE customers_log(
	log_id SERIAL PRIMARY KEY,
	customer_id INT NOT NULL,
	operation VARCHAR(10) NOT NULL CHECK(operation IN ('INSERT', 'UPDATE', 'DELETE')),
	old_data JSONB,
	new_data JSONB,
	change_by VARCHAR(100) NOT NULL,
	change_time TIMESTAMPTZ DEFAULT now()
);

CREATE OR REPLACE FUNCTION log_customer_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
	v_changed_by VARCHAR(100);
BEGIN
	v_changed_by := current_user;
	
	CASE TG_OP
		WHEN 'INSERT' THEN
			INSERT INTO customers_log(customer_id, operation, old_data, new_data, change_by)
			VALUES (NEW.customer_id, 'INSERT', NULL, to_jsonb(NEW), v_changed_by);

		WHEN 'UPDATE' THEN
			INSERT INTO customers_log(customer_id, operation, old_data, new_data, change_by)
			VALUES (NEW.customer_id, 'UPDATE', to_jsonb(OLD), to_jsonb(NEW), v_changed_by);

		WHEN 'DELETE' THEN
			INSERT INTO customers_log(customer_id, operation, old_data, new_data, change_by)
			VALUES (OLD.customer_id, 'DELETE', to_jsonb(OLD), NULL, v_changed_by);
	END CASE;

	RETURN NULL;

EXCEPTION
	WHEN OTHERS THEN
		RAISE LOG 'Lỗi trigger log_customer_change!';
		RAISE;
END;
$$;

CREATE TRIGGER trg_log_customer_change
	AFTER INSERT OR UPDATE OR DELETE ON customers
	FOR EACH ROW
	EXECUTE FUNCTION log_customer_change();

INSERT INTO customers(name, email, phone, address) VALUES
('Nguyễn Văn A', 'a.nguyen@example.com', '0901234567', 'Hà Nội'),
('Trần Thị B',   'b.tran@example.com',   '0912345678', 'TP.HCM');

SELECT * FROM customers_log;
SELECT * FROM customers;

UPDATE customers
SET    phone = '0909999999', address = 'Đà Nẵng'
WHERE  customer_id = 1;

DELETE FROM customers
WHERE  customer_id = 2;

-- LOG HOẠT ĐỘNG ĐÚNG YÊU CẦU

