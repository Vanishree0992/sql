CREATE DATABASE Library_bookDB;
USE Library_bookDB;

CREATE TABLE Authors (
  author_id INT AUTO_INCREMENT PRIMARY KEY,
  author_name VARCHAR(100) NOT NULL
);

CREATE TABLE Genres (
  genre_id INT AUTO_INCREMENT PRIMARY KEY,
  genre_name VARCHAR(50) NOT NULL
);


CREATE TABLE Books (
  book_id INT AUTO_INCREMENT PRIMARY KEY,
  book_title VARCHAR(200) NOT NULL,
  author_id INT NOT NULL,
  genre_id INT NOT NULL,
  published_year INT,
  FOREIGN KEY (author_id) REFERENCES Authors(author_id),
  FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
);

CREATE TABLE BorrowHistory (
  borrow_id INT AUTO_INCREMENT PRIMARY KEY,
  book_id INT NOT NULL,
  borrower_name VARCHAR(100) NOT NULL,
  borrow_date DATE NOT NULL,
  FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

CREATE INDEX idx_book_title ON Books(book_title);
CREATE INDEX idx_author_name ON Authors(author_name);
CREATE INDEX idx_borrow_date ON BorrowHistory(borrow_date);


INSERT INTO Authors (author_name) VALUES
('J.K. Rowling'),
('George R.R. Martin'),
('J.R.R. Tolkien');


INSERT INTO Genres (genre_name) VALUES
('Fantasy'),
('Adventure'),
('Mystery');


INSERT INTO Books (book_title, author_id, genre_id, published_year) VALUES
('Harry Potter and the Sorcerer''s Stone', 1, 1, 1997),
('Harry Potter and the Chamber of Secrets', 1, 1, 1998),
('A Game of Thrones', 2, 1, 1996),
('A Clash of Kings', 2, 1, 1998),
('The Hobbit', 3, 2, 1937),
('The Lord of the Rings', 3, 2, 1954);


INSERT INTO BorrowHistory (book_id, borrower_name, borrow_date) VALUES
(1, 'Alice', '2025-07-01'),
(1, 'Bob', '2025-07-02'),
(1, 'Carol', '2025-07-03'),
(1, 'David', '2025-07-04'),
(1, 'Eve', '2025-07-05'),
(2, 'Alice', '2025-07-06'),
(2, 'Bob', '2025-07-07'),
(2, 'Carol', '2025-07-08'),
(2, 'David', '2025-07-09'),
(2, 'Eve', '2025-07-10'),
(3, 'Alice', '2025-07-11'),
(3, 'Bob', '2025-07-12'),
(3, 'Carol', '2025-07-13'),
(3, 'David', '2025-07-14'),
(3, 'Eve', '2025-07-15'),
(4, 'Alice', '2025-07-16'),
(4, 'Bob', '2025-07-17'),
(4, 'Carol', '2025-07-18'),
(4, 'David', '2025-07-19'),
(4, 'Eve', '2025-07-20'),
(5, 'Alice', '2025-07-21'),
(5, 'Bob', '2025-07-22'),
(5, 'Carol', '2025-07-23'),
(6, 'David', '2025-07-24'),
(6, 'Eve', '2025-07-25');

EXPLAIN
SELECT 
  b.book_title,
  a.author_name,
  bh.borrower_name,
  bh.borrow_date
FROM BorrowHistory bh
JOIN Books b ON bh.book_id = b.book_id
JOIN Authors a ON b.author_id = a.author_id
WHERE b.book_title = 'Harry Potter and the Sorcerer''s Stone'
ORDER BY bh.borrow_date DESC;

CREATE OR REPLACE VIEW BookBorrowReport AS
SELECT 
  b.book_id,
  b.book_title,
  a.author_name,
  MAX(bh.borrow_date) AS last_borrowed,
  COUNT(bh.borrow_id) AS total_borrows
FROM Books b
JOIN Authors a ON b.author_id = a.author_id
LEFT JOIN BorrowHistory bh ON b.book_id = bh.book_id
GROUP BY b.book_id, b.book_title, a.author_name;


SELECT *
FROM BookBorrowReport
ORDER BY total_borrows DESC
LIMIT 5;