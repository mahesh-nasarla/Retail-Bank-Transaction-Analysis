show databases;
use retail_banking_transaction_analysis;
show tables;
CREATE DATABASE retail_banking_analysis;

USE retail_banking_analysis;
CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth VARCHAR (20) NOT NULL,
    gender VARCHAR(20),
    city VARCHAR(100),
    state VARCHAR(50),
    customer_since VARCHAR(20) NOT NULL,
    kyc_status VARCHAR(30),
    segment VARCHAR(50),
    annual_income DECIMAL(15,2),
    credit_score INT,
    is_active VARCHAR(10)
);

CREATE TABLE branches (
    branch_id VARCHAR(20) PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    state VARCHAR(50),
    region VARCHAR(50),
    opening_date VARCHAR(20) NOT NULL,
    employee_count INT
);

CREATE TABLE accounts (
    account_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    branch_id VARCHAR(20) NOT NULL,
    account_type VARCHAR(50),
    open_date VARCHAR (20) NOT NULL,
    close_date VARCHAR(20) NOT NULL,
    current_balance DECIMAL(15,2) DEFAULT 0,
    interest_rate DECIMAL(5,2) DEFAULT 0,
    overdraft_limit DECIMAL(15,2) DEFAULT 0,
    status VARCHAR(30),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)
);

CREATE TABLE loans (
    loan_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    branch_id VARCHAR(20) NOT NULL,
    loan_type VARCHAR(50),
    principal_amount DECIMAL(15,2),
    interest_rate DECIMAL(5,2),
    tenure_months INT,
    disbursement_date VARCHAR(20) NOT NULL,
    maturity_date VARCHAR(20) NOT NULL,
    emi_amount DECIMAL(15,2),
    outstanding_balance DECIMAL(15,2),
    loan_status VARCHAR(50),
    purpose VARCHAR(100),
FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)
);

CREATE TABLE loan_payments (
    payment_id VARCHAR(20) PRIMARY KEY,
    loan_id VARCHAR(20) NOT NULL,
    payment_date VARCHAR (20) NOT NULL,
    scheduled_amount DECIMAL(15,2),
    paid_amount DECIMAL(15,2),
    principal_paid DECIMAL(15,2),
    interest_paid DECIMAL(15,2),
    penalty DECIMAL(15,2) DEFAULT 0,
    days_late INT DEFAULT 0,
    payment_method VARCHAR(50),
    status VARCHAR(50),
FOREIGN KEY (loan_id)
        REFERENCES loans(loan_id)
);

CREATE TABLE cards (
    card_id VARCHAR(20) PRIMARY KEY,
    account_id VARCHAR(20) NOT NULL,
    card_type VARCHAR(30),
    issue_date VARCHAR (20) NOT NULL,
    expiry_date VARCHAR (20) NOT NULL,
    credit_limit DECIMAL(15,2) DEFAULT 0,
    outstanding_balance DECIMAL(15,2) DEFAULT 0,
    reward_points INT DEFAULT 0,
    is_active VARCHAR(10),
    network VARCHAR(30),
FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);

CREATE TABLE transactions (
    transaction_id VARCHAR(20) PRIMARY KEY,
    account_id VARCHAR(20) NOT NULL,
    transaction_date varchar(20),
    transaction_time TIME,
    transaction_type VARCHAR(50),
    amount DECIMAL(15,2),
    channel VARCHAR(50),
    description VARCHAR(100),
    balance_after DECIMAL(15,2),
    status VARCHAR(30),
	FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);
show tables;
select * from customers;

select * from customers;
select * from branches;
select * from loans;
select * from loan_payments;
select * from accounts;
select * from transactions;
select * from cards;

-- modifying varchar() to date
ALTER TABLE customers
MODIFY date_of_birth DATE NOT NULL,
MODIFY customer_since DATE NOT NULL;
desc customers;

ALTER TABLE branches
MODIFY opening_date DATE NOT NULL;

desc branches;

SELECT close_date
FROM accounts
LIMIT 20;
desc accounts;

UPDATE accounts
SET close_date = NULL
WHERE close_date = '';

ALTER TABLE accounts
MODIFY open_date DATE NOT NULL,
MODIFY close_date DATE NULL;
desc accounts;

ALTER TABLE loans
MODIFY disbursement_date DATE NOT NULL,
MODIFY maturity_date DATE NOT NULL;
desc loans;

ALTER TABLE loan_payments
MODIFY payment_date DATE NOT NULL;

desc loan_payments;


ALTER TABLE cards
MODIFY issue_date DATE NOT NULL,
MODIFY expiry_date DATE NOT NULL;
desc cards;


ALTER TABLE transactions
MODIFY transaction_date DATE;
desc transactions;


-- 	SPRINT 3: BASIC ANALYSIS/DATA EXPLORATION
-- 11.	What is the total number of customers?
select count(*)  as  total_customers from customers;

-- 12.	What is the total number of accounts?
select count(*) as total_accounts from accounts;

-- 13.	What are the different account types available?
select  distinct account_type from accounts;
select * from accounts;
-- 14.	How many customers are currently active?
select * from customers;
select count(is_active) as currently_active from customers where is_active='yes';


-- 15.	What are the different transaction types available?
select * from transactions;
select distinct transaction_type from transactions;

-- 16.	What is the total amount of completed transactions?
select sum(amount) as total_amount from transactions;

-- 17.	What are the different loan types available?
select *  from loans;
select distinct loan_type from loans;

-- 
select distinct loan_type from loans;

-- 18.	What is the total number of loans?
select count(*) as total_loans from loans;


-- 19.	What are the different card types available?
select * from cards;
select distinct card_type from cards;

-- 20.	What is the total outstanding loan balance?
select sum(outstanding_balance) as total_loan_balance from loans;


-- SPRINT 4: CUSTOMER PROFILE AND SEGMENTATION
-- Q1. How many customers are in each segment?
select segment ,count(*) as customer_count from customers
group by segment order by customer_count desc;

-- Q2. What is the average income and credit score for each segment?
select * from customers;
select segment , count(*) as customer_count,avg(annual_income) as average_income, avg(credit_score) as average_credit_score from customers group by segment  order by average_income;

-- Q3. Which cities have the most customers?
select city,count(*) as city_count from customers group by city  order by city_count desc ;

-- Q4. How are customers distributed across states?
select state,count(*) as state_count from customers group by state order by state_count desc;

-- Q5.What is the distribution of active and inactive customers across segments?
SELECT
    segment,
    is_active,
    COUNT(*) AS customer_count
FROM customers
GROUP BY segment, is_active
ORDER BY segment, customer_count DESC;
-- Q6 How does KYC status vary across customer segments?
SELECT segment,kyc_status,COUNT(*) AS customer_count FROM customers GROUP BY segment, kyc_status
ORDER BY segment, customer_count DESC;

-- Q7. What is the average customer tenure for each segment?
SELECT segment,ROUND(AVG(TIMESTAMPDIFF(YEAR, customer_since, CURDATE())), 2) AS avg_tenure_years FROM customers GROUP BY segment
ORDER BY avg_tenure_years DESC;

-- Q8. Compare income and credit score across segments
SELECT segment,
    MIN(annual_income) AS min_income,
    ROUND(AVG(annual_income), 2) AS avg_income,
    MAX(annual_income) AS max_income,
    MIN(credit_score) AS min_credit_score,
    ROUND(AVG(credit_score), 2) AS avg_credit_score,
    MAX(credit_score) AS max_credit_score
FROM customers
GROUP BY segment
ORDER BY avg_income DESC;


--  4.2 UNDERSTAND ACCOUNT USAGE AND BRANCH ACTIVITY
-- Q1 — How many accounts are there for each account type?
SELECT
    account_type,
    COUNT(*) AS account_count
FROM accounts
GROUP BY account_type
ORDER BY account_count DESC;
-- Q2 – Average balance by account type

SELECT
    account_type,
    COUNT(*) AS total_accounts,
    ROUND(AVG(current_balance), 2) AS avg_balance,
    MIN(current_balance) AS min_balance,
    MAX(current_balance) AS max_balance
FROM accounts
GROUP BY account_type
ORDER BY avg_balance DESC;

-- Q3 — Which branches have the highest number of accounts?
SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    b.state,
    COUNT(a.account_id) AS account_count
FROM branches b
JOIN accounts a
    ON b.branch_id = a.branch_id
GROUP BY
    b.branch_id,
    b.branch_name,
    b.city,
    b.state
ORDER BY account_count DESC;


-- Q4 — Which branches have the highest total account balance?
SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    b.state,
    COUNT(a.account_id) AS account_count,
    ROUND(SUM(a.current_balance), 2) AS total_balance
FROM branches b
JOIN accounts a
    ON b.branch_id = a.branch_id
GROUP BY
    b.branch_id,
    b.branch_name,
    b.city,
    b.state
ORDER BY total_balance DESC;


-- Q5.Which branches have the highest average account balance?
SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    b.state,
    COUNT(a.account_id) AS account_count,
    ROUND(AVG(a.current_balance), 2) AS avg_balance
FROM branches b
JOIN accounts a
    ON b.branch_id = a.branch_id
GROUP BY
    b.branch_id,
    b.branch_name,
    b.city,
    b.state
ORDER BY avg_balance DESC;


-- Q6 — Interest Rates by Account Type
SELECT
    account_type,
    COUNT(*) AS account_count,
    ROUND(AVG(interest_rate), 2) AS avg_interest_rate,
    MIN(interest_rate) AS min_interest_rate,
    MAX(interest_rate) AS max_interest_rate
FROM accounts
GROUP BY account_type
ORDER BY avg_interest_rate DESC;

-- Q7 — Active vs Closed Accounts

SELECT
    status,
    COUNT(*) AS account_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM accounts),
        2
    ) AS percentage
FROM accounts
GROUP BY status
ORDER BY account_count DESC;


--  Q8 — Which customers have the most accounts?
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(a.account_id) AS account_count
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(a.account_id) > 1
ORDER BY account_count DESC;

-- SPRINT 4.3 TRANSACTION PATTERNS
-- 1.Question: Which transaction type has the highest number of transactions?

SELECT transaction_type, COUNT(*) AS transaction_count
FROM transactions
GROUP BY transaction_type
ORDER BY transaction_count DESC
LIMIT 1;

-- 2.Question: Which transaction channel has the highest number of transactions?
SELECT channel, COUNT(*) AS transaction_count
FROM transactions
GROUP BY channel
ORDER BY transaction_count DESC
LIMIT 1;

-- 3.Transaction Amounts
SELECT AVG(amount) AS average_transaction_amount
FROM transactions;
select * from transactions;

-- 4.Question: Which transaction description occurs most frequently?
SELECT description, COUNT(*) AS description_count
FROM transactions
GROUP BY description
ORDER BY description_count DESC
LIMIT 1;

-- 5.Question: Which month has the highest number of transactions?
SELECT 
    YEAR(transaction_date) AS year,
    MONTH(transaction_date) AS month,
    COUNT(*) AS transaction_count
FROM transactions
GROUP BY YEAR(transaction_date), MONTH(transaction_date)
ORDER BY transaction_count DESC
LIMIT 1;

-- 6.Question: Which account has the highest number of transactions?
SELECT account_id, COUNT(*) AS transaction_count
FROM transactions
GROUP BY account_id
ORDER BY transaction_count DESC
LIMIT 1;

-- 7.Question: Which account has the largest net change in balance due to transactions?
SELECT
    account_id,
    SUM(
        CASE
            WHEN transaction_type = 'Credit' THEN amount
            WHEN transaction_type = 'Debit' THEN amount
            ELSE 0
        END
    ) AS net_balance_change
FROM transactions
GROUP BY account_id
ORDER BY net_balance_change DESC
LIMIT 1;
select distinct transaction_type from transactions;

-- 	Sprint 4.4 — Evaluate Loan Performance and Repayment
-- 1. Compare different loan types Question: Which loan type has the highest total loan amount?
SELECT
    loan_type,
    SUM(principal_amount) AS total_loan_amount
FROM loans
GROUP BY loan_type
ORDER BY total_loan_amount DESC
LIMIT 1;

-- 2. Which loan purpose has the highest average loan amount?
SELECT
    purpose,
    AVG(principal_amount) AS average_loan_amount
FROM loans
GROUP BY purpose
ORDER BY average_loan_amount DESC
LIMIT 1;


-- 3. Which loan has the highest outstanding balance?
SELECT
    loan_id,
    outstanding_balance
FROM loans
ORDER BY outstanding_balance DESC
LIMIT 1;

-- 4. Which loan status has the highest number of loans?
SELECT
    loan_status,
    COUNT(*) AS loan_count
FROM loans
GROUP BY loan_status
ORDER BY loan_count DESC
LIMIT 1;

-- Q-5. Identify loans with repayment delays
SELECT COUNT(DISTINCT loan_id) AS delayed_loans
FROM loan_payments
WHERE days_late > 0;

-- Q.6. Examine penalties and late payments
SELECT
    loan_id,
    SUM(penalty) AS total_penalty
FROM loan_payments
GROUP BY loan_id
ORDER BY total_penalty DESC
LIMIT 1;

-- Q.7. Compare repayment behaviour across loan types

SELECT
    l.loan_type,
    AVG(lp.paid_amount) AS average_repayment
FROM loans l
JOIN loan_payments lp
    ON l.loan_id = lp.loan_id
GROUP BY l.loan_type
ORDER BY average_repayment DESC
LIMIT 1;


-- Q8. Look at payment methods used by customers
SELECT
    payment_method,
    COUNT(*) AS payment_count
FROM loan_payments
GROUP BY payment_method
ORDER BY payment_count DESC
LIMIT 1;
-- Sprint 4.5 — Understand Card Usage and Product

-- Q1.Question: Which card type has the highest number of cards?
SELECT
    card_type,
    COUNT(*) AS card_count
FROM cards
GROUP BY card_type
ORDER BY card_count DESC
LIMIT 1;

-- Q2.2. Examine credit limits and outstanding balances
SELECT
    card_id,
    outstanding_balance
FROM cards
ORDER BY outstanding_balance DESC
LIMIT 1;

-- Q3. Question: How many cards are active and how many are inactive?
SELECT
    is_active,
    COUNT(*) AS card_count
FROM cards
GROUP BY is_active;

-- Q4. Question: Which card has the highest reward points?
SELECT
    card_id,
    reward_points
FROM cards
ORDER BY reward_points DESC
LIMIT 1;


-- Q5.Question: Which card network has the highest number of cards?
SELECT
    network,
    COUNT(*) AS card_count
FROM cards
GROUP BY network
ORDER BY card_count DESC
LIMIT 1;

-- Q6 .Question: Which customers use the highest number of different banking products?
SELECT
    c.customer_id,
    COUNT(DISTINCT a.account_id) AS account_count,
    COUNT(DISTINCT ca.card_id) AS card_count,
    COUNT(DISTINCT l.loan_id) AS loan_count
FROM customers c
LEFT JOIN accounts a
    ON c.customer_id = a.customer_id
LEFT JOIN cards ca
    ON a.account_id = ca.account_id
LEFT JOIN loans l
    ON c.customer_id = l.customer_id
GROUP BY c.customer_id
ORDER BY
    (account_count + card_count + loan_count) DESC
LIMIT 1;


-- Q7.Question: How many customers have both a card and a loan linked to their banking relationship?

SELECT
    COUNT(DISTINCT a.customer_id) AS customers_with_card_and_loan
FROM accounts a
JOIN cards ca
    ON a.account_id = ca.account_id
JOIN loans l
    ON a.customer_id = l.customer_id;
    
    