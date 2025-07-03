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
 
 
 
 


