-- Create the database
CREATE DATABASE HospitalDB;
-- Use the database
USE HospitalDB;

-- Tables: Patients, Doctors, Appointments.
CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    DOB DATE,
    ContactNumber VARCHAR(20)
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
    Reason VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Insert appointments for different doctors and patients.
INSERT INTO Patients (Name, DOB, ContactNumber) 
VALUES 
('Alice', '1990-05-15', '1234567890'),
('Bob', '1985-09-10', '9876543210'),
('Charlie', '2000-12-20', '5556667777'),
('David', '1975-07-30', '4445556666'),
('Eva', '1995-11-25', '3334445555');

INSERT INTO Doctors (Name, Specialty) 
VALUES 
('Dr. Smith', 'Cardiology'),
('Dr. Johnson', 'Dermatology'),
('Dr. Williams', 'Neurology');

INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Reason) 
VALUES 
(1, 1, '2025-07-01', 'Heart Checkup'),
(2, 2, '2025-07-02', 'Skin Rash'),
(3, 3, '2025-07-03', 'Headache'),
(4, 1, '2025-07-04', 'Follow-up'),
(1, 1, '2025-07-10', 'Routine Checkup'),
(2, 2, '2025-07-11', 'Follow-up');


-- List appointments for a doctor within a date range.
SELECT 
    a.AppointmentID,
    p.Name AS PatientName,
    d.Name AS DoctorName,
    a.AppointmentDate,
    a.Reason
FROM 
    Appointments a
JOIN 
    Patients p ON a.PatientID = p.PatientID
JOIN 
    Doctors d ON a.DoctorID = d.DoctorID
WHERE 
    d.Name = 'Dr. Smith'
    AND a.AppointmentDate BETWEEN '2025-07-01' AND '2025-07-10'
ORDER BY 
    a.AppointmentDate;

--  Find patients without assigned doctors.
SELECT 
    p.PatientID,
    p.Name
FROM 
    Patients p
LEFT JOIN 
    Appointments a ON p.PatientID = a.PatientID
WHERE 
    a.DoctorID IS NULL;
