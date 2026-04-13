CREATE DATABASE UniversityDB;
CREATE SCHEMA university;

CREATE TABLE university.Students(
	student_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	birth_date DATE,
	email VARCHAR(255) NOT NULL UNIQUE
);
DROP TABLE university.Students;

CREATE TABLE university.Courses(
	course_id SERIAL PRIMARY KEY,
	course_name VARCHAR(100) NOT NULL,
	credits INT
);
DROP TABLE university.Courses;


CREATE TABLE university.Enrollments(
	enrollment_id SERIAL PRIMARY KEY,
	student_id INT NOT NULL REFERENCES university.Students(student_id),
	course_id INT NOT NULL REFERENCES university.Courses(course_id),
	enroll_date DATE
);
DROP TABLE university.Enrollments;

SELECT datname FROM pg_database;

SELECT schema_name FROM information_schema.schemata;

SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'university';
