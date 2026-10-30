-- Steel Plant Dispatch Analytics
-- Import data/Dispatch_Data_PowerBI.csv into SQLite as table: dispatch
-- Column names with spaces/symbols are quoted with double quotes.

-- Q1. Overall dispatch KPIs
SELECT
    ROUND(SUM("Qty/Weight (t)"), 2) AS total_dispatch_mt,
    ROUND(SUM("Dispatch Value (Rs)"), 2) AS total_dispatch_value_rs,
    COUNT(*) AS dispatch_lines,
    COUNT(DISTINCT "Customer Name") AS unique_customers,
    COUNT(DISTINCT "Sales Order") AS unique_sales_orders
FROM dispatch;

-- Q2. Monthly dispatch trend
SELECT
    "Year-Month" AS year_month,
    ROUND(SUM("Qty/Weight (t)"), 2) AS dispatch_mt,
    ROUND(SUM("Dispatch Value (Rs)"), 2) AS dispatch_value_rs
FROM dispatch
GROUP BY "Year-Month"
ORDER BY "Year-Month";

-- Q3. Product-wise dispatch
SELECT
    "FG Product" AS product,
    ROUND(SUM("Qty/Weight (t)"), 2) AS dispatch_mt,
    COUNT(*) AS dispatch_lines
FROM dispatch
GROUP BY "FG Product"
ORDER BY dispatch_mt DESC;

-- Q4. Top 10 customers by dispatched tonnage
SELECT
    "Customer Name" AS customer,
    ROUND(SUM("Qty/Weight (t)"), 2) AS dispatch_mt,
    ROUND(SUM("Dispatch Value (Rs)"), 2) AS dispatch_value_rs
FROM dispatch
GROUP BY "Customer Name"
ORDER BY dispatch_mt DESC
LIMIT 10;

-- Q5. Destination-wise dispatch
SELECT
    "Destination" AS destination,
    ROUND(SUM("Qty/Weight (t)"), 2) AS dispatch_mt
FROM dispatch
GROUP BY "Destination"
ORDER BY dispatch_mt DESC;

-- Q6. Shift-wise dispatch
SELECT
    "Shift" AS shift,
    ROUND(SUM("Qty/Weight (t)"), 2) AS dispatch_mt,
    COUNT(*) AS dispatch_lines
FROM dispatch
GROUP BY "Shift"
ORDER BY dispatch_mt DESC;

-- Q7. Quality-wise dispatch
SELECT
    "Quality" AS quality,
    ROUND(SUM("Qty/Weight (t)"), 2) AS dispatch_mt
FROM dispatch
GROUP BY "Quality"
ORDER BY dispatch_mt DESC;

-- Q8. Weighted commercial rates by product.
-- Weight each rate by dispatched tonnes; avoid an unweighted AVG().
SELECT
    "FG Product" AS product,
    ROUND(SUM("NSR (Rs/t)" * "Qty/Weight (t)") /
          NULLIF(SUM("Qty/Weight (t)"), 0), 2) AS weighted_nsr_rs_per_t,
    ROUND(SUM("UPR (Rs/t)" * "Qty/Weight (t)") /
          NULLIF(SUM("Qty/Weight (t)"), 0), 2) AS weighted_upr_rs_per_t,
    ROUND(SUM("Freight (Rs/t)" * "Qty/Weight (t)") /
          NULLIF(SUM("Qty/Weight (t)"), 0), 2) AS weighted_freight_rs_per_t
FROM dispatch
GROUP BY "FG Product"
ORDER BY product;

-- Q9. Monthly shift-wise dispatch
SELECT
    "Year-Month" AS year_month,
    "Shift" AS shift,
    ROUND(SUM("Qty/Weight (t)"), 2) AS dispatch_mt
FROM dispatch
GROUP BY "Year-Month", "Shift"
ORDER BY "Year-Month", "Shift";

-- Q10. Data-quality checks: missing operational dimensions
SELECT
    SUM(CASE WHEN "Thickness" IS NULL THEN 1 ELSE 0 END) AS missing_thickness,
    SUM(CASE WHEN "Width" IS NULL THEN 1 ELSE 0 END) AS missing_width,
    SUM(CASE WHEN "Customer Name" IS NULL OR TRIM("Customer Name") = '' THEN 1 ELSE 0 END) AS missing_customer,
    SUM(CASE WHEN "Qty/Weight (t)" IS NULL THEN 1 ELSE 0 END) AS missing_quantity
FROM dispatch;

-- Q11. Dispatch lines by recorded interval category.
-- Treat Interval as a source category; do not label it lead time without confirmation.
SELECT
    "Interval" AS interval_category,
    COUNT(*) AS dispatch_lines,
    ROUND(SUM("Qty/Weight (t)"), 2) AS dispatch_mt
FROM dispatch
GROUP BY "Interval"
ORDER BY dispatch_lines DESC;

-- Q12. Diversion reason distribution
SELECT
    "Diversion Reason" AS diversion_reason,
    COUNT(*) AS dispatch_lines,
    ROUND(SUM("Qty/Weight (t)"), 2) AS dispatch_mt
FROM dispatch
GROUP BY "Diversion Reason"
ORDER BY dispatch_lines DESC;
