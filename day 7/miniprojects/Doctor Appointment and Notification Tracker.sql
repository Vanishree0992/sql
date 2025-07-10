CREATE DATABASE doctor_appointment;
USE doctor_appointment;

CREATE TABLE Patients (
  patient_id INT PRIMARY KEY AUTO_INCREMENT,
  patient_name VARCHAR(100)
);

CREATE TABLE Doctors (
  doctor_id INT PRIMARY KEY AUTO_INCREMENT,
  doctor_name VARCHAR(100),
  specialization VARCHAR(100)
);

CREATE TABLE Appointments (
  appointment_id INT PRIMARY KEY AUTO_INCREMENT,
  patient_id INT,
  doctor_id INT,
  appointment_date DATE,
  appointment_time TIME,
  status VARCHAR(20) DEFAULT 'Booked',
  FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
  FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE DoctorNotifications (
  notification_id INT PRIMARY KEY AUTO_INCREMENT,
  doctor_id INT,
  message VARCHAR(255),
  notified_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE MedicalHistory (
  history_id INT PRIMARY KEY AUTO_INCREMENT,
  patient_id INT,
  record_date DATE,
  diagnosis VARCHAR(255),
  treatment VARCHAR(255),
  FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

INSERT INTO Doctors (doctor_name, specialization) VALUES
('Dr. Smith', 'Cardiology'),
('Dr. Johnson', 'Orthopedics'),
('Dr. Lee', 'Dermatology');

INSERT INTO Patients (patient_name) VALUES
('Alice'), ('Bob'), ('Charlie'), ('David'), ('Eve'),
('Frank'), ('Grace'), ('Heidi'), ('Ivan'), ('Judy');

INSERT INTO Appointments (patient_id, doctor_id, appointment_date, appointment_time) VALUES
(1, 1, '2025-07-12', '09:00:00'),
(2, 1, '2025-07-12', '09:30:00'),
(3, 1, '2025-07-12', '10:00:00'),
(4, 2, '2025-07-12', '11:00:00'),
(5, 2, '2025-07-12', '11:30:00'),
(6, 2, '2025-07-12', '12:00:00'),
(7, 3, '2025-07-12', '13:00:00'),
(8, 3, '2025-07-12', '13:30:00'),
(9, 3, '2025-07-12', '14:00:00'),
(10, 1, '2025-07-13', '09:00:00'),
(1, 2, '2025-07-13', '10:30:00'),
(2, 2, '2025-07-13', '11:00:00'),
(3, 2, '2025-07-13', '11:30:00'),
(4, 3, '2025-07-13', '12:00:00'),
(5, 3, '2025-07-13', '12:30:00'),
(6, 3, '2025-07-13', '13:00:00'),
(7, 1, '2025-07-14', '09:00:00'),
(8, 1, '2025-07-14', '09:30:00'),
(9, 1, '2025-07-14', '10:00:00'),
(10, 2, '2025-07-14', '11:00:00');

-- view: Doctor schedules (safe for patients)
CREATE VIEW vw_doctor_schedules AS
SELECT 
  a.appointment_id,
  d.doctor_name,
  d.specialization,
  a.appointment_date,
  a.appointment_time,
  a.status
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.doctor_id;
SELECT * FROM vw_doctor_schedules;

--  Stored Procedure: Book an appointment
DELIMITER $$

CREATE PROCEDURE BookAppointment(
  IN p_patient_id INT,
  IN p_doctor_id INT,
  IN p_date DATE,
  IN p_time TIME
)
BEGIN
  INSERT INTO Appointments (patient_id, doctor_id, appointment_date, appointment_time)
  VALUES (p_patient_id, p_doctor_id, p_date, p_time);
END$$

DELIMITER ;
CALL BookAppointment(1, 1, '2025-07-15', '09:00:00');
SELECT * FROM DoctorNotifications;

-- Function: Get next available slot
DELIMITER $$

CREATE FUNCTION GetNextAvailableSlot(p_doctor_id INT, p_date DATE)
RETURNS TIME
DETERMINISTIC
BEGIN
  DECLARE v_next_slot TIME;

  SELECT MIN(appointment_time)
  INTO v_next_slot
  FROM Appointments
  WHERE doctor_id = p_doctor_id AND appointment_date = p_date AND status = 'Available';

  RETURN v_next_slot;
END$$

DELIMITER ;
SELECT GetNextAvailableSlot(1, '2025-07-12') AS NextSlot;

--  Trigger: Notify doctor upon booking
DELIMITER $$

CREATE TRIGGER trg_notify_doctor_booking
AFTER INSERT ON Appointments
FOR EACH ROW
BEGIN
  INSERT INTO DoctorNotifications (doctor_id, message)
  VALUES (NEW.doctor_id, CONCAT('New appointment booked on ', NEW.appointment_date, ' at ', NEW.appointment_time));
END$$

DELIMITER ;


SET @current_patient_id = 1;

SELECT * FROM MedicalHistory WHERE patient_id = @current_patient_id;