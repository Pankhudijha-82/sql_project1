-- Data cleaning

select * from retail_sales
where transactions_id is null or	
sale_date is null or	
sale_time	is null or
customer_id is null or
gender	is null or
age	is null or
category	is null or
quantiy	is null or
price_per_unit	is null or
cogs	is null or
total_sale is null ;


-- Data exploration

-- How many sales we have?
select count(*) as total_sales  from retail_sales;

-- How many unique customers we have?
select count(distinct customer_id) from retail_sales;

-- How many categories we have?
select count(distinct category) from retail_sales;


-- Data exploration

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
select * from retail_sales
where sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.
select * from retail_sales
where category='Clothing' 
and To_Char(sale_date,'YYYY-MM')= '2022-11'
and quantiy >= 4;

-- Write a SQL query to calculate the total sales (total_sale) for each category.
select sum (total_sale) as total_sales, category from retail_sales
group by category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select avg (age) as avg_age from retail_sales
where category = 'Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale>1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender, category, count (transactions_id) from retail_sales
group by category, gender
order by category;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
select 
       year,
       month,
    avg_sale
from
(    
select
    extract(year from sale_date) as year,
    extract(month from sale_date) as month,
    avg(total_sale) as avg_sale,
    rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by year, month
) as t1
where rank = 1;

--Write a SQL query to find the top 5 customers based on the highest total sales.
select customer_id, sum(total_sale) as highest_total_sales from retail_sales
group by customer_id 
order by highest_total_sales desc
limit 5;

--Write a SQL query to find the number of unique customers who purchased items from each category.
select count(distinct customer_id)as unique_customer_id, category from retail_sales
group by category;

-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17). 
with hourly_sales
as
( 
select *,
case
 when extract(hour from sale_time)<12 then'morning'
 when extract(hour from sale_time)between 12 and 17 then 'afternoon'
else 'evening'
end as shift
from retail_sales
)
select shift, count(*)as number_of_orders
from hourly_sales
group by shift;

-- End of project
