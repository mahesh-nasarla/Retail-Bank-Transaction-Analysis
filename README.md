Retail Banking Transaction Analysis

MySQL | SQL Business Analytics

Project Overview
Banks work with data from customers, accounts, branches, transactions, loans, repayments, and cards. Looking at these records separately does not always explain how customers use banking services or where the bank should focus its attention.

In this project, I used MySQL to organize and analyze retail banking data. I created relational tables based on the database ER diagram, explored the data with SQL, and answered business questions about customer segments, account and branch activity, transaction patterns, loan repayments, and card usage. The goal was to turn raw banking records into findings that could support practical business decisions.
Business Objectives
- Understand customer segments, demographics, income, credit scores, activity, and KYC status.
- Compare account types, balances, interest rates, and branch activity.
- Identify common transaction types and channels, and examine transaction activity over time.
- Review loan types, outstanding balances, repayment amounts, delays, and penalties.
- Understand card types, active status, networks, reward points, and customers using multiple banking products.
  
Dataset Overview:
The project dataset contains the following records:
Table	Rows	What it contains
customers	500	Customer details, segment, income, credit score, KYC status, and activity status
accounts	700	Account type, customer and branch links, balance, interest rate, dates, and status
branches	40	Branch names, locations, region, opening date, and employee count
loans	300	Loan type, principal amount, interest rate, tenure, outstanding balance, status, and purpose
loan_payments	2,000	Scheduled and paid amounts, principal and interest paid, penalties, days late, and payment method
cards	600	Card type, linked account, credit limit, outstanding balance, reward points, status, and network
transactions	5,000	Transaction date and time, type, amount, channel, description, status, and balance after transaction


Database Design and Relationships
I used the ER diagram to structure the data into seven related tables, with primary keys identifying records and foreign keys connecting related entities.
- customers → accounts
- branches → accounts
- customers → loans
- branches → loans
- loans → loan_payments
- accounts → cards
- accounts → transactions
These relationships make it possible to analyze customer, branch, account, transaction, loan, repayment, and card information together rather than treating each table as a separate dataset.

Project Workflow:
1. Business and Data Understanding
I reviewed the business requirements and ER diagram first. Before writing analysis queries, I mapped each business question to the tables and columns needed and considered how the tables were related.
2. Database Setup and Data Preparation
- Created the MySQL database and tables based on the ER diagram.
- Defined primary keys and foreign-key relationships.
- Imported the provided CSV data and checked the tables.
- Converted date fields from text to DATE where appropriate and handled blank account close dates as NULL.
3. Basic SQL Exploration
I used basic queries to inspect the database, including customer and account counts, account and transaction types, customer activity, loan and card types, transaction amounts, and outstanding loan balances.
4. Objective-Based Analysis
I developed business questions and SQL queries across five areas:

Customer Profile and Segmentation
- Compared customer counts by segment, city, and state.
- Examined income and credit-score differences across segments.
- Reviewed active status, KYC status, and customer tenure.
Account Usage and Branch Activity
- Compared account counts and balances by account type.
- Identified branches with more accounts, higher total balances, and higher average balances.
- Compared interest rates and account statuses.
- Identified customers holding more than one account.
Transaction Patterns
- Compared transaction types and channels.
- Examined average transaction amounts and common descriptions.
- Identified months and accounts with higher transaction counts.
- Explored transaction activity and account balance changes.
Loan Performance and Repayment Behaviour
- Compared total loan amounts by loan type and average loan amounts by purpose.
- Reviewed outstanding balances and loan status counts.
- Identified loans with late payments and compared penalties, repayment amounts, and payment methods.
Card Usage and Product Engagement
- Compared card types, networks, active status, outstanding balances, and reward points.
- Identified customers using multiple banking products.
- Examined customers who had both cards and loans linked to their banking relationship.
SQL Skills Used
- Database and table creation (CREATE DATABASE, CREATE TABLE)
- Primary keys, foreign keys, and column constraints
- Data type changes and handling blank date values
- Filtering and selection (SELECT, WHERE)
- Joining related tables (JOIN)
- Grouped analysis (GROUP BY, HAVING)
- Aggregations such as COUNT, SUM, AVG, MIN, and MAX
- Sorting and ranking results (ORDER BY, LIMIT)
- Subqueries and date calculations
Key Findings
The following findings are from the results included in the project presentation:
- Customer segments: The Student segment was the largest, with 100 customers.
- Branch activity: Pittsburgh Branch had the highest account count, with 28 accounts.
- Account balances: IRA accounts had the highest total balance, reported as 2,894,008.04 in the analysis.
- Card usage: Debit cards were the most common card type, with 374 cards.
- Transaction channels: Online banking was the most-used channel, with 1,470 transactions.
- Loan repayment: 241 distinct loans had at least one payment recorded as late.
Business Recommendations
- Customer engagement: Offer products that suit different customer segments. For students, test digital banking options and low-fee accounts; offer loan products only where customers meet eligibility requirements.
- Branch performance: Review the practices and customer needs at Pittsburgh Branch to identify ideas that may be useful at other branches.
- Account products: Use the high total balance in IRA accounts to inform service and engagement plans for customers using long-term savings products.
- Digital banking: Continue improving online banking convenience, reliability, and security because it is the most-used channel in the analyzed data.
- Card engagement: Consider offering suitable credit-card options to eligible debit-card customers.
- Loan repayments: Monitor late payments and penalties, and consider timely reminders and early follow-up for customers showing repayment delays.
Project Files
- Sql(Analysis).sql — database table definitions, data type adjustments, basic exploration, and objective-based SQL queries.
- Retail_bank_transaction_analysis(PPT).pptx — project presentation with selected queries, results, findings, and recommendations.
Conclusion:
This project gave me practical experience moving from a business requirement to a SQL-based analysis: understanding a data model, creating related tables, preparing data types, writing queries, comparing results, and translating findings into business recommendations. It brought customer, account, branch, transaction, loan, repayment, and card data together to support a broader view of retail banking activity.
