-- Tạo bảng customer
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    region VARCHAR(50)
);

-- Tạo bảng orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customer(customer_id),
    total_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);

-- Tạo bảng product
CREATE TABLE product (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2),
    category VARCHAR(50)
);

-- Tạo bảng order_detail
CREATE TABLE order_detail (
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES product(product_id),
    quantity INT
);

-- Khách hàng theo khu vực
INSERT INTO customer (full_name, region) VALUES
('Nguyễn Văn A', 'Miền Bắc'),
('Trần Thị B', 'Miền Bắc'),
('Lê Văn C', 'Miền Trung'),
('Phạm Thị D', 'Miền Nam'),
('Hoàng Văn E', 'Miền Nam'),
('Vũ Thị F', 'Miền Bắc'),
('Đặng Văn G', 'Miền Trung');

-- Đơn hàng
INSERT INTO orders (customer_id, total_amount, order_date, status) VALUES
(1, 1500000, '2026-01-10', 'COMPLETED'),
(2, 2300000, '2026-01-15', 'COMPLETED'),
(3, 800000, '2026-02-05', 'COMPLETED'),
(4, 4500000, '2026-02-20', 'COMPLETED'),
(5, 3200000, '2026-03-12', 'COMPLETED'),
(6, 1200000, '2026-03-18', 'COMPLETED'),
(7, 950000, '2026-04-01', 'COMPLETED'),
(1, 2800000, '2026-04-10', 'PENDING'),
(2, 500000, '2026-04-15', 'PENDING');

-- Sản phẩm
INSERT INTO product (name, price, category) VALUES
('Laptop Dell XPS', 25000000, 'Điện tử'),
('iPhone 15', 20000000, 'Điện tử'),
('Áo sơ mi', 350000, 'Thời trang'),
('Giày thể thao', 1200000, 'Thời trang'),
('Sách SQL', 250000, 'Sách');

-- Chi tiết đơn hàng (không bắt buộc cho view này nhưng tạo đầy đủ)
INSERT INTO order_detail (order_id, product_id, quantity) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 5),
(4, 4, 3),
(5, 5, 10);

SELECT * FROM customer;
SELECT * FROM orders;
SELECT * FROM product;
SELECT * FROM order_detail;

-- Tạo View tổng hợp doanh thu theo khu vực
CREATE VIEW v_revenue_by_region AS
SELECT
	c.region AS Region,
	SUM(o.total_amount) AS total_revenue
FROM customer as c
INNER JOIN orders o ON o.customer_id = c.customer_id
WHERE o.status = 'COMPLETED'
GROUP BY c.region
ORDER BY c.region;

SELECT * FROM v_revenue_by_region;

-- Truy vấn top 3 khu vực có doanh thu cao nhất
SELECT
	region,
 	total_revenue
FROM v_revenue_by_region
ORDER BY total_revenue DESC
LIMIT 3;

-- Tạo Nested View (View lồng nhau) v_revenue_above_avg
CREATE VIEW v_revenue_above_avg AS
SELECT region, total_revenue
FROM v_revenue_by_region
WHERE total_revenue > (SELECT AVG(total_revenue) FROM v_revenue_by_region

SELECT * FROM v_revenue_above_avg;

-- Thử nghiệm Materialized View
-- Tạo Materialized View lưu trữ dữ liệu vật lý
CREATE MATERIALIZED VIEW mv_revenue_by_region AS
SELECT c.region, SUM(o.total_amount) AS total_revenue
FROM customer c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;

SELECT * FROM mv_revenue_by_region;

-- Refresh dữ liệu khi cần
REFRESH MATERIALIZED VIEW mv_revenue_by_region;

-- Xóa
DROP MATERIALIZED VIEW mv_revenue_by_region;