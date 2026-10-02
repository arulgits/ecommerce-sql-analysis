-- ADVANCED ANALYSIS PRACTICE
USE ecommerce_sql_portfolio;

-- TODO 1: Use CTEs to make a multi-step sales or customer analysis readable.

-- Task 1
-- Business Question:
-- Which products generated the highest successful-sales revenue?

WITH successful_sales AS (
    SELECT
        coi.product_id,
        SUM(coi.quantity * coi.cleaned_unit_price) AS revenue
    FROM cleaned_order_items coi
    JOIN orders o
        ON o.order_id = coi.order_id
    WHERE LOWER(TRIM(o.order_status)) IN ('delivered', 'shipped')
    GROUP BY coi.product_id
)
SELECT
    p.product_name,
    ss.revenue
FROM successful_sales ss
JOIN products p
    ON ss.product_id = p.product_id
ORDER BY ss.revenue DESC;

-- TODO 2: Window Functions

-- Task 2A: Product Ranking Within Categories
-- Business Question:
-- Among successful sales, how can we rank products by revenue
-- within each product category using a window function?

WITH product_sales AS (
    SELECT
        p.product_name,
        p.category,
        SUM(coi.quantity * coi.cleaned_unit_price) AS successful_sales_revenue
    FROM cleaned_order_items coi
    JOIN orders o
        ON coi.order_id = o.order_id
    JOIN products p
        ON coi.product_id = p.product_id
    WHERE LOWER(TRIM(o.order_status)) IN ('shipped', 'delivered')
    GROUP BY
        coi.product_id,
        p.product_name,
        p.category
)
SELECT
    product_name,
    category,
    successful_sales_revenue,
    DENSE_RANK() OVER (
        PARTITION BY category
        ORDER BY successful_sales_revenue DESC
    ) AS revenue_rank
FROM product_sales;

-- Task 2B — Running Monthly Sales Total
-- Business Question: How does successful-sales revenue accumulate month by month, 
-- and how can a window function calculate the running monthly total?

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(coi.quantity * coi.cleaned_unit_price) AS revenue
    FROM cleaned_order_items coi
    JOIN orders o
        ON coi.order_id = o.order_id
    WHERE LOWER(TRIM(o.order_status)) IN ('delivered','shipped')
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT month, revenue,
SUM(revenue) OVER (
    ORDER BY month
) AS running_total
FROM monthly_sales;

-- TODO 3: Customer-Level Purchase Summary

-- Task 3: Customer Purchase History
-- Business Question:
-- For each customer, what are their:
-- first purchase date, last purchase date, number of orders, total successful spending, and
-- number of days between their first and last purchases?

SELECT
    c.customer_id,
    MIN(o.order_date) AS first_purchase,
    MAX(o.order_date) AS last_purchase,
    COUNT(DISTINCT o.order_id) AS order_count,
    DATEDIFF(
        MAX(o.order_date),
        MIN(o.order_date)
    ) AS days_between_purchases,
    SUM(coi.quantity * coi.cleaned_unit_price) AS successful_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN cleaned_order_items coi
    ON o.order_id = coi.order_id
WHERE UPPER(TRIM(o.order_status)) IN ('delivered', 'shipped')
GROUP BY c.customer_id;

-- TODO 4: Repeat Purchasers / Retention

-- Task 4: Repeat Purchasers
-- Business Question:
-- How many successful orders did each customer make, and which customers qualify as repeat purchasers?

WITH customer_orders AS (
    SELECT 
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS successful_order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE UPPER(TRIM(o.order_status)) IN ('delivered', 'shipped')
    GROUP BY c.customer_id
)
SELECT
    customer_id,
    successful_order_count,
    CASE
        WHEN successful_order_count >= 2
            THEN 'repeat purchaser'
        ELSE 'not repeat purchaser'
    END AS purchaser_type
FROM customer_orders;

-- TODO 5: Use subqueries and/or UNION ALL for a comparison that is easier to explain than a single query.

-- Task 5: Business Comparison
-- Business Question:
-- Can we create a useful business comparison using a subquery and/or UNION ALL 
-- that is easier to explain than one large query?

SELECT
    'Successful' AS order_type,
    COUNT(DISTINCT order_id) AS order_count
FROM orders
WHERE UPPER(TRIM(order_status)) IN ('delivered' , 'shipped')
UNION ALL
SELECT
    'Other' AS order_type,
    COUNT(DISTINCT order_id) AS order_count
FROM orders
WHERE UPPER(TRIM(order_status)) NOT IN ('delivered' , 'shipped');

-- TODO 6: Document your assumptions, especially how you treat cancelled, returned, and messy records.

-- Task 6: Document Data Treatment
-- Business Question:
-- What assumptions are being used when handling cancelled, returned,
-- processing, and messy records in the Part 5 analysis?

-- 1) Successful sales are defined as orders with status 'delivered' or 'shipped'.
-- 2) 'cancelled', 'returned', and 'processing' are not included when calculating successful sales.
-- 3) Different capitalization/spacing in status values → handled with UPPER(TRIM()).
-- 4) Missing unit_price → cleaned_unit_price uses COALESCE() with the product price.
-- 5) Duplicate-looking records were not automatically deleted unless 
-- they met the duplicate criteria established during cleaning.