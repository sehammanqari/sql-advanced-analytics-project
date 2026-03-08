/*
======================================================================
REPORTING
======================================================================

This section builds final analytical reports that summarize
customer behavior and product performance.

Reports included:

1) Customer Report
   - Customer demographics
   - Customer segmentation
   - Purchase behavior metrics

2) Product Report
   - Product sales performance
   - Customer engagement
   - Revenue metrics

These reports are implemented as SQL Views so they can be reused
easily in analysis, dashboards, or BI tools.
======================================================================
*/


-- ====================================================
-- CUSTOMER REPORT
-- ====================================================

CREATE VIEW gold.report_customers AS

-- Step 1: Base query
WITH base_query AS (
    SELECT
        F.order_number,
        F.product_key,
        F.order_date,
        F.sales_amount,
        F.quantity,
        C.customer_key,
        C.customer_number,
        CONCAT(C.first_name,' ',C.last_name) AS customer_name,
        DATEDIFF(YEAR,C.birthdate,GETDATE()) AS age
    FROM gold.fact_sales F
    LEFT JOIN gold.dim_customers C
        ON F.customer_key = C.customer_key
    WHERE order_date IS NOT NULL
)

-- Step 2: Customer aggregations
, customer_aggregation AS(
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
    FROM base_query
    GROUP BY
        customer_key,
        customer_number,
        customer_name,
        age
)

-- Step 3: Final report
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,

    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END AS age_group,

    CASE
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,

    DATEDIFF(MONTH,last_order_date,GETDATE()) AS recency,

    total_orders,
    total_sales,
    total_quantity,
    total_products,
    last_order_date,
    lifespan,

    CASE
        WHEN total_sales = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_value,

    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_spend

FROM customer_aggregation;



-- ====================================================
-- PRODUCT REPORT
-- ====================================================

CREATE VIEW gold.report_products AS

-- Step 1: Base query
WITH base_query AS (
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE order_date IS NOT NULL
)

-- Step 2: Product aggregations
, product_aggregations AS (
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        MAX(order_date) AS last_sale_date,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity,0)),1) AS avg_selling_price
    FROM base_query
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

-- Step 3: Final report
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,

    DATEDIFF(MONTH,last_sale_date,GETDATE()) AS recency_in_months,

    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,

    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,

    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_revenue,

    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_revenue

FROM product_aggregations;
