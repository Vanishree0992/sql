CREATE DATABASE  Hospital_DB;
USE Hospital_DB;

CREATE TABLE Patients (
  patient_id INT PRIMARY KEY AUTO_INCREMENT,
  patient_name VARCHAR(100) NOT NULL,
  date_of_birth DATE NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Doctors (
  doctor_id INT PRIMARY KEY AUTO_INCREMENT,
  doctor_name VARCHAR(100) NOT NULL,
  specialization VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Appointments (
  appointment_id INT PRIMARY KEY AUTO_INCREMENT,
  patient_id INT NOT NULL,
  doctor_id INT NOT NULL,
  appointment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  treatment_status VARCHAR(50) NOT NULL DEFAULT 'Scheduled',
  FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
    ON DELETE CASCADE,
  FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
    ON DELETE CASCADE
);

INSERT INTO Doctors (doctor_name, specialization, email)
VALUES 
  ('Dr. Smith', 'Cardiology', 'smith@hospital.com'),
  ('Dr. Jones', 'Neurology', 'jones@hospital.com');
  
  INSERT INTO Patients (patient_name, date_of_birth, email)
VALUES 
  ('Alice Brown', '1990-04-15', 'alice.brown@example.com'),
  ('Bob Green', '1985-07-22', 'bob.green@example.com');

INSERT INTO Appointments (patient_id, doctor_id, treatment_status)
VALUES
  (1, 1, 'Scheduled'),
  (2, 2, 'Scheduled');
  
--  •	Update treatment status with UPDATE.
UPDATE Appointments
SET treatment_status = 'In Treatment'
WHERE appointment_id = 1;

-- •	Delete past records after discharge.
DELETE FROM Patients
WHERE patient_id = 2;

-- •	Simulate patient registration with rollback on failure.

START TRANSACTION;
INSERT INTO Patients (patient_name, date_of_birth, email)
VALUES ('Charlie White', '1995-09-05', 'charlie.white@example.com');
SAVEPOINT before_email_error;
INSERT INTO Patients (patient_name, date_of_birth, email)
VALUES ('Charlie Duplicate', '1998-11-20', 'charlie.white@example.com');
ROLLBACK TO before_email_error;
COMMIT;

SELECT * FROM Patients;
SELECT * FROM Doctors;
SELECT * FROM Appointments;