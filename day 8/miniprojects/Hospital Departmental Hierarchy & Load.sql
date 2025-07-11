CREATE DATABASE hospital;
USE hospital;

CREATE TABLE Departments (
  department_id INT PRIMARY KEY,
  department_name VARCHAR(100),
  parent_department_id INT NULL
);

CREATE TABLE Doctors (
  doctor_id INT PRIMARY KEY,
  doctor_name VARCHAR(100),
  unit_id INT,
  FOREIGN KEY (unit_id) REFERENCES Departments(department_id)
);

CREATE TABLE Patients (
  patient_id INT PRIMARY KEY,
  doctor_id INT,
  FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);


-- Departments (root level)
INSERT INTO Departments VALUES (1, 'Cardiology', NULL);
INSERT INTO Departments VALUES (2, 'Neurology', NULL);

-- Units under Cardiology
INSERT INTO Departments VALUES (3, 'Cardiology ICU', 1);
INSERT INTO Departments VALUES (4, 'Cardiology General Ward', 1);

-- Units under Neurology
INSERT INTO Departments VALUES (5, 'Neuro ICU', 2);
INSERT INTO Departments VALUES (6, 'Neuro General Ward', 2);


INSERT INTO Doctors VALUES (1, 'Dr. Smith', 3); -- Cardiology ICU
INSERT INTO Doctors VALUES (2, 'Dr. Adams', 4); -- Cardiology General
INSERT INTO Doctors VALUES (3, 'Dr. Patel', 5); -- Neuro ICU
INSERT INTO Doctors VALUES (4, 'Dr. Lee', 6);   -- Neuro General


INSERT INTO Patients VALUES (1, 1);
INSERT INTO Patients VALUES (2, 1);
INSERT INTO Patients VALUES (3, 2);
INSERT INTO Patients VALUES (4, 2);
INSERT INTO Patients VALUES (5, 2);
INSERT INTO Patients VALUES (6, 3);
INSERT INTO Patients VALUES (7, 3);
INSERT INTO Patients VALUES (8, 4);


WITH RECURSIVE DeptHierarchy AS (
  -- Root level: Departments
  SELECT
    department_id,
    department_name,
    parent_department_id,
    department_name AS path,
    1 AS level
  FROM Departments
  WHERE parent_department_id IS NULL

  UNION ALL

  -- Units under Departments
  SELECT
    d.department_id,
    d.department_name,
    d.parent_department_id,
    CONCAT(dh.path, ' -> ', d.department_name),
    dh.level + 1
  FROM Departments d
  JOIN DeptHierarchy dh ON d.parent_department_id = dh.department_id
)
SELECT * FROM DeptHierarchy
ORDER BY path;

-- 4️⃣ Add Doctors & Patient Counts
WITH RECURSIVE DeptHierarchy AS (
  SELECT
    department_id,
    department_name,
    parent_department_id,
    department_name AS path,
    1 AS level
  FROM Departments
  WHERE parent_department_id IS NULL

  UNION ALL

  SELECT
    d.department_id,
    d.department_name,
    d.parent_department_id,
    CONCAT(dh.path, ' -> ', d.department_name),
    dh.level + 1
  FROM Departments d
  JOIN DeptHierarchy dh ON d.parent_department_id = dh.department_id
),
DoctorPatientLoad AS (
  SELECT 
    doc.doctor_id,
    doc.doctor_name,
    doc.unit_id,
    COUNT(p.patient_id) AS patient_count
  FROM Doctors doc
  LEFT JOIN Patients p ON p.doctor_id = doc.doctor_id
  GROUP BY doc.doctor_id, doc.doctor_name, doc.unit_id
)
SELECT
  dh.department_id,
  dh.department_name,
  dh.path AS hierarchy_path,
  dh.level,
  doc.doctor_id,
  doc.doctor_name,
  doc.patient_count,
  SUM(doc.patient_count) OVER (PARTITION BY dh.department_id) AS unit_total_patients
FROM DeptHierarchy dh
LEFT JOIN DoctorPatientLoad doc ON dh.department_id = doc.unit_id
ORDER BY dh.path, doc.doctor_name;


-- create View: DepartmentalWorkloadView
CREATE VIEW DepartmentalWorkloadView AS
WITH RECURSIVE DeptHierarchy AS (
  SELECT
    department_id,
    department_name,
    parent_department_id,
    department_name AS path,
    1 AS level
  FROM Departments
  WHERE parent_department_id IS NULL

  UNION ALL

  SELECT
    d.department_id,
    d.department_name,
    d.parent_department_id,
    CONCAT(dh.path, ' -> ', d.department_name),
    dh.level + 1
  FROM Departments d
  JOIN DeptHierarchy dh ON d.parent_department_id = dh.department_id
),
DoctorPatientLoad AS (
  SELECT 
    doc.doctor_id,
    doc.doctor_name,
    doc.unit_id,
    COUNT(p.patient_id) AS patient_count
  FROM Doctors doc
  LEFT JOIN Patients p ON p.doctor_id = doc.doctor_id
  GROUP BY doc.doctor_id, doc.doctor_name, doc.unit_id
)
SELECT
  dh.department_id,
  dh.department_name,
  dh.path AS hierarchy_path,
  dh.level,
  doc.doctor_id,
  doc.doctor_name,
  doc.patient_count,
  SUM(doc.patient_count) OVER (PARTITION BY dh.department_id) AS unit_total_patients
FROM DeptHierarchy dh
LEFT JOIN DoctorPatientLoad doc ON dh.department_id = doc.unit_id;
