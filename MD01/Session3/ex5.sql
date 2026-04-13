CREATE TABLE Khoahoc(
	ma_khoahoc SERIAL PRIMARY KEY,
	ten VARCHAR(100) NOT NULL,
	mota TEXT,
	hocphi NUMERIC(12,2) NOT NULL
);

CREATE TABLE Giangvien(
	ma_giangvien SERIAL PRIMARY KEY,
	hoten VARCHAR(100) NOT NULL,
	chuyennganh VARCHAR(100) NOT NULL,
	sodienthoai VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Hocvien(
	ma_hocvien SERIAL PRIMARY KEY,
	hoten VARCHAR(100) NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Lophoc(
	ma_lop SERIAL PRIMARY KEY,
	ma_khoahoc INT NOT NULL REFERENCES Khoahoc(ma_khoahoc),
	ma_giangvien INT NOT NULL REFERENCES Giangvien(ma_giangvien),
	thoigianhoc VARCHAR(100)
);

CREATE TABLE Dangki(
	ma_hocvien INT NOT NULL REFERENCES Hocvien(ma_hocvien),
	ma_lop INT NOT NULL REFERENCES Lophoc(ma_lop),
	ngaydangky DATE NOT NULL,
	PRIMARY KEY(ma_hocvien, ma_lop)
);