create table people(
					person varchar, region varchar);

select * from people;

create table returns(
					returned varchar, order_id varchar, market varchar);

select * from returns;

create table orders(
				row_id int, order_id varchar, order_date date , ship_date date,	
				ship_mode varchar, customer_id varchar, customer_name varchar, 
				segment varchar, city varchar, state varchar, country  varchar, 
				market varchar, region varchar, product_id varchar, category varchar,
				sub_category varchar, product_name varchar, sales float, quantity int, 
				discount float, profit float, shipping_cost float, order_priority varchar);

select * from returns;

select * from orders as o
join returns as r
on o.order_id = r.order_id
join people as p
on o.region = p.region;


--1a) What are the three countries that generated the highest total profit for Global Superstore in 2014?
select * from orders
	
select country, sum(profit) as total_profit
from orders
where order_date between '2014-1-31' and '2014-12-31'
group by country
order by total_profit desc
limit 3;

--1b) For each of these three countries, find the three products with the highest total profit.
--Specifically, what are the products’ names and the total profit for each product?
create table best_selling_product as (select country, product_name, sum(profit)
from orders
where country in ('United States', 'India', 'China')
group by country, product_name, order_date
having order_date between '2014-1-31' and '2014-12-31')

select country, product_name, sum(sum)as total_profit
from best_selling_product
where country = 'United States'
group by product_name, country
order by total_profit desc
limit 3;

select country, product_name, sum(sum)as total_profit
from best_selling_product
where country = 'India'
group by product_name, country
order by total_profit desc
limit 3;

select country, product_name, sum(sum)as total_profit
from best_selling_product
where country = 'China'
group by product_name, country
order by total_profit desc
limit 3;

--2) Identify the 3 subcategories with the highest average shipping cost in the United States
select sub_category, avg(shipping_cost) as average_ship_cost
from orders
group by sub_category
order by average_ship_cost desc
limit 3;

--3a) Assess Nigeria’s profitability (i.e., total profit) for 2014. How does it compare to other
--African countries?
select country, sum(profit) as total_profit
from orders
where ship_date between '2014-1-31' and '2014-12-31'
group by country, region
having region = 'Africa'
order by total_profit asc
limit 10;

--3b) What factors might be responsible for Nigeria’s poor performance? You might want to
--investigate shipping costs and the average discount as potential root causes.
select country, avg(shipping_cost) as average_ship_cost, avg(discount) as average_discount
from orders
where ship_date between '2014-1-31' and '2014-12-31'
group by country, region
having region = 'Africa'
order by average_discount desc;
/*3B shows that Nigeria is top 6 Africa country with the lowest average shipping cost yet 
top 3 with the most discount. This has affect the profit greatly because they import at a high price 
and still give high discount */

/* 4a)Identify the product subcategory that is the least profitable in Southeast Asia.
Note: For this question, assume that Southeast Asia comprises Cambodia,
Indonesia, Malaysia, Myanmar (Burma), the Philippines, Singapore, Thailand, and
Vietnam. */
select sub_category, sum(profit) as total_profit
from orders
where region = 'Southeast Asia'
group by sub_category, country
order by total_profit asc
limit 1;

--4b)Is there a specific country in Southeast Asia where Global Superstore should stop
--offering the subcategory identified in 4a? */
select sum(profit) as total_profit, country
from orders
where region = 'Southeast Asia' and sub_category = 'Tables'
group by country
order by total_profit asc
limit 1;

/* 5a) Which city is the least profitable (in terms of average profit) in the United States? For
this analysis, discard the cities with less than 10 Orders. */
select city, sum(profit) as total_profit
from orders
where country = 'United States' and quantity >= 10
group by city
order by total_profit asc
limit 1;

--5b) Why is this city’s average profit so low?
select city, avg(sales) as avg_sales, avg(profit) as avg_profit, avg(discount), avg(shipping_cost),
avg(quantity) as avg_quan, count(returned) as returned
from orders as o
join returns as r
on o.order_id = r.order_id
where country = 'United States'
group by city
having avg(profit) >= 41
order by avg(profit) desc;
/*it has a low average sales of 225.98, Concord City has a low average profit of 41.742 because of the high
average shipping cost and high average discount, amongst other economical, and political factors. */

--6) Which product subcategory has the highest average profit in Australia?
select sub_category, avg(profit) as avg_profit
from orders
where country = 'Australia'
group by sub_category
order by avg_profit desc
limit 1;

--7a)  Which customer returned items and what segment do they belong
select customer_name, segment, count(returned) as number_of_returns
from orders as o
join returns as r
on o.order_id = r.order_id
group by customer_name, segment
order by number_of_returns desc;

--7b)  Who are the most valuable customers and what do they purchase?
select customer_name, product_name, round(cast(sum(profit)as numeric),0) as total_profit
from orders
group by customer_name, product_name
order by total_profit desc
limit 10;

-- slicers for interactive dashboard
select distinct (country)
from orders
where region = 'Africa';

select distinct (category)
from orders
where region = 'Africa';

select distinct (segment)
from orders;

