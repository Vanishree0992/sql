CREATE DATABASE Hospital_patientDB;
USE Hospital_patientDB;

CREATE TABLE Patients (
  patient_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_name VARCHAR(100) NOT NULL,
  date_of_birth DATE,
  gender ENUM('M','F','O')
);

CREATE TABLE Doctors (
  doctor_id INT AUTO_INCREMENT PRIMARY KEY,
  doctor_name VARCHAR(100) NOT NULL,
  specialization VARCHAR(100)
);

CREATE TABLE Visits (
  visit_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  doctor_id INT NOT NULL,
  visit_date DATE NOT NULL,
  notes TEXT,
  FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
  FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Diagnoses (
  diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,
  visit_id INT NOT NULL,
  diagnosis_text VARCHAR(255) NOT NULL,
  FOREIGN KEY (visit_id) REFERENCES Visits(visit_id)
);

CREATE INDEX idx_patient_name ON Patients(patient_name);
CREATE INDEX idx_doctor_id ON Visits(doctor_id);
CREATE INDEX idx_visit_date ON Visits(visit_date);


INSERT INTO Doctors (doctor_name, specialization) VALUES
('Dr. Alice Smith', 'Cardiology'),
('Dr. Bob Johnson', 'Dermatology'),
('Dr. Carol White', 'Pediatrics');


INSERT INTO Patients (patient_name, date_of_birth, gender) VALUES
('John Doe', '1980-05-15', 'M'),
('Mary Jane', '1992-08-20', 'F'),
('David Lee', '1975-03-10', 'M'),
('Sophia Brown', '2000-12-25', 'F'),
('Chris Green', '1988-07-07', 'M');


INSERT INTO Visits (patient_id, doctor_id, visit_date, notes) VALUES
(1, 1, '2025-07-01', 'Routine checkup'),
(1, 1, '2025-07-15', 'Follow-up visit'),
(1, 2, '2025-07-20', 'Skin rash'),
(2, 2, '2025-07-02', 'Skin allergy'),
(2, 2, '2025-07-16', 'Dermatitis treatment'),
(3, 1, '2025-07-03', 'Chest pain'),
(3, 1, '2025-07-17', 'ECG follow-up'),
(4, 3, '2025-07-04', 'Flu symptoms'),
(4, 3, '2025-07-18', 'Immunization'),
(5, 1, '2025-07-05', 'Hypertension'),
(5, 1, '2025-07-19', 'Blood pressure check'),
(1, 1, '2025-07-21', 'Stress test'),
(1, 1, '2025-07-22', 'Heart monitor'),
(2, 2, '2025-07-21', 'Acne treatment'),
(2, 2, '2025-07-22', 'Dermatitis review'),
(3, 1, '2025-07-21', 'Cardiac stress test'),
(3, 1, '2025-07-22', 'Echo follow-up'),
(4, 3, '2025-07-21', 'Pediatric check'),
(4, 3, '2025-07-22', 'Vaccination'),
(5, 1, '2025-07-21', 'Cardio follow-up'),
(5, 1, '2025-07-22', 'BP monitoring'),
(1, 1, '2025-07-23', 'Cardio rehab'),
(2, 2, '2025-07-23', 'Skin biopsy'),
(3, 1, '2025-07-23', 'Heart MRI'),
(4, 3, '2025-07-23', 'Pediatric wellness');


INSERT INTO Diagnoses (visit_id, diagnosis_text) VALUES
(1, 'Normal'),
(2, 'Stable'),
(3, 'Eczema'),
(4, 'Skin allergy'),
(5, 'Contact dermatitis'),
(6, 'Possible angina'),
(7, 'Normal ECG'),
(8, 'Flu'),
(9, 'Immunization'),
(10, 'Hypertension'),
(11, 'BP check'),
(12, 'Stress test normal'),
(13, 'Heart rhythm normal'),
(14, 'Acne mild'),
(15, 'Dermatitis improving'),
(16, 'Stress test abnormal'),
(17, 'Echo clear'),
(18, 'Routine check'),
(19, 'Vaccination done'),
(20, 'Normal BP'),
(21, 'BP stable'),
(22, 'Rehab scheduled'),
(23, 'Skin biopsy done'),
(24, 'MRI pending'),
(25, 'Wellness normal');

EXPLAIN
SELECT 
  p.patient_name,
  v.visit_date,
  d.doctor_name,
  dg.diagnosis_text
FROM Visits v
JOIN Patients p ON v.patient_id = p.patient_id
JOIN Doctors d ON v.doctor_id = d.doctor_id
JOIN Diagnoses dg ON v.visit_id = dg.visit_id
WHERE p.patient_name = 'John Doe'
ORDER BY v.visit_date DESC;


CREATE OR REPLACE VIEW DoctorVisitReport AS
SELECT
  d.doctor_id,
  d.doctor_name,
  d.specialization,
  p.patient_name,
  v.visit_date,
  dg.diagnosis_text
FROM Visits v
JOIN Doctors d ON v.doctor_id = d.doctor_id
JOIN Patients p ON v.patient_id = p.patient_id
JOIN Diagnoses dg ON v.visit_id = dg.visit_id
ORDER BY d.doctor_id, v.visit_date DESC;

SELECT *
FROM DoctorVisitReport
ORDER BY visit_date DESC
LIMIT 10;