-- Create the database
CREATE DATABASE ClinicDB;

-- Use the database
USE ClinicDB;

-- creating tables
CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100)
);

CREATE TABLE Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Specialty VARCHAR(100)
);

CREATE TABLE Appointments (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE,
    Status VARCHAR(20), 
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- inserting datas
INSERT INTO Patients (Name, Email) 
VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com'),
('David', 'david@example.com');

INSERT INTO Doctors (Name, Specialty) 
VALUES
('Dr. Smith', 'Cardiology'),
('Dr. Jones', 'Dermatology'),
('Dr. Lee', 'Pediatrics');


INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Status) 
VALUES
(1, 1, '2025-07-01', 'Completed'),
(2, 1, '2025-07-02', 'Completed'),
(3, 1, '2025-07-03', 'Missed'),
(4, 1, '2025-07-04', 'Scheduled'),
(1, 2, '2025-07-01', 'Completed'),
(2, 2, '2025-07-02', 'Missed'),
(3, 2, '2025-07-03', 'Completed'),
(1, 3, '2025-07-04', 'Completed'),
(2, 3, '2025-07-05', 'Scheduled');

-- Find doctors with most appointments in a week.
SELECT 
    d.DoctorID,
    d.Name AS DoctorName,
    COUNT(a.AppointmentID) AS TotalAppointments
FROM 
    Appointments a
JOIN 
    Doctors d ON a.DoctorID = d.DoctorID
WHERE 
    a.AppointmentDate BETWEEN '2025-07-01' AND '2025-07-07'
GROUP BY 
    d.DoctorID, d.Name
ORDER BY 
    TotalAppointments DESC;

-- List patients with missed appointments.
SELECT 
    p.PatientID,
    p.Name AS PatientName,
    COUNT(a.AppointmentID) AS MissedAppointments
FROM 
    Appointments a
JOIN 
    Patients p ON a.PatientID = p.PatientID
WHERE 
    a.Status = 'Missed'
GROUP BY 
    p.PatientID, p.Name;
