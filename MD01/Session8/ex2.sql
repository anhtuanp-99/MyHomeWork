CREATE TABLE inventory(
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(100),
	quantity INT
);

-- Yêu cầu:

-- Viết một Procedure có tên check_stock(p_id INT, p_qty INT) để:
-- Kiểm tra xem sản phẩm có đủ hàng không
-- Nếu quantity < p_qty, in ra thông báo lỗi bằng RAISE EXCEPTION ‘Không đủ hàng trong kho’
-- Gọi Procedure với các trường hợp:
-- Một sản phẩm có đủ hàng
-- Một sản phẩm không đủ hàng

INSERT INTO inventory(product_name, quantity) VALUES
('laptop Dell', 10),
('Chuột không dây', 5),
('Bàn phím cơ', 0);

SELECT * FROM inventory;

CREATE OR REPLACE PROCEDURE check_stock(
	IN p_id INT,
	IN p_qty INT
)
LANGUAGE plpgsql
AS $$ 
DECLARE
	v_current_qty INT;
BEGIN
	-- Validate input
	IF p_id IS NULL OR p_id <= 0 THEN
		RAISE EXCEPTION 'Mã sản phẩm % không hợp lệ!', p_id
		USING ERRCODE = 'P0001';
	END IF;

	IF p_qty IS NULL OR p_qty <= 0 THEN
		RAISE EXCEPTION 'Số lượng yêu cầu phải > 0'
			USING ERRCODE = 'P0002';
	END IF;

	-- Lấy số lượng trong kho hiện tại
	SELECT quantity INTO v_current_qty
	FROM inventory
	WHERE product_id = p_id;

	--Kiểm tra sản phẩm có tồn tại không
	IF NOT FOUND THEN
		RAISE EXCEPTION 'Không tìm thấy sản phẩm với mã %', p_id
			USING ERRCODE = 'P0003';
	END IF;

	-- Kiểm tra tồn kho
	IF v_current_qty < p_qty THEN
		RAISE EXCEPTION 'Không đủ hàng trong kho(cần: %, còn: %)', p_qty, v_current_qty
		USING ERRCODE = 'P0004';
	END IF;

	-- Đủ hàng
	RAISE NOTICE 'Đủ hàng. Số lượng tồn %, yêu cầu %', v_current_qty, p_qty;
		
END;
$$;

CALL check_stock(1, 12);