CREATE DATABASE Gym_DB;
USE Gym_DB;

CREATE TABLE MembershipPlans (
  plan_id INT PRIMARY KEY AUTO_INCREMENT,
  plan_name VARCHAR(100) NOT NULL,
  duration_months INT NOT NULL CHECK (duration_months > 0),
  price DECIMAL(10, 2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE Members (
  member_id INT PRIMARY KEY AUTO_INCREMENT,
  member_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  plan_id INT,
  status ENUM('Active', 'Expired') DEFAULT 'Active',
  membership_start DATE,
  membership_end DATE,
  FOREIGN KEY (plan_id) REFERENCES MembershipPlans(plan_id) ON DELETE SET NULL
);

CREATE TABLE ClassBookings (
  booking_id INT PRIMARY KEY AUTO_INCREMENT,
  member_id INT NOT NULL,
  class_date DATE NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE
);

INSERT INTO MembershipPlans (plan_name, duration_months, price)
VALUES 
  ('Monthly', 1, 50.00),
  ('Quarterly', 3, 135.00),
  ('Yearly', 12, 480.00);

INSERT INTO Members (member_name, email, plan_id, membership_start, membership_end)
VALUES
  ('Alice Strong', 'alice@gymfit.com', 1, '2025-07-01', '2025-07-31'),
  ('Bob Lifter', 'bob@gymfit.com', 2, '2025-07-01', '2025-09-30');

INSERT INTO ClassBookings (member_id, class_date)
VALUES (1, '2025-07-15');

-- •	Update membership status.
UPDATE Members m
JOIN (
  SELECT member_id
  FROM Members
  WHERE membership_end < CURDATE()
) AS sub ON m.member_id = sub.member_id
SET m.status = 'Expired';

-- •	Delete expired memberships.
DELETE FROM Members
WHERE status = 'Expired'
  AND member_id > 0; 
  
-- •	Use transactions for membership purchase + booking together.
START TRANSACTION;
UPDATE Members
SET plan_id = 3,
    membership_start = CURDATE(),
    membership_end = DATE_ADD(CURDATE(), INTERVAL 12 MONTH),
    status = 'Active'
WHERE member_id = 1;

INSERT INTO ClassBookings (member_id, class_date)
VALUES (1, '2025-08-10');

COMMIT;

SELECT * FROM Members;
SELECT * FROM MembershipPlans;
SELECT * FROM ClassBookings;