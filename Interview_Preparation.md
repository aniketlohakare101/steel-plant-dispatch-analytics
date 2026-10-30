# Interview Preparation — Steel Plant Dispatch Analytics

Use the answers as a framework, not as a script to memorise. Replace bracketed observations with values you have personally verified from your final analysis and be ready to open the SQL/Python/Power BI work.

## 60–90 second project explanation

“I worked on an anonymised steel-plant dispatch-register dataset containing 1,255 records across May 2025 to July 2026. The objective was to convert operational dispatch data into useful views for dispatch and commercial review. I checked the data structure and missing values, used SQL to answer questions around monthly dispatch, product/customer/destination mix and shift distribution, and used Python for cleaning checks, KPI summaries and visual EDA. I also prepared a Power BI report design with an overview page, customer/product analysis and an operations/commercial page. One important part of the work was defining metrics carefully: I summed row-level dispatch value, used tonnage-weighted averages for rate fields, and avoided claiming OTIF because the dataset does not include promised and actual delivery dates.”

## Questions you should be able to answer

### Business and domain
1. What business problem were you solving?
2. Why does dispatch visibility matter in a steel plant?
3. What is the difference between production, sales order, dispatch and delivery?
4. How could dispatch analysis help PPIC, logistics and commercial teams?
5. What would you investigate if dispatch volume fell sharply in one month?

### Data and cleaning
6. What does one row represent in your dataset?
7. How did you handle missing thickness and width?
8. How did you check duplicate records? What would make a row a true duplicate?
9. Why did you keep the customer names anonymised?
10. How did you validate date and numeric data types?
11. What checks would you run for negative or unusually high dispatch quantities?

### SQL
12. Why use GROUP BY for product/customer summaries?
13. Difference between COUNT(*) and COUNT(DISTINCT customer)?
14. How would you find the top five customers by dispatch tonnage?
15. How would you calculate month-on-month dispatch change?
16. Why is NULLIF useful in a weighted-average denominator?
17. When would you use a window function such as LAG()?

### Python and statistics
18. Why did you use Pandas?
19. What is the difference between a Series and a DataFrame?
20. How did you decide which chart to use?
21. Why inspect distributions and outliers before drawing conclusions?
22. How would you compare dispatch mix across months?
23. What is the difference between correlation and causation?

### Power BI
24. What is a star schema?
25. Why create a separate Date table?
26. What is the difference between a calculated column and a measure?
27. What does filter context mean?
28. Why use a weighted-average DAX measure for NSR or freight?
29. How would you make the report useful to a plant manager?

### KPI judgement and limitations
30. Why did you not calculate OTIF?
31. Why should `Total NSR (source field)` not be summed?
32. Why can a simple average of rate values be misleading?
33. Does higher dispatch value necessarily mean higher profitability?
34. Does shift-wise dispatch tonnage measure labour productivity?
35. What additional data would you request to calculate OTIF?

## High-value technical explanations

### Why weighted average?
Suppose two dispatches have rates of ₹70,000/t for 2 tonnes and ₹80,000/t for 20 tonnes. The simple average is ₹75,000/t, which gives both lines equal influence. The tonnage-weighted average is:

`(70,000 × 2 + 80,000 × 20) / (2 + 20) = ₹79,090.91/t`

The weighted result better reflects the rate applied across the dispatched tonnes, assuming the row-level rate and quantity align.

### Why not OTIF?
OTIF requires at least an agreed promised delivery date, actual delivery/receipt date, and a clear order-line quantity/fulfilment definition. A dispatch register may show that material left the plant, but that alone does not prove it arrived on time and in full at the customer.

### What would you improve next?
- Obtain order-line commitment date, actual delivery date and ordered/delivered quantity to build a defensible OTIF view.
- Reconcile dispatch quantity and value with the official ERP extract.
- Confirm the business definition of `Interval`.
- Add inventory, production-plan and vehicle/transport data if the business question requires those views.
- Validate all KPI totals with the data owner before management use.

## Resume bullet (edit to reflect only work you personally completed)

“Analysed an anonymised steel-plant dispatch register (1,255 records) using SQL and Python to examine monthly dispatch trends, product/customer mix, destination and shift-wise movement; prepared Power BI measures and a three-page dashboard design with documented KPI definitions and data limitations.”

Do not claim quantified business impact, OTIF improvement, cost savings, predictive modelling or a deployed dashboard unless you actually completed and validated that work.
