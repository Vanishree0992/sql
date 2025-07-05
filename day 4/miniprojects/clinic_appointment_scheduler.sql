CREATE DATABASE Clinic_DB;
USE Clinic_DB;

CREATE TABLE Doctors (
  doctor_id INT PRIMARY KEY AUTO_INCREMENT,
  doctor_name VARCHAR(100) NOT NULL,
  specialization VARCHAR(100)
);

CREATE TABLE Patients (
  patient_id INT PRIMARY KEY AUTO_INCREMENT,
  patient_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20)
);

CREATE TABLE Appointments (
  appointment_id INT PRIMARY KEY AUTO_INCREMENT,
  doctor_id INT NOT NULL,
  patient_id INT NOT NULL,
  appointment_datetime DATETIME NOT NULL,
  status ENUM('Scheduled', 'Cancelled', 'Completed') DEFAULT 'Scheduled',
  FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE CASCADE,
  FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
  UNIQUE (doctor_id, appointment_datetime) 
);

INSERT INTO Doctors (doctor_name, specialization)
VALUES 
  ('Dr. Smith', 'Cardiology'),
  ('Dr. Adams', 'Dermatology');

INSERT INTO Patients (patient_name, phone)
VALUES
  ('Alice Patient', '1234567890'),
  ('Bob Patient', '0987654321');

 -- •	Use transactions to batch-schedule multiple appointments
START TRANSACTION;

INSERT INTO Appointments (doctor_id, patient_id, appointment_datetime)
VALUES (1, 1, '2025-07-15 10:00:00');

INSERT INTO Appointments (doctor_id, patient_id, appointment_datetime)
VALUES (2, 2, '2025-07-15 11:00:00');

COMMIT;
-- •	Update appointment status
UPDATE Appointments
SET status = 'Cancelled'
WHERE appointment_id = 1 AND appointment_id > 0; 

--	Delete old appointments.
DELETE FROM Appointments
WHERE appointment_datetime < CURDATE()
  AND appointment_id > 0; 


SELECT * FROM Doctors;
SELECT * FROM Patients;
SELECT * FROM Appointments;