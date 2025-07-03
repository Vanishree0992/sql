CREATE DATABASE patientsDB;
USE patientsDB;

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100),
    birthdate DATE
);


CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100),
    specialty VARCHAR(100)
);


CREATE TABLE visits (
    visit_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    visit_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);


INSERT INTO patients 
VALUES
(1, 'Alice', '1980-05-10'),
(2, 'Bob', '1990-08-22'),
(3, 'Charlie', '1985-12-30'),
(4, 'Diana', '1975-02-15');


INSERT INTO doctors 
VALUES
(1, 'Dr. Smith', 'Cardiology'),
(2, 'Dr. Jones', 'Neurology'),
(3, 'Dr. Lee', 'Pediatrics');


INSERT INTO visits 
VALUES
(1, 1, 1, '2025-06-01'),
(2, 1, 2, '2025-06-10'),
(3, 2, 1, '2025-06-15'),
(4, 3, 1, '2025-06-20');

-- Count visits per doctor and per patient.
SELECT 
    d.doctor_id,
    d.name AS doctor_name,
    COUNT(v.visit_id) AS visit_count
FROM doctors d
LEFT JOIN visits v ON d.doctor_id = v.doctor_id
GROUP BY d.doctor_id, d.name;

-- List patients with only one visit.
SELECT 
    p.patient_id,
    p.name AS patient_name,
    COUNT(v.visit_id) AS visit_count
FROM patients p
LEFT JOIN visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_id, p.name;

-- Show doctors with no patient visits.
SELECT 
    p.patient_id,
    p.name
FROM patients p
JOIN visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_id, p.name
HAVING COUNT(v.visit_id) = 1;
