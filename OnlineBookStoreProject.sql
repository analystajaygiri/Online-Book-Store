-- Create DB
CREATE DATABASE onlinebookstore;
use onlinebookstore;
-- Create Books Table
CREATE TABLE books(
	Book_ID	SERIAL	PRIMARY KEY	,
	Title	VARCHAR(100),	
	Author	VARCHAR(100),	
	Genre	VARCHAR(100),	
	Published_Year	INT,	
	Price	NUMERIC(10,2),	
	Stock	INT
);

-- Insert Data Into Books Table
COPY
books(Book_ID,Title,Author,Genre,Published_Year,Price,Stock)
FROM 'C:\Program Files\PostgreSQL\17\bin\books.csv'
DELIMITER ','
CSV HEADER;

-- Fetch Data From Books Table
SELECT * FROM books;

-- Create Customer Table
CREATE TABLE customer(
	Customer_ID	SERIAL	PRIMARY KEY,
	Name	VARCHAR(100),
	Email	VARCHAR(100),
	Phone	VARCHAR(13),
	City	VARCHAR(70),
	Country	VARCHAR(100)
);
-- Insert Data Into Customer Table
COPY
customer(Customer_ID,Name,Email,Phone,City,Country)
FROM 'C:\Program Files\PostgreSQL\17\bin\customers.csv'
DELIMITER ','
CSV HEADER;

-- Fetch Data From Customers Table
SELECT * FROM customer;

-- Create Orders Table
CREATE TABLE orders(
	Order_ID SERIAL	PRIMARY KEY,
	Customer_ID	INT	REFERENCES customer(Customer_ID),	
	Book_ID	INT	REFERENCES books(Book_ID),	
	Order_Date DATE,
	Quantity INT,	
	Total_Amount NUMERIC(10,2)		
);

-- Insert Data Into Orders Table
COPY
orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
FROM 'C:\Program Files\PostgreSQL\17\bin\orders.csv'
DELIMITER ','
CSV HEADER;

-- Fetch Data From Orders Table
SELECT * FROM orders;


-- Q.1 Retrive all book in a 'fiction' genre.
SELECT title, genre FROM books WHERE genre = 'Fiction';

-- Q.2 Find book published after the year 1950.
SELECT * FROM books WHERE Published_Year>'1950';

-- Q.3 List all customers from canada.
SELECT * FROM customer WHERE Country = 'Canada';

-- Q.4 Show orders placed in Nov 2023.
SELECT * FROM orders where Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- Q.5 Retrive the total stock of books available.
SELECT SUM(stock) AS Total_Stock FROM books;

-- Q.6 Find the details of most expensive book.
SELECT * FROM books ORDER BY price DESC LIMIT 1;

-- Q.7 Show all customers who ordered more than 1 quantity of book.
SELECT * FROM orders WHERE quantity>1;

-- Q.8 Retrive all orders where the total amount exceeds $20.
SELECT * FROM orders WHERE total_amount>'20.00';

-- Q.9 List all genres available in books table.
SELECT DISTINCT genre FROM books;

-- Q.10 Find the book with lowest stock
SELECT * FROM books ORDER BY stock;

-- Q.11 Calculate the total revenue generated from all orders.
SELECT SUM(total_amount) AS total_revenue from orders;



-- Q.12 Retrive the total number of books sold for each genre
SELECT b.genre, SUM(o.quantity) AS Total_Book_Sold FROM orders o JOIN books b ON o.book_id = b.book_id
GROUP BY b.genre;

-- Q.13 Find the average price of books in the fantasy genre
SELECT AVG(price) AS Avg_Price FROM books WHERE genre = 'Fantasy';

-- Q.14 List customers who have placed at least 2 orders
SELECT customer_id, COUNT(order_id) AS Order_Count FROM orders GROUP BY customer_id HAVING COUNT(order_id) >=2;

-- Q.15 Find the most frequently ordered book
SELECT book_id, COUNT(order_id) AS Order_Count FROM orders GROUP BY book_id ORDER BY Order_Count DESC LIMIT 1;

-- Q.16 Show the top 3 most expensive books of 'Fantasy' Genre
SELECT book_id,title,genre,price FROM books WHERE genre='Fantasy' ORDER BY price DESC LIMIT 3;

-- Q.17 Retrieve the total quantity of books sold by each author
SELECT b.author, SUM(o.quantity) FROM orders o JOIN books b ON o.book_id = b.book_id GROUP BY b.author;

-- Q.18 List the cities where customers who spent over $30 are located
SELECT DISTINCT c.city, total_amount FROM orders o JOIN customer c ON o.customer_id = c.customer_id
WHERE total_amount > 30;

-- Q.19 Find the customer who spent the most on orders
SELECT c.customer_id,c.name, SUM(o.total_amount) AS total_spent FROM orders o JOIN customer c
ON o.customer_id = c.customer_id GROUP BY c.customer_id, c.name ORDER BY total_spent DESC LIMIT 1;

-- Q.20 Calculate the stock remaining after fulfilling all orders
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;
