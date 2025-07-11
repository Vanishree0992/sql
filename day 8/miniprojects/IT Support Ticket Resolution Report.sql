CREATE DATABASE ITSupportDB;
USE ITSupportDB;

CREATE TABLE SupportStaff (
  staff_id INT PRIMARY KEY,
  staff_name VARCHAR(100)
);


CREATE TABLE Users (
  user_id INT PRIMARY KEY,
  user_name VARCHAR(100)
);


CREATE TABLE Tickets (
  ticket_id INT PRIMARY KEY,
  user_id INT,
  staff_id INT,
  opened_date DATE,
  closed_date DATE,
  sla_days INT,
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  FOREIGN KEY (staff_id) REFERENCES SupportStaff(staff_id)
);


INSERT INTO SupportStaff VALUES (1, 'Alice');
INSERT INTO SupportStaff VALUES (2, 'Bob');

INSERT INTO Users VALUES (1, 'UserA');
INSERT INTO Users VALUES (2, 'UserB');

INSERT INTO Tickets VALUES (1, 1, 1, '2024-07-01', '2024-07-02', 2);
INSERT INTO Tickets VALUES (2, 1, 1, '2024-07-05', '2024-07-10', 3);
INSERT INTO Tickets VALUES (3, 2, 2, '2024-07-02', '2024-07-06', 2);
INSERT INTO Tickets VALUES (4, 2, 2, '2024-07-07', '2024-07-20', 5); -- overdue


-- Use DATEDIFF() + LEAD() for resolution times
SELECT
  t.ticket_id,
  u.user_name,
  s.staff_name,
  t.opened_date,
  t.closed_date,
  DATEDIFF(t.closed_date, t.opened_date) AS resolution_days,
  LEAD(t.opened_date) OVER (PARTITION BY t.user_id ORDER BY t.opened_date) AS next_ticket_opened,
  ROW_NUMBER() OVER (PARTITION BY t.user_id ORDER BY t.opened_date) AS ticket_order
FROM Tickets t
JOIN Users u ON t.user_id = u.user_id
JOIN SupportStaff s ON t.staff_id = s.staff_id
ORDER BY t.user_id, t.opened_date;

-- CTE for overdue tickets
WITH TicketResolution AS (
  SELECT
    t.ticket_id,
    t.user_id,
    t.staff_id,
    DATEDIFF(t.closed_date, t.opened_date) AS resolution_days,
    t.sla_days
  FROM Tickets t
)
SELECT
  tr.ticket_id,
  u.user_name,
  s.staff_name,
  tr.resolution_days,
  tr.sla_days
FROM TicketResolution tr
JOIN Users u ON tr.user_id = u.user_id
JOIN SupportStaff s ON tr.staff_id = s.staff_id
WHERE tr.resolution_days > tr.sla_days;


-- Average resolution time per support staff
SELECT
  s.staff_id,
  s.staff_name,
  ROUND(AVG(DATEDIFF(t.closed_date, t.opened_date)), 2) AS avg_resolution_days
FROM Tickets t
JOIN SupportStaff s ON t.staff_id = s.staff_id
GROUP BY s.staff_id, s.staff_name;

-- 
CREATE VIEW ITSupportSLAReport AS
WITH TicketResolution AS (
  SELECT
    t.ticket_id,
    t.user_id,
    t.staff_id,
    DATEDIFF(t.closed_date, t.opened_date) AS resolution_days,
    t.sla_days
  FROM Tickets t
)
SELECT
  tr.ticket_id,
  u.user_name,
  s.staff_name,
  tr.resolution_days,
  tr.sla_days,
  CASE WHEN tr.resolution_days > tr.sla_days THEN 'Overdue' ELSE 'On Time' END AS status
FROM TicketResolution tr
JOIN Users u ON tr.user_id = u.user_id
JOIN SupportStaff s ON tr.staff_id = s.staff_id;
