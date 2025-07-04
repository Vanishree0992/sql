CREATE DATABASE Supply_Chain;
USE Supply_Chain;

CREATE TABLE suppliers_q1 (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100),
    avg_delivery_days INT
);

CREATE TABLE suppliers_q2 (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100),
    avg_delivery_days INT
);

INSERT INTO suppliers_q1 VALUES
(1, 'Alpha Logistics', 5),
(2, 'Beta Transport', 7),
(3, 'Gamma Supply Co.', 6),
(4, 'Delta Express', 4);

INSERT INTO suppliers_q2 VALUES
(1, 'Alpha Logistics', 6),
(2, 'Beta Transport', 7),
(3, 'Gamma Supply Co.', 5),
(5, 'Epsilon Movers', 8);

--	Use INTERSECT to find suppliers present in both Q1 and Q2.
SELECT supplier_id, supplier_name FROM suppliers_q1
INTERSECT
SELECT supplier_id, supplier_name FROM suppliers_q2;

--	Use EXCEPT to find suppliers missing in Q2.
SELECT supplier_id, supplier_name FROM suppliers_q1
EXCEPT
SELECT supplier_id, supplier_name FROM suppliers_q2;

--	Use subquery to compare average delivery time.
SELECT 
    s2.supplier_id,
    s2.supplier_name,
    s1.avg_delivery_days AS q1_delivery,
    s2.avg_delivery_days AS q2_delivery,
    CASE
        WHEN s2.avg_delivery_days < s1.avg_delivery_days THEN 'Improved'
        WHEN s2.avg_delivery_days = s1.avg_delivery_days THEN 'Consistent'
        ELSE 'Worsened'
    END AS delivery_status
FROM suppliers_q1 s1
JOIN suppliers_q2 s2 ON s1.supplier_id = s2.supplier_id;


--	Tag supplier status using CASE
SELECT 
    s2.supplier_id,
    s2.supplier_name,
    CASE
        WHEN s2.avg_delivery_days < s1.avg_delivery_days THEN 'Improved'
        WHEN s2.avg_delivery_days = s1.avg_delivery_days THEN 'Consistent'
        ELSE 'Worsened'
    END AS supplier_status
FROM suppliers_q1 s1
JOIN suppliers_q2 s2 ON s1.supplier_id = s2.supplier_id;
