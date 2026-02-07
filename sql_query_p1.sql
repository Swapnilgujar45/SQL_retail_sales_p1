--SQL Retail Sales Analysis - Project1
Create database sql_project2;

SELECT * from retail_sales;

SELECT COUNT(*) from retail_sales;

--check nulls
select * from retail_sales
where
transactions_id is null
or 
sale_date is null
or 
sale_time is null
or 
customer_id is null
or 
gender is null
or 
age is null
or 
category is null
or 
quantiy is null
or 
price_per_unit is null
or 
cogs is null
or 
total_sale is null;

--Data Exploration

--how many sales we have?
select count(*) as total_sale from retail_sales;

--how many unique customers we have?
select count(distinct(customer_id)) as total_customer from retail_sales;

SELECT *
FROM (
    SELECT
        ROW_NUMBER() OVER (ORDER BY customer_id) AS rownum,
		*
    FROM retail_sales
) t
WHERE rownum % 2 = 0;

--Self Join

select r1.customer_id 'customer', r2.customer_id 'category'
from retail_sales r1, retail_sales r2
where r1.customer_id = r2.cateogry

--display 1st and nth rows

select * from (select row_number() over(order by sale_date desc) as rn,
* from retail_sales) order by rn desc
--where rn =1 or rn = (select count(*)-2 from retail_sales);

SELECT *
FROM (
    SELECT
        ROW_NUMBER() OVER (ORDER BY customer_id DESC) AS rn,
        rs.*
    FROM retail_sales rs
)
WHERE rn = 3;

--how many categories have total price below 1000?

select count(*) from
(select category, max(total_sale) as max_price from retail_sales
group by category) as mp
where max_price>1000;
 
--WITH CTE
with mp as(select category, max(total_sale) as max_price from retail_sales
group by category)

select count(*) from mp where max_price <(select avg(max_price) from mp)


update retail_sales set total_sale = 2500 where category = 'Electronics'

--store proceduer
select * from 
retail_sales
where total_sale >2000

DROP PROCEDURE IF EXISTS highest_sale;

CREATE PROCEDURE highest_sale()
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT *
    FROM retail_sales
    WHERE total_sale > 2000;
END;
$$;

CALL highest_sale();


SELECT * FROM highest_sale();

--WINDOW Functions

select *, 
row_number() over(order by total_sale desc) as popularity,
rank() over(order by total_sale desc) as popularity_r,
dense_rank() over(order by total_sale desc) as popularity_dr
from retail_sales;


select *, 
row_number() over(partition by category order by total_sale desc) as popularity
from retail_sales;

select * from
(select *, 
row_number() over(partition by category order by total_sale desc) as popularity
from retail_sales) as pop
where popularity<=3;

--lead and lag

select *, 
lag(total_sale) over(order by total_sale) as previous_sale
from retail_sales;

select *, 
lead(total_sale) over(order by total_sale) as previous_sale
from retail_sales;

--Dates

select sale_date,
extract(day from sale_date)
from retail_sales;

select sale_date,
DATEDIFF(day, sale_date)
from retail_sales;


select distinct total_sale
from retail_sales
order by total_sale desc
limit 1 offset 1;


--creating view

create view "highest sales category" as 
select 
	max(total_sale) as highest_sale
from retail_sales
where category = 'Beauty';


create view highest_sales_category1 as 
select category,
	max(total_sale) as highest_sale
from retail_sales
where category = 'Beauty'
group by category;

--DATA Anlaysis and Businesss Key Problems-Answers

SELECT *
FROM highest_sales_category

Select count(distinct category)
from retail_sales;

-- 1. retrive all column for sales made on '2022-22-05'.

select * from retail_sales
where sale_date = '2022-11-05'

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
--the quantity sold is more than 4 in the month of Nov-2022.

SELECT *
from retail_sales
WHERE
category = 'Clothing' 
	AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND quantiy >= 4;

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category,
SUM(total_sale) AS net_sale,
COUNT(*) as total_orders
FROM retail_sales
Group BY category;

--4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT category,
ROUND(AVG(age),2) as average_age_by_category
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;

-- 5. Write a SQL query to find all transactions where the total sale is greater than 1000.

SELECT *
FROM retail_sales
WHERE total_sale>=1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) 
--made by each gender in each category.

SELECT 
count(*) as total,
category,
gender
FROM retail_sales
GROUP BY category, gender
ORDER BY 2

-- 7. Write a SQL query to calculate the average sale for each month. 
--Find out best selling month in each year.

SELECT 
	year,
	month,
	Average_sale_by_month
FROM
(SELECT
	EXTRACT (YEAR from sale_date) as year,
	EXTRACT (MONTH from sale_date) as month,
	ROUND(AVG(total_sale)) as Average_sale_by_month,
	RANK() OVER(PARTITION BY EXTRACT (YEAR from sale_date) ORDER BY AVG(total_sale) desc)as RNK
from retail_sales
GROUP BY 1, 2) as t1
WHERE RNK =1;

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT 
	customer_id, 
	SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 desc
LIMIT 10;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	COUNT(DISTINCT(customer_id)) as Unique_customers,
	category
FROM retail_sales
GROUP BY 2
ORDER BY 1

-- 10. Write a SQL query to create each shift and number of orders 
--(example: Morning < 12, Afternoon between 12 & 17, Evening > 17).

WITH hourly_sale AS (
    SELECT
        *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales)
SELECT COUNT(*), shift FROM hourly_sale
GROUP BY shift

--End of Project


































