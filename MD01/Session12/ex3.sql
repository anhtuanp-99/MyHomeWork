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

CREATE OR REPLACE FUNCTION update_stock_after_sale()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
#variable_conflict error
BEGIN
    UPDATE products
    SET stock = stock - NEW.quantity
    WHERE product_id = NEW.product_id;

    RETURN NULL;   -- AFTER trigger không cần trả về dòng, nhưng phải RETURN
END;
$$;

CREATE TRIGGER trg_update_stock
    AFTER INSERT ON sales
    FOR EACH ROW
    EXECUTE FUNCTION update_stock_after_sale();

CREATE OR REPLACE FUNCTION check_stock_before_sale()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock INT;
BEGIN
    SELECT stock INTO v_stock
    FROM products
    WHERE product_id = NEW.product_id;

    IF NEW.quantity > v_stock THEN
        RAISE EXCEPTION 'Không đủ hàng! Sản phẩm % chỉ còn %.', 
            (SELECT name FROM products WHERE product_id = NEW.product_id), v_stock;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_check_stock
    BEFORE INSERT ON sales
    FOR EACH ROW
    EXECUTE FUNCTION check_stock_before_sale();

INSERT INTO sales (product_id, quantity) VALUES (1, 2);

SELECT * FROM products;   -- Áo thun còn 8
SELECT * FROM sales;      -- 1 dòng mới

INSERT INTO sales (product_id, quantity) VALUES (2, 3);

INSERT INTO sales (product_id, quantity) VALUES (1, 20);
-- lỗi "Không đủ hàng! Sản phẩm Áo thun chỉ còn 8."