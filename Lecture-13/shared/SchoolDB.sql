-- Create the SchoolDB database if not exists
CREATE DATABASE IF NOT EXISTS SchoolDB;
USE SchoolDB;

-- Create the Institutions table if not exists
CREATE TABLE IF NOT EXISTS Institutions (
    institution_id INT AUTO_INCREMENT PRIMARY KEY,
    institution_name VARCHAR(100) NOT NULL,
    institution_type ENUM('School', 'Kindergarten') NOT NULL,
    address VARCHAR(255) NOT NULL
);

-- Create the Classes table if not exists
CREATE TABLE IF NOT EXISTS Classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL,
    institution_id INT,
    direction ENUM('Mathematics', 'Biology and Chemistry', 'Language Studies') NOT NULL,
    FOREIGN KEY (institution_id) REFERENCES Institutions(institution_id)
);

-- Create the Children table if not exists
CREATE TABLE IF NOT EXISTS Children (
    child_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    year_of_entry YEAR NOT NULL,
    age INT NOT NULL,
    institution_id INT,
    class_id INT,
    FOREIGN KEY (institution_id) REFERENCES Institutions(institution_id),
    FOREIGN KEY (class_id) REFERENCES Classes(class_id)
);

-- Create the Parents table if not exists
CREATE TABLE IF NOT EXISTS Parents (
    parent_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    child_id INT,
    tuition_fee DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (child_id) REFERENCES Children(child_id)
);

-- Insert sample data into Institutions
INSERT INTO Institutions (institution_name, institution_type, address)
VALUES 
    ('Sunrise School', 'School', '123 Main St, Cityville'),
    ('Bright Kindergarten', 'Kindergarten', '456 Maple Ave, Townsville'),
    ('Green High School', 'School', '789 Oak Rd, Cityville');

-- Insert sample data into Classes
INSERT INTO Classes (class_name, institution_id, direction)
VALUES 
    ('Grade 1', 1, 'Mathematics'),
    ('Preschool', 2, 'Language Studies'),
    ('Grade 9', 3, 'Biology and Chemistry');

-- Insert sample data into Children
INSERT INTO Children (first_name, last_name, birth_date, year_of_entry, age, institution_id, class_id)
VALUES 
    ('Alice', 'Johnson', '2015-05-10', 2021, 9, 1, 1),
    ('Tom', 'Smith', '2018-08-25', 2023, 6, 2, 2),
    ('Emily', 'Davis', '2010-12-12', 2019, 14, 3, 3);

-- Insert sample data into Parents
INSERT INTO Parents (first_name, last_name, child_id, tuition_fee)
VALUES 
    ('Michael', 'Johnson', 1, 1500.00),
    ('Sarah', 'Smith', 2, 2000.00),
    ('David', 'Davis', 3, 1200.00);

-- Verify the data
SELECT * FROM Institutions;
SELECT * FROM Classes;
SELECT * FROM Children;
SELECT * FROM Parents;

-- Anonymize Children Table: Replace first and last names with "Child" and "Anonymous"
UPDATE Children
SET first_name = 'Child', last_name = 'Anonymous';

-- Anonymize Parents Table: Replace first and last names with "Parent1", "Parent2", etc.
SET @parent_counter = 0;
UPDATE Parents
SET first_name = CONCAT('Parent', @parent_counter := @parent_counter + 1),
    last_name = CONCAT('Parent', @parent_counter := @parent_counter + 1);

-- Anonymize Institutions Table: Replace real names with "Institution1", "Institution2", etc.
SET @institution_counter = 0;
UPDATE Institutions
SET institution_name = CONCAT('Institution', @institution_counter := @institution_counter + 1);

-- Anonymize financial data: Replace tuition_fee with random values within a reasonable range (e.g., between 1000 and 3000)
UPDATE Parents
SET tuition_fee = FLOOR(1000 + (RAND() * (3000 - 1000)));

-- Verify anonymization results
SELECT * FROM Children;
SELECT * FROM Parents;
SELECT * FROM Institutions;
