create database bank;
use bank;
select * from details;

Select count(*) from details;

ALTER TABLE details
MODIFY id INT,
MODIFY address_state VARCHAR(10),
MODIFY application_type VARCHAR(50),
MODIFY emp_length VARCHAR(20),
MODIFY emp_title VARCHAR(100),
MODIFY grade CHAR(2),
MODIFY home_ownership VARCHAR(20),
MODIFY loan_status VARCHAR(50),
MODIFY member_id INT,
MODIFY purpose VARCHAR(50),
MODIFY sub_grade VARCHAR(5),
MODIFY term VARCHAR(20),
MODIFY verification_status VARCHAR(50),
MODIFY annual_income DECIMAL(15,2),
MODIFY dti DECIMAL(10,2),
MODIFY installment DECIMAL(12,2),
MODIFY int_rate DECIMAL(10,2),
MODIFY loan_amount INT,
MODIFY total_acc INT,
MODIFY total_payment INT;

/* SUMMERY PAGE  */

-- Total Loan Applications

SELECT COUNT(id) AS Total_Loan_Applications
FROM details;

-- MTD Loan Applications

SELECT COUNT(id) AS MTD_Loan_Applications
FROM details
WHERE MONTH(STR_TO_DATE(issue_date,'%d-%m-%Y')) = 12;

-- PMTD Loan Applications

SELECT COUNT(id) AS PMTD_Loan_Applications
FROM details
WHERE MONTH(STR_TO_DATE(issue_date,'%d-%m-%Y')) = 11;

-- Total Funded Amount

SELECT SUM(loan_amount) AS Total_Funded_Amount
FROM details;

-- Total Amount Received

SELECT SUM(total_payment) AS Total_Amount_Received
FROM details;

-- Average Interest Rate

SELECT AVG(int_rate) * 100 AS Avg_Interest_Rate
FROM details;

-- Average DTI

SELECT AVG(dti) *100 AS Avg_DTI
FROM details;

/*GOOD LOANS*/

-- Good Loan %

SELECT
(COUNT(CASE 
WHEN loan_status='Fully Paid' OR loan_status='Current'
THEN id END) * 100.0) / COUNT(id) AS Good_Loan_Percentage
FROM details;

-- Good Loan Applications

SELECT COUNT(id) AS Good_Loan_Applications
FROM details
WHERE loan_status IN ('Fully Paid','Current');

/*BAD LOANS*/

-- Bad Loan %

SELECT
(COUNT(CASE 
WHEN loan_status='Charged Off'
THEN id END) * 100.0) / COUNT(id) AS Bad_Loan_Percentage
FROM details;

-- Loan Status Analysis

SELECT
loan_status,
COUNT(id) AS Loan_Count,
SUM(total_payment) AS Total_Amount_Received,
SUM(loan_amount) AS Total_Funded_Amount,
AVG(int_rate*100) AS Interest_Rate,
AVG(dti*100) AS DTI
FROM details
GROUP BY loan_status;

-- Month Wise Loan Analysis

SELECT
MONTH(STR_TO_DATE(issue_date,'%d-%m-%Y')) AS Month_Number,
MONTHNAME(STR_TO_DATE(issue_date,'%d-%m-%Y')) AS Month_Name,
COUNT(id) AS Total_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Amount_Received
FROM details
GROUP BY Month_Number,Month_Name
ORDER BY Month_Number;

-- State Wise Analysis

SELECT
address_state AS State,
COUNT(id) AS Total_Loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Amount_Received
FROM details
GROUP BY address_state
ORDER BY address_state;

-- Term Analysis

SELECT
term,
COUNT(id) AS Total_Loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Amount_Received
FROM details
GROUP BY term;

-- Purpose Analysis

SELECT
purpose,
COUNT(id) AS Total_Loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Amount_Received
FROM details
GROUP BY purpose;

-- Home Ownership Analysis

SELECT
home_ownership,
COUNT(id) AS Total_Loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Amount_Received
FROM details
GROUP BY home_ownership;

-- Top 10 States by Loan Amount

SELECT 
address_state,
SUM(loan_amount) AS Total_Loan_Amount
FROM details
GROUP BY address_state
ORDER BY Total_Loan_Amount DESC
LIMIT 10;

-- Loan Status Distribution

SELECT 
loan_status,
COUNT(id) AS Loan_Count
FROM details
GROUP BY loan_status;

-- Income vs Loan Amount

SELECT 
AVG(annual_income) AS Avg_Income,
AVG(loan_amount) AS Avg_Loan
FROM details;

-- Default Rate by Grade

SELECT 
grade,
COUNT(id) AS Total_Loans,
SUM(CASE WHEN loan_status='Charged Off' THEN 1 ELSE 0 END) AS Defaults,
(SUM(CASE WHEN loan_status='Charged Off' THEN 1 ELSE 0 END)*100.0)/COUNT(id) AS Default_Rate
FROM details
GROUP BY grade
ORDER BY Default_Rate DESC;
