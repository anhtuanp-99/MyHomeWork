CREATE SCHEMA sales;

-- Bang Customers
CREATE TABLE sales.customers(
	customer_id SERIAL PRIMARY KEY,
	full_name VARCHAR(100) NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE,
	phone VARCHAR(20),
	city VARCHAR(100),
	join_date DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Bang Products
CREATE TABLE sales.products(
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(200) NOT NULL,
	category VARCHAR(100) NOT NULL,
	price NUMERIC(12,2) NOT NULL CHECK(price > 0),
	stock_quantity INT NOT NULL
);


-- Bang Orders
CREATE TABLE sales.orders(
	order_id SERIAL PRIMARY KEY,
	customer_id INT NOT NULL REFERENCES sales.customers(customer_id),
	order_date DATE NOT NULL DEFAULT CURRENT_DATE,
	total_amount NUMERIC(12,2) NOT NULL CHECK(total_amount >= 0),
	status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
);


--Bang order_items (chi tiết đơn hàng)
CREATE TABLE sales.order_items(
	order_item_id SERIAL PRIMARY KEY,
	order_id INT NOT NULL REFERENCES sales.orders(order_id) ON DELETE CASCADE,
	product_id INT NOT NULL REFERENCES sales.products(product_id),
	quantity INT NOT NULL,
	unit_price NUMERIC(12,2) NOT NULL CHECK(unit_price > 0)
);

ALTER TABLE sales.order_items DROP CONSTRAINT order_items_product_id_fkey;
ALTER TABLE sales.order_items ADD CONSTRAINT order_items_product_id_fkey
FOREIGN KEY (product_id) REFERENCES sales.products(product_id) ON DELETE CASCADE;
-- INSERT DATA
-- Thêm 10 khách hàng
INSERT INTO sales.customers (full_name, email, phone, city, join_date) VALUES
('Nguyen Van An',      'an.nguyen@email.com',   '0912345671', 'Ha Noi',        '2024-01-15'),
('Tran Thi Binh',      'binh.tran@email.com',   '0912345672', 'Ho Chi Minh',   '2024-02-20'),
('Le Van Cuong',       'cuong.le@email.com',    NULL,          'Da Nang',       '2024-03-05'),
('Pham Thi Dung',      'dung.pham@email.com',   '0912345674', 'Ha Noi',        '2024-01-10'),
('Hoang Van Em',       'em.hoang@email.com',    '0912345675', 'Hai Phong',     '2024-04-01'),
('Vu Thi Phuong',      'phuong.vu@email.com',   NULL,          'Can Tho',       '2024-05-12'),
('Dang Van Giang',     'giang.dang@email.com',  '0912345677', 'Ho Chi Minh',   '2024-06-18'),
('Bui Thi Hoa',        'hoa.bui@email.com',     '0912345678', 'Da Nang',       '2024-07-22'),
('Ngo Van Hung',       'hung.ngo@email.com',    '0912345679', 'Ha Noi',        '2024-08-30'),
('Ly Thi Huong',       'huong.ly@email.com',    '0912345680', 'Ho Chi Minh',   '2024-09-14');
SELECT * FROM sales.customers;


-- Thêm 15 sản phẩm (3 danh mục)
INSERT INTO sales.products(product_name, category, price, stock_quantity) VALUES
-- Electronics
('Laptop Dell XPS 13',          'Electronics', 25000000, 15),
('iPhone 14 Pro',               'Electronics', 28000000, 0),
('Tai nghe Sony WH-1000XM5',    'Electronics', 6500000,  25),
('Ban phim co Logitech',        'Electronics', 1200000,  12),
('Chuot khong day',             'Electronics', 450000,   20),
('Man hinh Dell 27"',           'Electronics', 6500000,  5),

-- Fashion
('Ao thun nam co tron',         'Fashion',     250000,   100),
('Quan jean nu',                'Fashion',     450000,   60),
('Giay the thao Nike',          'Fashion',     1800000,  0),
('Vay lien',                    'Fashion',     550000,   40),
('Ao khoac gio',                'Fashion',     780000,   25),

-- Books
('Sach "Clean Code"',           'Books',       320000,   50),
('Sach "Dac Nhan Tam"',         'Books',       110000,   0),
('Sach "Nha gia kim"',          'Books',       90000,    70),
('Sach "Atomic Habits"',        'Books',       180000,   45);
SELECT * FROM sales.products;
DROP TABLE sales.products;


INSERT INTO sales.orders (customer_id, order_date, total_amount, status) VALUES
(1, '2024-10-01', 28000000, 'CONFIRMED'),
(2, '2024-10-03', 6500000,  'PENDING'),
(3, '2024-10-05', 1250000,  'CANCELLED'),
(1, '2024-10-07', 320000,   'CONFIRMED'),
(4, '2024-10-10', 1800000,  'PENDING'),
(5, '2024-10-12', 450000,   'CONFIRMED'),
(2, '2024-10-15', 110000,   'PENDING'),
(6, '2024-10-18', 780000,   'CONFIRMED');
SELECT * FROM sales.orders;

INSERT INTO sales.order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 2, 1, 28000000),   -- iPhone
(2, 3, 1, 6500000),    -- Tai nghe
(3, 5, 2, 450000),     -- Chuot khong day (2 cái)
(4, 11, 1, 320000),    -- Sach Clean Code
(5, 8, 2, 1800000),    -- Giay Nike (2 đôi)
(6, 4, 1, 1200000),    -- Ban phim co Logitech
(7, 12, 1, 110000),    -- Sach Dac Nhan Tam
(8, 14, 1, 180000);    -- Sach Atomic Habits
SELECT * FROM sales.order_items;
DROP TABLE sales.order_items;

-- 1. Cập nhật giá sản phẩm category 'Electronics' tăng 10%
UPDATE sales.products
SET price = (price + price * 1.1)
WHERE category = 'Electronics';

SELECT * FROM sales.products  ORDER BY product_id ASC;

-- 2. Cập nhật số điện thoại cho khách hàng có email 'binh.tran@email.com'
UPDATE sales.customers
SET email = 'binhdeptrai@email.com'
WHERE full_name = 'Tran Thi Binh';

SELECT * FROM sales.customers ORDER BY customer_id ASC;

-- 3. Cập nhật trạng thái đơn hàng từ 'PENDING' sang 'CONFIRMED'
UPDATE sales.orders
SET status = 'CONFIRMED'
WHERE status = 'PENDING';

SELECT * FROM sales.orders ORDER BY customer_id ASC;

-- 4. Xóa sản phẩm có stock_quantity = 0
DELETE FROM sales.products
WHERE stock_quantity = 0;

-- 5. Xóa khách hàng không có bất kỳ đơn hàng nào
SELECT DISTINCT customer_id FROM sales.orders ORDER BY customer_id ASC;
DELETE FROM sales.customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM sales.orders);


--Phần 2: Truy vấn dữ liệu (8 truy vấn)
-- 1. Tìm khách hàng theo tên (ILIKE) - ví dụ tên chứa 'nguyen'
SELECT * FROM sales.customers
WHERE full_name ILIKE '%nguyen%';

-- 2. Lọc sản phẩm theo khoảng giá (BETWEEN 500.000 và 2.000.000)
SELECT * FROM sales.products
WHERE price BETWEEN 500000 AND 2000000;

-- 3. Tìm khách hàng chưa có số điện thoại (IS NULL)
SELECT * FROM sales.customers
WHERE phone IS NULL;

-- 4. Top 5 sản phẩm có giá cao nhất
SELECT * FROM sales.products
ORDER BY price DESC LIMIT 5;

-- 5. Phân trang danh sách đơn hàng (trang 1, mỗi trang 3 đơn)
SELECT * FROM sales.orders
ORDER BY order_id ASC LIMIT 3 OFFSET 0;

-- 6. Đếm số lượng khách hàng theo thành phố (GROUP BY + COUNT)
SELECT city, COUNT(*) AS so_luong_khach
FROM sales.customers GROUP BY city
ORDER BY so_luong_khach DESC;

-- 7. Tìm đơn hàng trong khoảng thời gian (BETWEEN DATE)
SELECT * FROM sales.orders
WHERE order_date BETWEEN '2024-10-1' AND '2024-10-10'
ORDER BY order_date;

-- 8. Sản phẩm chưa được bán (NOT EXISTS)
SELECT * FROM sales.products p
WHERE NOT EXISTS(
	SELECT 1 FROM sales.order_items oi
	WHERE oi.product_id = p.product_id
);
