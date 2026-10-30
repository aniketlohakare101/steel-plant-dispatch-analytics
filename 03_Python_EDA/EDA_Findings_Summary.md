# EVSL Dispatch Dataset – EDA Summary

## Dataset overview
- Records: **1,255**
- Columns: **20**
- Date field range: **2025-05-19 to 2026-07-09**
- Distinct customers: **109**
- Distinct product labels: **17**
- Distinct destinations: **76**

## Core metrics
- Total recorded dispatch quantity: **4,272.47 tonnes**
- Average dispatch line quantity: **3.40 tonnes**
- Median dispatch line quantity: **2.64 tonnes**
- Weighted average NSR: **Rs 64,119.81/tonne**
- Calculated line-level dispatch value (NSR × quantity): **Rs 273,950,203.05**

## Initial observations
- Highest-volume month in the available date field: **2026-07** (2,453.93 tonnes).
- Highest-volume customer: **Customer 039** (320.29 tonnes).
- Top two customers together account for **13.96%** of total recorded dispatch quantity.
- Customers needed to reach/cross 80% cumulative dispatch: **40**.
- Highest-volume product label: **HR CTL** (1,713.07 tonnes).
- Highest-volume destination: **PUNE** (390.74 tonnes).

## Data quality and interpretation cautions
- Missing values: Thickness = 1, Width = 1.
- The source `Total NSR (source field)` is excluded from additive revenue totals because it may repeat order-level amounts across dispatch lines.
- The date column is named `Production Date`; confirm its business meaning before describing the chart as dispatch-date performance.
- Quality category mix is not automatically a defect rate. A valid rejected/total quantity definition is needed.
- Statistical outliers are investigation flags, not automatic errors.

## What this dataset cannot establish
The workbook does not include committed delivery dates, actual delivery dates, inventory snapshots, stock movements, or production plan quantities. Therefore this dataset alone cannot produce reliable OTIF, delivery-delay, inventory-turnover, stock-out, or production-plan-adherence metrics.

## Confidentiality
Customer names are pseudonymised, but sales order references and financial/commercial data may remain sensitive. Obtain permission and further anonymise or simulate sensitive fields before publishing the raw dataset or notebook outputs publicly.
