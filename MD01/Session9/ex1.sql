CREATE TABLE orders(
	order_id SERIAL PRIMARY KEY,
	customer_id INT NOT NULL,
	order_date DATE DEFAULT CURRENT_DATE,
	total_amount NUMERIC(12, 2)
);

INSERT INTO orders(customer_id, order_date, total_amount) VALUES
(1, '2026-4-30', 5000),
(3, '2026-4-15', 7000),
(2, '2026-4-20', 6000),
(4, '2026-5-30', 9000),
(1, '2026-7-25', 8000),
(5, '2026-4-30', 9000);

-- Sinh dữ liệu giả 500000 dòng
INSERT INTO orders(customer_id, order_date, total_amount)
SELECT
	(random() * 1000)::INT + 1,
	CURRENT_DATE - (random() * 365)::INT,
	(random() * 1000)::NUMERIC(10,2)
FROM generate_series(1, 500000);

SELECT * FROM orders;
DROP TABLE orders;

-- Kiểm tra hiệu suất trước khi indexs
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM orders
WHERE customer_id = 123; -- SEQ Scan, Rows Removed by Filter: 166498, Execution Time: 74.921 ms 

-- Tạo B-Tree Index
CREATE INDEX idx_customer_id ON orders(customer_id);

-- Kiểm tra lại hiệu suất
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM orders
WHERE customer_id = 123; -- Bitmap Index Scan on idx_customer_id, Execution Time: 7.951 ms --> nhanh hơn

DROP INDEX IF EXISTS idx_customer_id;


SELECT ctid, order_id, customer_id FROM orders ORDER BY order_id LIMIT 20;
SELECT ctid, order_id, customer_id FROM orders WHERE customer_id = 123;
CLUSTER orders USING idx_customer_id;

