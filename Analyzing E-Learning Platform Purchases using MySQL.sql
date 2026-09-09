CREATE DATABASE Online_Learning_DB;-- Creating a database 

USE Online_Learning_DB;
/*1. Create the database and schema. Populate the Schema:*/

CREATE TABLE Learners(  -- Creating table name with the datatypes
Learner_ID INT PRIMARY KEY,
Full_Name VARCHAR(100) NOT NULL,
Country VARCHAR(60)
);

INSERT INTO Learners(Learner_ID, Full_name, Country)
VALUES
(101,'Arun Kumar', 'India'),
(102, 'Deepika','UK'),
(103, 'Divya','USA'),
(104,'Jai kumar','Europe'),
(105, 'Ashwini' ,'Canada'),
(106, 'Hema','Canada'),
(107, 'Preethi Sharma','Germany'),
(108, 'Edward', 'India');


CREATE TABLE Courses(
Course_ID INT PRIMARY KEY,
Course_Name VARCHAR(80) NOT NULL,
Category VARCHAR(80),
Unit_Price DECIMAL(10,2) NOT NULL
);

INSERT INTO Courses(Course_ID, Course_Name, Category, Unit_Price)
VALUES
(1,'SQL','Database',2500.00),
(2,'Python Programming', 'Programming', 3500.00),
(3,'Power BI ', 'Data Analytics', 3000.00),
(4,'Web Development', 'Web Development', 4000.00),
(5,'Machine Learning', 'AI & ML', 5000.00);

CREATE TABLE Purchases(
Purchase_ID INT PRIMARY KEY,
Learner_ID INT,
FOREIGN KEY (Learner_ID) REFERENCES Learners(Learner_ID),
Course_ID INT,
FOREIGN KEY (Course_ID) REFERENCES Courses(Course_ID),
Quantity INT NOT NULL,
Purchase_Date DATE
);

INSERT INTO Purchases(Purchase_ID, Learner_ID,Course_ID,Quantity,Purchase_Date)
VALUES
(1001,101,2,1,'2026-06-03'),
(1002,102,1,2,'2026-06-06'),
(1003,104,5,1,'2026-06-10'),
(1004,105,4,1,'2026-06-22'),
(1005,103,3,2,'2026-06-25'),
(1006,106,5,1,'2026-06-17'),
(1007,107,3,1,'2026-06-14'),
(1008,108,2,2,'2026-06-20');


SELECT * FROM Learners;
 
SELECT * FROM Courses;
 
SELECT * FROM Purchases;

/*2. Data Exploration Using Joins*/

/*1. INNER JOIN — Combine Learner, Course & Purchase Data*/

SELECT
    l.full_name AS learner_name,
    l.country,
    c.course_name,
    c.category,
    p.quantity,
    c.unit_price,
    ROUND(c.unit_price * p.quantity, 2) AS total_revenue,
    p.purchase_date
FROM learners l
INNER JOIN purchases p
    ON l.learner_id = p.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id
ORDER BY total_revenue DESC;

/*2. LEFT JOIN — Display All Learners*/

SELECT
    l.full_name AS learner_name,
    l.country,
    c.course_name,
    c.category,
    p.quantity,
    ROUND(c.unit_price * p.quantity, 2) AS total_revenue,
    p.purchase_date
FROM learners l
LEFT JOIN purchases p
    ON l.learner_id = p.learner_id
LEFT JOIN courses c
    ON p.course_id = c.course_id
ORDER BY total_revenue DESC;

/*3. RIGHT JOIN — Display All Courses*/

SELECT
    l.full_name AS learner_name,
    l.country,
    c.course_name,
    c.category,
    p.quantity,
    ROUND(c.unit_price * p.quantity, 2) AS total_amount,
    p.purchase_date
FROM purchases p
RIGHT JOIN courses c
    ON p.course_id = c.course_id
RIGHT JOIN learners l
    ON p.learner_id = l.learner_id
ORDER BY total_amount DESC;

/*3. Analytical Queries
		Write SQL queries to answer the following questions:
Q1. Display each learner’s total spending (quantity × unit_price) along with their country.*/

SELECT
    l.learner_id,
    l.full_name,
    l.country,
    FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_spending
FROM learners l
INNER JOIN purchases p
    ON l.learner_id = p.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id
GROUP BY
    l.learner_id,
    l.full_name,
    l.country
ORDER BY total_spending DESC;

## Q2. Find the top 3 most purchased courses based on total quantity sold.

SELECT
    c.course_id,
    c.course_name,
    c.category,
    SUM(p.quantity) AS total_quantity_sold
FROM courses c
INNER JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY
    c.course_id,
    c.course_name,
    c.category
ORDER BY total_quantity_sold DESC
LIMIT 3;

## Q3. Show each course category’s total revenue and the number of unique learners who purchased from that category.

SELECT
    c.category AS category,
    FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_revenue,
    COUNT(DISTINCT p.learner_id) AS unique_learners
FROM courses c
INNER JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY c.category
ORDER BY total_revenue DESC;

## Q4. List all learners who have purchased courses from more than one category.

SELECT
    l.learner_id,
    l.full_name,
    l.country,
    COUNT(DISTINCT c.category) AS category_count
FROM learners l
INNER JOIN purchases p
    ON l.learner_id = p.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id
GROUP BY
    l.learner_id,
    l.full_name,
    l.country
HAVING category_count > 1;

INSERT INTO purchases /* inserted to know about learners who have purchased courses from more than one category*/
    (purchase_id, learner_id, course_id, quantity, purchase_date)
VALUES
(1009, 102, 2, 1, '2026-06-24');

## Q5. Identify courses that have not been purchased at all.

SELECT
    c.course_id,
    c.course_name,
    c.category,
    ROUND(c.unit_price, 2) AS unit_price
FROM courses c
LEFT JOIN purchases p
    ON c.course_id = p.course_id
WHERE p.purchase_id IS NULL;







 


