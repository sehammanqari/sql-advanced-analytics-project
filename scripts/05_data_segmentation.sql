```sql
-- ====================================================
-- DATA SEGMENTATION
-- Grouping products and customers into meaningful segments
-- ====================================================

/*
Purpose:
Data segmentation is used to divide entities such as
products and customers into logical groups based on
shared characteristics.

This helps answer questions such as:
- How are products distributed across price ranges?
- How are customers distributed based on their spending behavior?
- Which segments are the most common in the business?
*/


------------------------------------------------------------------------------------------
-- PRODUCT SEGMENTATION
-- Segment products into cost ranges and count how many
-- products fall into each segment
------------------------------------------------------------------------------------------
WITH product_segment AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)

SELECT
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segment
GROUP BY cost_range
ORDER BY COUNT(product_key) DESC;



------------------------------------------------------------------------------------------
-- CUSTOMER SEGMENTATION
-- Group customers into segments based on spending behavior
------------------------------------------------------------------------------------------
/*
Customer segments:
- VIP: Customers with at least 12 months of history and spending more than €5,000
- Regular: Customers with at least 12 months of history but spending €5,000 or less
- New: Customers with a lifespan less than 12 months

Goal:
Find the total number of customers in each segment
*/
WITH spending_behavior AS (
    SELECT
        C.customer_key,
        SUM(F.sales_amount) AS total_spending,
        DATEDIFF(MONTH, MIN(F.order_date), MAX(F.order_date)) AS lifespan
    FROM gold.fact_sales F
    LEFT JOIN gold.dim_customers C
        ON C.customer_key = F.customer_key
    GROUP BY C.customer_key
)

SELECT
    customer_segment,
    COUNT(customer_key) AS total_customer
FROM (
    SELECT
        customer_key,
        CASE
            WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM spending_behavior
) T
GROUP BY customer_segment
ORDER BY total_customer DESC;


-- ====================================================
-- NOTES
-- ====================================================

-- Segmentation Purpose
-- ----------------------------------------------------
-- Segmentation helps divide products or customers into
-- logical groups that are easier to analyze and compare.
--
-- In this script:
-- • Products are grouped by cost range
-- • Customers are grouped by purchase behavior and history
--
-- This helps identify business patterns and supports
-- targeted decision-making.



-- Flexibility of Segments
-- ----------------------------------------------------
-- The segment definitions used here are business rules
-- and can be adjusted depending on the analysis goal.
--
-- For example:
-- • Product cost ranges can be changed
-- • Customer thresholds for VIP / Regular can be increased or decreased
-- • Additional customer groups can be introduced
--
-- This makes segmentation highly flexible and adaptable
-- to different business scenarios.



-- Reusability
-- ----------------------------------------------------
-- The same segmentation logic can be reused for:
--
-- • Customers by order frequency
-- • Customers by average order value
-- • Products by sales performance
-- • Products by quantity sold
--
-- Segmentation is a common analytical technique used in
-- customer analytics, marketing, and performance analysis.



