SQL DAY 19 and DAY 20
 
# 50 SQL and Database Practice Tasks
 
## Database Concepts & Setup
1. Define what a database is and give two real-world examples (not from the notes).
2. List three differences between relational and non-relational databases.
3. Name two advantages of using a DBMS.
4. List three popular RDBMS and two popular NoSQL databases.
5. Install MySQL, PostgreSQL, or SQLite on your system and confirm the installation.
6. Start your SQL server and log in using a command-line tool.
7. Create a new database called School.
 
## Table Creation & Data Insertion
8. Create a table called Students with columns: StudentID, Name, Age, Department.
9. Create a table called Courses with columns: CourseID, Title, Credits.
10. Insert three records into the Students table.
11. Insert two records into the Courses table.
12. Insert multiple records into the Students table using a single SQL statement.
 
## Data Retrieval: SELECT Statements
13. Write a SQL query to select all columns from the Students table.
14. Write a query to select only the Name and Age columns from Students.
15. Write a query to select all records from Courses.
16. Use SELECT DISTINCT to find unique departments from the Students table.
 
## Filtering Data: WHERE Clause & Operators
17. Write a query to select all students who are older than 20.
18. Select all courses with more than 3 credits.
19. Retrieve students whose department is 'Computer Science'.
20. Select students whose age is not equal to 18.
21. Use the LIKE operator to find students whose name starts with 'A'.
22. Use the LIKE operator to find students whose name contains the letter 'n'.
23. Find all students whose name is exactly four letters long.
24. Retrieve students whose age is between 18 and 22 (inclusive).
25. Select all courses with CourseID in the list (101, 102, 105).
26. Find students who are NOT in the 'Physics' department.
27. Select students with NULL in the Department column.
28. Select students whose Department is NOT NULL.
 
## Logical Operators: AND, OR, NOT
29. Retrieve students older than 18 AND in the 'Mathematics' department.
30. Find students who are in the 'Biology' OR 'Chemistry' department.
31. Select students who are NOT in the 'History' department and are younger than 21.
 
## Sorting Data: ORDER BY
32. Select all students and order them by Name in ascending order.
33. Select all courses and order them by Credits in descending order.
34. Retrieve students, sorting by Department ASC and Age DESC.
 
## Limiting Results: LIMIT
35. Retrieve only the first 5 students from the Students table.
36. Get the top 3 courses with the highest credits.
 
## Table Management
37. Add a new column Email to the Students table.
38. Update the Email column for a specific student.
39. Delete students who are older than 25.
40. Delete a course with a specific CourseID.
 
## Practice with NULLs
41. Insert a student without specifying the Department.
42. Find all students without a Department assigned.
 
## Data Modification
43. Change the department for all students named ‘Alex’ to ‘Engineering’.
44. Increase all students’ ages by 1 year.
 
## Advanced Filtering
45. List all students whose name ends with the letter 'a'.
46. Select students whose name has 'ar' anywhere in it.
 
## Combined Tasks
47. Retrieve the names of students in the 'Physics' or 'Mathematics' department, ordered by Age DESC.
48. Find all unique ages of students who have a Department assigned.
49. Select all students, but only display the first 3 in alphabetical order by Name.
50. Delete all students who have NULL in the Department column.
 
---
 
# 20 Mini Project (SQL & Database Concepts)
 
Below are 20 real-life mini project ideas. Each project aligns with the SQL/database concepts covered, including DBMS setup, table creation, data insertion, querying (SELECT, WHERE, ORDER BY, LIMIT), filtering, sorting, and basic data manipulation.
 
---
 
## 1. Library Management System
**Requirements:**
- Create tables for Books, Authors, Members, and Loans.
- Insert sample data (at least 5 books, 3 authors, 3 members).
- Write queries to find books currently loaned out, overdue books, and members with the most loans.
 
---
 
## 2. Student Attendance Tracker
**Requirements:**
- Tables: Students, Courses, Attendance.
- Insert attendance records for multiple students across different courses.
- Query all students who have more than 90% attendance in a course.
- List students absent on a specific date.
 
---
 
## 3. Employee Payroll System
**Requirements:**
- Tables: Employees, Departments, Salaries.
- Insert data for at least 10 employees, 3 departments.
- Retrieve all employees in a department earning above a certain salary.
- Update salary for employees based on performance.
 
---
 
## 4. Online Store Product Catalog
**Requirements:**
- Tables: Products, Categories, Suppliers.
- Insert products with prices and categories.
- Query products by category, price range, or supplier.
- Find the top 5 most expensive products.
 
---
 
## 5. Hospital Patient Record Management
**Requirements:**
- Tables: Patients, Doctors, Appointments.
- Insert appointments for different doctors and patients.
- List appointments for a doctor within a date range.
- Find patients without assigned doctors.
 
---
 
## 6. Movie Rental System
**Requirements:**
- Tables: Movies, Customers, Rentals.
- Insert sample movies and rental records.
- Query overdue rentals and customers who rented specific genres.
- List top 3 most rented movies.
 
---
 
## 7. Restaurant Reservation System
**Requirements:**
- Tables: Tables, Customers, Reservations.
- Insert reservation entries for different dates and times.
- Find available tables at a given time.
- List customers with more than 2 reservations.
 
---
 
## 8. School Grading System
**Requirements:**
- Tables: Students, Subjects, Grades.
- Insert grades for students in various subjects.
- Query students with highest grade per subject.
- List students who failed (grade below passing threshold).
 
---
 
## 9. Travel Agency Booking System
**Requirements:**
- Tables: Customers, Trips, Bookings.
- Insert bookings for various trips.
- Find all trips booked by a customer.
- List trips with no bookings.
 
---
 
## 10. Gym Membership Management
**Requirements:**
- Tables: Members, MembershipTypes, Payments.
- Insert members and their payment records.
- Query members with expired memberships.
- List members who haven’t made a payment in the last month.
 
---
 
## 11. E-Commerce Order Tracking
**Requirements:**
- Tables: Customers, Orders, OrderItems, Products.
- Insert orders for customers.
- Query pending orders and order history for a customer.
- List products ordered more than 10 times.
 
---
 
## 12. Hotel Room Booking System
**Requirements:**
- Tables: Rooms, Guests, Bookings.
- Insert bookings for various rooms.
- Find available rooms for a given date.
- List guests with more than 3 bookings.
 
---
 
## 13. Inventory Management for a Grocery Store
**Requirements:**
- Tables: Products, Suppliers, Stock.
- Insert products with stock levels and suppliers.
- Query low-stock products (below threshold).
- List suppliers providing more than 5 products.
 
---
 
## 14. Vehicle Service Center Database
**Requirements:**
- Tables: Vehicles, Customers, Services, ServiceRecords.
- Insert records of vehicle services.
- Query vehicles serviced in the last month.
- Find customers with more than 2 services in a year.
 
---
 
## 15. Bookstore Sales System
**Requirements:**
- Tables: Books, Sales, Customers.
- Insert sales transactions.
- Query best-selling books.
- List customers who purchased more than 3 books.
 
---
 
## 16. University Course Enrollment System
**Requirements:**
- Tables: Students, Courses, Enrollments.
- Insert students enrolled in various courses.
- Query courses with no enrollments.
- List students enrolled in more than 2 courses.
 
---
 
## 17. Parking Lot Management
**Requirements:**
- Tables: Lots, Vehicles, ParkingRecords.
- Insert vehicle entry/exit times.
- Find currently parked vehicles.
- List lots that are full.
 
---
 
## 18. Music Streaming Database
**Requirements:**
- Tables: Users, Songs, Playlists, PlaylistSongs.
- Insert user playlists and song data.
- Query most played songs.
- List users with more than 2 playlists.
 
---
 
## 19. Event Management System
**Requirements:**
- Tables: Events, Attendees, Registrations.
- Insert event registrations.
- Query events with more than 100 attendees.
- List attendees registered for multiple events.
 
---
 
## 20. Clinic Appointment Scheduling
**Requirements:**
- Tables: Patients, Doctors, Appointments.
- Insert appointments for patients and doctors.
- Find doctors with most appointments in a week.
- List patients with missed appointments.
 
---
SQL DAY 21
 
50 TASKS
 
 
 
## Aggregate Functions
1. Count the total number of employees in the employees table.
2. Count how many employees are in the "IT" department.
3. Find the sum of all employees’ salaries.
4. Find the sum of salaries for employees in the "HR" department.
5. Calculate the average salary of all employees.
6. Find the average salary of employees in the "Marketing" department.
7. Find the minimum salary in the employees table.
8. Find the maximum salary in the employees table.
9. Find the minimum hire date in the employees table.
10. Find the maximum hire date in the employees table.
 
## GROUP BY
11. Show the total salary paid for each department.
12. Show the average salary for each department.
13. List the number of employees in each department.
14. List departments with more than 2 employees (use HAVING).
15. Show the minimum salary for each department.
16. Show the maximum salary for each department.
17. List the number of employees hired each year.
18. Show the total salary for departments where the total salary exceeds 100,000.
19. List departments where the average salary is above 60,000.
20. List years and the number of employees hired in each year.
 
## HAVING
21. Find departments where the sum of salaries is less than 120,000.
22. Find departments with an average salary below 55,000.
23. List departments with more than 3 employees and total salary above 150,000.
24. Show departments where the maximum salary is at least 70,000.
25. List departments where the minimum salary is above 50,000.
 
## Advanced Aggregates
26. Find the highest salary among employees who joined after 2020-01-01.
27. Count how many employees have a salary below the overall average.
28. List all departments and their total salary, including those with NULL department names.
29. Find the department with the most employees.
30. Find the department with the lowest total salary.
 
## Joins (Assume you have a departments table: department_id, department_name)
31. List all employees and their department names (use INNER JOIN).
32. List all employees and their department names, including those without a department (LEFT JOIN).
33. List all departments and employees, including departments with no employees (RIGHT JOIN).
34. Show all department names, even if there are no employees in them (RIGHT or LEFT JOIN).
35. For each department, list the department name and the number of employees in it (JOIN + GROUP BY).
 
## Multiple Joins (Assume you have a salaries table: employee_id, amount, date_paid)
36. Show all employees, their department names, and their latest salary paid.
37. List all salaries paid in each department.
38. Find employees who have never been paid a salary (LEFT JOIN with salaries).
39. List departments and the total paid to their employees (JOIN + GROUP BY).
40. Find the average salary amount paid per department.
 
## Self Joins (Assume employees table has manager_id referencing employee_id)
41. List all employees with their manager’s name.
42. Find employees who are also managers.
43. Find employees who have the same manager.
44. List all managers and the number of employees reporting to them.
45. Show employees whose manager is in the "IT" department.
 
## Combining Aggregates and Joins
46. For each department, show the department name and the highest salary of its employees.
47. List employees whose salary is higher than the average salary of their department.
48. List all departments with the total salary paid to employees who joined before 2020.
49. Show departments where all employees have a salary above 50,000.
50. Find the manager who manages the most employees.
 
---
 
20 Mini Projects
 
---
 
### 1. **Company Payroll Analytics**
- Tables: employees, departments, salaries
- Calculate total, average, min, and max salaries by department.
- List departments with total salary above a threshold using HAVING.
- Identify top 3 highest paid employees.
 
---
 
### 2. **School Performance Dashboard**
- Tables: students, classes, grades
- Find average grade per student and per class.
- List classes where the average grade is below a set value.
- Identify students with the highest and lowest grades.
 
---
 
### 3. **E-Commerce Sales Summary**
- Tables: products, orders, order_items, customers
- Show total sales per product and per customer.
- List products with sales above a certain amount.
- Identify customers with no orders (LEFT JOIN).
 
---
 
### 4. **Hospital Department Metrics**
- Tables: doctors, patients, departments, appointments
- Count patients per department and per doctor.
- Find doctors with the most appointments.
- List departments where patient count exceeds 100.
 
---
 
### 5. **Library Borrowing Trends**
- Tables: books, members, loans
- Count total loans per book and per member.
- Identify books borrowed more than N times.
- List members who have never borrowed a book.
 
---
 
### 6. **Restaurant Order Analysis**
- Tables: menu_items, orders, customers, order_details
- Compute total revenue per menu item.
- List customers with the highest order totals.
- Find menu items never ordered.
 
---
 
### 7. **University Course Statistics**
- Tables: courses, enrollments, students
- Find the number of students per course.
- List courses with no enrollments (LEFT JOIN).
- Show courses where all students passed.
 
---
 
### 8. **Retail Inventory & Supplier Summary**
- Tables: products, suppliers, purchases
- Show total stock purchased per supplier.
- List products never purchased.
- Find supplier with the largest product portfolio.
 
---
 
### 9. **Fitness Club Member Engagement**
- Tables: members, classes, attendance
- Count class attendance per member.
- Identify members with no attendance (LEFT JOIN).
- List classes with highest average attendance.
 
---
 
### 10. **Event Registration Reporting**
- Tables: events, attendees, registrations
- Count registrations per event.
- Find attendees who registered for most events.
- List events with no registrations.
 
---
 
### 11. **IT Asset Management**
- Tables: assets, employees, departments
- Count assets assigned per department.
- List employees with more than 2 assets.
- Show departments with no assigned assets.
 
---
 
### 12. **Movie Rental Store Insights**
- Tables: movies, rentals, customers
- Find most and least rented movies.
- List customers with overdue rentals.
- Show movies never rented.
 
---
 
### 13. **Bank Branch & Customer Statistics**
- Tables: branches, customers, accounts, transactions
- Count accounts and total balance per branch.
- List customers with no transactions.
- Find branches with the highest/lowest number of customers.
 
---
 
### 14. **Clinic Patient Visit Analysis**
- Tables: patients, visits, doctors
- Count visits per doctor and per patient.
- List patients with only one visit.
- Show doctors with no patient visits.
 
---
 
### 15. **Hotel Booking Dashboard**
- Tables: rooms, bookings, guests
- Calculate occupancy rates per room.
- Find guests with multiple bookings.
- List rooms never booked.
 
---
SQL DAY 22 
50 TASKS
🔁 A. Subqueries (20 Tasks)
✅ 1–5: Subqueries in SELECT Clause
1.	Retrieve each employee’s name and compare their salary to the highest salary in the company.
2.	Show each employee’s salary and the total number of employees (using subquery).
3.	List employees with their salaries and the minimum salary in their department.
4.	Display each product with its price and the highest price in the product table.
5.	Show each employee’s bonus as 10% of the max salary (use subquery in SELECT).
________________________________________
✅ 6–10: Subqueries in FROM Clause
6.	Display departments where average salary is more than ₹10,000 using a subquery in the FROM clause.
7.	Get department-wise average salaries and sort only those greater than the company-wide average salary.
8.	From a subquery table of top 3 salaried employees, list employee names and departments.
9.	Calculate total salary by department, only for departments that have more than 5 employees.
10.	Create a temporary table using subquery to calculate salary ranges (min, max, avg) per department.
________________________________________
✅ 11–15: Subqueries in WHERE Clause
11.	Show employees who earn more than the average salary.
12.	List products whose price is higher than the average price.
13.	Find employees whose department has more than 3 employees (using COUNT subquery).
14.	Get customers who have placed more orders than the average number of orders per customer.
15.	Display products whose quantity is below the minimum quantity across all products.
________________________________________
✅ 16–20: Correlated vs. Non-Correlated Subqueries
16.	Find employees who earn more than the average salary in their department.
17.	List employees who are the highest paid in their department.
18.	Show departments that have at least one employee earning more than ₹50,000.
19.	List employees whose salaries are higher than all their team members (correlated).
20.	Identify employees who earn less than the maximum salary of any department (non-correlated).
________________________________________
🔗 B. UNION, UNION ALL, INTERSECT, EXCEPT (10 Tasks)
✅ 21–25: UNION & UNION ALL
21.	List all unique customer names from two tables: online_orders and store_orders (use UNION).
22.	List all customer names (including duplicates) from online_orders and store_orders (UNION ALL).
23.	Combine employee names from full_time_employees and contract_employees.
24.	Combine all product names from electronics and furniture tables.
25.	Display all city names from customers and suppliers (with and without duplicates).
________________________________________
✅ 26–30: INTERSECT & EXCEPT
26.	Find employees who work in both department 101 (IT) and 102 (Finance) – INTERSECT.
27.	List employees in IT but not in HR – use EXCEPT or MINUS.
28.	Get product IDs available in both wholesale and retail tables.
29.	Find customers who only ordered from the website, not from stores.
30.	List employee IDs that exist in current_employees but not in resigned_employees.
________________________________________
🔍 C. Complex Queries with JOIN, GROUP BY, Aggregation (10 Tasks)
✅ 31–35: JOIN + GROUP BY + Aggregation
31.	Show total salary paid per department (join with department table).
32.	Find number of employees in each department.
33.	Get department names and average salary of employees working in them.
34.	Display departments with a total salary bill above ₹1,00,000.
35.	Show number of employees hired per year.
________________________________________
✅ 36–40: JOIN + Subquery + Aggregation
36.	Find departments where the average salary is higher than the company's average salary.
37.	Display departments and the name of the highest-paid employee in each.
38.	Get names of departments where the employee count is below the average department size.
39.	Show all departments and count of employees earning more than ₹50,000.
40.	List employees whose salary is more than their department’s average salary.
________________________________________
🎯 D. Conditional Logic & Date Functions (10 Tasks)
✅ 41–45: CASE WHEN – Conditional Aggregation
41.	Classify employees as High, Medium, or Low salary using CASE WHEN.
42.	Display product stock status as Low, Moderate, or High based on quantity.
43.	Show department-wise count of employees in each salary category (using CASE inside SUM).
44.	Show employees with remarks: New Joiner, Mid-Level, or Senior based on their joining year.
45.	For each employee, display salary grade using CASE WHEN with 3 conditions.
________________________________________
✅ 46–50: Working with Date Functions
46.	List employees who joined in the last 6 months using DATE_SUB.
47.	Show employees whose tenure is more than 2 years using DATEDIFF or TIMESTAMPDIFF.
48.	Display employees' names and months since their joining.
49.	Count how many employees joined in each year using YEAR(hire_date).
50.	List all employees whose birthday is in the current month.



20 MINI PROJECTS
 
✅ 1. Employee Salary Insight Dashboard
Domain: HR
Objective: Create insights comparing each employee’s salary to various benchmarks.
Requirements:
•	Show each employee’s salary alongside company-wide max, avg, and min salary (subqueries in SELECT).
•	Classify salary as High, Medium, or Low using CASE WHEN.
•	Use correlated subquery to compare salary to department average.
•	Display department-wise salary summary with JOIN and GROUP BY.
________________________________________
✅ 2. Department Budget Analyzer
Domain: Corporate Finance
Objective: Analyze departmental salary expenses.
Requirements:
•	Use subquery in FROM clause to calculate average salary by department.
•	Filter only those departments with average salary > ₹50,000.
•	Show total salary paid by each department.
•	Show which department has the highest total salary using subquery comparison.
________________________________________
✅ 3. Employee Transfer Tracker
Domain: HR / Operations
Objective: Track employees who worked in multiple departments.
Requirements:
•	Use INTERSECT to find employees in both IT and Finance.
•	Use EXCEPT to find employees in one dept but not in another.
•	Use subqueries to find employees who transferred in the last 6 months.
•	Track unique department count per employee using subquery.
________________________________________
✅ 4. Product Category Merger Report
Domain: E-Commerce
Objective: Analyze merged product data from multiple categories.
Requirements:
•	Use UNION to combine products from electronics, clothing, and furniture.
•	Use UNION ALL to check duplicate products.
•	Show max price, min price using subqueries.
•	Classify products by price using CASE.
________________________________________
✅ 5. Customer Purchase Comparison Tool
Domain: Retail
Objective: Compare online and offline customer purchases.
Requirements:
•	Use UNION and UNION ALL to merge customer data from two sources.
•	Use INTERSECT to find customers active on both platforms.
•	Use subqueries to find customers who bought more than the average.
•	Classify customers based on purchase frequency.
________________________________________
✅ 6. High Performer Identification System
Domain: HR
Objective: Find top-performing employees.
Requirements:
•	Use a correlated subquery to get employees with salary > dept average.
•	Highlight top 5 earners using subquery with ORDER BY LIMIT.
•	Show department-level performance summary using JOIN + GROUP BY.
•	Use CASE WHEN to classify employee performance level.
________________________________________
✅ 7. Inventory Stock Checker
Domain: Warehouse Management
Objective: Check stock levels across categories.
Requirements:
•	Merge items using UNION from different category tables.
•	Use subquery to find average stock.
•	Use CASE to tag stock as High, Moderate, Low.
•	Use EXCEPT to find items available in one warehouse but not in another.
________________________________________
✅ 8. Employee Joiner Trend Report
Domain: HR Analytics
Objective: Analyze hiring patterns over time.
Requirements:
•	Use DATE_SUB to get employees who joined in the last 6 months.
•	Use subqueries to find employees who joined before and after company average join date.
•	Aggregate joiners per month using GROUP BY.
•	Use CASE WHEN for year-wise hiring classification.
________________________________________
✅ 9. Department Performance Ranker
Domain: Management
Objective: Rank departments by performance.
Requirements:
•	Use subqueries to calculate total, average salary per department.
•	Use JOIN to get department names.
•	Use CASE WHEN to assign performance tags.
•	Filter departments above average salary expense.
________________________________________
✅ 10. Cross-Sell Opportunity Finder
Domain: Sales Analytics
Objective: Identify common customers across categories.
Requirements:
•	Use INTERSECT to find customers who purchased from multiple categories.
•	Use EXCEPT to find customers loyal to only one.
•	Use subqueries to find customers who spend above average.
•	Merge customer lists with UNION.
________________________________________
✅ 11. Salary Band Distribution Analyzer
Domain: HR
Objective: Categorize employees based on salary bands.
Requirements:
•	Use subqueries to get company and department averages.
•	Use CASE to tag salaries as Band A, B, C.
•	Use GROUP BY to count employees per band per department.
•	Include only those departments where band A employees > 3.
________________________________________
✅ 12. Product Launch Impact Report
Domain: Marketing
Objective: Analyze the success of new product launches.
Requirements:
•	Use DATE functions to get products launched in the last 3 months.
•	Compare sales of new vs existing products using UNION.
•	Use subqueries to find average sales.
•	Classify launch as Successful/Neutral/Fail using CASE.
________________________________________
✅ 13. Supplier Consistency Checker
Domain: Supply Chain
Objective: Evaluate supplier consistency.
Requirements:
•	Use INTERSECT to find suppliers present in both Q1 and Q2.
•	Use EXCEPT to find suppliers missing in Q2.
•	Use subquery to compare average delivery time.
•	Tag supplier status using CASE.
________________________________________
✅ 14. Student Performance Dashboard
Domain: Education
Objective: Analyze academic scores.
Requirements:
•	Use subqueries to calculate subject-wise and overall average marks.
•	Use CASE to tag students as Pass, Merit, Distinction.
•	Use JOIN to combine student and course tables.
•	Filter students above average using WHERE with subquery.
________________________________________
✅ 15. Revenue Comparison Engine
Domain: Finance
Objective: Compare monthly revenue across years.
Requirements:
•	Use DATE functions to group revenue by year/month.
•	Use subquery to calculate year-wise average revenue.
•	Highlight months where revenue was higher than average.
•	Use CASE to classify month as High/Low revenue.
________________________________________
✅ 16. Resignation & Replacement Audit
Domain: HR
Objective: Audit resigned and hired employees.
Requirements:
•	Use EXCEPT to list resigned employees not replaced.
•	Use INTERSECT to identify overlapping designations.
•	Use subqueries to find departments with highest attrition.
•	Use JOIN and GROUP BY for department-level resignation count.
________________________________________
✅ 17. Product Return & Complaint Analyzer
Domain: Customer Support
Objective: Track product return behavior.
Requirements:
•	Use subqueries to find most returned products.
•	Use CASE to classify return reason (Damaged, Late, Not as Described).
•	Use JOIN to link orders and returns.
•	Filter products with return rate above average.
________________________________________
✅ 18. Freelancer Project Tracker
Domain: Freelance Portal
Objective: Analyze freelancer earnings and projects.
Requirements:
•	Use subquery to calculate average earnings.
•	Use correlated subquery to compare project earnings to user average.
•	Use CASE to classify freelancers by earnings.
•	Use GROUP BY to show projects completed per freelancer.
________________________________________
✅ 19. Course Enrollment Optimizer
Domain: E-Learning
Objective: Analyze course popularity.
Requirements:
•	Use UNION to combine enrollments from free and paid platforms.
•	Use subquery to find average enrollment per course.
•	Use JOIN to connect courses and categories.
•	Classify courses as Popular/Regular based on average.
________________________________________
✅ 20. Vehicle Maintenance Tracker
Domain: Transportation
Objective: Track vehicle maintenance schedules.
Requirements:
•	Use DATE_SUB to list vehicles due for service in the next 30 days.
•	Use subqueries to find vehicles with highest service cost.
•	Use CASE to label urgency (High, Medium, Low).
•	Use GROUP BY to get total cost per vehicle type.


 
### 16. **Online Learning Platform Statistics**
- Tables: courses, users, enrollments, completions
- Count course completions per user.
- List courses with less than 5 completions.
- Identify users enrolled but never completed any course.
 
---
 
### 17. **Municipal Service Requests**
- Tables: requests, citizens, departments
- Count requests per citizen and department.
- List departments with no requests.
- Find citizens with the highest number of requests.
 
---
 
### 18. **Warehouse Order Fulfillment**
- Tables: orders, order_items, products, employees
- Count orders handled per employee.
- Identify products frequently out of stock.
- Show employees with top fulfillment rates.
 
---
 
### 19. **Sales Team Performance Tracking**
- Tables: salespeople, sales, regions
- Calculate total sales per region and per salesperson.
- List salespeople with no sales in a region (LEFT JOIN).
- Identify regions with the highest sales growth.
 
---
 
### 20. **Friend Referral Program**
- Tables: users, referrals (user_id, referred_user_id), purchases
- Count number of referrals per user (self join).
- List users who referred others but made no purchases.
- Identify users with the most referred purchases.
 
---
 
 
 
 


