CREATE DATABASE Clinic_DOCTORDB;
USE Clinic_DOCTORDB;

CREATE TABLE Doctors (
  DoctorID INT PRIMARY KEY AUTO_INCREMENT,
  DoctorName VARCHAR(100) NOT NULL,
  Specialty VARCHAR(100) NOT NULL,
  IsAvailable BOOLEAN DEFAULT TRUE
);

CREATE TABLE Patients (
  PatientID INT PRIMARY KEY AUTO_INCREMENT,
  PatientName VARCHAR(100) NOT NULL
);

CREATE TABLE Appointments (
  AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
  DoctorID INT NOT NULL,
  PatientID INT NOT NULL,
  AppointmentDate TIMESTAMP NOT NULL,
  FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

INSERT INTO Doctors (DoctorName, Specialty)
VALUES 
('Dr. Smith', 'Cardiology'),
('Dr. Patel', 'Dermatology'),
('Dr. Wong', 'Neurology'),
('Dr. Lee', 'Pediatrics');

INSERT INTO Patients (PatientName)
VALUES ('Alice'), ('Bob'), ('Carol'), ('David');

INSERT INTO Appointments (DoctorID, PatientID, AppointmentDate)
VALUES
(1, 1, '2025-07-01'),
(1, 2, '2025-07-02'),
(2, 3, '2025-07-03'),
(1, 4, '2025-07-04');


--	Use LIKE to filter by specialty name.
SELECT *
FROM Doctors
WHERE Specialty LIKE '%Cardio%';

--	Use GROUP BY to count patients by each doctor.
SELECT 
  d.DoctorID,
  d.DoctorName,
  d.Specialty,
  COUNT(a.AppointmentID) AS PatientCount
FROM Doctors d
LEFT JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID, d.DoctorName, d.Specialty;

--	Use HAVING to find overloaded doctors.
SELECT 
  d.DoctorID,
  d.DoctorName,
  COUNT(a.AppointmentID) AS PatientCount
FROM Doctors d
LEFT JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID, d.DoctorName
HAVING COUNT(a.AppointmentID) > 2;

--	Insert and update doctor availability using transactions
START TRANSACTION;

UPDATE Doctors
SET IsAvailable = FALSE
WHERE DoctorID = 1;
COMMIT;