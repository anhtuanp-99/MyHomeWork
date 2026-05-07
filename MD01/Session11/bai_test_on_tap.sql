CREATE TABLE Member (
    member_id      VARCHAR(5) PRIMARY KEY,
    full_name      VARCHAR(100) NOT NULL,
    email          VARCHAR(100) UNIQUE NOT NULL,
    phone          VARCHAR(15),
    membership_date DATE
);

CREATE TABLE Book (
    book_id  VARCHAR(5) PRIMARY KEY,
    title    VARCHAR(100) NOT NULL,
    author   VARCHAR(100),
    price    DECIMAL(10,2) CHECK (price >= 0),
    status   VARCHAR(20) DEFAULT 'Available' CHECK (status IN ('Available','Borrowed')),
    page_count INT CHECK (page_count > 0)
);

CREATE TABLE Borrowing (
    borrow_id   SERIAL PRIMARY KEY,
    member_id   VARCHAR(5) NOT NULL REFERENCES Member(member_id),
    book_id     VARCHAR(5) NOT NULL REFERENCES Book(book_id),
    borrow_date DATE NOT NULL,
    return_date DATE,
    fine_amount DECIMAL(10,2) DEFAULT 0
);

CREATE TABLE Staff (
    staff_id    SERIAL PRIMARY KEY,
    borrow_id   INT NOT NULL REFERENCES Borrowing(borrow_id),
    staff_name  VARCHAR(50),
    action_date DATE DEFAULT CURRENT_DATE,
    service_fee DECIMAL(10,2)
);

SELECT * FROM Member;
SELECT * FROM Book;
SELECT * FROM Borrowing;
SELECT * FROM Staff;

DROP TABLE Member CASCADE;
DROP TABLE Book CASCADE;
DROP TABLE Borrowing CASCADE;
DROP TABLE Staff CASCADE;

-- Member
INSERT INTO Member (member_id, full_name, email, phone, membership_date) VALUES
('M001', 'Nguyễn Văn A', 'a@email.com', '0901000001', '2025-01-10'),
('M002', 'Trần Thị B',   'b@email.com', '0901000002', '2024-12-15'),
('M003', 'Lê Văn C',     'c@email.com', '0901000003', '2025-03-20'),
('M004', 'Phạm Thị D',   'd@email.com', '0901000004', '2026-01-01'),
('M005', 'Hoàng Văn E',  'e@email.com', '0901000005', '2025-05-05'),
('M006', 'Nguyễn Thị Anh','anhtran@gmail.com', '0901000006', '2025-06-01');

-- Book
INSERT INTO Book (book_id, title, author, price, status, page_count) VALUES
('B001', 'Lập trình SQL',   'Tác giả X', 150.00, 'Available', 300),
('B002', 'Giải tích 1',      'Tác giả Y', 200.00, 'Available', 450),
('B003', 'Kinh tế vi mô',    'Tác giả Z', 100.00, 'Available', 250),
('B004', 'Lịch sử thế giới', 'Tác giả W', 180.00, 'Available', 600),
('B005', 'Văn học Anh',      'Tác giả V', 120.00, 'Available', 350);


INSERT INTO Borrowing (member_id, book_id, borrow_date, return_date, fine_amount) VALUES
('M001', 'B001', '2025-06-01', '2025-06-15', 0),
('M002', 'B002', '2024-12-20', NULL,          0),   -- borrow_date < 2025-01-01
('M003', 'B004', '2025-08-20', '2025-09-05', 5.00),
('M001', 'B003', '2025-09-01', NULL,          0),
('M004', 'B005', '2025-09-15', '2025-09-25', 0),
('M002', 'B001', '2025-10-01', NULL,          0),
('M005', 'B002', '2024-11-10', '2024-11-20', 10.00); -- borrow_date < 2025-01-01

INSERT INTO Borrowing (member_id, book_id, borrow_date, return_date, fine_amount) VALUES
('M002', 'B005', '2025-10-03', '2025-11-03', 0);

-- Staff (thêm một nhân viên tạm thời để test DELETE)
INSERT INTO Staff (borrow_id, staff_name, action_date, service_fee) VALUES
(1, 'Nguyen Van A', '2025-06-15', 20.0),
(3, 'Temporary Worker', '2025-09-05', 100.0),   -- sẽ bị xoá
(5, 'Le Van C',     '2025-09-25', 10.0),
(7, 'Temporary Staff', '2024-11-20', 150.0);     -- service_fee <200 & chứa "Temporary"


UPDATE borrowing
SET fine_amount = fine_amount * 1.1
WHERE borrow_date < '2025-1-1';


DELETE FROM staff
WHERE staff_name LIKE '%Temporary%' AND service_fee < 200;

SELECT * FROM Member;
SELECT * FROM Book;
SELECT * FROM Borrowing;
SELECT * FROM Staff;

--Lấy thông tin độc giả gồm: mã, họ tên, email, ngày đăng ký. Sắp xếp theo ngày đăng ký giảm dần.
SELECT member_id, full_name, email, membership_date 
FROM member
ORDER BY membership_date DESC;

--Lấy thông tin sách gồm: mã, tiêu đề, tác giả, giá tiền. Sắp xếp theo giá tiền tăng dần.
SELECT book_id, title, author, price
FROM book
ORDER BY price ASC;

--Lấy họ tên độc giả, tiêu đề sách và ngày mượn của tất cả các lượt mượn.
SELECT m.full_name, b.title, br.borrow_date
FROM borrowing br
JOIN member m ON m.member_id = br.member_id
JOIN book b ON b.book_id = br.book_id;

--Lấy danh sách độc giả và tổng số tiền phí dịch vụ họ đã trả (thông qua bảng Staff), sắp xếp theo tổng tiền giảm dần.
SELECT m.member_id, m.full_name, COALESCE(SUM(s.service_fee), 0) AS total_fee
FROM borrowing br
LEFT JOIN member m ON m.member_id = br.member_id
LEFT JOIN staff s ON s.borrow_id = br.borrow_id
GROUP BY m.member_id, m.full_name
ORDER BY total_fee;

--Lấy thông tin độc giả từ vị trí 3 đến 5 trong bảng Member sau khi sắp xếp tên theo thứ tự A-Z.
SELECT *
FROM member
ORDER BY full_name
LIMIT 3 OFFSET 2

--Lấy danh sách độc giả đã mượn ít nhất 3 cuốn sách khác nhau.
SELECT m.member_id, m.full_name, COUNT(DISTINCT br.book_id) AS distinct_books
FROM borrowing br
JOIN member m ON m.member_id = br.member_id
GROUP BY m.member_id, m.full_name
HAVING(COUNT(br.book_id) >= 3);

--Lấy danh sách các cuốn sách đã được mượn bởi ít nhất 2 độc giả khác nhau.
SELECT b.book_id, b.title, COUNT(DISTINCT br.member_id)
FROM borrowing br
JOIN book AS b ON b.book_id = br.book_id
GROUP BY b.book_id, b.title
HAVING (COUNT(br.member_id) >= 2);

--Lấy danh sách độc giả có tổng tiền phạt (fine_amount) lớn hơn 500.
SELECT  m.member_id, br.fine_amount
FROM borrowing br
JOIN member AS m ON m.member_id = br.member_id
WHERE br.fine_amount > 500;


--Lấy thông tin độc giả có tên chứa chữ "Anh" hoặc email sử dụng tên miền "@gmail.com". Sắp xếp theo tên tăng dần.
SELECT member_id, full_name
FROM member
WHERE full_name LIKE '%Anh' OR email LIKE '%@gmail.com'
ORDER BY full_name ASC;

--Phân trang: Lấy danh sách sách, sắp xếp theo số trang (page_count) giảm dần. Bỏ qua 10 quyển đầu, lấy 10 quyển tiếp theo.
SELECT * FROM book
ORDER BY page_count DESC
LIMIT 10 OFFSET 10;


SELECT * FROM Member;
SELECT * FROM Book;
SELECT * FROM Borrowing;
SELECT * FROM Staff;
-- PHẦN 2: Truy vấn dữ liệu (40 điểm)
-- Lấy thông tin độc giả gồm: mã, họ tên, email, ngày đăng ký. Sắp xếp theo ngày đăng ký giảm dần.
SELECT member_id, full_name, email, membership_date
FROM member
ORDER BY membership_date DESC

-- Lấy thông tin sách gồm: mã, tiêu đề, tác giả, giá tiền. Sắp xếp theo giá tiền tăng dần.
SELECT book_id, title, author, price
FROM book
ORDER BY price ASC;

-- Lấy họ tên độc giả, tiêu đề sách và ngày mượn của tất cả các lượt mượn.
SELECT m.full_name, b

-- Lấy danh sách độc giả và tổng số tiền phí dịch vụ họ đã trả (thông qua bảng Staff), sắp xếp theo tổng tiền giảm dần.
-- Lấy thông tin độc giả từ vị trí 3 đến 5 trong bảng Member sau khi sắp xếp tên theo thứ tự A-Z.
-- Lấy danh sách độc giả đã mượn ít nhất 3 cuốn sách khác nhau.
-- Lấy danh sách các cuốn sách đã được mượn bởi ít nhất 2 độc giả khác nhau.
-- Lấy danh sách độc giả có tổng tiền phạt (fine_amount) lớn hơn 500.
-- Lấy thông tin độc giả có tên chứa chữ "Anh" hoặc email sử dụng tên miền "@gmail.com". Sắp xếp theo tên tăng dần.
-- Phân trang: Lấy danh sách sách, sắp xếp theo số trang (page_count) giảm dần. Bỏ qua 10 quyển đầu, lấy 10 quyển tiếp theo.


-- PHẦN 3: Tạo View (10 điểm)
-- View 1: Tạo view hiển thị thông tin Sách và Độc giả đang mượn sách đó với điều kiện borrow_date sau ngày 01/02/2025.
CREATE OR REPLACE VIEW v_reader_with_book_before_1_2_25 AS
SELECT m.full_name, b.title, br.borrow_date
FROM borrowing br
JOIN member m ON m.member_id = br.member_id
JOIN book b ON b.book_id = br.book_id
WHERE br.borrow_date > '2025-02-01';

SELECT * FROM v_reader_with_book_before_1_2_25;

-- View 2: Tạo view hiển thị Độc giả và Sách đã mượn có page_count (số trang) lớn hơn 500 trang.
CREATE OR REPLACE VIEW v_book_by_page_count AS
SELECT m.full_name, b.title, b.page_count
FROM borrowing br
JOIN member m ON m.member_id = br.member_id
JOIN book b ON b.book_id = br.book_id
WHERE b.page_count > 500;

SELECT * FROM v_book_by_page_count;

-- PHẦN 4: Tạo Trigger (10 điểm)
-- Trigger 1: Tạo trigger check_borrow_date kiểm tra khi chèn vào bảng Borrowing. Nếu borrow_date (ngày mượn) lớn hơn return_date (ngày trả), báo lỗi "Ngày mượn không thể sau ngày trả!" và hủy thao tác.
CREATE OR REPLACE FUNCTION check_borrow_date()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
BEGIN
	IF NEW.borrow_date > NEW.return_date THEN
		RAISE EXCEPTION 'Ngày mượn không thể sau ngày trả'
			USING ERRCODE = 'P0001';
	END IF;
	RETURN NEW;
END;
$$;

CREATE TRIGGER trg_check_borrow_date
BEFORE INSERT OR UPDATE ON borrowing
FOR EACH ROW
EXECUTE FUNCTION check_borrow_date();

-- Trigger 2: Tạo trigger update_book_status tự động cập nhật status của sách thành 'Borrowed' ngay sau khi một bản ghi mới được chèn vào bảng Borrowing.
CREATE OR REPLACE FUNCTION update_book_status()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
BEGIN
	UPDATE book
	SET status = 'Borrowed'
	WHERE book_id = NEW.book_id;
	RETURN NEW;
END;
$$;

CREATE TRIGGER trg_update_book_status
AFTER INSERT ON borrowing
FOR EACH ROW
EXECUTE FUNCTION update_book_status();

INSERT INTO Borrowing (member_id, book_id, borrow_date, return_date)
VALUES ('M001', 'B003', '2025-06-01', '2025-06-10');
-- Kỳ vọng: INSERT thành công.

INSERT INTO Borrowing (member_id, book_id, borrow_date, return_date)
VALUES ('M002', 'B001', '2025-06-15', '2025-06-01');
-- Kỳ vọng: ERROR "Ngày mượn không thể sau ngày trả!"

UPDATE Borrowing
SET return_date = '2025-05-01'   -- nhỏ hơn borrow_date
WHERE borrow_id = 1;
-- Kỳ vọng: ERROR "Ngày mượn không thể sau ngày trả!"

SELECT book_id, status FROM Book WHERE book_id IN ('B001','B003','B005');
-- Giả sử ban đầu B001, B003, B005 đều 'Available' (nếu chưa bị mượn).

INSERT INTO Borrowing (member_id, book_id, borrow_date, return_date)
VALUES ('M004', 'B005', '2025-08-01', NULL);
-- Kỳ vọng: INSERT thành công.


-- PHẦN 5: Store Procedure (10 điểm)
-- Procedure 1: add_new_member: Thêm một độc giả mới vào bảng Member.
CREATE OR REPLACE PROCEDURE add_new_member(
	IN p_member_id VARCHAR(5),
	IN p_full_name VARCHAR(100), 
	IN p_email VARCHAR(100), 
	IN p_phone VARCHAR(15),
	IN p_membership_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO member(member_id, full_name, email, phone, membership_date) VALUES
	(p_member_id, p_full_name, p_email, p_phone, p_membership_date);
EXCEPTION
	WHEN unique_violation THEN
		RAISE EXCEPTION 'Mã độc giả hoặc email đã tồn tại!'
			USING ERRCODE = 'P0002';
END;
$$;


-- Procedure 2: process_return: Nhận vào p_borrow_id, p_staff_name, tbp_fee để thực hiện chèn dữ liệu vào bảng Staff khi độc giả đến trả sách và thanh toán phí.
CREATE OR REPLACE PROCEDURE process_return(
	IN p_borrow_id INT,
	IN p_staff_name VARCHAR(50),
	IN tbp_fee DECIMAL(10,2)
)
LANGUAGE plpgsql
AS $$
DECLARE
BEGIN
	IF p_borrow_id IS NULL AND p_borrow_id < 0 THEN
		RAISE EXCEPTION 'Mã borrow_id không hợp lệ!';
	END IF;

	INSERT INTO staff(borrow_id, staff_name, action_date, service_fee) VALUES
	(p_borrow_id, p_staff_name, CURRENT_DATE, tbp_fee);
END;
$$;

SELECT * FROM Member;
SELECT * FROM Book;
SELECT * FROM Borrowing;
SELECT * FROM Staff;

-- PHẦN 6: Transaction (10 điểm)
-- Tình huống: Một độc giả đến trả sách, hệ thống cần thực hiện đồng thời 3 việc:
-- Cập nhật ngày trả sách (return_date) thực tế vào bảng Borrowing.
-- Cập nhật trạng thái sách (status) trong bảng Book thành 'Available'.
-- Ghi nhận phí dịch vụ vào bảng Staff.
-- Yêu cầu: Viết một khối lệnh Transaction để thực hiện các công việc sau cho độc giả có mã M001 mượn sách B005:
-- Bắt đầu giao dịch (BEGIN).
-- Cập nhật return_date là ngày hiện tại cho bản ghi mượn tương ứng.
-- Cập nhật trạng thái sách B005 thành 'Available'.
-- Thêm một bản ghi vào bảng Staff để ghi nhận nhân viên 'Nguyen Van A' đã xử lý với phí dịch vụ là 50.0.
-- Nếu tất cả các lệnh trên thành công, hãy xác nhận giao dịch (COMMIT).
-- Nếu có bất kỳ lỗi nào xảy ra trong quá trình thực hiện, hãy hủy bỏ toàn bộ thay đổi (ROLLBACK).

CREATE OR REPLACE PROCEDURE return_book(
    IN p_member_id VARCHAR(5),
    IN p_book_id VARCHAR(5),
    IN p_staff_name VARCHAR(100),
    IN p_service_fee NUMERIC(10,2)
)
LANGUAGE plpgsql
AS $$
#variable_conflict error  -- Nên có để tránh lỗi nhầm tên kiểu này trong tương lai
DECLARE
    v_borrow_id INT;
BEGIN
    -- 1. Tìm chính xác bản ghi mượn sách đang hoạt động
    SELECT borrow_id INTO STRICT v_borrow_id
    FROM borrowing 
    WHERE member_id = p_member_id AND book_id = p_book_id ;      -- SỬA LỖI Ở ĐÂY

      
    -- 2. Cập nhật ngày trả cho đúng bản ghi đó
    UPDATE borrowing
    SET return_date = CURRENT_DATE
    WHERE borrow_id = v_borrow_id;   -- Dùng borrow_id duy nhất để an toàn

    -- 3. Cập nhật trạng thái sách
    UPDATE book
    SET status = 'Available'
    WHERE book_id = p_book_id;

    -- 4. Ghi nhận phí dịch vụ
    INSERT INTO staff(borrow_id, staff_name, action_date, service_fee) 
    VALUES (v_borrow_id, p_staff_name, CURRENT_DATE, p_service_fee);
	
    COMMIT;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'Không tìm thấy bản ghi mượn sách này cho độc giả %.', p_member_id;
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
$$;

CALL return_book('M001', 'B005', 'Nguyen Van A', 50.0);
