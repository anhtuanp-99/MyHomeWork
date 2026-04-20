create table customers(
	customer_id serial primary key,
	customer_name varchar(100),
	city varchar(50)
);

create table orders(
	order_id serial primary key,
	customer_id int references customers(customer_id),
	order_date date,
	total_amount numeric(10,2)
);

create table order_items(
	item_id serial primary key,
	order_id int references orders(order_id),
	product_name varchar(100),	
	quantity int,
	price numeric(10,2)
);

INSERT INTO customers (customer_name, city) VALUES
('Nguyễn Văn A', 'Hà Nội'),
('Trần Thị B', 'Đà Nẵng'),
('Lê Văn C', 'Hồ Chí Minh'),
('Phạm Thị D', 'Hà Nội'),
('Hoàng Văn E', 'Cần Thơ');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-01-10', 5000.00),  -- Khách A (Hà Nội)
(4, '2025-01-15', 6000.00),  -- Khách D (Hà Nội) -> Tổng HN = 11.000 (Thỏa HAVING > 10k)
(2, '2025-02-01', 1500.00),  -- Khách B (Đà Nẵng)
(3, '2025-02-10', 12000.00), -- Khách C (HCM) -> Khách này sẽ có doanh thu cao nhất
(5, '2025-03-05', 800.00);   -- Khách E (Cần Thơ)

INSERT INTO order_items (order_id, product_name, quantity, price) VALUES
-- Đơn 1 của khách A
(1, 'Laptop Dell', 1, 4000.00),
(1, 'Chuột không dây', 2, 500.00),

-- Đơn 2 của khách D
(2, 'iPhone 15', 1, 6000.00),

-- Đơn 3 của khách B
(3, 'Bàn làm việc', 1, 1500.00),

-- Đơn 4 của khách C (Đơn hàng lớn nhất)
(4, 'Máy ảnh Sony', 1, 10000.00),
(4, 'Ống kính 50mm', 1, 2000.00),

-- Đơn 5 của khách E
(5, 'Tai nghe', 1, 800.00);

select * from customers;
select * from orders;
select * from order_items;

INSERT INTO orders (customer_id, order_date, total_amount) 
VALUES (2, '2025-04-20', 2500.00);
INSERT INTO order_items (order_id, product_name, quantity, price) 
VALUES (6, 'Loa Bluetooth', 1, 2500.00);

--ALIAS:
--	Hiển thị danh sách tất cả các đơn hàng với các cột:
--	Tên khách (customer_name)
--	Ngày đặt hàng (order_date)
--	Tổng tiền (total_amount)
select 
	c.customer_name,
	o.order_date,
	o.total_amount
from orders o
inner join customers c on o.customer_id = c.customer_id
group by c.customer_name, o.order_date, o.total_amount;

--Aggregate Functions:
--Tính các thông tin tổng hợp:
--	Tổng doanh thu (SUM(total_amount))
--	Trung bình giá trị đơn hàng (AVG(total_amount))
--	Đơn hàng lớn nhất (MAX(total_amount))
--	Đơn hàng nhỏ nhất (MIN(total_amount))
--	Số lượng đơn hàng (COUNT(order_id))

select
	sum(o.total_amount) as "Tong doanh thu",
	avg(o.total_amount) as "Trung binh gia tri don hang",
	max(o.total_amount) as "Don hang lon nhat",
	min(o.total_amount) as "Don hang nho nhat",
	count(o.order_id) as "So luong don hang"
from orders o;

--GROUP BY / HAVING:
--	Tính tổng doanh thu theo từng thành phố
--	chỉ hiển thị những thành phố có tổng doanh thu lớn hơn 10.000
select
	c.city as "Thanh pho",
	sum(o.total_amount) as "Tong doanh thu"
from customers as c
inner join orders o on o.customer_id = c.customer_id
group by c.city
having sum(o.total_amount) > 10000
order by "Tong doanh thu" desc;

--JOIN:
--Liệt kê tất cả các sản phẩm đã bán, kèm:
--	Tên khách hàng
--	Ngày đặt hàng
--	Số lượng và giá
--	(JOIN 3 bảng customers, orders, order_items)
select
	i.product_name as "San pham",
	c.customer_name as "Ten khach hang",
	o.order_date as "Ngay dat hang",
	i.quantity as "So luong",
	i.price as "Gia ca moi san pham"
from order_items i
inner join orders o on o.order_id = i.order_id
inner join customers c on c.customer_id = o.customer_id
group by i.product_name, c.customer_name, o.order_date, i.quantity, i.price
order by "Ngay dat hang" asc;

--Subquery:
--	Tìm tên khách hàng có tổng doanh thu cao nhất.
--	Gợi ý: Dùng SUM(total_amount) trong subquery để tìm MAX
select customer_name
from customers 
where customer_id = (
	select customer_id
	from orders
	group by customer_id
	order by sum(total_amount) desc
	limit 1
);
