CREATE DATABASE Product_catDB;
USE Product_catDB;

CREATE TABLE ProductCategories (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(100),
  parent_id INT,
  FOREIGN KEY (parent_id) REFERENCES ProductCategories(category_id)
);


INSERT INTO ProductCategories VALUES (1, 'Electronics', NULL);
INSERT INTO ProductCategories VALUES (2, 'Clothing', NULL);

INSERT INTO ProductCategories VALUES (3, 'Phones', 1);
INSERT INTO ProductCategories VALUES (4, 'Laptops', 1);
INSERT INTO ProductCategories VALUES (5, 'Smartphones', 3);
INSERT INTO ProductCategories VALUES (6, 'Feature Phones', 3);

INSERT INTO ProductCategories VALUES (7, 'Men', 2);
INSERT INTO ProductCategories VALUES (8, 'Women', 2);


-- Use recursive CTE to build hierarchy with level and path
WITH RECURSIVE CategoryHierarchy AS (
  SELECT
    category_id,
    category_name,
    parent_id,
    1 AS level,
    CAST(category_name AS CHAR(255)) AS path
  FROM ProductCategories
  WHERE parent_id IS NULL

  UNION ALL

  SELECT
    pc.category_id,
    pc.category_name,
    pc.parent_id,
    ch.level + 1,
    CONCAT(ch.path, ' → ', pc.category_name)
  FROM ProductCategories pc
  JOIN CategoryHierarchy ch ON pc.parent_id = ch.category_id
)
SELECT
  category_id,
  category_name,
  parent_id,
  level,
  path
FROM CategoryHierarchy
ORDER BY path;


-- 
CREATE VIEW ProductCategoryTreeView AS
WITH RECURSIVE CategoryHierarchy AS (
  SELECT
    category_id,
    category_name,
    parent_id,
    1 AS level,
    CAST(category_name AS CHAR(255)) AS path
  FROM ProductCategories
  WHERE parent_id IS NULL

  UNION ALL

  SELECT
    pc.category_id,
    pc.category_name,
    pc.parent_id,
    ch.level + 1,
    CONCAT(ch.path, ' → ', pc.category_name)
  FROM ProductCategories pc
  JOIN CategoryHierarchy ch ON pc.parent_id = ch.category_id
)
SELECT
  category_id,
  category_name,
  parent_id,
  level,
  path
FROM CategoryHierarchy;

SELECT * FROM ProductCategoryTreeView;
