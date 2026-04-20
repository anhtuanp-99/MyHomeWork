create table customers(
	customer_id serial primary key,
	customer_name varchar(100),
	city varchar(50)
);

create table orders(
	order_id serial primary key,
	customer_id int references customers(customer_id), 
	order_date date default current_date,
	total_price decimal(10,2)
);

create table order_items(
	item_id serial primary key,
	order_id int references orders(order_id),
	product_id int,
	quantity int check(quantity >= 0),
	price decimal(10,2)
);

insert into customers(customer_name, city) values
('Nguyễn Văn A', 'Hà Nội'),
('Trần Thị B', 'Đà Nẵng'),
('Lê Văn C', 'Hồ Chí Minh'),
('Phạm Thị D', 'Hà Nội');

insert into orders(order_id, customer_id, order_date, total_price) values
(101, 1, '2024-12-20', 3000),
(102, 2, '2025-01-5', 1500),
(103, 1, '2025-02-10', 2500),
(104, 3, '2025-02-15', 4000),
(105, 4, '2025-03-01', 800);

insert into order_items(order_id, product_id, quantity, price) values
(101, 1, 2, 1500),
(102, 2, 1, 1500),
(103, 3, 5, 500),
(104, 2, 4, 1000);

select * from customers;
select * from orders;
select * from order_items;

--Q1: Khách hàng có doanh thu > 2000
select 
	c.customer_name as "Khach hang",
	sum(o.total_price) as "Doanh thu",
	count(o.order_id) as order_count
from customers as c
inner join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having sum(o.total_price) > 2000;

--Q2: Khách hàng tiềm năng (Doanh thu > Trung bình)
select 
	c.customer_name as "Khach hang",
	sum(o.total_price) as "Doanh thu"
from customers as c
inner join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having sum(o.total_price) > (
	select avg(customer_total)
	from (
		select sum(o.total_price) as customer_total
		from orders o
		group by order_id
	) as average_table
);

--Q3: Thành phố có doanh thu cao nhất
select 
	c.city as "Thanh pho",
	sum(o.total_price) as "Doanh thu cao nhat"
from customers as c
inner join orders o on c.customer_id = o.customer_id
group by c.city
order by "Doanh thu cao nhat" desc
limit 1;

--Q4: Chi tiết tổng hợp (Join 3 bảng)
select 
	c.customer_name,
	c.city,
	sum(t.quantity) as "Sl sp đã mua",
	sum(o.total_price) as "Tong chi tieu"
from customers as c
inner join orders o on o.customer_id = c.customer_id
inner join order_items t on t.order_id = o.order_id
group by c.customer_id, c.customer_name, c.city
order by "Sl sp đã mua" desc;  
