-- EVSL Supply Chain & Dispatch Analytics | MySQL 8.0+
-- Run queries individually after selecting the EVSL_Supply_Chain database.
-- The source date field is production_date; confirm its business meaning.
-- This dispatch-only dataset does not independently support OTIF or inventory turnover.

USE EVSL_Supply_Chain;

-- Q1. Overall dispatch performance
SELECT COUNT(*) AS total_records,
       ROUND(SUM(quantity_t),2) AS total_dispatch_tonnes,
       ROUND(AVG(quantity_t),2) AS average_tonnes_per_record
FROM dispatch;

-- Q2. Monthly dispatch trend
SELECT DATE_FORMAT(production_date,'%Y-%m') AS month,
       ROUND(SUM(quantity_t),2) AS dispatch_tonnes
FROM dispatch
GROUP BY DATE_FORMAT(production_date,'%Y-%m')
ORDER BY month;

-- Q3. Top 10 customers
SELECT customer_name, ROUND(SUM(quantity_t),2) AS dispatch_tonnes
FROM dispatch
GROUP BY customer_name
ORDER BY dispatch_tonnes DESC
LIMIT 10;

-- Q4. Product-wise dispatch
SELECT fg_product, ROUND(SUM(quantity_t),2) AS dispatch_tonnes
FROM dispatch
GROUP BY fg_product
ORDER BY dispatch_tonnes DESC;

-- Q5. Top 10 destinations
SELECT destination, ROUND(SUM(quantity_t),2) AS dispatch_tonnes
FROM dispatch
GROUP BY destination
ORDER BY dispatch_tonnes DESC
LIMIT 10;

-- Q6. Quality-wise dispatch mix
SELECT quality, ROUND(SUM(quantity_t),2) AS dispatch_tonnes,
       COUNT(*) AS records
FROM dispatch
GROUP BY quality
ORDER BY dispatch_tonnes DESC;

-- Q7. Shift-wise dispatch
SELECT shift_code, ROUND(SUM(quantity_t),2) AS dispatch_tonnes
FROM dispatch
GROUP BY shift_code
ORDER BY dispatch_tonnes DESC;

-- Q8. Weighted average NSR (Rs/tonne)
SELECT ROUND(SUM(nsr_rs_per_t * quantity_t) /
             NULLIF(SUM(quantity_t),0),2) AS weighted_average_nsr_rs_per_t
FROM dispatch;

-- Q9. Customer contribution
SELECT customer_name,
       ROUND(SUM(quantity_t),2) AS customer_dispatch_tonnes,
       ROUND(100.0 * SUM(quantity_t) /
             NULLIF((SELECT SUM(quantity_t) FROM dispatch),0),2) AS contribution_pct
FROM dispatch
GROUP BY customer_name
ORDER BY customer_dispatch_tonnes DESC;

-- Q10. Month-over-month dispatch growth
WITH monthly AS (
    SELECT DATE_FORMAT(production_date,'%Y-%m') AS month,
           SUM(quantity_t) AS dispatch_tonnes
    FROM dispatch
    GROUP BY DATE_FORMAT(production_date,'%Y-%m')
),
comparison AS (
    SELECT month, dispatch_tonnes,
           LAG(dispatch_tonnes) OVER (ORDER BY month) AS previous_month_tonnes
    FROM monthly
)
SELECT month,
       ROUND(dispatch_tonnes,2) AS current_month_tonnes,
       ROUND(previous_month_tonnes,2) AS previous_month_tonnes,
       ROUND(100.0 * (dispatch_tonnes-previous_month_tonnes) /
             NULLIF(previous_month_tonnes,0),2) AS growth_pct
FROM comparison
ORDER BY month;

-- Q11. Rank customers using DENSE_RANK
WITH customer_totals AS (
    SELECT customer_name, SUM(quantity_t) AS dispatch_tonnes
    FROM dispatch
    GROUP BY customer_name
)
SELECT customer_name, ROUND(dispatch_tonnes,2) AS dispatch_tonnes,
       DENSE_RANK() OVER (ORDER BY dispatch_tonnes DESC) AS customer_rank
FROM customer_totals
ORDER BY customer_rank, customer_name;

-- Q12. Customer cumulative contribution / Pareto analysis
WITH customer_totals AS (
    SELECT customer_name, SUM(quantity_t) AS dispatch_tonnes
    FROM dispatch
    GROUP BY customer_name
),
cumulative AS (
    SELECT customer_name, dispatch_tonnes,
           SUM(dispatch_tonnes) OVER () AS grand_total,
           SUM(dispatch_tonnes) OVER (
               ORDER BY dispatch_tonnes DESC, customer_name
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ) AS cumulative_tonnes
    FROM customer_totals
)
SELECT customer_name,
       ROUND(dispatch_tonnes,2) AS dispatch_tonnes,
       ROUND(100.0*dispatch_tonnes/NULLIF(grand_total,0),2) AS contribution_pct,
       ROUND(100.0*cumulative_tonnes/NULLIF(grand_total,0),2) AS cumulative_pct
FROM cumulative
ORDER BY dispatch_tonnes DESC, customer_name;
