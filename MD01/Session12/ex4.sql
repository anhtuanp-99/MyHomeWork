-- Xóa bảng cũ nếu có để tạo mới (cẩn thận với dữ liệu thật)
DROP TABLE IF EXISTS order_items, orders, sales, products CASCADE;

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock INT NOT NULL CHECK (stock >= 0)
);

-- Chèn dữ liệu mẫu
INSERT INTO products (name, price, stock) VALUES
('Áo thun', 150000, 10),
('Quần jeans', 350000, 5),
('Giày thể thao', 500000, 3);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    total_amount NUMERIC(10,2)   -- Sẽ được trigger tự động điền
);


CREATE OR REPLACE FUNCTION calculate_total_amount()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
#variable_conflict error
DECLARE
    v_price NUMERIC(10,2);
BEGIN
    -- Lấy giá sản phẩm, đồng thời kiểm tra tồn tại (nhờ REFERENCES đã đảm bảo, nhưng ta vẫn làm để an toàn)
    SELECT price INTO STRICT v_price
    FROM products
    WHERE product_id = NEW.product_id;

    -- Tính tổng tiền và gán vào NEW
    NEW.total_amount := NEW.quantity * v_price;

    -- Cho phép INSERT tiếp tục
    RETURN NEW;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'Sản phẩm với ID % không tồn tại.', NEW.product_id;
END;
$$;

CREATE OR REPLACE FUNCTION calculate_total_amount()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
#variable_conflict error
DECLARE
    v_price NUMERIC(10,2);
BEGIN
    -- Lấy giá sản phẩm, đồng thời kiểm tra tồn tại (nhờ REFERENCES đã đảm bảo, nhưng ta vẫn làm để an toàn)
    SELECT price INTO STRICT v_price
    FROM products
    WHERE product_id = NEW.product_id;

    -- Tính tổng tiền và gán vào NEW
    NEW.total_amount := NEW.quantity * v_price;

    -- Cho phép INSERT tiếp tục
    RETURN NEW;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'Sản phẩm với ID % không tồn tại.', NEW.product_id;
END;
$$;

CREATE TRIGGER trg_calculate_total_amount
    BEFORE INSERT ON orders
    FOR EACH ROW
    EXECUTE FUNCTION calculate_total_amount();

INSERT INTO orders (product_id, quantity) VALUES (1, 2);
-- Tự động tính total_amount = 2 * 150000 = 300000

INSERT INTO orders (product_id, quantity) VALUES (2, 1);
-- total_amount = 1 * 350000 = 350000

SELECT * FROM orders;

INSERT INTO orders (product_id, quantity) VALUES (999, 1);