CREATE DATABASE Hospital_trackerDB;
USE Hospital_trackerDB;

CREATE TABLE Doctors (
  DoctorID INT PRIMARY KEY AUTO_INCREMENT,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Specialty VARCHAR(100) NOT NULL
);

CREATE TABLE Patients (
  PatientID INT PRIMARY KEY AUTO_INCREMENT,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Phone VARCHAR(20)
);

CREATE TABLE Appointments (
  AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
  DoctorID INT NOT NULL,
  PatientID INT NOT NULL,
   AppointmentDate TIMESTAMP NOT NULL,
  Reason VARCHAR(255),
  FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

INSERT INTO Doctors (FirstName, LastName, Specialty)
VALUES
('Alice', 'Brown', 'Cardiology'),
('Bob', 'Smith', 'Dermatology'),
('Carol', 'White', 'Neurology');

INSERT INTO Patients (FirstName, LastName, Phone)
VALUES
('David', 'Miller', '555-1111'),
('Eva', 'Johnson', '555-2222'),
('Frank', 'Taylor', '555-3333');

INSERT INTO Appointments (DoctorID, PatientID, AppointmentDate, Reason)
VALUES
(1, 1, '2025-07-08', 'Heart Checkup'),
(1, 2, '2025-07-09', 'Follow-up'),
(2, 3, '2025-07-09', 'Skin Rash'),
(3, 1, '2025-07-10', 'Headache');

--	Use JOIN to display doctor schedules.
SELECT 
  d.FirstName AS DoctorFirstName,
  d.LastName AS DoctorLastName,
  d.Specialty,
  a.AppointmentDate,
  p.FirstName AS PatientFirstName,
  p.LastName AS PatientLastName,
  a.Reason
FROM Appointments a
JOIN Doctors d ON a.DoctorID = d.DoctorID
JOIN Patients p ON a.PatientID = p.PatientID
ORDER BY d.LastName, a.AppointmentDate;

--	Use WHERE with LIKE to search patients by name.
SELECT *
FROM Patients
WHERE FirstName LIKE '%Dav%' OR LastName LIKE '%Dav%';

--	Use GROUP BY and COUNT() to find doctors with the most patients.
SELECT 
  d.FirstName,
  d.LastName,
  d.Specialty,
  COUNT(DISTINCT a.PatientID) AS TotalPatients
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID
ORDER BY TotalPatients DESC;

--	Add CHECK constraint for valid appointment dates.

--	Use UPDATE to reschedule and DELETE for cancellations.
UPDATE Appointments
SET AppointmentDate = '2025-07-12'
WHERE AppointmentID = 1;

DELETE FROM Appointments
WHERE AppointmentID = 4;
