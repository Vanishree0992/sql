CREATE DATABASE movie_store;
USE movie_store;

CREATE TABLE movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(150),
    genre VARCHAR(50),
    release_year INT
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE rentals (
    rental_id INT PRIMARY KEY,
    movie_id INT,
    customer_id INT,
    rental_date DATE,
    due_date DATE,
    return_date DATE,  -- NULL if not returned yet
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


INSERT INTO movies VALUES
(1, 'Inception', 'Sci-Fi', 2010),
(2, 'The Matrix', 'Sci-Fi', 1999),
(3, 'Titanic', 'Romance', 1997),
(4, 'The Godfather', 'Crime', 1972),
(5, 'Interstellar', 'Sci-Fi', 2014);


INSERT INTO customers VALUES
(1, 'Alice', 'alice@example.com'),
(2, 'Bob', 'bob@example.com'),
(3, 'Charlie', 'charlie@example.com');


INSERT INTO rentals VALUES
(1, 1, 1, '2025-06-01', '2025-06-10', '2025-06-09'),
(2, 2, 2, '2025-06-05', '2025-06-12', NULL),  -- overdue if today > 2025-06-12
(3, 1, 3, '2025-06-08', '2025-06-15', NULL),
(4, 3, 1, '2025-05-20', '2025-05-27', '2025-05-26');


-- Find most and least rented movies.
WITH rental_counts AS (
    SELECT 
        m.movie_id,
        m.title,
        COUNT(r.rental_id) AS rentals_count
    FROM movies m
    LEFT JOIN rentals r ON m.movie_id = r.movie_id
    GROUP BY m.movie_id, m.title
)
SELECT * FROM rental_counts
WHERE rentals_count = (SELECT MAX(rentals_count) FROM rental_counts)
   OR rentals_count = (SELECT MIN(rentals_count) FROM rental_counts);

-- List customers with overdue rentals.
SELECT DISTINCT
    c.customer_id,
    c.name,
    c.email,
    r.rental_id,
    r.due_date
FROM customers c
JOIN rentals r ON c.customer_id = r.customer_id
WHERE r.return_date IS NULL
  AND r.due_date < DATE('2025-07-03');

-- Show movies never rented.
SELECT 
    m.movie_id,
    m.title
FROM movies m
LEFT JOIN rentals r ON m.movie_id = r.movie_id
WHERE r.rental_id IS NULL;

