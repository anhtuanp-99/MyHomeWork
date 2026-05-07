CREATE TABLE products (
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(100),
	stock INT,
	price NUMERIC(10,2)
);

CREATE TABLE orders (
	order_id SERIAL PRIMARY KEY,
	customer_name VARCHAR(100),
	total_amount NUMERIC(10,2),
	created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE order_items(
	order_item_id SERIAL PRIMARY KEY,
	order_id INT REFERENCES orders (order_id),
	product_id INT REFERENCES products(product_id),
	quantity INT,
	subtotal NUMERIC(10,2)
);

-- Sản phẩm có sẵn
INSERT INTO products (product_name, stock, price) VALUES
('Áo thun', 5, 100.00),    -- product_id = 1
('Quần jeans', 3, 200.00), -- product_id = 2
('Giày thể thao', 0, 300.00); -- sản phẩm hết hàng (dùng cho mô phỏng lỗi)


DO $$
DECLARE
    v_stock1 INT; v_stock2 INT;
    v_price1 NUMERIC; v_price2 NUMERIC;
    v_order_id INT;
    v_subtotal1 NUMERIC; v_subtotal2 NUMERIC;
BEGIN
    -- 1. Lấy tồn kho và giá của 2 sản phẩm
    SELECT stock, price INTO v_stock1, v_price1 
	FROM products 
	WHERE product_id = 1;
	
    SELECT stock, price INTO v_stock2, v_price2 
	FROM products 
	WHERE product_id = 2;

    -- 2. Kiểm tra điều kiện đủ hàng
    IF v_stock1 < 2 OR v_stock2 < 1 THEN
        RAISE EXCEPTION 'Không đủ hàng trong kho!';
    END IF;

    -- 3. Giảm tồn kho
    UPDATE products SET stock = stock - 2 WHERE product_id = 1;
    UPDATE products SET stock = stock - 1 WHERE product_id = 2;

    -- 4. Tạo đơn hàng mới
    INSERT INTO orders (customer_name) VALUES ('Nguyen Van A')
    RETURNING order_id INTO v_order_id;

    -- 5. Tính thành tiền từng món
    v_subtotal1 := v_price1 * 2;
    v_subtotal2 := v_price2 * 1;

    -- 6. Thêm chi tiết đơn hàng
    INSERT INTO order_items (order_id, product_id, quantity, subtotal) VALUES
    (v_order_id, 1, 2, v_subtotal1),
    (v_order_id, 2, 1, v_subtotal2);

    -- 7. Cập nhật tổng tiền cho đơn hàng
    UPDATE orders
    SET total_amount = v_subtotal1 + v_subtotal2
    WHERE order_id = v_order_id;

    RAISE NOTICE 'Đặt hàng thành công. Mã đơn: %', v_order_id;
END;
$$;

SELECT * FROM products;    
SELECT * FROM orders;        
SELECT * FROM order_items;   

-- Giả lập hết hàng sản phẩm 1
UPDATE products SET stock = 0 WHERE product_id = 1;

-- Chạy lại transaction
DO $$
DECLARE
    v_stock1 INT; v_stock2 INT;
    v_price1 NUMERIC; v_price2 NUMERIC;
    v_order_id INT;
    v_subtotal1 NUMERIC; v_subtotal2 NUMERIC;
BEGIN
    SELECT stock, price INTO v_stock1, v_price1 
	FROM products 
	WHERE product_id = 1;
	
    SELECT stock, price INTO v_stock2, v_price2 
	FROM products 
	WHERE product_id = 2;

    IF v_stock1 < 2 OR v_stock2 < 1 THEN
        RAISE EXCEPTION 'Không đủ hàng trong kho!';
    END IF;

    UPDATE products 
	SET stock = stock - 2 
	WHERE product_id = 1;
	
    UPDATE products 
	SET stock = stock - 1 
	WHERE product_id = 2;

    INSERT INTO orders (customer_name) VALUES ('Nguyen Van A')
    RETURNING order_id INTO v_order_id;

    v_subtotal1 := v_price1 * 2;
    v_subtotal2 := v_price2 * 1;

    INSERT INTO order_items (order_id, product_id, quantity, subtotal) VALUES
    (v_order_id, 1, 2, v_subtotal1),
    (v_order_id, 2, 1, v_subtotal2);

    UPDATE orders SET total_amount = v_subtotal1 + v_subtotal2 WHERE order_id = v_order_id;

    RAISE NOTICE 'Đặt hàng thành công. Mã đơn: %', v_order_id;
END;
$$;