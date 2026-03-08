-- ====================================================
-- PART-TO-WHOLE ANALYSIS
-- Which categories contribute the most to overall sales?
-- ====================================================

/*
Purpose:
This analysis measures the contribution of each product
category to total business sales.

It helps answer questions such as:
- Which categories drive the largest share of revenue?
- How much does each category contribute to total sales?
- Is revenue concentrated in a few categories or spread evenly?
*/


-- ====================================================
-- Step 1: Aggregate total sales by product category
-- ====================================================
WITH category_sales AS (
    SELECT
        P.category,
        SUM(F.sales_amount) AS total_sales
    FROM gold.fact_sales AS F
    LEFT JOIN gold.dim_products AS P
        ON F.product_key = P.product_key
    GROUP BY P.category
)

-- ====================================================
-- Step 2: Compare each category against overall sales
-- ====================================================
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,

    -- Percentage contribution of each category to total sales
    CONCAT(
        ROUND(
            (CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100,
            2
        ),
        '%'
    ) AS percentage_of_total

FROM category_sales
ORDER BY total_sales DESC;


-- ====================================================
-- NOTES
-- ====================================================

-- Analysis Scope
-- ----------------------------------------------------
-- This query performs a part-to-whole analysis by showing
-- how much each product category contributes to total sales.
--
-- It is useful for identifying the most important revenue-
-- generating categories in the business.



-- Reusability
-- ----------------------------------------------------
-- The same logic can be reused for other dimensions, such as:
--
--  • Subcategory contribution to total sales
--  • Product line contribution to total sales
--  • Country contribution to total sales
--  • Customer segment contribution to total sales
--
-- In each case, replace the grouping column with the
-- relevant business dimension.

