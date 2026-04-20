create table students(
	student_id serial primary key,
	full_name varchar(100),
	major varchar(50)
);

create table courses(
	course_id serial primary key,
	course_name varchar(100),
	credit int
);

create table enrollments(
	student_id int references students(student_id),
	course_id int references courses(course_id),
	score numeric(5,2)
);

-- Chèn dữ liệu sinh viên
INSERT INTO students (full_name, major) VALUES
('Nguyễn Văn An', 'IT'),
('Trần Thị Bình', 'IT'),
('Lê Văn Cường', 'Business'),
('Phạm Diệu Linh', 'Business'),
('Vũ Hoàng Long', 'Design');

-- Chèn dữ liệu môn học
INSERT INTO courses (course_name, credit) VALUES
('SQL Database', 3),
('Python Programming', 4),
('Marketing Basics', 3),
('Graphic Design', 2);

-- Chèn dữ liệu điểm số (enrollments)
INSERT INTO enrollments (student_id, course_id, score) VALUES
(1, 1, 8.5), (1, 2, 9.0), -- An (IT): TB 8.75
(2, 1, 7.0), (2, 2, 6.5), -- Bình (IT): TB 6.75 -> Trung bình ngành IT = 7.75
(3, 3, 6.0),             -- Cường (Business): TB 6.0
(4, 3, 7.0),             -- Linh (Business): TB 7.0 -> Trung bình ngành Business = 6.5
(5, 4, 9.5);             -- Long (Design): TB 9.5

select * from students;
select * from courses;
select * from enrollments;

--ALIAS:
--	Liệt kê danh sách sinh viên kèm tên môn học và điểm
--	dùng bí danh bảng ngắn (vd. s, c, e)
--	và bí danh cột như Tên sinh viên, Môn học, Điểm
select
	s.full_name,
	c.course_name,
	e.score
from students as s
inner join enrollments e on e.student_id = s.student_id
inner join courses c on c.course_id = e.course_id;

--Aggregate Functions:
--	Tính cho từng sinh viên:
--	Điểm trung bình
--	Điểm cao nhất
--	Điểm thấp nhất
select
	s.full_name as "Ten sinh vien",
	avg(e.score) as "Diem trung binh",
	max(e.score) as "Diem cao nhat",
	min(e.score) as "Diem thap nhat"
from students as s
inner join enrollments e on e.student_id = s.student_id
group by s.full_name;

--GROUP BY / HAVING:
--	Tìm ngành học (major) có điểm trung bình cao hơn 7.5
select
	c.course_name as "Nganh hoc",
	avg(e.score) as "Diem trung binh"
from courses as c
inner join enrollments e on e.course_id = c.course_id
group by c.course_name
having avg(e.score) > 7.5;

--JOIN:
--	Liệt kê tất cả sinh viên, môn học, số tín chỉ và điểm (JOIN 3 bảng)
select
	s.full_name,
	c.course_name,
	c.credit,
	e.score
from students as s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id;

--Subquery:
--	Tìm sinh viên có điểm trung bình cao hơn điểm trung bình toàn trường
--	Gợi ý: dùng AVG(score) trong subquery
select 
	s.full_name as "Ten sinh vien",
	avg(e.score) as "Diem tb ca nhan"
	from students s
	join enrollments e on e.student_id = s.student_id
	group by s.student_id, s.full_name
	having avg(e.score) > (
		select avg(score)
		from enrollments
	);