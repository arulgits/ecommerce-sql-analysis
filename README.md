# E-Commerce SQL Analysis

A practical MySQL project analyzing e-commerce sales, products, and customer purchasing behavior through data cleaning, exploratory analysis, business analysis, and advanced SQL techniques.

## Project Overview

This project follows an end-to-end SQL analysis workflow:

1. Database setup
2. Data cleaning
3. Exploratory analysis
4. Business analysis
5. Advanced analysis

The goal is to transform raw e-commerce data into structured, business-focused insights using SQL.

## Database

**Database:** MySQL 8.0+

**Main tables:**

- `customers`
- `products`
- `orders`
- `order_items`

**Relationships:**

- `orders.customer_id` → `customers.customer_id`
- `order_items.order_id` → `orders.order_id`
- `order_items.product_id` → `products.product_id`

## Project Structure

| File | Description |
|---|---|
| `01_database_setup.sql` | Database and table setup |
| `02_data_cleaning.sql` | Data quality checks and cleaning |
| `03_exploratory_analysis.sql` | Initial exploration and validation |
| `04_business_analysis.sql` | Business-focused sales and customer analysis |
| `05_advanced_analysis.sql` | Advanced SQL techniques and analysis |

## SQL Techniques

- JOINs
- GROUP BY and HAVING
- Aggregate functions
- Subqueries
- CTEs
- Window functions
- `RANK()` / `DENSE_RANK()`
- Running totals
- `CASE`
- `COALESCE()`
- Date and string functions
- `UNION ALL`
- Data cleaning and validation

## Data Treatment

For successful-sales analysis:

- `delivered` and `shipped` orders are treated as successful sales.
- `cancelled`, `returned`, and `processing` orders are excluded from successful-sales calculations.
- Inconsistent status formatting is handled using `UPPER()` and `TRIM()`.
- Missing order-item prices are handled using `COALESCE()` with the corresponding product price.
- Duplicate-looking records are not automatically removed unless they meet the established duplicate criteria.

## Key Analysis Areas

The project covers:

- Product revenue and performance
- Customer purchasing behavior
- Monthly sales and running totals
- Product ranking within categories
- Customer purchase history
- Repeat purchasers
- Business comparisons
- Data-quality treatment

## How to Use

1. Install MySQL 8.0+.
2. Open `01_database_setup.sql` and create the database.
3. Run the SQL files in numerical order.
4. Review the queries and results in MySQL Workbench.

## Project Goal

This project demonstrates practical SQL skills by taking an e-commerce dataset from initial setup and cleaning through exploratory, business, and advanced analysis.
