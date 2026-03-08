-- ====================================================
-- CUMULATIVE ANALYSIS
-- Running totals and moving averages over time
-- ====================================================

/*
Cumulative analysis is used to understand how metrics
accumulate or evolve over time.

Two common techniques are:

1. Running Total
   A cumulative sum that continuously adds values
   across time periods.

2. Moving Average
   A rolling average calculated over a fixed number
   of previous periods to smooth trends.
*/


-- ====================================================
-- 1. RUNNING TOTAL OF MONTHLY SALES
-- ====================================================

WITH monthly_sales AS (
    SELECT
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        SUM(sales_amount) AS monthly_sales
    FROM gold.fact_sales
    GROUP BY YEAR(order_date), MONTH(order_date)
)

SELECT
    order_year,
    order_month,
    monthly_sales,
    SUM(monthly_sales) OVER(
        ORDER BY order_year, order_month
    ) AS running_total_sales
FROM monthly_sales
ORDER BY order_year, order_month;


-- ====================================================
-- 2. RUNNING TOTAL OF MONTHLY ORDERS
-- ====================================================

WITH monthly_orders AS (
    SELECT
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        COUNT(DISTINCT order_number) AS monthly_orders
    FROM gold.fact_sales
    GROUP BY YEAR(order_date), MONTH(order_date)
)

SELECT
    order_year,
    order_month,
    monthly_orders,
    SUM(monthly_orders) OVER(
        ORDER BY order_year, order_month
    ) AS running_total_orders
FROM monthly_orders
ORDER BY order_year, order_month;


-- ====================================================
-- 3. MOVING AVERAGE OF MONTHLY SALES (3-MONTH WINDOW)
-- ====================================================

WITH monthly_sales AS (
    SELECT
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        SUM(sales_amount) AS monthly_sales
    FROM gold.fact_sales
    GROUP BY YEAR(order_date), MONTH(order_date)
)

SELECT
    order_year,
    order_month,
    monthly_sales,
    AVG(monthly_sales) OVER(
        ORDER BY order_year, order_month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_sales
FROM monthly_sales
ORDER BY order_year, order_month;


-- ====================================================
-- 4. MOVING AVERAGE OF MONTHLY ORDERS (3-MONTH WINDOW)
-- ====================================================

WITH monthly_orders AS (
    SELECT
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        COUNT(DISTINCT order_number) AS monthly_orders
    FROM gold.fact_sales
    GROUP BY YEAR(order_date), MONTH(order_date)
)

SELECT
    order_year,
    order_month,
    monthly_orders,
    AVG(monthly_orders) OVER(
        ORDER BY order_year, order_month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_orders
FROM monthly_orders
ORDER BY order_year, order_month;
