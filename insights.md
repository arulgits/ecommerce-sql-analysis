# E-Commerce SQL Analysis — Key Insights

This document summarizes the key findings from the e-commerce SQL analysis project.

The analysis focuses on successful sales, product performance, customer purchasing behavior, monthly sales trends, repeat purchasers, and data quality.

> Successful sales are defined as orders with `delivered` or `shipped` status.

## 1. Order Status Overview

The dataset contains **150 distinct orders**.

| Order Type                           |  Orders |
| ------------------------------------ | ------: |
| Successful (`delivered` + `shipped`) |     104 |
| Other statuses                       |      46 |
| **Total**                            | **150** |

### Finding

Out of 150 distinct orders, **104 were classified as successful sales** based on the project's `delivered` and `shipped` status definition.

## 2. Monthly Successful Sales

Successful-sales revenue was calculated monthly from January 2024 through November 2025.

| Metric                         |                     Result |
| ------------------------------ | -------------------------: |
| Total successful-sales revenue |              ₹1,073,119.00 |
| Highest monthly revenue        | ₹78,453.00 — November 2025 |
| Lowest monthly revenue         |     ₹11,384.00 — July 2025 |

### Finding

Successful-sales revenue accumulated to **₹1,073,119.00** across the analyzed period.

Monthly revenue varied considerably. The highest monthly revenue occurred in **November 2025 (₹78,453.00)**, while the lowest occurred in **July 2025 (₹11,384.00)**.

The running-total analysis shows how monthly successful-sales revenue accumulated over time, reaching **₹994,666.00 by October 2025** and **₹1,073,119.00 by November 2025**.

## 3. Top 5 Products by Revenue

The top 5 products by successful-sales revenue were:

| Product                     | Successful Revenue |
| --------------------------- | -----------------: |
| Running Shoes               |        ₹111,960.00 |
| Smartwatch Lite             |         ₹97,972.00 |
| Noise Cancelling Headphones |         ₹95,984.00 |
| Mechanical Keyboard         |         ₹89,964.00 |
| Power Bank 10000mAh         |         ₹64,764.00 |

### Finding

**Running Shoes** generated the highest successful-sales revenue at **₹111,960.00**.

The other top-performing products were **Smartwatch Lite**, **Noise Cancelling Headphones**, **Mechanical Keyboard**, and **Power Bank 10000mAh**.

These results show that successful-sales revenue was concentrated among a small group of high-revenue products.

## 4. Repeat Purchasers

A repeat purchaser is defined as a customer with **2 or more successful orders**.

Based on this definition:

| Metric                                    | Result |
| ----------------------------------------- | -----: |
| Customers with successful purchases       |     34 |
| Customers classified as repeat purchasers |     34 |
| Minimum successful orders                 |      2 |
| Maximum successful orders                 |      5 |

### Finding

All **34 customers with successful purchases** qualified as repeat purchasers because each had at least **2 successful orders**.

Successful order counts ranged from **2 to 5 orders per customer**. **Customer 16** had the highest number of successful orders, with **5 orders**.

## 5. Data Quality & Treatment

The analysis included several data-quality considerations and defined clear rules for handling them.

### Data Treatment Rules

* **Successful sales:** Orders with `delivered` or `shipped` status are treated as successful sales.
* **Excluded statuses:** `cancelled`, `returned`, and `processing` orders are excluded from successful-sales calculations.
* **Status inconsistencies:** Different capitalization and spacing in order statuses are handled using `UPPER()` and `TRIM()`.
* **Missing prices:** Missing order-item prices are handled using `COALESCE()` with the corresponding product price.
* **Duplicate-looking records:** Records are not automatically deleted unless they meet the duplicate criteria established during the data-cleaning process.

### Finding

Defining these rules before analysis helps keep the business calculations consistent and makes the treatment of messy records transparent.
