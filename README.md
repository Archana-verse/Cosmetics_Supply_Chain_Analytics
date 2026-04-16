# Cosmetics Supply Chain Analytics
### End-to-End Business Intelligence Solution
**Tools:** Python | PostgreSQL | Power BI | pandas | matplotlib

---

## Project Overview

This project analyzes a cosmetics supply chain dataset to identify operational inefficiencies, supplier performance gaps, quality control issues, and stockout risks. The goal is to provide actionable business intelligence insights that enable more profitable and data-driven supply chain decisions.

This project was built to demonstrate end-to-end BI skills including data cleaning, SQL analysis, KPI development, and interactive dashboard design.

---

## Business Questions Answered

1. Which high-revenue SKUs are at risk of running out of stock?
2. Which suppliers have the best quality, speed, and reliability?
3. Which shipping carriers and routes are most cost-efficient?
4. Where are the biggest quality and defect rate problems?

---

## Dataset

- **Source:** Kaggle — Cosmetics Supply Chain Dataset
- **Size:** 100 SKUs, 24 columns
- **Fields:** Product type, SKU, Price, Revenue, Stock levels, Lead times, Supplier name, Defect rates, Inspection results, Shipping carriers, Manufacturing costs, Location, Routes, Transportation modes

---

## Tools & Technologies

| Tool | Purpose |
|------|---------|
| Python (pandas, matplotlib) | Data cleaning and exploratory analysis |
| PostgreSQL | SQL analysis and KPI aggregation |
| Power BI | Interactive dashboard and visualization |
| pgAdmin | Database management |
| GitHub | Version control and portfolio |

---

## Project Structure

```
cosmetics-supply-chain-analytics/
│
├── supply_chain_eda.py          # Python EDA script
├── supply_chain_postgresql.sql  # All SQL analysis queries
├── supply_chain_eda_charts.png  # EDA visualization output
├── Supply_Chain_Dashboard.pdf   # Power BI dashboard export
└── README.md                    # Project documentation
```

---

## Key Findings

### 1. Stockout Risk — 27% of SKUs at Risk
- 27 out of 100 SKUs have stock levels below 20 units
- **Critical:** SKU2 has revenue of $9,577 but only 1 unit in stock
- **Critical:** SKU31 has revenue of $9,655 but only 6 units in stock
- High-revenue SKUs with low stock represent significant revenue risk

### 2. Supplier Performance — Supplier 4 is a Quality Risk
- **Best quality:** Supplier 1 — lowest defect rate (1.804%), highest revenue ($157,529)
- **Worst quality:** Supplier 5 — highest defect rate (2.665%)
- **Biggest risk:** Supplier 4 — 12 out of 18 SKUs failed inspection (67% failure rate)
- **Fastest delivery:** Supplier 3 — average lead time 14.3 days, only 3 failed inspections

### 3. Quality Control — 36% Inspection Failure Rate
- 36 out of 100 SKUs failed quality inspection
- Overall average defect rate: 2.277%
- This represents a major quality control issue requiring immediate attention

### 4. Availability — Only 48.4% Average
- Products are available less than half the time on average
- Combined with 27% stockout risk, this points to a systemic inventory management problem

---

## Dashboard Pages

| Page | Content |
|------|---------|
| Executive Summary | 4 KPI cards, Revenue by product type, Stockout risk overview |
| Supplier Performance | Supplier scorecard, Defect rate comparison, Lead time vs defect scatter |
| Shipping & Quality | Carrier comparison, Inspection results breakdown, Defect by location |
| Stockout Risk | Revenue vs stock scatter, At-risk SKUs table, Risk by supplier |

---

## Business Recommendations

1. **Immediately restock** SKU2 and SKU31 — highest revenue SKUs with critically low stock
2. **Audit Supplier 4** — 67% inspection failure rate is unacceptable and needs immediate review
3. **Expand Supplier 3** — fastest delivery, fewest failed inspections, best overall reliability
4. **Investigate availability** — 48.4% average availability suggests systemic inventory planning gaps
5. **Review Supplier 5** — highest defect rate (2.665%) is impacting product quality

---

## How to Run

### Python EDA
```bash
pip install pandas matplotlib
python supply_chain_eda.py
```

### PostgreSQL Setup
```sql
-- Run in pgAdmin Query Tool
-- See supply_chain_postgresql.sql for all queries
```

### Power BI Dashboard
- Open Power BI Desktop
- Connect to PostgreSQL: localhost / supply_chain_db
- Load supply_chain table
- Open Supply_Chain_Dashboard.pbix

---

## Author
Built as a portfolio project demonstrating business intelligence and data analytics skills for healthcare and supply chain analytics roles.
