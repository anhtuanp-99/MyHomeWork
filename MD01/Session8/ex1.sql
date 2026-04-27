

CREATE TABLE order_detail(
	id SERIAL PRIMARY KEY,
	order_id INT,
	product_name VARCHAR(100),
	quantity INT,
	unit_price NUMERIC(10,2)
);

DROP TABLE order_detail;

INSERT INTO order_detail(order_id, product_name, quantity, unit_price) VALUES
(1, 'Laptop', 2, 15000000),
(1, 'Chuột không dây', 5, 250000),
(1, 'Bàn phím cơ', 3, 1200000),
(2, 'Màn hình 27 inch', 1, 5500000),
(2, 'Cáp HDMI', 2, 150000),
(3, 'Tai nghe bluetooth', 1, 800000);
SELECT * FROM order_detail;


-- Viết một Stored Procedure có tên calculate_order_total(order_id_input INT, OUT total NUMERIC)
-- Tham số order_id_input: mã đơn hàng cần tính
-- Tham số total: tổng giá trị đơn hàng
-- Trong Procedure:
-- Viết câu lệnh tính tổng tiền theo order_id
-- Gọi Procedure để kiểm tra hoạt động với một order_id cụ thể

CREATE OR REPLACE PROCEDURE calculate_order_total(
	IN p_order_id INT,
	OUT p_total NUMERIC
)
LANGUAGE plpgsql
AS $$ 
BEGIN
	-- Kiểm tra id có tồn tại trong bảng hay ko
	IF p_order_id IS NULL THEN
		RAISE EXCEPTION 'p_order_id không được NULL'
			USING ERRCODE = 'P0001';
	END IF;

	PERFORM 1
	FROM order_detail
	WHERE order_id = p_order_id;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'Đơn hàng % không tồn tại hoặc không có sản phẩm', p_order_id
		USING ERRCODE = 'P0003';
	END IF;	
	
	-- Tính toán
	SELECT COALESCE(SUM(od.quantity * od.unit_price), 0) INTO p_total
	FROM order_detail AS od
	WHERE od.order_id = p_order_id;

	RAISE NOTICE 'Tổng giá trị đơn hàng % = %', p_order_id, p_total;
END;
$$;

CALL calculate_order_total(2, NULL);

DROP PROCEDURE calculate_order_total;