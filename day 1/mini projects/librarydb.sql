CREATE DATABASE LibraryDB;
USE LibraryDB;

-- 2️⃣ Create Authors Table
CREATE TABLE Authors (
  AuthorID INT AUTO_INCREMENT PRIMARY KEY,
  Name VARCHAR(100)
);

-- 3️⃣ Create Books Table
USE LibraryDB;
CREATE TABLE Books (
  BookID INT AUTO_INCREMENT PRIMARY KEY,
  Title VARCHAR(200),
  AuthorID INT,
  PublishedYear INT,
  Available BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- 4️⃣ Create Members Table
USE LibraryDB;
CREATE TABLE Members (
  MemberID INT AUTO_INCREMENT PRIMARY KEY,
  Name VARCHAR(100),
  JoinDate DATE
);

-- 5️⃣ Create Loans Table
USE LibraryDB;
CREATE TABLE Loans (
  LoanID INT AUTO_INCREMENT PRIMARY KEY,
  BookID INT,
  MemberID INT,
  LoanDate DATE,
  DueDate DATE,
  ReturnDate DATE,
  FOREIGN KEY (BookID) REFERENCES Books(BookID),
  FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

-- 6️⃣ Insert Authors
INSERT INTO Authors (Name) VALUES ('J.K. Rowling');
INSERT INTO Authors (Name) VALUES ('George Orwell');
INSERT INTO Authors (Name) VALUES ('Jane Austen');

-- 7️⃣ Insert Books
INSERT INTO Books (Title, AuthorID, PublishedYear)
 VALUES 
('Harry Potter and the Sorcerer''s Stone', 1, 1997),
('1984', 2, 1949),
('Animal Farm', 2, 1945),
('Pride and Prejudice', 3, 1813),
('Emma', 3, 1815);

-- 8️⃣ Insert Members
INSERT INTO Members (Name, JoinDate) 
VALUES 
('Alice', '2023-01-15'),
('Bob', '2023-02-20'),
('Charlie', '2023-03-10');

-- 9️⃣ Insert Loans
INSERT INTO Loans (BookID, MemberID, LoanDate, DueDate, ReturnDate) VALUES
(1, 1, '2023-06-01', '2023-06-15', NULL), -- Currently loaned
(2, 2, '2023-05-15', '2023-05-30', NULL), -- Overdue
(3, 1, '2023-05-01', '2023-05-15', '2023-05-10'), -- Returned
(4, 3, '2023-06-05', '2023-06-20', NULL); -- Currently loaned

-- ✅ Verify Data
SELECT * FROM Authors;
SELECT * FROM Books;
SELECT * FROM Members;
SELECT * FROM Loans;

-- 🔍 Query: Books currently loaned out
SELECT 
  Books.Title, Members.Name AS Borrower, Loans.LoanDate, Loans.DueDate
FROM 
  Loans
  JOIN Books ON Loans.BookID = Books.BookID
  JOIN Members ON Loans.MemberID = Members.MemberID
WHERE 
  Loans.ReturnDate IS NULL;

-- 🔍 Query: Overdue books
SELECT 
  Books.Title, Members.Name AS Borrower, Loans.DueDate
FROM 
  Loans
  JOIN Books ON Loans.BookID = Books.BookID
  JOIN Members ON Loans.MemberID = Members.MemberID
WHERE 
  Loans.ReturnDate IS NULL AND Loans.DueDate < CURDATE();

-- 🔍 Query: Members with the most loans
SELECT 
  Members.Name, COUNT(Loans.LoanID) AS TotalLoans
FROM 
  Members
  JOIN Loans ON Members.MemberID = Loans.MemberID
GROUP BY 
  Members.MemberID
ORDER BY 
  TotalLoans DESC;