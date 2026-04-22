CREATE TABLE customer(
	customer_id SERIAL PRIMARY KEY,
	full_name VARCHAR(100),
	email VARCHAR(100),
	phone VARCHAR(15)
);

CREATE TABLE orders(
	order_id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customer(customer_id),
	total_amount DECIMAL(10, 2),
	order_date DATE
);

-- Chèn dữ liệu mẫu
INSERT INTO customer (full_name, email, phone) VALUES
('Nguyễn Văn A', 'a.nguyen@example.com', '0901234567'),
('Trần Thị B', 'b.tran@example.com', '0912345678'),
('Lê Văn C', 'c.le@example.com', '0923456789'),
('Phạm Thị D', 'd.pham@example.com', '0934567890');

INSERT INTO orders (customer_id, total_amount, order_date) VALUES
(1, 500000, '2026-01-10'),
(1, 1200000, '2026-01-15'),
(2, 800000, '2026-02-05'),
(3, 2000000, '2026-02-20'),
(2, 1500000, '2026-03-12'),
(4, 300000, '2026-03-18');

-- Tạo một View tên v_order_summary hiển thị:
-- full_name, total_amount, order_date
-- (ẩn thông tin email và phone)
-- Viết truy vấn để xem tất cả dữ liệu từ View
CREATE VIEW v_order_summary AS
SELECT c.full_name, o.total_amount, o.order_date
FROM customer as c
INNER JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.full_name, o.total_amount, o.order_date;

SELECT * FROM v_order_summary;
SELECT * FROM orders;
SELECT * FROM customer;

-- Tạo 1 view lấy về thông tin của tất cả các đơn hàng với điều kiện total_amount ≥ 1 triệu .
CREATE VIEW view_infor_orders AS
SELECT order_id, customer_id, total_amount, order_date
FROM orders
WHERE total_amount >= 1000000
ORDER BY total_amount;

SELECT * FROM view_infor_orders;

-- Sau đó bạn hãy cập nhật lại thông tin 1 bản ghi trong view đó nhé .
UPDATE view_infor_orders
SET total_amount = 1600000
WHERE order_id = 5;

-- Tạo một View thứ hai v_monthly_sales thống kê tổng doanh thu mỗi tháng
CREATE VIEW v_monthly_sales AS
SELECT
	EXTRACT(YEAR FROM order_date) AS year,
	EXTRACT(MONTH FROM order_date) AS month,
	SUM(total_amount) AS monthly_total
FROM orders
GROUP BY year, month
ORDER BY year, month;

SELECT * FROM v_monthly_sales;

-- Thử DROP View và ghi chú sự khác biệt giữa DROP VIEW và DROP MATERIALIZED VIEW trong PostgreSQL
DROP VIEW v_order_summary;
DROP VIEW IF EXISTS view_infor_orders;

--	DROP VIEW: 	Chỉ xóa định nghĩa view, không mất dữ liệu bảng gốc
-- 	DROP MATERIALIZED VIEW: Xóa cả định nghĩa và dữ liệu đã lưu trữ của view