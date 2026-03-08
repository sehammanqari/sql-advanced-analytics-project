-- ====================================================
-- PERFORMANCE ANALYSIS
-- Compare yearly product sales against historical averages
-- and previous-year performance
-- ====================================================

/*
Purpose:
This analysis evaluates product performance over time by comparing
each product's yearly sales against:

1. Its average historical sales performance
2. Its previous year's sales performance

This helps identify whether a product is:
- performing above or below its average
- improving or declining compared to last year
*/


-- ====================================================
-- Step 1: Aggregate yearly sales by product
-- ====================================================
WITH yearly_product_sales AS (
    SELECT
        YEAR(F.order_date) AS order_year,
        P.product_name,
        SUM(F.sales_amount) AS current_sales
    FROM gold.fact_sales AS F
    LEFT JOIN gold.dim_products AS P
        ON F.product_key = P.product_key
    WHERE YEAR(F.order_date) IS NOT NULL
    GROUP BY
        YEAR(F.order_date),
        P.product_name
)

-- ====================================================
-- Step 2: Compare current sales with average sales
-- and previous year's sales
-- ====================================================
SELECT
    order_year,
    product_name,
    current_sales,

    -- Average sales of the product across all years
    AVG(current_sales) OVER (
        PARTITION BY product_name
    ) AS avg_sales,

    -- Difference between current year sales and average sales
    current_sales - AVG(current_sales) OVER (
        PARTITION BY product_name
    ) AS diff_avg,

    -- Performance label compared to average
    CASE
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,

    -- Previous year's sales for the same product
    LAG(current_sales) OVER (
        PARTITION BY product_name
        ORDER BY order_year
    ) AS previous_years_sales,

    -- Difference between current sales and previous year's sales
    current_sales - LAG(current_sales) OVER (
        PARTITION BY product_name
        ORDER BY order_year
    ) AS diff_sales,

    -- Year-over-year performance label
    CASE
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS year_change

FROM yearly_product_sales
ORDER BY product_name, order_year;


-- ====================================================
-- NOTES
-- ====================================================

-- Granularity Flexibility
-- ----------------------------------------------------
-- This analysis is currently performed at the YEAR level
-- using:
--
--      YEAR(F.order_date)
--
-- However, the same logic can easily be applied at
-- different time granularities depending on the
-- business requirements, such as:
--
--  • Month-to-Month analysis
--  • Quarter-to-Quarter analysis
--  • Year-to-Year analysis
--
-- For example, to perform a monthly analysis, the query
-- can group by both YEAR(order_date) and MONTH(order_date).
-- Adjusting the time granularity allows analysts to
-- explore trends at different levels of detail.



-- Reusability Consideration
-- ----------------------------------------------------
-- This type of analysis can also be implemented as a
-- STORED PROCEDURE.
--
-- Converting this query into a stored procedure allows:
--
--  • Reusable execution without rewriting the query
--  • Automation for scheduled reporting
--  • Parameterization of filters such as:
--        - Time granularity (Year / Month / Quarter)
--        - Date ranges
--        - Product categories
--
-- Example usage:
-- The stored procedure could be executed periodically
-- (e.g., monthly or yearly) to monitor product
-- performance trends over time.

