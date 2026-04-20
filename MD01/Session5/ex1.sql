create table products(
	product_id serial primary key,
	product_name varchar(50),
	category varchar(50)
);

create table orders(
	order_id serial primary key,
	product_id int references products(product_id),
	quantity int check(quantity >= 0),
	total_price decimal(12,2)
);

insert into products(product_name, category) values
('Laptop Dell', 'Electronics'),
('Iphone 15', 'Electronics'),
('Bàn học gỗ', 'Furniture'),
('Ghế xoay', 'Furniture');

insert into orders(product_id, quantity, total_price) values
(1, 2, 2200),
(2, 3, 3300),
(3, 5, 2500),
(4, 4, 1600),
(1, 1, 1100);
select * from orders;

--1. Viết truy vấn hiển thị tổng doanh thu (SUM(total_price)) và số lượng sản phẩm bán được (SUM(quantity)) cho từng nhóm danh mục (category)
-- 		Đặt bí danh cột như sau:
-- 		total_sales cho tổng doanh thu
-- 		total_quantity cho tổng số lượng
--2. Chỉ hiển thị những nhóm có tổng doanh thu lớn hơn 2000
--3. Sắp xếp kết quả theo tổng doanh thu giảm dần
select
	p.category,
	sum(o.total_price) as "Tong doanh thu" ,
	sum(o.quantity) as "So luong san pham ban duoc" 
from products as p
join orders o on p.product_id = o.product_id
group by p.category
having sum(o.total_price) > 2000
order by "Tong doanh thu" desc;