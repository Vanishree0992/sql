CREATE DATABASE library_borrowingDB;
USE library_borrowingDB;

CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL
);

CREATE TABLE members (
    member_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE loans (
    loan_id INTEGER PRIMARY KEY,
    book_id INTEGER,
    member_id INTEGER,
    loan_date DATE,
    FOREIGN KEY(book_id) REFERENCES books(book_id),
    FOREIGN KEY(member_id) REFERENCES members(member_id)
);

INSERT INTO books (book_id, title)
 VALUES
(1, '1984'),
(2, 'Brave New World'),
(3, 'Fahrenheit 451');


INSERT INTO members (member_id, name) 
VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'Diana');


INSERT INTO loans (loan_id, book_id, member_id, loan_date)
 VALUES
(1, 1, 1, '2025-07-01'),
(2, 2, 1, '2025-07-03'),
(3, 1, 2, '2025-07-04'),
(4, 3, 2, '2025-07-05'),
(5, 1, 3, '2025-07-06');

-- Count total loans per book and per member.
SELECT 
    b.title AS book_title,
    COUNT(l.loan_id) AS total_loans
FROM 
    books b
LEFT JOIN loans l ON b.book_id = l.book_id
GROUP BY 
    b.book_id;

SELECT 
    m.name AS member_name,
    COUNT(l.loan_id) AS total_loans
FROM 
    members m
LEFT JOIN loans l ON m.member_id = l.member_id
GROUP BY 
    m.member_id;

-- Identify books borrowed more than N times.
SELECT 
    b.title AS book_title,
    COUNT(l.loan_id) AS total_loans
FROM 
    books b
JOIN loans l ON b.book_id = l.book_id
GROUP BY 
    b.book_id
HAVING 
    COUNT(l.loan_id) > 2;

-- List members who have never borrowed a book.
SELECT 
    m.name AS member_name
FROM 
    members m
LEFT JOIN loans l ON m.member_id = l.member_id
WHERE 
    l.loan_id IS NULL;

