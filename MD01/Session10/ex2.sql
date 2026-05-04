CREATE TABLE customers(
	customer_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	credit_limit NUMERIC(10,2) NOT NULL CHECK(credit_limit >= 0)
);

CREATE TABLE orders(
	order_id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(customer_id),
	order_amount NUMERIC(10,2) NOT NULL CHECK(order_amount >= 0),
	order_date DATE DEFAULT CURRENT_DATE
);

DROP TABLE orders;
-- Viết Function check_credit_limit() để kiểm tra tổng giá trị đơn hàng của khách hàng trước khi insert đơn mới. 
--     Nếu vượt hạn mức, raise exception
-- Tạo Trigger trg_check_credit gắn với bảng orders để gọi Function trước khi insert
SELECT * FROM orders;
SELECT * FROM customers;

CREATE OR REPLACE FUNCTION check_credit_limit()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
	v_current_total NUMERIC(10,2);
	v_credit_limit NUMERIC(10,2);
BEGIN
	-- Lấy hạn mức của khách hàng
	SELECT credit_limit 
	INTO STRICT v_credit_limit
	FROM customers
	WHERE customer_id = NEW.customer_id;
	
	-- Tính tổng giá trị đơn hàng hiện tại của khách hàng đó
	SELECT COALESCE(SUM(order_amount), 0) 
	INTO v_current_total
	FROM orders
	WHERE customer_id = NEW.customer_id;

	IF v_current_total + NEW.order_amount > v_credit_limit THEN
		RAISE EXCEPTION 'Vượt hạn mức tín dụng! Hạn mức: %, Hiện có: %, Đơn mới: %', v_credit_limit, v_current_total, NEW.order_amount
		USING ERRCODE = 'P0001';
	END IF;	

	RETURN NEW;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RAISE EXCEPTION 'Khách hàng với customer_id % không tồn tại!', NEW.customer_id
		USING ERRCODE = 'P0003';
	WHEN OTHERS THEN
		RAISE LOG 'Lỗi trong trigger_check_credit_limit!';
		RAISE;
END;
$$;

CREATE TRIGGER trg_check_credit
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION check_credit_limit();

INSERT INTO customers(name, credit_limit) VALUES
('Anh Tuấn', 5000),
('Phương Mai', 3000),
('Văn Đạt', 2500),
('Đức Huy', 3000);

INSERT INTO orders(customer_id, order_amount) VALUES
(1, 2000),
(2, 2000),
(1, 1000),
(4, 2000),
(3, 2500),
(2, 500);

SELECT * FROM orders;
SELECT * FROM customers;

INSERT INTO orders(customer_id, order_amount) VALUES
(1, 3000);
-- TRIGGER ĐÃ NGĂN CHẶN KHI VƯỢT HẠN MỨC