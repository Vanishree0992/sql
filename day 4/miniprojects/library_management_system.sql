CREATE DATABASE Library_DB;
USE Library_DB;


CREATE TABLE Books (
  book_id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  author VARCHAR(100) NOT NULL,
  is_available BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE Members (
  member_id INT PRIMARY KEY AUTO_INCREMENT,
  member_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE BorrowRecords (
  borrow_id INT PRIMARY KEY AUTO_INCREMENT,
  book_id INT NOT NULL,
  member_id INT NOT NULL,
  borrow_date DATE NOT NULL,
  return_date DATE NOT NULL,
  FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
  FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
  CHECK (borrow_date <= return_date)
);

INSERT INTO Books (title, author)
VALUES
  ('The Great Gatsby', 'F. Scott Fitzgerald'),
  ('1984', 'George Orwell'),
  ('To Kill a Mockingbird', 'Harper Lee');
  
INSERT INTO Members (member_name, email)
VALUES
  ('Alice Green', 'alice.green@example.com'),
  ('Bob White', 'bob.white@example.com');
  
  UPDATE Books
SET is_available = FALSE
WHERE book_id = 1;

UPDATE Books
SET is_available = TRUE
WHERE book_id = 1;

--	Delete outdated borrow records.
DELETE FROM BorrowRecords
WHERE borrow_id = 3;

--	Use transactions for borrowing multiple books at once.
  START TRANSACTION;

INSERT INTO BorrowRecords (book_id, member_id, borrow_date, return_date)
VALUES (1, 1, '2025-07-05', '2025-07-20');

UPDATE Books
SET is_available = FALSE
WHERE book_id = 1;

INSERT INTO BorrowRecords (book_id, member_id, borrow_date, return_date)
VALUES (2, 1, '2025-07-05', '2025-07-18');

UPDATE Books
SET is_available = FALSE
WHERE book_id = 2;

COMMIT;