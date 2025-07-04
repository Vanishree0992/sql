CREATE DATABASE Freelance_Portal;
USE Freelance_Portal;

CREATE TABLE freelancers (
    freelancer_id INT PRIMARY KEY,
    full_name VARCHAR(100)
);

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    freelancer_id INT,
    project_title VARCHAR(100),
    earnings DECIMAL(10, 2),
    FOREIGN KEY (freelancer_id) REFERENCES freelancers(freelancer_id)
);

INSERT INTO freelancers 
VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'Diana');

INSERT INTO projects 
VALUES
(101, 1, 'Web Design', 1000),
(102, 1, 'Logo Design', 700),
(103, 2, 'App Development', 2000),
(104, 2, 'Bug Fixing', 800),
(105, 3, 'SEO Audit', 400),
(106, 3, 'Marketing Strategy', 300),
(107, 4, 'Database Setup', 2500),
(108, 4, 'Cloud Migration', 3000);

--	Use subquery to calculate average earnings.
SELECT AVG(earnings) AS avg_earning_all_projects
FROM projects;

--	Use correlated subquery to compare project earnings to user average.
SELECT 
    p.project_id,
    f.full_name,
    p.project_title,
    p.earnings,
    (SELECT AVG(p2.earnings) 
     FROM projects p2 
     WHERE p2.freelancer_id = p.freelancer_id) AS freelancer_avg,
    CASE 
        WHEN p.earnings > (SELECT AVG(p2.earnings) FROM projects p2 WHERE p2.freelancer_id = p.freelancer_id) THEN 'Above Avg'
        WHEN p.earnings = (SELECT AVG(p2.earnings) FROM projects p2 WHERE p2.freelancer_id = p.freelancer_id) THEN 'Average'
        ELSE 'Below Avg'
    END AS earning_level
FROM projects p
JOIN freelancers f ON p.freelancer_id = f.freelancer_id;

--	Use CASE to classify freelancers by earnings.
SELECT 
    f.freelancer_id,
    f.full_name,
    SUM(p.earnings) AS total_earnings,
    CASE
        WHEN SUM(p.earnings) > 4000 THEN 'High'
        WHEN SUM(p.earnings) >= 2000 THEN 'Medium'
        ELSE 'Low'
    END AS earning_category
FROM freelancers f
JOIN projects p ON f.freelancer_id = p.freelancer_id
GROUP BY f.freelancer_id, f.full_name;

--	Use GROUP BY to show projects completed per freelancer.
SELECT 
    f.freelancer_id,
    f.full_name,
    COUNT(p.project_id) AS projects_completed
FROM freelancers f
JOIN projects p ON f.freelancer_id = p.freelancer_id
GROUP BY f.freelancer_id, f.full_name;
