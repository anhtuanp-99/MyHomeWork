CREATE TABLE sales(
	sale_id SERIAL PRIMARY KEY,
	customer_id INT NOT NULL,
	product_id INT NOT NULL,
	sale_date DATE DEFAULT CURRENT_DATE,
	amount NUMERIC(10, 2) NOT NULL
);

-- Tạo View CustomerSales tổng hợp tổng amount theo từng customer_id
-- Viết truy vấn SELECT * FROM CustomerSales WHERE total_amount > 1000; để xem khách hàng mua nhiều
-- Thử cập nhật một bản ghi qua View và quan sát kết quả

INSERT INTO sales(customer_id, product_id, sale_date, amount) VALUES
(1, 2, '2026-4-30', 1500),
(3, 1, '2026-4-15', 3500),
(4, 3, '2026-4-25', 2500),
(2, 2, '2026-3-30', 900),
(1, 3, '2026-5-25', 500),
(3, 4, '2026-6-30', 1500);

SELECT * FROM sales;
DROP TABLE sales CASCADE;

-- Tạo View CustomerSales tổng hợp tổng amount theo từng customer_id
CREATE OR REPLACE VIEW CustomerSales AS
SELECT
	customer_id,
	SUM(amount) AS total_amount
FROM sales
GROUP BY customer_id
ORDER BY customer_id;

DROP VIEW CustomerSales;
SELECT * FROM CustomerSales;

-- Viết truy vấn SELECT * FROM CustomerSales WHERE total_amount > 1000; để xem khách hàng mua nhiều
SELECT * FROM CustomerSales
WHERE total_amount > 1000
ORDER BY total_amount;

-- Thử cập nhật một bản ghi qua View và quan sát kết quả
UPDATE CustomerSales
SET total_amount = 950
WHERE customer_id = 4; -- Không thể cập nhật bản ghi vì View sử dụng SUM và GROUP BY
  