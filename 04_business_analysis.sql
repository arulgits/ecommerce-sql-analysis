-- PART 4: BUSINESS ANALYSIS PRACTICE
USE ecommerce_sql_portfolio;

-- TODO 1: DEFINE REVENUE FORMULA AND SUCCESSFUL SALES
-- Define the revenue calculation and determine which order
-- statuses should count as successful sales.

-- Task 1: Define Successful Sales Statuses
-- Business Question:
-- Which order statuses should be treated as successful sales?

SELECT
    LOWER(TRIM(order_status)) AS normalized_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY LOWER(TRIM(order_status))
ORDER BY normalized_status;

-- Business Interpretation:
-- After normalizing order statuses, five distinct statuses are present.
-- Delivered (85) and shipped (19) are treated as successful sales,
-- while processing (22), returned (11), and cancelled (13) are excluded
-- from successful sales revenue analysis.

-- Task 2: Calculate Total Successful Revenue
-- Business Question:
-- What is the total revenue generated from successful sales?

SELECT
    SUM(cleaned_order_items.quantity * cleaned_order_items.cleaned_unit_price) AS total_revenue
FROM orders
JOIN cleaned_order_items
    ON orders.order_id = cleaned_order_items.order_id
WHERE LOWER(TRIM(orders.order_status)) IN ('delivered', 'shipped');

-- Business Interpretation:
-- Total revenue from successful sales is ₹1,073,119.00.
-- This revenue is calculated only from Delivered and Shipped orders.

-- Task 3: Calculate Successful Order Count
-- Business Question:
-- How many orders are considered successful sales?

SELECT
    COUNT(DISTINCT orders.order_id) AS successful_order_count
FROM orders
WHERE LOWER(TRIM(orders.order_status)) IN ('delivered', 'shipped');

-- Business Interpretation:
-- There are 104 successful orders in total.
-- Only Delivered and Shipped orders are counted as successful orders.

-- Task 4: Calculate Successful Average Order Value
-- Business Question:
-- What is the average revenue generated per successful order?

SELECT
    SUM(cleaned_order_items.quantity * cleaned_order_items.cleaned_unit_price)
    / COUNT(DISTINCT orders.order_id) AS successful_avg_order_value
FROM orders
JOIN cleaned_order_items
    ON orders.order_id = cleaned_order_items.order_id
WHERE LOWER(TRIM(orders.order_status)) IN ('delivered', 'shipped');

-- Business Interpretation:
-- The average order value for successful orders is ₹10,318.45.
-- This represents the average revenue generated per successful order,
-- based on Delivered and Shipped orders.

-- TODO 2: ANALYZE SALES TRENDS
-- Use date functions and aggregation to understand how
-- successful sales change over time.

-- Task 5: Calculate Monthly Revenue
-- Business Question:
-- How much successful revenue was generated in each month?

SELECT
    YEAR(orders.order_date) AS year,
    MONTH(orders.order_date) AS month,
    SUM(
        cleaned_order_items.quantity
        * cleaned_order_items.cleaned_unit_price
    ) AS monthly_revenue
FROM orders
JOIN cleaned_order_items
    ON orders.order_id = cleaned_order_items.order_id
WHERE LOWER(TRIM(orders.order_status)) IN ('delivered', 'shipped')
GROUP BY year, month
ORDER BY year, month;

-- Business Interpretation:
-- Successful monthly revenue varies considerably across the two years.
-- In 2024, monthly revenue ranges from ₹23,079.00 to ₹73,596.00.
-- In 2025, monthly revenue ranges from ₹11,384.00 to ₹78,453.00.
-- The highest monthly revenue in the dataset is ₹78,453.00 in November 2025.

-- Task 6: Calculate Monthly Order Count
-- Business Question:
-- How many successful orders were placed in each month?

SELECT
    YEAR(orders.order_date) AS year,
    MONTH(orders.order_date) AS month,
    COUNT(DISTINCT orders.order_id) AS successful_order_count
FROM orders
WHERE LOWER(TRIM(orders.order_status)) IN ('delivered', 'shipped')
GROUP BY year, month
ORDER BY year, month;

-- Business Interpretation:
-- Successful order volume varies across months in both years.
-- Monthly successful orders range from 2 to 7 orders.
-- August 2024 has the highest monthly order count with 7 successful orders.

-- Task 7: Calculate Monthly Revenue Change
-- Business Question:
-- How did successful revenue change from one month to the next?

WITH monthly_sales AS (
    SELECT
        YEAR(orders.order_date) AS year,
        MONTH(orders.order_date) AS month,
        SUM(
            cleaned_order_items.quantity
            * cleaned_order_items.cleaned_unit_price
        ) AS monthly_revenue
    FROM orders
    JOIN cleaned_order_items
        ON orders.order_id = cleaned_order_items.order_id
    WHERE LOWER(TRIM(orders.order_status)) IN ('delivered', 'shipped')
    GROUP BY year, month
)
SELECT
    year,
    month,
    monthly_revenue,
    LAG(monthly_revenue)
        OVER (ORDER BY year, month) AS previous_monthly_revenue,
    monthly_revenue
        - LAG(monthly_revenue)
          OVER (ORDER BY year, month) AS revenue_change
FROM monthly_sales
ORDER BY year, month;

-- Business Interpretation:
-- Monthly successful revenue fluctuates substantially across the dataset.
-- The largest month-over-month increase is ₹39,180.00 in April 2025.
-- The largest month-over-month decrease is ₹44,573.00 in January 2025.
-- Revenue change is calculated against the immediately preceding month,
-- including the transition from December 2024 to January 2025.

-- TODO 3: ANALYZE PRODUCT & CATEGORY PERFORMANCE
-- Use aggregation, joins, and ranking to understand which products
-- and categories contribute the most to successful sales.

-- Task 8: Identify Top 5 Products by Revenue
-- Business Question:
-- Which 5 products generate the highest successful revenue?

SELECT
    products.product_id,
    products.product_name,
    SUM(
        cleaned_order_items.quantity
        * cleaned_order_items.cleaned_unit_price
    ) AS product_revenue
FROM products
JOIN cleaned_order_items
    ON cleaned_order_items.product_id = products.product_id
JOIN orders
    ON orders.order_id = cleaned_order_items.order_id
WHERE LOWER(TRIM(orders.order_status)) IN ('delivered', 'shipped')
GROUP BY
    products.product_id,
    products.product_name
ORDER BY product_revenue DESC
LIMIT 5;

-- Business Interpretation:
-- Running Shoes generated the highest successful revenue at ₹111,960.00.
-- Smartwatch Lite and Noise Cancelling Headphones followed with
-- ₹97,972.00 and ₹95,984.00 respectively.
-- The top 5 products generated successful revenue ranging from
-- ₹64,764.00 to ₹111,960.00.

-- Task 9: Identify Bottom 5 Products by Revenue
-- Business Question:
-- Which 5 products generate the lowest successful revenue?

SELECT
    products.product_id,
    products.product_name,
    SUM(
        cleaned_order_items.quantity
        * cleaned_order_items.cleaned_unit_price
    ) AS product_revenue
FROM products
JOIN cleaned_order_items
    ON cleaned_order_items.product_id = products.product_id
JOIN orders
    ON orders.order_id = cleaned_order_items.order_id
WHERE LOWER(TRIM(orders.order_status)) IN ('delivered', 'shipped')
GROUP BY
    products.product_id,
    products.product_name
ORDER BY product_revenue ASC
LIMIT 5;

-- Business Interpretation:
-- Gel Pen Set generated the lowest successful revenue at ₹1,992.00.
-- Phone Case and Wireless Mouse followed with ₹2,394.00 and ₹5,593.00 respectively.
-- The bottom 5 products generated successful revenue ranging from
-- ₹1,992.00 to ₹6,490.00.

-- Task 10: Calculate Revenue by Product Category
-- Business Question:
-- How much successful revenue does each product category generate?

SELECT
    products.category,
    SUM(
        cleaned_order_items.quantity
        * cleaned_order_items.cleaned_unit_price
    ) AS category_revenue
FROM products
JOIN cleaned_order_items
    ON cleaned_order_items.product_id = products.product_id
JOIN orders
    ON orders.order_id = cleaned_order_items.order_id
WHERE LOWER(TRIM(orders.order_status)) IN ('delivered', 'shipped')
GROUP BY products.category
ORDER BY category_revenue DESC;

-- Business Interpretation:
-- Electronics has the highest recorded successful revenue at ₹344,120.00
-- among the category labels returned by the query.
-- Fashion and Home & Kitchen follow with ₹164,316.00 and ₹159,865.00.
-- Some category names still appear as separate labels, such as
-- Electronics, Fashion, Sports & Fitness, Sports and Fitness,
-- Home & Office, and Home and Office.

-- Task 11: Identify Bottom 5 Categories by Revenue
-- Business Question:
-- Which 5 product categories generate the lowest successful revenue?

SELECT
    products.category,
    SUM(
        cleaned_order_items.quantity
        * cleaned_order_items.cleaned_unit_price
    ) AS category_revenue
FROM products
JOIN cleaned_order_items
    ON cleaned_order_items.product_id = products.product_id
JOIN orders
    ON orders.order_id = cleaned_order_items.order_id
WHERE LOWER(TRIM(orders.order_status)) IN ('delivered', 'shipped')
GROUP BY products.category
ORDER BY category_revenue ASC
LIMIT 5;

-- Business Interpretation:
-- Stationary has the lowest recorded successful revenue at ₹1,992.00.
-- Stationery, Home & Decor, Home and Decor, and Home and Office
-- follow with successful revenue between ₹5,980.00 and ₹11,184.00.
-- Some category naming variants are still reported separately,
-- so these results should be interpreted at the category-label level.

-- TODO 4: ANALYZE CUSTOMER PURCHASING BEHAVIOUR
-- Use customer-level and order-level analysis to understand
-- purchasing frequency, spending, and average order value.

-- Task 12: Calculate Customer Order Frequency
-- Business Question:
-- How frequently does each customer place successful orders?

SELECT
    customers.customer_id,
    CONCAT(customers.first_name, ' ', customers.last_name) AS customer_name,
    COUNT(DISTINCT orders.order_id) AS order_frequency
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
WHERE LOWER(TRIM(orders.order_status)) IN ('delivered', 'shipped')
GROUP BY
    customers.customer_id,
    customers.first_name,
    customers.last_name
ORDER BY order_frequency DESC;

-- Business Interpretation:
-- Successful order frequency ranges from 2 to 5 orders per customer.
-- Aditi Rao has the highest successful order frequency with 5 orders.
-- Nine customers have 4 successful orders, while 20 customers have
-- 2 or 3 successful orders.

-- Task 13: Calculate Customer Spending
-- Business Question:
-- How much successful revenue has each customer generated?

SELECT
    customers.customer_id,
    CONCAT(customers.first_name, ' ', customers.last_name) AS customer_name,
    SUM(
        cleaned_order_items.quantity
        * cleaned_order_items.cleaned_unit_price
    ) AS customer_revenue
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
JOIN cleaned_order_items
    ON orders.order_id = cleaned_order_items.order_id
WHERE LOWER(TRIM(orders.order_status)) IN ('delivered', 'shipped')
GROUP BY
    customers.customer_id,
    customers.first_name,
    customers.last_name
ORDER BY customer_revenue DESC;

-- Business Interpretation:
-- Successful customer spending ranges from ₹9,488.00 to ₹66,264.00.
-- Yash Bhatia has the highest successful revenue at ₹66,264.00.
-- Riya Mukherjee has the lowest successful revenue at ₹9,488.00.
-- Customer spending varies substantially across the customer base.

-- Task 14: Calculate Customer Average Order Value
-- Business Question:
-- What is the average amount spent per successful order by each customer?

SELECT
    customers.customer_id,
    CONCAT(customers.first_name, ' ', customers.last_name) AS customer_name,
    SUM(
        cleaned_order_items.quantity
        * cleaned_order_items.cleaned_unit_price
    ) AS customer_revenue,
    COUNT(DISTINCT orders.order_id) AS successful_order_count,
    SUM(
        cleaned_order_items.quantity
        * cleaned_order_items.cleaned_unit_price
    ) / COUNT(DISTINCT orders.order_id) AS average_order_value
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
JOIN cleaned_order_items
    ON orders.order_id = cleaned_order_items.order_id
WHERE LOWER(TRIM(orders.order_status)) IN ('delivered', 'shipped')
GROUP BY
    customers.customer_id,
    customers.first_name,
    customers.last_name
ORDER BY average_order_value DESC;

-- Business Interpretation:
-- Customer average order value ranges from ₹4,744.00 to ₹16,859.00.
-- Rahul Khanna has the highest average order value at ₹16,859.00
-- across 3 successful orders.
-- Riya Mukherjee has the lowest average order value at ₹4,744.00
-- across 2 successful orders.

-- Task 15: Calculate Total Units Purchased by Customer
-- Business Question:
-- Which customers have purchased the highest number of units
-- through successful orders?

SELECT
    customers.customer_id,
    CONCAT(customers.first_name, ' ', customers.last_name) AS customer_name,
    SUM(cleaned_order_items.quantity) AS total_units_purchased
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
JOIN cleaned_order_items
    ON orders.order_id = cleaned_order_items.order_id
WHERE LOWER(TRIM(orders.order_status)) IN ('delivered', 'shipped')
GROUP BY
    customers.customer_id,
    customers.first_name,
    customers.last_name
ORDER BY total_units_purchased DESC;

-- Business Interpretation:
-- Total units purchased by customers range from 12 to 36 units.
-- Yash Bhatia purchased the highest number of units with 36 units.
-- Riya Mukherjee purchased the lowest number of units with 12 units.

-- Task 16: Calculate Average Units per Order by Customer
-- Business Question:
-- On average, how many units does each customer purchase
-- per successful order?

SELECT
    customers.customer_id,
    CONCAT(customers.first_name, ' ', customers.last_name) AS customer_name,
    SUM(cleaned_order_items.quantity) AS total_units_purchased,
    COUNT(DISTINCT orders.order_id) AS successful_order_count,
    SUM(cleaned_order_items.quantity)
        / COUNT(DISTINCT orders.order_id) AS avg_units_per_order
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
JOIN cleaned_order_items
    ON orders.order_id = cleaned_order_items.order_id
WHERE LOWER(TRIM(orders.order_status)) IN ('delivered', 'shipped')
GROUP BY
    customers.customer_id,
    customers.first_name,
    customers.last_name
ORDER BY avg_units_per_order DESC;

-- Business Interpretation:
-- Average units per successful order range from 6.00 to 9.00 units.
-- Manav Mishra and Yash Bhatia have the highest average of 9.00 units
-- per successful order.
-- Riya Mukherjee has the lowest average at 6.00 units per successful order.

-- TODO 5: COMPARE CUSTOMER SEGMENTS, GEOGRAPHIES & PAYMENT METHODS
-- Compare customer segments, geographies, and payment methods
-- where the available data quality permits.

-- Task 17: Compare Customer Segments
-- Business Question:
-- How does successful revenue and purchasing activity differ
-- across customer segments?

SELECT
    customers.customer_segment,
    COUNT(DISTINCT customers.customer_id) AS customer_count,
    COUNT(DISTINCT orders.order_id) AS successful_order_count,
    SUM(
        cleaned_order_items.quantity
        * cleaned_order_items.cleaned_unit_price
    ) AS total_revenue,
    SUM(
        cleaned_order_items.quantity
        * cleaned_order_items.cleaned_unit_price
    ) / COUNT(DISTINCT orders.order_id) AS average_order_value
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
JOIN cleaned_order_items
    ON orders.order_id = cleaned_order_items.order_id
WHERE LOWER(TRIM(orders.order_status)) IN ('delivered', 'shipped')
GROUP BY customers.customer_segment
ORDER BY total_revenue DESC;

-- Business Interpretation:
-- Consumer customers account for 26 customers and 81 successful orders,
-- generating ₹791,208.00 in successful revenue with an AOV of ₹9,768.00.
-- Small Business customers account for 7 customers and 23 successful orders,
-- generating ₹281,911.00 in successful revenue with an AOV of ₹12,257.00.
-- The Small Business segment has a higher average order value,
-- while the Consumer segment has more customers, orders, and total revenue.

-- Task 18: Compare Geography by Revenue
-- Business Question:
-- Which cities generate the highest successful revenue?

SELECT
    orders.shipping_city,
    COUNT(DISTINCT orders.order_id) AS successful_order_count,
    SUM(
        cleaned_order_items.quantity
        * cleaned_order_items.cleaned_unit_price
    ) AS total_revenue,
    SUM(
        cleaned_order_items.quantity
        * cleaned_order_items.cleaned_unit_price
    ) / COUNT(DISTINCT orders.order_id) AS average_order_value
FROM orders
JOIN cleaned_order_items
    ON orders.order_id = cleaned_order_items.order_id
WHERE LOWER(TRIM(orders.order_status)) IN ('delivered', 'shipped')
  AND orders.shipping_city IS NOT NULL
  AND TRIM(orders.shipping_city) <> ''
GROUP BY orders.shipping_city
ORDER BY total_revenue DESC;

-- Business Interpretation:
-- Successful revenue varies across the reported shipping cities.
-- Mumbai generated the highest successful revenue at ₹180,174.00,
-- followed by Bengaluru at ₹176,730.00 and Chennai at ₹171,740.00.
-- Hyderabad generated the lowest successful revenue at ₹67,490.00.
-- Chennai has the highest average order value at ₹14,311.67,
-- while Hyderabad has the lowest at ₹6,749.00.

-- Task 19: Compare Payment Methods
-- Business Question:
-- How does successful sales performance differ across payment methods?

SELECT
    orders.payment_method,
    COUNT(DISTINCT orders.order_id) AS successful_order_count,
    SUM(
        cleaned_order_items.quantity
        * cleaned_order_items.cleaned_unit_price
    ) AS total_revenue,
    SUM(
        cleaned_order_items.quantity
        * cleaned_order_items.cleaned_unit_price
    ) / COUNT(DISTINCT orders.order_id) AS average_order_value
FROM orders
JOIN cleaned_order_items
    ON orders.order_id = cleaned_order_items.order_id
WHERE LOWER(TRIM(orders.order_status)) IN ('delivered', 'shipped')
  AND orders.payment_method IS NOT NULL
  AND TRIM(orders.payment_method) <> ''
GROUP BY orders.payment_method
ORDER BY total_revenue DESC;

-- Business Interpretation:
-- Credit Card generated ₹131,026.00 in successful revenue across 10 orders,
-- with an average order value of ₹13,102.60.
-- UPI appears as two separate records in the result, with successful revenue
-- of ₹751,277.00 and ₹190,816.00.
-- The duplicate UPI records indicate that payment-method data may contain
-- inconsistent representations and should be interpreted at the reported-label level.