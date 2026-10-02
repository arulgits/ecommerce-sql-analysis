-- EXPLORATORY ANALYSIS
USE ecommerce_sql_portfolio;

-- TODO 1: INSPECT THE DATASET STRUCTURE
-- Understand what each table contains and what one row represents.

-- Task 1: Inspect Customers Table
-- Business Question:
-- What does one row represent in the customers table?

SELECT *
FROM customers
LIMIT 5;
-- Customers: One row represents one customer and their profile information.

-- Task 2: Inspect Products Table
-- Business Question:
-- What does one row represent in the products table?

SELECT *
FROM products
LIMIT 5;
-- Products: One row represents one product and its product details.

-- Task 3: Inspect Orders Table
-- Business Question:
-- What does one row represent in the orders table?

SELECT *
FROM orders
LIMIT 5;
-- Orders: One row represents one customer order and its order details.

-- Task 4: Inspect Order Items Table
-- Business Question:
-- What does one row represent in the order_items table?

SELECT *
FROM order_items
LIMIT 5;
-- Order Items: One row represents one product line within an order.

-- TODO 2: PROFILE DATE RANGE AND DISTINCT VALUES
-- Understand the overall time period and unique values in key fields.

-- Task 5: Find the Order Date Range
-- Business Question:
-- What are the earliest and latest order dates?

SELECT
    MIN(order_date) AS earliest_order_date,
    MAX(order_date) AS latest_order_date
FROM orders;

-- Task 6: Count Distinct Customers
-- Business Question:
-- How many unique customers have placed orders?

SELECT COUNT(DISTINCT customer_id) AS customer_count
FROM orders;

-- Task 7: Count Distinct Products
-- Business Question:
-- How many unique products exist?

SELECT COUNT(DISTINCT product_id) AS product_count
FROM products;

-- Task 8: Inspect Product Categories
-- Business Question:
-- What unique product categories exist?

SELECT DISTINCT category
FROM products;

-- Task 9: Inspect Order Statuses
-- Business Question:
-- What unique order statuses exist?

SELECT DISTINCT order_status
FROM orders;

-- Task 10: Inspect Payment Methods
-- Business Question:
-- What unique payment methods exist?

SELECT DISTINCT payment_method
FROM orders;

-- TODO 3: PROFILE ORDER COUNTS BY MONTH/YEAR, CATEGORY,
-- CUSTOMER SEGMENT, AND STATUS.

-- Task 11: Count Orders by Year
-- Business Question:
-- How many orders were placed in each year?

SELECT YEAR(order_date) AS year ,COUNT(*) AS order_count
FROM orders
GROUP BY YEAR(order_date);

-- Task 12: Count Orders by Month and Year
-- Business Question:
-- How does order activity change across months and years?

SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    COUNT(*) AS order_count
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

-- Task 13: Count Orders by Product Category
-- Business Question:
-- How many orders are associated with each product category?

SELECT
    products.category,
    COUNT(DISTINCT orders.order_id) AS order_count
FROM orders
JOIN order_items
    ON orders.order_id = order_items.order_id
JOIN products
    ON order_items.product_id = products.product_id
GROUP BY products.category;

-- Task 14: Count Orders by Customer Segment
-- Business Question:
-- How many orders are placed by each customer segment?

SELECT
    customers.customer_segment,
    COUNT(DISTINCT orders.order_id) AS order_count
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id
GROUP BY customers.customer_segment;

-- Task 15: Count Orders by Order Status
-- Business Question:
-- How many orders exist under each order status?

SELECT
    order_status,
    COUNT(DISTINCT order_id) AS order_count
FROM orders
GROUP BY order_status;

-- TODO 4: INSPECT EXTREME VALUES
-- Use ORDER BY and LIMIT to inspect the highest and lowest
-- price, quantity, and discount values.

-- Task 16: Inspect Highest and Lowest Product Prices
-- Business Question:
-- Which products have the highest and lowest selling prices?

-- Highest product price
SELECT *
FROM products
ORDER BY unit_price DESC
LIMIT 1;

-- Lowest product price
SELECT *
FROM products
ORDER BY unit_price ASC
LIMIT 1;

-- Task 17: Inspect Highest and Lowest Order Quantities
-- Business Question:
-- Which order-item records have the highest and lowest quantities?

-- Find the highest order quantity.
SELECT *
FROM order_items
ORDER BY quantity DESC
LIMIT 1;

-- Find the lowest order quantity.
SELECT *
FROM order_items
ORDER BY quantity ASC
LIMIT 1;

-- Task 18: Inspect Highest and Lowest Discount Rates
-- Business Question:
-- Which order-item records have the highest and lowest discount rates?

-- Find the highest discount rate.
SELECT *
FROM order_items
ORDER BY discount_rate DESC
LIMIT 1;

-- Find the lowest discount rate.
SELECT *
FROM order_items
ORDER BY discount_rate ASC
LIMIT 1;

-- TODO 5: IDENTIFY UNUSUAL GROUPS AND REPEAT ACTIVITY
-- Use GROUP BY and HAVING to look for unusual groups or repeat activity.

-- Task 19: Identify Customers With Multiple Orders
-- Business Question:
-- Which customers have placed more than one order?

SELECT
    customer_id,
    COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Task 20: Identify Products Ordered Multiple Times
-- Business Question:
-- Which products have been ordered more than once?

SELECT
    product_id,
    COUNT(*) AS order_count
FROM order_items
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Task 21: Identify Categories With Unusual Order Counts
-- Business Question:
-- Which product categories have unusually high order activity?

SELECT
    products.category,
    COUNT(DISTINCT order_items.order_id) AS order_count
FROM products
JOIN order_items
    ON order_items.product_id = products.product_id
GROUP BY products.category
HAVING COUNT(DISTINCT order_items.order_id) > 1;

-- Task 22: Identify Customers With Unusually High Order Activity
-- Business Question:
-- Which customers have placed an unusually high number of orders?

SELECT
    customer_id,
    COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 3;

-- Task 23: Identify Repeated Order/Product Combinations
-- Business Question:
-- Which products appear more than once within the same order?

SELECT
    order_id,
    product_id,
    COUNT(*) AS order_count
FROM order_items
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;
