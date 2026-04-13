CREATE SCHEMA elearning;

CREATE TABLE elearning.Students(
	student_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	email VARCHAR(200) NOT NULL UNIQUE
);

CREATE TABLE elearning.Instructors(
	instructor_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	email VARCHAR(200) NOT NULL UNIQUE
);

CREATE TABLE elearning.Courses(
	course_id SERIAL PRIMARY KEY,
	course_name VARCHAR(100) NOT NULL UNIQUE,
	instructor_id INT NOT NULL REFERENCES elearning.Instructors(instructor_id)
);

CREATE TABLE elearning.Enrollments(
	enrollment_id SERIAL PRIMARY KEY,
	student_id INT NOT NULL REFERENCES elearning.Students(student_id),
	course_id INT NOT NULL REFERENCES elearning.Courses(course_id),
	enroll_date DATE NOT NULL
);

CREATE TABLE elearning.Assignments(
	assignment_id SERIAL PRIMARY KEY,
	course_id INT NOT NULL REFERENCES elearning.Courses(course_id),
	title VARCHAR(100) NOT NULL,
	due_date DATE NOT NULL
);

CREATE TABLE elearning.Submissions(
	submission_id SERIAL PRIMARY KEY,
	assignment_id INT NOT NULL REFERENCES elearning.Assignments(assignment_id),
	student_id INT NOT NULL REFERENCES elearning.Students(student_id),
	submission_date DATE NOT NULL,
	grade NUMERIC(5,2) CHECK(grade BETWEEN 0 AND 100)
);
