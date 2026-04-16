import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import warnings
warnings.filterwarnings("ignore")

df = pd.read_csv("supply_chain_data.csv")   # <-- change to your filename

df.columns = df.columns.str.strip().str.lower().str.replace(" ", "_")

print("=" * 55)
print("COSMETICS SUPPLY CHAIN — INITIAL EXPLORATION")
print("=" * 55)

print(f"\nRows: {df.shape[0]}  |  Columns: {df.shape[1]}")
print("\nColumn names and dtypes:")
print(df.dtypes)

print("\n--- Missing Values ---")
missing = df.isnull().sum()
print(missing[missing >= 0])          # show all (yours has none)

print("\n--- Descriptive Statistics ---")
print(df.describe(include="all").T)

print("\n--- Product Type Breakdown ---")
print(df["product_type"].value_counts())

print("\n--- Key Business KPIs ---")
print(f"Total Revenue:           ${df['revenue_generated'].sum():,.2f}")
print(f"Avg Revenue per SKU:     ${df['revenue_generated'].mean():,.2f}")
print(f"Total Units Sold:        {df['number_of_products_sold'].sum():,}")
print(f"Avg Lead Time:           {df['lead_times'].mean():.1f} days")
print(f"Max Lead Time:           {df['lead_times'].max()} days")
print(f"Min Lead Time:           {df['lead_times'].min()} days")
print(f"Avg Stock Level:         {df['stock_levels'].mean():.1f}")
print(f"SKUs with Stock < 10:    {(df['stock_levels'] < 10).sum()}  ← stockout risk")
print(f"Avg Availability:        {df['availability'].mean():.1f}%")

print("\n--- Revenue by Product Type ---")
rev_by_type = df.groupby("product_type")["revenue_generated"].agg(["sum", "mean", "count"])
rev_by_type.columns = ["total_revenue", "avg_revenue", "sku_count"]
rev_by_type = rev_by_type.sort_values("total_revenue", ascending=False)
print(rev_by_type)

print("\n--- Lead Time Risk Segmentation ---")
def lead_risk(days):
    if days <= 7:   return "Low (≤7 days)"
    elif days <= 15: return "Medium (8–15 days)"
    else:            return "High (>15 days)"

df["lead_time_risk"] = df["lead_times"].apply(lead_risk)
print(df["lead_time_risk"].value_counts())

df["stockout_risk"] = df["stock_levels"].apply(
    lambda x: "At Risk" if x < 20 else "Healthy"
)
print("\n--- Stockout Risk Flags ---")
print(df["stockout_risk"].value_counts())

print("\n--- Top 10 SKUs by Revenue ---")
top_skus = df[["sku", "product_type", "revenue_generated",
               "number_of_products_sold", "stock_levels", "lead_times"]]\
             .sort_values("revenue_generated", ascending=False).head(10)
print(top_skus.to_string(index=False))

print("\n--- Correlation Matrix (numeric columns) ---")
numeric_cols = ["price", "availability", "number_of_products_sold",
                "revenue_generated", "stock_levels", "lead_times", "order_quantities"]
print(df[numeric_cols].corr().round(2))

fig = plt.figure(figsize=(16, 12))
fig.suptitle("Cosmetics Supply Chain — Exploratory Analysis",
             fontsize=16, fontweight="bold", y=0.98)
gs = gridspec.GridSpec(3, 3, figure=fig, hspace=0.45, wspace=0.35)

ax1 = fig.add_subplot(gs[0, 0])
rev_by_type["total_revenue"].plot(kind="bar", ax=ax1, color=["#7F77DD","#1D9E75","#D85A30"])
ax1.set_title("Total Revenue by Product Type", fontsize=11)
ax1.set_xlabel("")
ax1.set_ylabel("Revenue ($)")
ax1.tick_params(axis="x", rotation=20)
for p in ax1.patches:
    ax1.annotate(f"${p.get_height():,.0f}",
                 (p.get_x() + p.get_width()/2, p.get_height()),
                 ha="center", va="bottom", fontsize=8)

ax2 = fig.add_subplot(gs[0, 1])
ax2.hist(df["lead_times"], bins=10, color="#7F77DD", edgecolor="white")
ax2.axvline(df["lead_times"].mean(), color="#D85A30", linestyle="--",
            linewidth=1.5, label=f"Mean: {df['lead_times'].mean():.1f}d")
ax2.set_title("Lead Time Distribution", fontsize=11)
ax2.set_xlabel("Days")
ax2.set_ylabel("Count")
ax2.legend(fontsize=8)

ax3 = fig.add_subplot(gs[0, 2])
ax3.hist(df["stock_levels"], bins=10, color="#1D9E75", edgecolor="white")
ax3.axvline(20, color="#D85A30", linestyle="--", linewidth=1.5, label="Risk threshold (20)")
ax3.set_title("Stock Levels Distribution", fontsize=11)
ax3.set_xlabel("Stock Level")
ax3.set_ylabel("Count")
ax3.legend(fontsize=8)

ax4 = fig.add_subplot(gs[1, 0])
colors_map = {"skincare": "#7F77DD", "haircare": "#1D9E75", "cosmetics": "#D85A30"}
for ptype in df["product_type"].unique():
    mask = df["product_type"] == ptype
    ax4.scatter(df.loc[mask, "number_of_products_sold"],
                df.loc[mask, "revenue_generated"],
                label=ptype, alpha=0.7, s=50,
                color=colors_map.get(ptype, "#888780"))
ax4.set_title("Revenue vs Units Sold", fontsize=11)
ax4.set_xlabel("Units Sold")
ax4.set_ylabel("Revenue ($)")
ax4.legend(fontsize=8)

ax5 = fig.add_subplot(gs[1, 1])
risk_counts = df["lead_time_risk"].value_counts()
ax5.pie(risk_counts, labels=risk_counts.index, autopct="%1.0f%%",
        colors=["#1D9E75", "#EF9F27", "#E24B4A"], startangle=90)
ax5.set_title("Lead Time Risk Segments", fontsize=11)

ax6 = fig.add_subplot(gs[1, 2])
stockout_counts = df["stockout_risk"].value_counts()
stockout_counts.plot(kind="bar", ax=ax6,
                     color=["#E24B4A" if x == "At Risk" else "#1D9E75"
                            for x in stockout_counts.index])
ax6.set_title("Stockout Risk Status", fontsize=11)
ax6.set_xlabel("")
ax6.set_ylabel("SKU Count")
ax6.tick_params(axis="x", rotation=0)
for p in ax6.patches:
    ax6.annotate(str(int(p.get_height())),
                 (p.get_x() + p.get_width()/2, p.get_height()),
                 ha="center", va="bottom", fontsize=10, fontweight="bold")

ax7 = fig.add_subplot(gs[2, 0])
ax7.scatter(df["price"], df["revenue_generated"], color="#534AB7", alpha=0.6, s=50)
ax7.set_title("Price vs Revenue", fontsize=11)
ax7.set_xlabel("Price ($)")
ax7.set_ylabel("Revenue ($)")

ax8 = fig.add_subplot(gs[2, 1])
ax8.scatter(df["availability"], df["stock_levels"], color="#0F6E56", alpha=0.6, s=50)
ax8.set_title("Availability vs Stock Levels", fontsize=11)
ax8.set_xlabel("Availability (%)")
ax8.set_ylabel("Stock Level")

ax9 = fig.add_subplot(gs[2, 2])
ax9.scatter(df["order_quantities"], df["lead_times"], color="#993C1D", alpha=0.6, s=50)
ax9.set_title("Order Qty vs Lead Time", fontsize=11)
ax9.set_xlabel("Order Quantity")
ax9.set_ylabel("Lead Time (days)")

plt.savefig("supply_chain_eda_charts.png", dpi=150, bbox_inches="tight")
plt.show()
print("\nCharts saved as supply_chain_eda_charts.png")

df.to_csv("supply_chain_cleaned.csv", index=False)
print("Cleaned data exported to supply_chain_cleaned.csv")
print("\nPhase 1 complete. Next step: SQL analysis (Phase 3)")
