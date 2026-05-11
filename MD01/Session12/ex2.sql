CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    stock INT CHECK (stock >= 0)
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    quantity INT CHECK (quantity > 0)
);

INSERT INTO products (name, stock) VALUES
('Áo thun', 10),
('Quần jeans', 5),
('Giày thể thao', 0);   -- Sản phẩm hết hàng để test

CREATE OR REPLACE FUNCTION check_stock_before_sale()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock INT;
BEGIN
    -- Lấy số lượng tồn kho hiện tại của sản phẩm
    SELECT stock INTO v_stock
    FROM products
    WHERE product_id = NEW.product_id;

    -- Kiểm tra tồn kho
    IF NEW.quantity > v_stock THEN
        RAISE EXCEPTION 'Không đủ hàng trong kho! Sản phẩm % chỉ còn % cái.',
            (SELECT name FROM products WHERE product_id = NEW.product_id),
            v_stock;
    END IF;

    -- Nếu đủ hàng, cho phép insert tiếp tục
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_check_stock
    BEFORE INSERT ON sales
    FOR EACH ROW
    EXECUTE FUNCTION check_stock_before_sale();

	INSERT INTO sales (product_id, quantity) VALUES (1, 3);
-- Kỳ vọng: INSERT thành công.

SELECT * FROM sales;

INSERT INTO sales (product_id, quantity) VALUES (1, 20);
-- Kỳ vọng: ERROR: Không đủ hàng trong kho! Sản phẩm Áo thun chỉ còn 10 cái.

INSERT INTO sales (product_id, quantity) VALUES (3, 1);
-- Kỳ vọng: ERROR: Không đủ hàng trong kho! Sản phẩm Giày thể thao chỉ còn 0 cái.

