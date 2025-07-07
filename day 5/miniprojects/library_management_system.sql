CREATE DATABASE Library_borrowerDB;
USE Library_borrowerDB;

CREATE TABLE Books (
  BookID INT PRIMARY KEY AUTO_INCREMENT,
  Title VARCHAR(255) NOT NULL,
  Author VARCHAR(100),
  IsAvailable BOOLEAN DEFAULT TRUE
);

CREATE TABLE Members (
  MemberID INT PRIMARY KEY AUTO_INCREMENT,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE BorrowRecords (
  BorrowID INT PRIMARY KEY AUTO_INCREMENT,
  BookID INT NOT NULL,
  MemberID INT NOT NULL,
  BorrowDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ReturnDate DATE DEFAULT NULL,
  FOREIGN KEY (BookID) REFERENCES Books(BookID),
  FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

INSERT INTO Books (Title, Author)
VALUES
('The Great Gatsby', 'F. Scott Fitzgerald'),
('1984', 'George Orwell'),
('To Kill a Mockingbird', 'Harper Lee');


INSERT INTO Members (FirstName, LastName, Email)
VALUES
('Alice', 'Johnson', 'alice@example.com'),
('Bob', 'Smith', 'bob@example.com'),
('Carol', 'White', 'carol@example.com');

--	Use BETWEEN to filter borrow dates in a specific range.
SELECT 
  br.BorrowID, 
  b.Title,
  m.FirstName, m.LastName,
  br.BorrowDate
FROM BorrowRecords br
JOIN Books b ON br.BookID = b.BookID
JOIN Members m ON br.MemberID = m.MemberID
WHERE br.BorrowDate BETWEEN '2025-07-01' AND '2025-07-07';

--	Use IS NULL to find overdue books (no return date).
SELECT 
  br.BorrowID,
  b.Title,
  m.FirstName, m.LastName,
  br.BorrowDate
FROM BorrowRecords br
JOIN Books b ON br.BookID = b.BookID
JOIN Members m ON br.MemberID = m.MemberID
WHERE br.ReturnDate IS NULL;

--	Use transactions to record borrowing and rollback if the book is unavailable.

START TRANSACTION;

SELECT IsAvailable FROM Books WHERE BookID = 1;

INSERT INTO BorrowRecords (BookID, MemberID)
VALUES (1, 1);

UPDATE Books
SET IsAvailable = FALSE
WHERE BookID = 1;

COMMIT;

-- ROLLBACK;


