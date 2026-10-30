# Steel Plant Dispatch Analytics

**End-to-end analytics portfolio project | Excel · SQL · Python**

An analysis of an anonymised steel-plant dispatch register to understand dispatch volume, dispatch value, customer and product mix, destinations, shift-wise movement, and selected commercial rates.

## Business context
Steel dispatch teams need visibility into what was dispatched, to whom, where, and in what product/quality mix. This project converts a dispatch register into practical analysis that can support operational and commercial review.

The project is framed around a Production & Industrial Engineering / PPIC perspective: translating plant dispatch records into useful information for review meetings and follow-up questions.

## Questions explored
- How does dispatched tonnage change month by month?
- Which finished-goods products account for the largest dispatched tonnage?
- Which customers and destinations account for the largest dispatch volumes and values?
- How is dispatch distributed across shifts and recorded quality categories?
- How do recorded NSR, UPR, freight and discount rates vary when weighted by dispatched tonnes?
- What missing or unusual values should be checked before reporting?

## Dataset
- **Rows:** 1,255 dispatch records.
- **Period:** 19 May 2025 to 9 July 2026.
- **Grain:** one row represents a dispatch-register line; it is not necessarily one unique customer order.
- **Customer names:** anonymised as `Customer 001`, `Customer 002`, etc.
- **File:** `data/Dispatch_Data_PowerBI.csv` (the filename is retained for compatibility with the original prepared extract; no Power BI work is included in this version).

## Tools and workflow

| Tool | Work |
|---|---|
| Excel | Source-data review, calculations, summaries and dashboard-oriented analysis. |
| SQL | Business questions and aggregations in SQLite-compatible SQL. |
| Python | Reproducible data checks, KPI summaries and exploratory charts. |

## Repository structure

```text
steel-plant-dispatch-analytics/
├── data/
│   └── Dispatch_Data_PowerBI.csv
├── sql/
│   └── dispatch_analysis.sql
├── python/
│   └── dispatch_eda.py
├── notebooks/
│   └── dispatch_eda.ipynb
├── docs/
│   ├── Data_Dictionary.md
│   ├── Data_Quality_and_Limitations.md
│   ├── Interview_Preparation.md
│   └── Project_Status.md
├── requirements.txt
└── README.md
```

## Run the Python analysis

```bash
git clone <your-repository-url>
cd steel-plant-dispatch-analytics
python -m pip install -r requirements.txt
python python/dispatch_eda.py
```

The script reads the CSV from `data/` and writes summary tables and charts to `outputs/`. Run it from the repository root.

## Run the SQL analysis

Import `data/Dispatch_Data_PowerBI.csv` into a SQLite-compatible tool as a table named `dispatch`, then execute `sql/dispatch_analysis.sql`. The queries are labelled by business question.

## Analytical choices
- Dispatch value is calculated by summing the row-level `Dispatch Value (Rs)` field.
- `Total NSR (source field)` is not summed because it can repeat at sales-order level.
- NSR, UPR, freight and discount are represented as **tonnage-weighted averages**, not simple averages.
- Missing thickness/width values are retained as missing; no unsupported imputation is performed.
- Customer and destination rankings describe dispatch recorded in this extract, not customer profitability or market share.

## What this dataset cannot prove
This is a dispatch register, not a complete order-commitment and delivery-confirmation dataset. It does not independently establish promised delivery dates, actual delivery completion dates, planned production quantities, or customer acceptance. Therefore, **OTIF, on-time delivery, order fill rate, production-plan adherence and true order lead time are not calculated**. The meaning of the `Interval` field has not been independently verified, so it is treated as a source category only.

## Interview preparation
Explain the business question first, then the data grain, cleaning decisions, KPI definitions, key patterns you found, and limitations. Be ready to explain why weighted averages are more suitable than simple averages for rate fields when dispatch quantities differ. See `docs/Interview_Preparation.md`.

## Responsible sharing
Before making this repository public, confirm that you have permission to publish the anonymised extract and derived outputs. Anonymisation of customer names does not automatically mean the underlying operational data is approved for public release. If permission is not available, keep the repository private or replace the source with a synthetic dataset that preserves the structure but not the real business records.
