CREATE DATABASE customer_churn_analysis;
use customer_churn_analysis;

CREATE TABLE customer_churn (
    Customer_ID INT AUTO_INCREMENT PRIMARY KEY,
    Date VARCHAR(20),
    Branch VARCHAR(100),
    Product_Type VARCHAR(100),
    Channel VARCHAR(100),
    Customer_Segment VARCHAR(100),
    New_Accounts INT,
    Closures INT,
    Transactions INT,
    Revenue DECIMAL(15,2),
    Avg_Balance DECIMAL(15,2),
    Customer_Complaints INT,
    Cost_per_Account DECIMAL(15,2),
    Total_Cost DECIMAL(15,2),
    NPA_Percentage DECIMAL(5,2),
    Churn_Rate DECIMAL(5,2)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bank_data.csv'
INTO TABLE customer_churn
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
Date,
Branch,
Product_Type,
Channel,
Customer_Segment,
New_Accounts,
Closures,
Transactions,
Revenue,
Avg_Balance,
Customer_Complaints,
Cost_per_Account,
Total_Cost,
NPA_Percentage,
Churn_Rate
);
select * from customer_churn;

-- =====================================================
-- 1. BRANCH DIMENSION TABLE
-- =====================================================
CREATE TABLE Branch_Dim (
    Branch_ID INT AUTO_INCREMENT PRIMARY KEY,
    Branch VARCHAR(100)
    );

-- =====================================================
-- 2. PRODUCT DIMENSION TABLE
-- =====================================================
CREATE TABLE Product_Dim (
    Product_ID INT AUTO_INCREMENT PRIMARY KEY,
    Product_Type VARCHAR(100)
    );

-- =====================================================
-- 3. CHANNEL DIMENSION TABLE
-- =====================================================
CREATE TABLE Channel_Dim (
    Channel_ID INT AUTO_INCREMENT PRIMARY KEY,
    Channel VARCHAR(100)
    );

-- =====================================================
-- 4. CUSTOMER SEGMENT DIMENSION TABLE
-- =====================================================
CREATE TABLE Customer_Segment_Dim (
    Segment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_Segment VARCHAR(100)
    );

-- =====================================================
-- 5. DATE DIMENSION TABLE
-- =====================================================
CREATE TABLE Date_Dim (
    Date_ID INT AUTO_INCREMENT PRIMARY KEY,
    Transaction_Date VARCHAR(20)
    );

-- =====================================================
-- 6. ACCOUNT ACTIVITY TABLE
-- =====================================================
CREATE TABLE Account_Activity (
    Activity_ID INT AUTO_INCREMENT PRIMARY KEY,
    New_Accounts INT,
    Closures INT
);

-- =====================================================
-- 7. TRANSACTION FACT TABLE
-- =====================================================
CREATE TABLE Transaction_Fact (
    Transaction_ID INT AUTO_INCREMENT PRIMARY KEY,
    Transactions INT
);

-- =====================================================
-- 8. REVENUE FACT TABLE
-- =====================================================
CREATE TABLE Revenue_Fact (
    Revenue_ID INT AUTO_INCREMENT PRIMARY KEY,
    Revenue DECIMAL(15,2)
);

-- =====================================================
-- 9. BALANCE FACT TABLE
-- =====================================================
CREATE TABLE Balance_Fact (
    Balance_ID INT AUTO_INCREMENT PRIMARY KEY,
    Avg_Balance DECIMAL(15,2)
);

-- =====================================================
-- 10. COMPLAINT FACT TABLE
-- =====================================================
CREATE TABLE Complaint_Fact (
    Complaint_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_Complaints INT
);

-- =====================================================
-- 11. COST FACT TABLE
-- =====================================================
CREATE TABLE Cost_Fact (
    Cost_ID INT AUTO_INCREMENT PRIMARY KEY,
    Cost_per_Account DECIMAL(15,2)
);

-- =====================================================
-- 12. TOTAL COST FACT TABLE
-- =====================================================
CREATE TABLE Total_Cost_Fact (
    Total_Cost_ID INT AUTO_INCREMENT PRIMARY KEY,
    Total_Cost DECIMAL(15,2)
);

-- =====================================================
-- 13. NPA FACT TABLE
-- =====================================================
CREATE TABLE NPA_Fact (
    NPA_ID INT AUTO_INCREMENT PRIMARY KEY,
    NPA_Percentage DECIMAL(5,2)
);

-- =====================================================
-- 14. CHURN FACT TABLE
-- =====================================================
CREATE TABLE Churn_Fact (
    Churn_ID INT AUTO_INCREMENT PRIMARY KEY,
    Churn_Rate DECIMAL(5,2)
);

-- =====================================================
-- 15. INACTIVE CUSTOMERS TABLE
-- =====================================================
CREATE TABLE Inactive_Customers (
    Inactive_ID INT AUTO_INCREMENT PRIMARY KEY,
    Branch VARCHAR(100),
    Customer_Segment VARCHAR(100),
    Closures INT
);

-- =====================================================
-- 16. HIGH CHURN CUSTOMERS TABLE
-- =====================================================
CREATE TABLE High_Churn_Customers (
    High_Churn_ID INT AUTO_INCREMENT PRIMARY KEY,
    Branch VARCHAR(100),
    Churn_Rate DECIMAL(5,2)
);

-- =====================================================
-- 17. BRANCH PERFORMANCE TABLE
-- =====================================================
CREATE TABLE Branch_Performance (
    Performance_ID INT AUTO_INCREMENT PRIMARY KEY,
    Branch VARCHAR(100),
    Revenue DECIMAL(15,2)
);

-- =====================================================
-- 18. PRODUCT PERFORMANCE TABLE
-- =====================================================
CREATE TABLE Product_Performance (
    Product_Performance_ID INT AUTO_INCREMENT PRIMARY KEY,
    Product_Type VARCHAR(100),
    Revenue DECIMAL(15,2)
);

-- =====================================================
-- 19. SEGMENT ANALYSIS TABLE
-- =====================================================
CREATE TABLE Segment_Analysis (
    Analysis_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_Segment VARCHAR(100),
    Churn_Rate DECIMAL(5,2)
);

-- =====================================================
-- 20. CUSTOMER CHURN MASTER TABLE
-- =====================================================
CREATE TABLE Customer_Churn_Master (
    Customer_ID INT AUTO_INCREMENT PRIMARY KEY,
    Date VARCHAR(20),
    Branch VARCHAR(100),
    Product_Type VARCHAR(100),
    Channel VARCHAR(100),
    Customer_Segment VARCHAR(100),
    New_Accounts INT,
    Closures INT,
    Transactions INT,
    Revenue DECIMAL(15,2),
    Avg_Balance DECIMAL(15,2),
    Customer_Complaints INT,
    Cost_per_Account DECIMAL(15,2),
    Total_Cost DECIMAL(15,2),
    NPA_Percentage DECIMAL(5,2),
    Churn_Rate DECIMAL(5,2)
);
SHOW TABLES;

-- =====================================================
-- Analyze Inactive Customers Using SQL Reports & Segmentation
-- =====================================================

-- 1. Total Customer Records
SELECT COUNT(*) AS Total_Records
FROM customer_churn;

-- 2. Total Revenue Generated
SELECT SUM(Revenue) AS Total_Revenue
FROM customer_churn;

-- 3. Overall Average Churn Rate
SELECT AVG(Churn_Rate) AS Avg_Churn_Rate
FROM customer_churn;

-- 4. Total New Accounts Opened
SELECT SUM(New_Accounts) AS Total_New_Accounts
FROM customer_churn;

-- 5. Total Accounts Closed
SELECT SUM(Closures) AS Total_Closures
FROM customer_churn;

-- 6. Net Customer Growth
SELECT SUM(New_Accounts)-SUM(Closures) AS Net_Growth
FROM customer_churn;

-- 7. Total Customer Complaints
SELECT SUM(Customer_Complaints) AS Total_Complaints
FROM customer_churn;

-- 8. Average Customer Balance
SELECT AVG(Avg_Balance) AS Average_Balance
FROM customer_churn;

-- 9. Branch-wise Churn Analysis
SELECT Branch, AVG(Churn_Rate) AS Avg_Churn
FROM customer_churn
GROUP BY Branch
ORDER BY Avg_Churn DESC;

-- 10. Top 10 High Churn Branches
SELECT Branch, AVG(Churn_Rate) AS Avg_Churn
FROM customer_churn
GROUP BY Branch
ORDER BY Avg_Churn DESC
LIMIT 10;

-- 11. Customer Segment-wise Churn
SELECT Customer_Segment, AVG(Churn_Rate) AS Avg_Churn
FROM customer_churn
GROUP BY Customer_Segment
ORDER BY Avg_Churn DESC;

-- 12. Product-wise Churn
SELECT Product_Type, AVG(Churn_Rate) AS Avg_Churn
FROM customer_churn
GROUP BY Product_Type
ORDER BY Avg_Churn DESC;

-- 13. Channel-wise Churn
SELECT Channel, AVG(Churn_Rate) AS Avg_Churn
FROM customer_churn
GROUP BY Channel
ORDER BY Avg_Churn DESC;

-- 14. Branches with Most Closures
SELECT Branch, SUM(Closures) AS Total_Closures
FROM customer_churn
GROUP BY Branch
ORDER BY Total_Closures DESC;

-- 15. Segments with Most Closures
SELECT Customer_Segment, SUM(Closures) AS Total_Closures
FROM customer_churn
GROUP BY Customer_Segment
ORDER BY Total_Closures DESC;

-- 16. Complaint Analysis by Branch
SELECT Branch, SUM(Customer_Complaints) AS Complaints
FROM customer_churn
GROUP BY Branch
ORDER BY Complaints DESC;

-- 17. Complaint Impact on Churn
SELECT Branch, AVG(Customer_Complaints) AS Avg_Complaints, 
AVG(Churn_Rate) AS Avg_Churn
FROM customer_churn
GROUP BY Branch
ORDER BY Avg_Churn DESC;

-- 18. Balance vs Churn Analysis
SELECT Customer_Segment, AVG(Avg_Balance) AS Avg_Balance,
AVG(Churn_Rate) AS Avg_Churn
FROM customer_churn
GROUP BY Customer_Segment;

-- 19. Revenue vs Churn by Branch
SELECT Branch, SUM(Revenue) AS Revenue,
AVG(Churn_Rate) AS Avg_Churn
FROM customer_churn
GROUP BY Branch;

-- 20. New Accounts vs Closures
SELECT Branch, SUM(New_Accounts) AS New_Accounts,
SUM(Closures) AS Closures
FROM customer_churn
GROUP BY Branch;

-- 21. Revenue by Product Type
SELECT Product_Type, SUM(Revenue) AS Revenue
FROM customer_churn
GROUP BY Product_Type
ORDER BY Revenue DESC;

-- 22. Revenue by Customer Segment
SELECT Customer_Segment, SUM(Revenue) AS Revenue
FROM customer_churn
GROUP BY Customer_Segment
ORDER BY Revenue DESC;

-- 23. Branches Above Average Churn
SELECT Branch, AVG(Churn_Rate) AS Avg_Churn
FROM customer_churn
GROUP BY Branch
HAVING AVG(Churn_Rate) >
(SELECT AVG(Churn_Rate)
FROM customer_churn);

-- 24. Products Above Average Churn
SELECT Product_Type, AVG(Churn_Rate) AS Avg_Churn
FROM customer_churn
GROUP BY Product_Type
HAVING AVG(Churn_Rate) >
(SELECT AVG(Churn_Rate)
FROM customer_churn);

-- 25. Churn Classification
SELECT Branch, Churn_Rate,
CASE
WHEN Churn_Rate >= 15 THEN 'High Churn'
WHEN Churn_Rate >= 8 THEN 'Medium Churn'
ELSE 'Low Churn'
END AS Churn_Category
FROM customer_churn;

-- 26. Revenue Ranking
SELECT Branch, SUM(Revenue) AS Revenue,
RANK() OVER(ORDER BY SUM(Revenue) DESC) AS Revenue_Rank
FROM customer_churn
GROUP BY Branch;

-- 27. Churn Ranking
SELECT Branch, AVG(Churn_Rate) AS Avg_Churn,
DENSE_RANK() OVER(ORDER BY AVG(Churn_Rate) DESC) AS Churn_Rank
FROM customer_churn
GROUP BY Branch;

-- 28. Branch Revenue Performance
SELECT r.Branch, r.Total_Revenue, c.Avg_Churn
FROM
(SELECT Branch,
           SUM(Revenue) AS Total_Revenue
    FROM customer_churn
    GROUP BY Branch) r
INNER JOIN
(SELECT Branch,
           AVG(Churn_Rate) AS Avg_Churn
    FROM customer_churn
    GROUP BY Branch) c
ON r.Branch = c.Branch
ORDER BY c.Avg_Churn DESC;

-- 29. Customer Segment Revenue vs Churn
SELECT r.Customer_Segment, r.Total_Revenue, c.Avg_Churn
FROM
(SELECT Customer_Segment, SUM(Revenue) AS Total_Revenue
    FROM customer_churn
    GROUP BY Customer_Segment) r
INNER JOIN
(SELECT Customer_Segment, AVG(Churn_Rate) AS Avg_Churn
    FROM customer_churn
    GROUP BY Customer_Segment) c
ON r.Customer_Segment = c.Customer_Segment
ORDER BY c.Avg_Churn DESC;


-- 30. Product Performance vs Churn
SELECT r.Product_Type, r.Total_Revenue, c.Avg_Churn
FROM
(SELECT Product_Type, SUM(Revenue) AS Total_Revenue
    FROM customer_churn
    GROUP BY Product_Type) r
INNER JOIN
(SELECT Product_Type, AVG(Churn_Rate) AS Avg_Churn
    FROM customer_churn
    GROUP BY Product_Type) c
ON r.Product_Type = c.Product_Type
ORDER BY c.Avg_Churn DESC;

-- 31. Complaint Impact on Churn
SELECT cp.Branch, cp.Total_Complaints, ch.Avg_Churn
FROM
(SELECT Branch, SUM(Customer_Complaints) AS Total_Complaints
    FROM customer_churn
    GROUP BY Branch) cp
INNER JOIN
(SELECT Branch, AVG(Churn_Rate) AS Avg_Churn
    FROM customer_churn
    GROUP BY Branch) ch
ON cp.Branch = ch.Branch
ORDER BY ch.Avg_Churn DESC;

-- 32. Closures vs Churn Analysis
SELECT cl.Branch, cl.Total_Closures, ch.Avg_Churn
FROM
(SELECT Branch, SUM(Closures) AS Total_Closures
    FROM customer_churn
    GROUP BY Branch) cl
INNER JOIN
(SELECT Branch, AVG(Churn_Rate) AS Avg_Churn
    FROM customer_churn
    GROUP BY Branch) ch
ON cl.Branch = ch.Branch
ORDER BY ch.Avg_Churn DESC;

-- 33. Create Churn Summary View
CREATE OR REPLACE VIEW Churn_Summary AS
SELECT Branch, 
AVG(Churn_Rate) AS Avg_Churn,
SUM(Revenue) AS Revenue,
SUM(Closures) AS Closures
FROM customer_churn
GROUP BY Branch;

-- 34. Display Churn Summary View
SELECT *
FROM Churn_Summary
ORDER BY Avg_Churn DESC;

-- 35. Executive Dashboard Report

SELECT Branch,
SUM(Revenue) AS Total_Revenue,
AVG(Churn_Rate) AS Avg_Churn,
SUM(Closures) AS Total_Closures,
SUM(Customer_Complaints) AS Total_Complaints,
AVG(Avg_Balance) AS Avg_Balance,
SUM(New_Accounts) AS New_Accounts,
SUM(New_Accounts) - SUM(Closures) AS Net_Growth
FROM customer_churn
GROUP BY Branch
ORDER BY Avg_Churn DESC;