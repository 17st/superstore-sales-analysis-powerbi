Create database sales_analysis;

Use sales_analysis;

CREATE TABLE superstore (
order_id TEXT,
order_date DATE,
order_year INT,
order_year_month TEXT,
month_name TEXT,
ship_date DATE,
ship_mode TEXT,
shipping_time INT,
customer_id TEXT,
customer_name TEXT,
segment TEXT,
city TEXT,
state TEXT,
postal_code TEXT,
region TEXT,
product_id TEXT,
category TEXT,
sub_category TEXT,
product_name TEXT,
sales DOUBLE
);

-- Data imported from cleaned Superstore CSV file; 
 
-- --------------------------------------
-- Key Business Metrics

-- Total revenue, orders, customers, and average order value
 select SUM(sales) AS total_revenue,
 count( distinct order_id) AS total_order,
 count( distinct customer_id) AS total_customer,
 SUM(sales) / count(distinct order_id) AS avg_order
 from superstore;
 
-- --------------------------------------
-- Sales Trend Analysis
 select order_year_month, SUM(sales) AS total_sales_per_month
 from superstore
 group by order_year_month
 order by order_year_month;
 
-- --------------------------------------
-- Regional Sales Performance
 select region, SUM(sales) AS total_sales_per_region
 from superstore
 group by region
 order by total_sales_per_region desc;
 
-- --------------------------------------
-- Category & Subcategory Analysis
 select category, SUM(sales) AS total_sales_by_category
 from superstore
 group by category
 order by total_sales_by_category desc;
 
 select sub_category, SUM(sales) AS total_sales_by_sub_category
 from superstore
 group by sub_category
 order by total_sales_by_sub_category desc;
 
-- -------------------------------------- 
-- Customer Segment Analysis
 select segment, SUM(sales) AS total_sales
 from superstore
 group by segment
 order by total_sales desc;
 
 -- -------------------------------------- 
 -- Product Performance Analysis
 select product_name, SUM(sales) AS total_sales
 from superstore
 group by product_name
 order by total_sales desc
 limit 10;
 
 select product_name, SUM(sales) AS total_sales, 
 rank() over(order by SUM(sales) desc) AS product_rank
 from superstore
 group by product_name;
 
 -- -------------------------------------- 
 -- Shipping Analysis
 select ship_mode, AVG(shipping_time) AS avg_shipping_time
 from superstore
 group by ship_mode
 order by avg_shipping_time desc;

 select ship_mode, COUNT(order_id) AS order_per_ship_mode
 from superstore
 group by ship_mode
 order by order_per_ship_mode desc;
 
 select ship_mode, SUM(sales) AS total_sales
 from superstore
 group by ship_mode
 order by total_sales desc;
 
 -- -------------------------------------- 
 -- Growth Analysis
 select order_year_month, SUM(sales) AS monthly_sales,
 LAG(SUM(sales)) OVER (ORDER BY order_year_month) AS previous_month_sales,
 ROUND((SUM(sales) - LAG(SUM(sales)) OVER (ORDER BY order_year_month))/ LAG(SUM(sales)) OVER (ORDER BY order_year_month), 2)*100 AS growth
 from superstore
 group by order_year_month;
 
 select order_year_month, SUM(sales) AS monthly_sales,
 LAG(SUM(sales)) OVER (ORDER BY order_year_month) AS previous_month_sales,
 SUM(sales) - LAG(SUM(sales)) OVER (ORDER BY order_year_month) AS revenue_change
 from superstore
 group by order_year_month;
 
  SELECT 
    order_year,
    SUM(sales) AS yearly_sales,
    LAG(SUM(sales)) OVER (ORDER BY order_year) AS previous_year_sales,
    ((SUM(sales) - LAG(SUM(sales)) OVER (ORDER BY order_year)) 
    / LAG(SUM(sales)) OVER (ORDER BY order_year)) * 100 AS revenue_growth_percent
FROM superstore
GROUP BY order_year
ORDER BY order_year;

 -- -------------------------------------- 
 -- Revenue by Region and Category
 select region, category, SUM(sales) as total_Sales
 from superstore
 group by region, category
 order by total_sales desc;
 
 -- -------------------------------------- 
 -- Revenue by Customer Segment and Category 
 select segment, category, SUM(sales) as total_Sales
 from superstore
 group by segment, category
 order by total_sales desc;
 
 -- --------------------------------------
 -- Revenue by Region and Customer Segment
 select region, segment, SUM(sales) as total_Sales
 from superstore
 group by region, segment
 order by total_sales desc;
 
 -- --------------------------------------
 -- Ranking Products Within Each Category
 select *
 from (
	 select category, product_name, SUM(sales) as total_sales,
	 rank() over(partition by category order by SUM(sales) DESC) as product_rank
	 from superstore
	 group by category, product_name
  ) ranked_products
  where product_rank <= 5;
 

 
 
 