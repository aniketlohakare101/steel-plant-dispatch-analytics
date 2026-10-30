# Data Dictionary

| Field | Meaning / treatment |
|---|---|
| Month | Source month label; use Production Date for chronological analysis. |
| Production Date | Date recorded for the dispatch line. |
| FG Product | Finished-goods product category. |
| Customer Name | Anonymised customer identifier. |
| Destination | Recorded destination. |
| Quality | Recorded product quality category. |
| Shift | Recorded shift category. |
| Interval | Source category; definition not independently verified. |
| Diversion Reason | Recorded diversion reason/category. |
| Sales Order | Sales-order reference; repeated across dispatch lines may occur. |
| Qty/Weight (t) | Dispatched quantity in tonnes. |
| Pieces | Recorded number of pieces. |
| UPR (Rs/t) | Recorded UPR rate per tonne. |
| NSR (Rs/t) | Recorded NSR rate per tonne. |
| Freight (Rs/t) | Recorded freight rate per tonne. |
| Discount (Rs/t) | Recorded discount rate per tonne. |
| Total NSR (source field) | Source total field; may repeat at order level, so do not sum blindly. |
| Dispatch Value (Rs) | Row-level dispatch value; sum this for total dispatch value. |
| Thickness / Width | Product dimensions; missing values remain blank. |
| Year / Month Number / Month Start / Year-Month | Reporting helper columns derived from Production Date. |
