CREATE DATABASE Warehouse_Management;
USE Warehouse_Management;

CREATE TABLE warehouse1_electronics (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    stock_quantity INT
);

CREATE TABLE warehouse1_furniture (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    stock_quantity INT
);

CREATE TABLE warehouse2_electronics (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    stock_quantity INT
);

CREATE TABLE warehouse2_furniture (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    stock_quantity INT
);

INSERT INTO warehouse1_electronics 
VALUES
(1, 'Smartphone', 50),
(2, 'Laptop', 30);

INSERT INTO warehouse1_furniture 
VALUES
(3, 'Office Chair', 20),
(4, 'Desk', 15);

INSERT INTO warehouse2_electronics 
VALUES
(1, 'Smartphone', 40),
(5, 'Tablet', 25);

INSERT INTO warehouse2_furniture 
VALUES
(3, 'Office Chair', 10),
(6, 'Bookshelf', 5);

--	Merge items using UNION from different category tables.
SELECT item_id, item_name, stock_quantity FROM warehouse1_electronics
UNION
SELECT item_id, item_name, stock_quantity FROM warehouse1_furniture;

--	Use subquery to find average stock.
SELECT AVG(stock_quantity) AS avg_stock FROM (
    SELECT stock_quantity FROM warehouse1_electronics
    UNION ALL
    SELECT stock_quantity FROM warehouse1_furniture
) AS all_items;

--	Use CASE to tag stock as High, Moderate, Low.
SELECT 
    item_name,
    stock_quantity,
    CASE
        WHEN stock_quantity > (SELECT AVG(stock_quantity) FROM (
            SELECT stock_quantity FROM warehouse1_electronics
            UNION ALL
            SELECT stock_quantity FROM warehouse1_furniture
        ) AS all_items) THEN 'High'
        WHEN stock_quantity = (SELECT AVG(stock_quantity) FROM (
            SELECT stock_quantity FROM warehouse1_electronics
            UNION ALL
            SELECT stock_quantity FROM warehouse1_furniture
        ) AS all_items) THEN 'Moderate'
        ELSE 'Low'
    END AS stock_level
FROM (
    SELECT item_name, stock_quantity FROM warehouse1_electronics
    UNION
    SELECT item_name, stock_quantity FROM warehouse1_furniture
) AS combined_items;

--	Use EXCEPT to find items available in one warehouse but not in another.
SELECT item_name FROM (
    SELECT item_name FROM warehouse1_electronics
    UNION
    SELECT item_name FROM warehouse1_furniture
) AS warehouse1_items

EXCEPT

SELECT item_name FROM (
    SELECT item_name FROM warehouse2_electronics
    UNION
    SELECT item_name FROM warehouse2_furniture
) AS warehouse2_items;
