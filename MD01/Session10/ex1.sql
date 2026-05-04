
CREATE TABLE products(
	id SERIAL PRIMARY KEY,
	name VARCHAR(200) NOT NULL,
	price NUMERIC(10,2) NOT NULL,
	last_modified TIMESTAMPTZ
);

CREATE OR REPLACE FUNCTION update_last_modified()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
BEGIN
	-- gán thời gian hiện tại cho cột last_modified
	NEW.last_modified := now();
	RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN
	-- Ghi log lỗi
	RAISE LOG 'Lỗi trong trigger update_last_modified [%]: %', TG_OP, SQLERRM;
	RAISE;
END;
$$;

CREATE TRIGGER trg_update_last_modified
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_last_modified();

-- Chèn dữ liệu mẫu
INSERT INTO products(name, price) VALUES
('Laptop DELL', 2500.00),
('Chuột không dây', 25.00),
('Bàn phím cơ', 120.00);

SELECT * FROM products;

UPDATE products
SET price = 3000
WHERE id = 1;

UPDATE products
SET price = price * 1.1
WHERE id IN (2, 3);