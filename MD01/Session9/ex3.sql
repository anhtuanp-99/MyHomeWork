CREATE TABLE products(
	product_id SERIAL PRIMARY KEY,
	category_id INT,
	price NUMERIC(10, 2),
	stock_quantity INT
);

INSERT INTO products(category_id, price, stock_quantity)
SELECT
	(random() * 50)::INT + 1,
	(random() * 10000)::NUMERIC + 2000,
	(random() * 30)::INT
FROM generate_series(1, 500000) AS i;

SELECT * FROM products;

-- Kiểm tra hiệu suất khi chưa có index
EXPLAIN(ANALYZE, BUFFERS)
SELECT * FROM products WHERE category_id = 38 ORDER BY price;
-- ->  Parallel Seq Scan on products	Buffers: shared hit=3185	Execution Time: 186.886 ms

CREATE INDEX idx_category_id ON products(category_id);
CREATE INDEX idx_price ON products(price);

-- Kiểm tra hiệu suất sau khi có index
EXPLAIN(ANALYZE, BUFFERS)
SELECT * FROM products WHERE category_id = 38 ORDER BY price;
--  ->  Bitmap Heap Scan on products	Buffers: shared read=11		Execution Time: 13.348 ms --> truy vấn nhanh hơn

CLUSTER products USING idx_category_id;
ANALYZE products;

SELECT ctid, product_id, price
FROM products
WHERE category_id = 38; -- Vì bảng đã được CLUSTER theo category_id, các dòng này nằm gần nhau

DROP INDEX idx_category_id;
DROP INDEX idx_price;