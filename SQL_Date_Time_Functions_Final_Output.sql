###############################################################
###############################################################
-- Guided Project: SQL Date-Time Functions
###############################################################
###############################################################

-- Datetime functions can be applied only to columns with datetime data types.
-- This project covers common datetime functions in SQL specifically, PostgreSQL.

#############################
-- Task One: Getting Started
-- In this task, we will retrieve data from the tables in the
-- employees database
#############################

-- 1.1: Retrieve all the data in the employees, sales, dept_manager, salaries table
SELECT *
FROM employees;

SELECT *
FROM sales;

SELECT *
FROM dept_manager;

SELECT *
FROM salaries;

#############################
-- Task Two: Current Date & Time
-- In this task, we will learn how to use a number of functions 
-- that return values related to the current date and time. 
#############################

-- The following statements return the current date, current time, and current date and time:

-- 2.1: Retrieve the current date
SELECT CURRENT_DATE;

-- 2.2: Retrieve the current time
SELECT CURRENT_TIME;
SELECT CURRENT_TIME(1);
SELECT CURRENT_TIME(3);

-- 2.3: Retrieve the current timestamp
SELECT CURRENT_TIMESTAMP;

-- 2.4: Retrieve the current date, current date, time, and timestamp
SELECT CURRENT_DATE, CURRENT_TIME, CURRENT_TIME(1), CURRENT_TIME(3), CURRENT_TIMESTAMP;

-- You can either use CURRENT_TIMESTAMP or transaction_timestamp. If you want to retrieve the
-- old timestamp in a text format, you can use timeofday(). Additionally, now() is traditional
-- PostgreSQL equivalent of transactional_timestamp so they will return the same output as the
-- transaction_timestamp.

-- 2.5: Retrieve the time of the day
SELECT transaction_timestamp();
SELECT timeofday();
SELECT now();

#############################
-- Task Three: AGE() - Part One
-- In this task, we will learn how to use the AGE() function to subtract arguments, 
-- producing a "symbolic" result that uses years and months
#############################

-- If you want to calculate the difference between two dates in PostgreSQL, the AGE() function
-- is used. It takes two parameters: the later date and the earlier date. The AGE() function
-- returns an interval value representing the difference between the two dates. The interval
-- can be represent years, months, days and so on.

-- 3.1: Check the difference between February 28th, 2021 and December 31st, 2019
SELECT AGE('2021-02-28', '2019-12-31');

-- 3.2: How old is the Batman movie that was released March 30, 1939
SELECT AGE(CURRENT_DATE, '1939-03-30') AS Batman_Age;

-- 3.3: Retrieve a list of the current age of all employees
SELECT * FROM employees;

SELECT first_name, last_name, birth_date, AGE(CURRENT_DATE, birth_date) AS AGE
FROM employees;

-- 3.4: Retrieve a list of all employees ages as at when they were employed
SELECT first_name, last_name, birth_date, hire_date, AGE(hire_date, birth_date) AS Age_Employed
FROM employees;

-- 3.5: Retrieve a list of how long a manager worked at the company
SELECT emp_no, AGE(to_date, from_date) AS Age
FROM dept_manager;

-- 3.6: Retrieve a list of how long a manager have been working at the company
SELECT emp_no, AGE(CURRENT_DATE, from_date) AS Age
FROM dept_manager
WHERE emp_no IN ('110039', '110114', '110228', '110420', '110567', '110854', '111133', '111534','111939');

#############################
-- Task Four: AGE() - Part Two
-- In this task, we will learn how the AGE() function to subtract arguments, 
-- producing a "symbolic" result that uses years and months
#############################

-- We will use AGE() function within CASE statements to give an accurate
-- answer for the previous question on how long a manager worked at a company. Since 
-- some of managers are still working in the company, their age return a thounsands of value,
-- which is quite inaccurate. For that, we will do this instead.

-- 4.1: Retrieve a list of how long a manager worked at the company
SELECT emp_no,
CASE
	WHEN AGE(to_date, from_date) < AGE(CURRENT_DATE, from_date) THEN AGE(to_date, from_date)
	ELSE AGE(CURRENT_DATE, from_date)
END
FROM dept_manager;

-- 4.2: Retrieve a list of how long it took to ship a product to a customer
SELECT * FROM sales;

SELECT order_line, order_date, ship_date, AGE(ship_date, order_date) AS time_taken
FROM sales
ORDER BY time_taken DESC;

-- 4.3: Retrieve all the data from the salaries table
SELECT * FROM salaries;


-- 4.4: Retrieve a list of the first name, last name, salary 
-- and how long the employee earned that salary
SELECT e.first_name, e.last_name, s.salary, s.from_date, s.to_date, AGE(s.to_date, s.from_date)
FROM employees e
JOIN salaries s
ON e.emp_no = s.emp_no; 

-- Since our result includes employees that is currently employed to the company, this gives them
-- a large age number which is about 7000 years.
-- A better result
SELECT e.first_name, e.last_name, s.salary, s.from_date, s.to_date,
CASE
	WHEN AGE(to_date, from_date) < AGE(CURRENT_DATE, from_date) THEN AGE(to_date, from_date)
	ELSE AGE(CURRENT_DATE, from_date)
END 
FROM employees e
JOIN salaries s
ON e.emp_no = s.emp_no;

#############################
-- Task Five: EXTRACT() - Part One
-- In this task, we will see how the EXTRACT() function 
-- to retrieve subfields like year or hour from date/time values
#############################

-- If you want to extract specific components (such as year, month, day, hour, etc.) from a date or
-- timestamp value, you can use the EXTRACT() function. It allows you to retrieve individual parts
-- of a date or timestamp and use them for various calculations or comparisons. You can also use
-- DATE_PART function as an alternative for EXTRACT function in PostgreSQL.

-- 5.1: Extract the day of the month from the current date
SELECT EXTRACT(DAY FROM CURRENT_DATE);

-- 5.2: Extract the day of the week from the current date
SELECT EXTRACT(ISODOW FROM CURRENT_DATE);

-- 5.3: Extract the hour of the day from the current date
SELECT EXTRACT(HOUR FROM CURRENT_TIMESTAMP);

-- 5.4: What do you think this result will be?
-- Of course, the result will be the day from that date which is 31.
SELECT EXTRACT(DAY FROM DATE('2019-12-31'));

-- 5.5: What do you think this result will be?
-- In this part, the result will be 2019.
SELECT EXTRACT(YEAR FROM DATE('2019-12-31'));

-- 5.6: What about this one?
-- While on this part, the result will be the minute part which is 44.
SELECT EXTRACT(MINUTE from '084412'::TIME);

-- 5.7: Retrieve a list of the ship mode and how long (in seconds) it took to ship a product to a customer
SELECT order_line, order_date, ship_date, ship_mode, 
(EXTRACT(EPOCH FROM ship_date) - EXTRACT(EPOCH FROM order_date)) AS secs_taken
FROM sales; 

-- 5.8: Retrieve a list of the ship mode and how long (in days) it took to ship a product to a customer
SELECT order_line, order_date, ship_date, 
(EXTRACT(DAY FROM ship_date) - EXTRACT(DAY FROM order_date)) AS days_taken
FROM sales
ORDER BY days_taken DESC;

-- 5.9: Retrieve a list of the current age of all employees
SELECT emp_no, birth_date, first_name, last_name,
(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birth_date)) AS emp_age
FROM employees;

-- In this, I concat 'years' in my emp age to make it more accurate.
-- 5.10: Retrieve a list of the current age of all employees
SELECT first_name, last_name, birth_date, 
(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birth_date)) || ' years' AS emp_age
FROM employees;

#############################
-- Task Six: EXTRACT() - Part Two
-- In this task, we will see how the EXTRACT() function 
-- to retrieve subfields like year or hour from date/time values
#############################

-- 6.1: Retrieve a list of all employees ages as at when they were employed
SELECT first_name, last_name, birth_date, hire_date,
(EXTRACT(YEAR FROM hire_date) - EXTRACT(YEAR FROM birth_date)) AS age_employed
FROM employees;

-- 6.2: Retrieve a list of all employees who were 25 or less than 25 years as at when they were employed
SELECT first_name, last_name, birth_date, hire_date, 
(EXTRACT(YEAR FROM hire_date) - EXTRACT(YEAR FROM birth_date)) AS Employed_25
FROM employees
WHERE (EXTRACT(YEAR FROM hire_date) - EXTRACT(YEAR FROM birth_date)) <= 25;

-- 6.3: How many employees were 25 or less than 25 years as at when they were employed
SELECT COUNT((EXTRACT(YEAR FROM hire_date) - EXTRACT(YEAR FROM birth_date))) AS Num_employed_25
FROM employees
WHERE (EXTRACT(YEAR FROM hire_date) - EXTRACT(YEAR FROM birth_date)) <= 25;
-- There are a total of 1585 employees that are 25 or less when they are employed.

-- 6.4: What do you think will be the result of this query?
-- The result of this query is the count of employees grouped by their age group, with each group
-- representing the difference in years between their hire date and birth date, and filtering those
-- groups where the age is less than or equal to 25.
SELECT (EXTRACT(YEAR FROM hire_date) - EXTRACT(YEAR FROM birth_date)) || ' years' AS Age_group,
COUNT((EXTRACT(YEAR FROM hire_date) - EXTRACT(YEAR FROM birth_date))) AS Num_Employed
FROM employees
WHERE (EXTRACT(YEAR FROM hire_date) - EXTRACT(YEAR FROM birth_date)) <= 25
GROUP BY age_group
ORDER BY age_group;

-- 6.5: Retrieve all data from the sales table
SELECT * FROM sales;

-- 6.6: Retrieve a list of the product_id, the month of sales and sales
-- for chair sub category in the year 2015
SELECT product_id, sub_category, EXTRACT(MONTH FROM order_date) AS month_sale
FROM sales
WHERE EXTRACT(YEAR FROM order_date) = 2015 AND sub_category = 'Chairs'

-- Or, you can use this instead:
SELECT product_id, sub_category, EXTRACT(MONTH FROM order_date) AS month_sale
FROM sales
WHERE order_id LIKE '%2015%' AND sub_category = 'Chairs'

-- 6.7: Retrieve a list of the month of sales and sum of sales
-- for each month for chair sub category in the year 2015
SELECT EXTRACT(MONTH FROM order_date) AS month_sale,
SUM(sales) AS sales_per_month
FROM sales
WHERE order_id LIKE '%2015%' AND sub_category = 'Chairs'
GROUP BY month_sale
ORDER BY month_sale;

#############################
-- Task Seven: Converting Date to Strings
-- In this task, we will see how to convert dates to strings
#############################

-- Converting a datetime or timestamp value to a string representation requires the use of
-- TO_CHAR() function. It allows you to format the date and time in a specific way. This
-- function is common in PostgreSQL and Oracle.

-- 7.1: Change the order date in the sales table to strings
SELECT order_date, TO_CHAR(order_date, 'MM/DD/YY')
FROM sales;

-- Or you can do this,
-- 7.2: Change the order date in the sales table to strings
SELECT order_date, TO_CHAR(order_date, 'Month FMDDth, YYYY')
FROM sales;

-- Or this,
-- 7.3: Change the order date in the sales table to strings
SELECT order_date, TO_CHAR(order_date, 'Month Day, YYYY')
FROM sales;

-- 7.4: What do you think will be the result of this?
-- Obviously, the difference of this query from abonve is that the DAY is uppercase,
-- so, the DAY from previous query will be uppercase.
SELECT order_date, TO_CHAR(order_date, 'Month DAY, YYYY')
FROM sales;

-- 7.5: What do you think will be the result of this?
SELECT *, TO_CHAR(hire_date, 'Day, Month DD YYYY') AS hired_date
FROM employees;

-- 7.6: Retrieve a list of the month of sales and sum of sales
-- for each month for chair sub category in the year 2015
SELECT TO_CHAR(order_date, 'Month') AS full_month_sale,
SUM(sales) AS sales_per_month
FROM sales
WHERE order_id LIKE '%2015%' AND sub_category = 'Chairs'
GROUP BY full_month_sale
ORDER BY full_month_sale;

-- 7.7: Retrieve a list of the month of sales and sum of sales
-- for each month in the right order for chair sub category in the year 2015
SELECT EXTRACT(MONTH FROM ship_date) AS month_sale,
TO_CHAR(ship_date, 'Month') AS full_month_sale,
SUM(sales) AS sales_per_month
FROM sales
WHERE order_id LIKE '%2015%' AND sub_category = 'Chairs'
GROUP BY full_month_sale, month_sale
ORDER BY month_sale;

-- 7.8: Add a currency (dollars) to the sum of monthly sales
SELECT EXTRACT(MONTH FROM ship_date) AS sales_month, 
TO_CHAR(ship_date, 'Month') AS full_sales_month, TO_CHAR(SUM(sales), '$99999.99') AS monthly_total
FROM sales
WHERE sub_category = 'Chairs' AND order_id LIKE '%2015%'
GROUP BY full_sales_month, sales_month
ORDER BY sales_month;

#############################
-- Task Eight: Converting Strings to Date
-- In this task, we will see how to convert strings to dates
#############################

-- There are two ways to convert a string to a datetime data type: Using the CAST function for a simple case.
-- And, using STR_TO_DATE/TO_DATE/CONVERT for a custom case. However, if a string column contains dates in a
-- standard format, you can use the CAST function to turn it into a date data type. For dates and times not
-- in the standard YYY-MM-DD/DD-MON-YYY/hh:mm:ss formats, use a string to date or a string to time function instead.

-- 8.1: Change '2019/12/31' to the correct date format
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD');

-- Alternative query:
SELECT CAST('2019/12/31' AS DATE)

-- 8.2: Change '20191231' to the correct date format
SELECT TO_DATE('20191231', 'YYYYMMDD');

-- Alternative query:
SELECT CAST('20191231' AS DATE)

-- 8.3: Change '191231' to the correct date format
SELECT TO_DATE('191231', 'YYMMDD');

-- Alternative query:
SELECT CAST('191231' AS DATE)

-- 8.4: What do you think will be the result of this?
SELECT TO_DATE('123119', 'MMDDYY');

-- 8.5: Retrieve all the data from the employees table
SELECT * FROM employees;

-- Start transaction
BEGIN;

ALTER TABLE employees
ALTER COLUMN hire_date TYPE CHAR(10);

SELECT * FROM employees;

-- Change the hire_date to a correct date format
SELECT *, TO_DATE(hire_date, 'YYYY-MM-DD') AS hire_date
FROM employees;

-- End the transaction
ROLLBACK;
