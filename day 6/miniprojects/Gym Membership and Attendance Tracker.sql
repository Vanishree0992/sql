CREATE DATABASE Gym_attendanceDB;
USE Gym_attendanceDB;

CREATE TABLE Members (
  member_id INT AUTO_INCREMENT PRIMARY KEY,
  member_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(100)
);


CREATE TABLE Plans (
  plan_id INT AUTO_INCREMENT PRIMARY KEY,
  plan_type VARCHAR(50) NOT NULL,
  duration_months INT,
  price DECIMAL(8,2)
);


CREATE TABLE Trainers (
  trainer_id INT AUTO_INCREMENT PRIMARY KEY,
  trainer_name VARCHAR(100) NOT NULL,
  specialty VARCHAR(100)
);


CREATE TABLE CheckIns (
  checkin_id INT AUTO_INCREMENT PRIMARY KEY,
  member_id INT NOT NULL,
  trainer_id INT NOT NULL,
  plan_id INT NOT NULL,
  checkin_date DATE NOT NULL,
  notes TEXT,
  FOREIGN KEY (member_id) REFERENCES Members(member_id),
  FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id),
  FOREIGN KEY (plan_id) REFERENCES Plans(plan_id)
);


CREATE INDEX idx_member_name ON Members(member_name);
CREATE INDEX idx_checkin_date ON CheckIns(checkin_date);
CREATE INDEX idx_plan_type ON Plans(plan_type);


INSERT INTO Members (member_name, phone, email) VALUES
('Alice Johnson', '555-111-2222', 'alice@gym.com'),
('Bob Smith', '555-222-3333', 'bob@gym.com'),
('Carol White', '555-333-4444', 'carol@gym.com'),
('David Lee', '555-444-5555', 'david@gym.com'),
('Eve Brown', '555-555-6666', 'eve@gym.com');


INSERT INTO Plans (plan_type, duration_months, price) VALUES
('Monthly', 1, 50.00),
('Quarterly', 3, 135.00),
('Yearly', 12, 480.00);


INSERT INTO Trainers (trainer_name, specialty) VALUES
('Trainer Mike', 'Weightlifting'),
('Trainer Sara', 'Yoga'),
('Trainer John', 'Cardio');


INSERT INTO CheckIns (member_id, trainer_id, plan_id, checkin_date, notes) VALUES
(1, 1, 1, '2025-07-01', 'Leg day'),
(1, 1, 1, '2025-07-02', 'Upper body'),
(1, 2, 1, '2025-07-03', 'Yoga session'),
(2, 1, 2, '2025-07-01', 'Strength'),
(2, 1, 2, '2025-07-04', 'Deadlifts'),
(2, 3, 2, '2025-07-05', 'Cardio'),
(3, 2, 1, '2025-07-01', 'Yoga basics'),
(3, 2, 1, '2025-07-03', 'Yoga advanced'),
(3, 3, 1, '2025-07-04', 'Treadmill'),
(4, 1, 3, '2025-07-01', 'Chest'),
(4, 1, 3, '2025-07-02', 'Back'),
(4, 1, 3, '2025-07-05', 'Arms'),
(5, 3, 3, '2025-07-01', 'HIIT'),
(5, 3, 3, '2025-07-02', 'Elliptical'),
(5, 3, 3, '2025-07-04', 'Spin class'),
(1, 1, 1, '2025-07-06', 'Squats'),
(1, 1, 1, '2025-07-07', 'Shoulders'),
(2, 1, 2, '2025-07-06', 'Bench press'),
(2, 3, 2, '2025-07-07', 'Stair climber'),
(3, 2, 1, '2025-07-06', 'Stretching'),
(3, 2, 1, '2025-07-07', 'Pilates'),
(4, 1, 3, '2025-07-06', 'Full body'),
(4, 1, 3, '2025-07-07', 'Deadlift'),
(5, 3, 3, '2025-07-06', 'Rowing'),
(5, 3, 3, '2025-07-07', 'Jump rope'),
(5, 3, 3, '2025-07-08', 'HIIT again'),
(1, 2, 1, '2025-07-08', 'Meditation');


CREATE OR REPLACE VIEW TrainerDashboard AS
SELECT 
  t.trainer_name,
  m.member_name,
  p.plan_type,
  c.checkin_date,
  c.notes
FROM CheckIns c
JOIN Trainers t ON c.trainer_id = t.trainer_id
JOIN Members m ON c.member_id = m.member_id
JOIN Plans p ON c.plan_id = p.plan_id
ORDER BY t.trainer_name, c.checkin_date DESC;


SELECT *
FROM TrainerDashboard
ORDER BY checkin_date DESC
LIMIT 5;