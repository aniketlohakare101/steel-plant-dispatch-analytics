"""Reproducible EDA for the steel-plant dispatch register.
Run from repository root: python python/dispatch_eda.py
"""
from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "dispatch_data.csv"
OUT = ROOT / "outputs"
OUT.mkdir(exist_ok=True)

df = pd.read_csv(DATA)
df["Production Date"] = pd.to_datetime(df["Production Date"], errors="coerce")
numeric_cols = [
    "Qty/Weight (t)", "Pieces", "UPR (Rs/t)", "NSR (Rs/t)",
    "Freight (Rs/t)", "Discount (Rs/t)", "Dispatch Value (Rs)",
    "Thickness", "Width"
]
for col in numeric_cols:
    df[col] = pd.to_numeric(df[col], errors="coerce")

# Basic validation profile
profile = pd.DataFrame({
    "dtype": df.dtypes.astype(str),
    "missing_count": df.isna().sum(),
    "missing_pct": (df.isna().mean() * 100).round(2),
    "distinct_values": df.nunique(dropna=True)
})
profile.to_csv(OUT / "data_quality_profile.csv")

# Core KPIs
qty = df["Qty/Weight (t)"].sum()
value = df["Dispatch Value (Rs)"].sum()
kpis = pd.DataFrame([{
    "total_dispatch_mt": qty,
    "dispatch_value_rs": value,
    "dispatch_lines": len(df),
    "unique_customers": df["Customer Name"].nunique(),
    "unique_sales_orders": df["Sales Order"].nunique(),
    "date_min": df["Production Date"].min(),
    "date_max": df["Production Date"].max()
}])
kpis.to_csv(OUT / "headline_kpis.csv", index=False)

# Monthly summary
df["Year-Month"] = df["Production Date"].dt.to_period("M").astype(str)
monthly = (df.groupby("Year-Month", dropna=False)
           .agg(dispatch_mt=("Qty/Weight (t)", "sum"),
                dispatch_value_rs=("Dispatch Value (Rs)", "sum"),
                dispatch_lines=("Production Date", "size"))
           .reset_index())
monthly.to_csv(OUT / "monthly_dispatch.csv", index=False)

# Weighted rates: denominator uses tonnes for rows with both rate and quantity.
def weighted_rate(group, rate_col):
    valid = group[[rate_col, "Qty/Weight (t)"]].dropna()
    valid = valid[valid["Qty/Weight (t)"] > 0]
    if valid.empty:
        return float("nan")
    return (valid[rate_col] * valid["Qty/Weight (t)"]).sum() / valid["Qty/Weight (t)"].sum()

for col, name in [
    ("NSR (Rs/t)", "weighted_nsr_rs_per_t"),
    ("UPR (Rs/t)", "weighted_upr_rs_per_t"),
    ("Freight (Rs/t)", "weighted_freight_rs_per_t"),
    ("Discount (Rs/t)", "weighted_discount_rs_per_t"),
]:
    kpis[name] = weighted_rate(df, col)
kpis.to_csv(OUT / "headline_kpis.csv", index=False)

# Category summaries
for field, filename in [
    ("FG Product", "product_summary.csv"),
    ("Customer Name", "customer_summary.csv"),
    ("Destination", "destination_summary.csv"),
    ("Shift", "shift_summary.csv"),
    ("Quality", "quality_summary.csv"),
    ("Interval", "interval_summary.csv"),
]:
    summary = (df.groupby(field, dropna=False)
               .agg(dispatch_mt=("Qty/Weight (t)", "sum"),
                    dispatch_value_rs=("Dispatch Value (Rs)", "sum"),
                    dispatch_lines=("Production Date", "size"))
               .sort_values("dispatch_mt", ascending=False)
               .reset_index())
    summary.to_csv(OUT / filename, index=False)

# Charts (one chart per figure; default Matplotlib styling)
def save_bar(data, x, y, title, filename, horizontal=False, top_n=10):
    d = data.head(top_n).copy()
    fig, ax = plt.subplots(figsize=(10, 5))
    if horizontal:
        ax.barh(d[x].astype(str)[::-1], d[y][::-1])
        ax.set_xlabel(y.replace("_", " ").title())
    else:
        ax.bar(d[x].astype(str), d[y])
        ax.tick_params(axis="x", rotation=35)
        ax.set_ylabel(y.replace("_", " ").title())
    ax.set_title(title)
    fig.tight_layout()
    fig.savefig(OUT / filename, dpi=160)
    plt.close(fig)

save_bar(monthly.sort_values("Year-Month"), "Year-Month", "dispatch_mt",
         "Monthly Dispatch (MT)", "monthly_dispatch.png", top_n=len(monthly))
for field, filename, title in [
    ("FG Product", "product_dispatch.png", "Dispatch by Product (MT)"),
    ("Customer Name", "top_customers_dispatch.png", "Top Customers by Dispatch (MT)"),
    ("Destination", "destination_dispatch.png", "Dispatch by Destination (MT)"),
    ("Shift", "shift_dispatch.png", "Dispatch by Shift (MT)"),
]:
    s = (df.groupby(field, dropna=False)["Qty/Weight (t)"]
         .sum().sort_values(ascending=False).reset_index())
    save_bar(s, field, "Qty/Weight (t)", title, filename, horizontal=True)

print(f"Analysis complete. Outputs saved in: {OUT}")
print(kpis.to_string(index=False))
