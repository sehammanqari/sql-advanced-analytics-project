-- ====================================================
-- CHANGE OVER TIME ANALYSIS
-- Analyzing trends and performance over time
-- ====================================================

/*
Change Over Time Analysis is used to track how business metrics
such as sales, customers, and quantity change across time periods.

This helps answer questions such as:
- Is sales performance improving or declining over time?
- Which months or years perform best?
- How does business activity change across periods?
*/


-- ====================================================
-- 1. Total Sales by Year
-- ====================================================
SELECT
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
GROUP BY YEAR(order_date)
ORDER BY order_year;


-- ====================================================
-- 2. Total Sales by Month
-- ====================================================
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;


-- ====================================================
-- 3. Total Orders by Year
-- ====================================================
SELECT
    YEAR(order_date) AS order_year,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales
GROUP BY YEAR(order_date)
ORDER BY order_year;


-- ====================================================
-- 4. Total Orders by Month
-- ====================================================
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;


-- ====================================================
-- 5. Total Quantity Sold by Year
-- ====================================================
SELECT
    YEAR(order_date) AS order_year,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
GROUP BY YEAR(order_date)
ORDER BY order_year;


-- ====================================================
-- 6. Total Quantity Sold by Month
-- ====================================================
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;


-- ====================================================
-- 7. Average Selling Price by Year
-- ====================================================
SELECT
    YEAR(order_date) AS order_year,
    AVG(price) AS avg_price
FROM gold.fact_sales
GROUP BY YEAR(order_date)
ORDER BY order_year;


-- ====================================================
-- 8. New Customers Created by Year
-- ====================================================
SELECT
    YEAR(create_date) AS customer_create_year,
    COUNT(customer_key) AS new_customers
FROM gold.dim_customers
GROUP BY YEAR(create_date)
ORDER BY customer_create_year;


-- ====================================================
-- 9. New Customers Created by Month
-- ====================================================
SELECT
    YEAR(create_date) AS customer_create_year,
    MONTH(create_date) AS customer_create_month,
    COUNT(customer_key) AS new_customers
FROM gold.dim_customers
GROUP BY YEAR(create_date), MONTH(create_date)
ORDER BY customer_create_year, customer_create_month;


-- ====================================================
-- 10. Sales Trend by Product Category Over Time
-- ====================================================
SELECT
    YEAR(fs.order_date) AS order_year,
    MONTH(fs.order_date) AS order_month,
    dp.category,
    SUM(fs.sales_amount) AS total_sales
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
    ON fs.product_key = dp.product_key
GROUP BY YEAR(fs.order_date), MONTH(fs.order_date), dp.category
ORDER BY order_year, order_month, dp.category;


-- ====================================================
-- 11. Sales Trend by Country Over Time
-- ====================================================
SELECT
    YEAR(fs.order_date) AS order_year,
    MONTH(fs.order_date) AS order_month,
    dc.country,
    SUM(fs.sales_amount) AS total_sales
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
    ON fs.customer_key = dc.customer_key
GROUP BY YEAR(fs.order_date), MONTH(fs.order_date), dc.country
ORDER BY order_year, order_month, dc.country;


-- ====================================================
-- 12. Year-over-Year Sales Comparison
-- ====================================================
SELECT
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
GROUP BY YEAR(order_date)
ORDER BY total_sales DESC;
