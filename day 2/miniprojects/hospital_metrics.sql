CREATE DATABASE hospital_metricsDB;
USE hospital_metricsDB;

CREATE TABLE departments (
    department_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE doctors (
    doctor_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    department_id INTEGER,
    FOREIGN KEY(department_id) REFERENCES departments(department_id)
);

CREATE TABLE patients (
    patient_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE appointments (
    appointment_id INTEGER PRIMARY KEY,
    doctor_id INTEGER,
    patient_id INTEGER,
    appointment_date DATE,
    FOREIGN KEY(doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY(patient_id) REFERENCES patients(patient_id)
);

-- Departments
INSERT INTO departments (department_id, name) VALUES
(1, 'Cardiology'),
(2, 'Neurology'),
(3, 'Orthopedics');


INSERT INTO doctors (doctor_id, name, department_id) 
VALUES
(1, 'Dr. Smith', 1),
(2, 'Dr. Jones', 2),
(3, 'Dr. Patel', 1),
(4, 'Dr. Lee', 3);


INSERT INTO patients (patient_id, name) 
VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'Diana');


INSERT INTO appointments (appointment_id, doctor_id, patient_id, appointment_date)
 VALUES
(1, 1, 1, '2025-07-01'),
(2, 1, 2, '2025-07-02'),
(3, 2, 3, '2025-07-02'),
(4, 1, 3, '2025-07-03'),
(5, 3, 4, '2025-07-04'),
(6, 4, 2, '2025-07-05');

-- Count patients per department and per doctor.
SELECT 
    d.name AS department_name,
    COUNT(DISTINCT a.patient_id) AS patient_count
FROM 
    departments d
JOIN doctors doc ON d.department_id = doc.department_id
JOIN appointments a ON doc.doctor_id = a.doctor_id
GROUP BY 
    d.department_id;


SELECT 
    doc.name AS doctor_name,
    COUNT(DISTINCT a.patient_id) AS patient_count
FROM 
    doctors doc
JOIN appointments a ON doc.doctor_id = a.doctor_id
GROUP BY 
    doc.doctor_id;

-- Find doctors with the most appointments.
SELECT 
    doc.name AS doctor_name,
    COUNT(a.appointment_id) AS total_appointments
FROM 
    doctors doc
JOIN appointments a ON doc.doctor_id = a.doctor_id
GROUP BY 
    doc.doctor_id
ORDER BY 
    total_appointments DESC
LIMIT 1;
WITH appointment_counts AS (
    SELECT 
        doctor_id,
        COUNT(*) AS total_appointments
    FROM appointments
    GROUP BY doctor_id
),
max_appointments AS (
    SELECT MAX(total_appointments) AS max_appt FROM appointment_counts
)
SELECT d.name, ac.total_appointments
FROM appointment_counts ac
JOIN max_appointments m ON ac.total_appointments = m.max_appt
JOIN doctors d ON d.doctor_id = ac.doctor_id;

-- List departments where patient count exceeds 100.

SELECT 
    d.name AS department_name,
    COUNT(DISTINCT a.patient_id) AS patient_count
FROM 
    departments d
JOIN doctors doc ON d.department_id = doc.department_id
JOIN appointments a ON doc.doctor_id = a.doctor_id
GROUP BY 
    d.department_id
HAVING 
    COUNT(DISTINCT a.patient_id) > 100;

