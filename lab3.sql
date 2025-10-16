drop database bank;
CREATE DATABASE IF NOT EXISTS BankDB;
USE BankDB;

CREATE TABLE Branch (
    branch_name VARCHAR(50) PRIMARY KEY,
    branch_city VARCHAR(50),
    assets DECIMAL(15,2)
);

CREATE TABLE BankAccount (
    accno INT PRIMARY KEY,
    branch_name VARCHAR(50),
    balance DECIMAL(15,2),
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

CREATE TABLE BankCustomer (
    customer_name VARCHAR(50) PRIMARY KEY,
    customer_street VARCHAR(100),
    customer_city VARCHAR(50)
);

CREATE TABLE Depositer (
    customer_name VARCHAR(50),
    accno INT,
    FOREIGN KEY (customer_name) REFERENCES BankCustomer(customer_name),
    FOREIGN KEY (accno) REFERENCES BankAccount(accno)
);

CREATE TABLE Loan (
    loan_number INT PRIMARY KEY,
    branch_name VARCHAR(50),
    amount DECIMAL(15,2),
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

INSERT INTO Branch VALUES
('SBI_ResidencyRoad', 'Bangalore', 5000000),
('SBI_Jayanagar', 'Bangalore', 3000000),
('HDFC_Delhi', 'Delhi', 4000000),
('ICICI_Bangalore', 'Bangalore', 3500000),
('PNB_Delhi', 'Delhi', 2500000);

INSERT INTO BankAccount VALUES
(1, 'SBI_ResidencyRoad', 25000),
(2, 'SBI_ResidencyRoad', 40000),
(3, 'SBI_Jayanagar', 30000),
(4, 'HDFC_Delhi', 50000),
(5, 'ICICI_Bangalore', 20000),
(6, 'PNB_Delhi', 45000),
(7, 'SBI_ResidencyRoad', 35000),
(8, 'SBI_ResidencyRoad', 15000),
(9, 'ICICI_Bangalore', 28000),
(10, 'SBI_ResidencyRoad', 60000);

INSERT INTO BankCustomer VALUES
('Avinash', 'Bull_Temple_Road', 'Bangalore'),
('Dinesh', 'Bannergatta_Road', 'Bangalore'),
('Mohan', 'NationalCollege_Road', 'Bangalore'),
('Nikil', 'Akbar_Road', 'Delhi'),
('Ravi', 'Prithviraj_Road', 'Delhi');

INSERT INTO Depositer VALUES
('Avinash', 8),
('Dinesh', 2),
('Dinesh', 10),
('Mohan', 3),
('Ravi', 6),
('Nikil', 4),
('Avinash', 1),
('Ravi', 5),
('Dinesh', 7),
('Mohan', 9);

INSERT INTO Loan VALUES
(101, 'SBI_ResidencyRoad', 200000),
(102, 'SBI_Jayanagar', 150000),
(103, 'HDFC_Delhi', 300000),
(104, 'ICICI_Bangalore', 250000),
(105, 'PNB_Delhi', 100000);


SELECT
    branch_name,
    (assets / 100000) AS "assets_in_lakhs"
FROM Branch;

SELECT d.customer_name, COUNT(*) AS num_accounts
FROM Depositer d
JOIN BankAccount b ON d.accno = b.accno
WHERE b.branch_name = 'SBI_ResidencyRoad'
GROUP BY d.customer_name
HAVING COUNT(*) >= 2;


DROP VIEW IF EXISTS BranchLoanSummary;

CREATE VIEW BranchLoanSummary AS
SELECT branch_name, SUM(amount) AS total_loan_amount
FROM Loan
GROUP BY branch_name;


SELECT * FROM BranchLoanSummary;

SELECT
    d.customer_name,
    COUNT(d.accno) AS total_accounts
FROM Depositer d
JOIN BankAccount a ON d.accno = a.accno
WHERE a.branch_name = 'SBI_ResidencyRoad'
GROUP BY d.customer_name
HAVING COUNT(d.accno) >= 2;