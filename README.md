Retail Sales Analysis — SQL Project
Project Overview

Project Title: Retail Sales Analysis
Level: Beginner
Database: sql_project1

This project demonstrates practical SQL skills used by data analysts to explore, clean, and analyze retail sales data. It includes database setup, exploratory data analysis (EDA), data cleaning, and business-focused analytical queries.

The project is designed to help build a strong foundation in SQL, covering real-world analytical use cases such as customer behavior analysis, sales performance tracking, and operational insights.

Objectives

Set up and structure a retail sales database
Perform data cleaning and validation
Conduct exploratory data analysis (EDA)
Develop SQL queries to answer business questions
Extract actionable insights to support business decisions

Project Structure
1. Database Setup

Database Creation

CREATE DATABASE p1_retail_db;


Table Creation

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

2. Data Exploration & Cleaning

Record Count

SELECT COUNT(*) FROM retail_sales;


Unique Customer Count

SELECT COUNT(DISTINCT customer_id) FROM retail_sales;


Distinct Categories

SELECT DISTINCT category FROM retail_sales;


Null Value Detection

SELECT *
FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR
    gender IS NULL OR age IS NULL OR category IS NULL OR
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;


Delete Null Records

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR
    gender IS NULL OR age IS NULL OR category IS NULL OR
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

Data Analysis & Business Queries
1. Sales on a Specific Date

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

2. High Quantity Clothing Sales (Nov-2022)

SELECT *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND quantity > 4;

3. Total Sales by Category

SELECT 
    category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

4. Average Age of Beauty Category Customers

SELECT 
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

5. High-Value Transactions (>1000)

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

6. Transactions by Gender & Category

SELECT 
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

7. Best-Selling Month in Each Year

SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY 1, 2
) t
WHERE rank = 1;

8. Top 5 Customers by Total Sales

SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

9. Unique Customers per Category

SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

10. Shift-Wise Order Distribution

WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

Key Findings

Customer Demographics: Sales are distributed across multiple age groups and categories.
High-Value Transactions: Premium purchases exist, indicating opportunities for targeted marketing.
Sales Trends: Monthly patterns reveal peak and low seasons.
Customer Insights: Identified top-spending customers and most engaged categories.
Operational Insights: Afternoon and evening shifts generate higher order volumes.

Reports

Sales Performance Summary
Monthly and Seasonal Trend Analysis
Customer Segmentation Insights
Shift-wise Operational Analysis

Conclusion

This project provides a complete walkthrough of SQL-based data analysis, covering database design, cleaning, exploratory analysis, and business-driven insights. It demonstrates how SQL can be used to convert raw transactional data into meaningful and actionable business intelligence.

How to Use

Clone the repository
Run the database setup SQL script
Load the dataset into the retail_sales table
Execute the analysis queries
Explore results and modify queries for deeper insights

Author
Swapnil Gujar
Data Analyst | SQL | Power BI | Data Engineering

This project is part of my professional portfolio, showcasing practical SQL skills relevant to real-world analytics roles.
