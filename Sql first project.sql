use ck;

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

Select count(transactions_id) from retail_sales;
Select count(distinct customer_id) from retail_sales;
Select count(distinct category) from retail_sales;

select * from retail_sales
where sale_date is null or sale_time is null or transactions_id is null 
or category is null or customer_id is null  or total_sale is null or
cogs is null or price_per_unit is null or gender is null or age is null or quantity is null;

Delete  from retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    
    
-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:

Select * from retail_sales
where sale_date ='2022-11-05';

/*Write a SQL query to retrieve all transactions where the category is 'Clothing' 
and the quantity sold is more than 4 in the month of Nov-2022:*/

SELECT 
Extract(year from sale_Date) as year,
Extract(month from sale_Date) as month
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity > 10
  AND DATE(sale_date) BETWEEN '2022-11-01' AND '2022-11-30';

-- Write a SQL query to calculate the total sales (total_sale) for each category.

Select sum(total_sale),category from retail_Sales
group by category;

/*Q.4 Write a SQL query to find the average age of
 customers who purchased items from the 'Beauty' category.*/
 
 Select round(avg(age),2),customer_id from retail_sales
 where category ='Beauty'
 group by customer_id;
 
  -- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
  
  select *
  from retail_sales
  where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select count(transactions_id),gender,category from retail_sales
group by gender,category;

#questions asked in interview
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

Select avgsale,years,months
From(
Select avg(total_sale) as avgsale,
Extract(year from sale_Date) as years,
Extract(month from sale_Date) as months,
Rank() over(partition by Extract(year from sale_Date)  order by avg(total_sale) desc) as rn
from retail_sales
group by 2,3) as t1
where rn =1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

Select sum(total_sale),customer_id 
from retail_sales
group by customer_id
order by sum(total_sale) desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select count(distinct customer_id),category
from retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders
-- (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sales
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sales
GROUP BY shift;
