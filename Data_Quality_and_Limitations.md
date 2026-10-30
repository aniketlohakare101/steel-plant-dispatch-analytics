# Data Quality, KPI Definitions and Limitations

## Grain and scope
The working table has 1,255 dispatch-register rows. Treat each row as a dispatch line. A row is not guaranteed to represent a distinct order or a complete delivery event.

## KPI definitions
- **Total Dispatch (MT):** sum of `Qty/Weight (t)`.
- **Dispatch Value (Rs):** sum of row-level `Dispatch Value (Rs)`.
- **Dispatch Lines:** row count.
- **Active Customers:** distinct count of anonymised `Customer Name` in the selected filter context.
- **Unique Sales Orders:** distinct count of `Sales Order` in the selected filter context.
- **Weighted average rate:** sum(rate × dispatched tonnes) / sum(dispatched tonnes), excluding rows where rate or quantity is missing as appropriate.

## Checks to run before publishing
1. Confirm date parsing and date range.
2. Check blank dimensions and missing customer/product values.
3. Check negative, zero or implausibly large quantities and rates.
4. Reconcile total dispatch quantity/value with the authorised source report if available.
5. Verify whether the source `Total NSR` field is repeated at order level.
6. Confirm what `Interval` means with the data owner before using a time-based label.

## Limitations
- No promised delivery date + actual delivery date pair: OTIF/on-time delivery cannot be measured.
- No order-line ordered quantity vs delivered quantity pair: order fill rate cannot be measured reliably.
- No production plan vs actual production: plan adherence cannot be measured.
- No verified interval definition: do not describe it as delivery lead time.
- Dispatch data alone does not establish customer profitability, demand, inventory availability, or causal drivers.
- Shift-wise tonnage is dispatch recorded by shift, not worker productivity.
