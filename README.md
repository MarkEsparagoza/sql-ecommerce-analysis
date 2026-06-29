# SQL E-Commerce Analysis

A portfolio project demonstrating SQL-based data analysis on a simulated e-commerce dataset. This project mirrors real-world analytics work: answering business questions through structured queries, aggregations, and reporting.

---

## Business Questions Answered

1. What is the total revenue by product category?
2. Who are the top 10 customers by lifetime value?
3. What is the monthly revenue trend over the past year?
4. Which products have the highest return/refund rate?
5. What is the average order value by acquisition channel?
6. Which customers have not ordered in the last 90 days (churn risk)?

---

## Project Structure

```
sql-ecommerce-analysis/
├── README.md                  # Project overview
├── data/
│   └── ecommerce_sample.json    # Sample dataset (JSON)
└── queries/
    └── analysis.sql             # All SQL queries
```

---

## Tools Used

- **SQL** (PostgreSQL-compatible syntax)
- **JSON** for raw data representation
- **Excel / Power BI** for downstream visualization

---

## Key Findings (Sample)

- **Electronics** was the top revenue category at $142,300 in Q1
- Top 10 customers accounted for **28% of total revenue**
- Average order value was highest from **Email campaigns** at $87.40
- **15% of customers** showed churn risk (no purchase in 90+ days)

---

## How to Use

1. Load `data/ecommerce_sample.json` into your preferred SQL environment
2. Run queries from `queries/analysis.sql` sequentially
3. Each query is annotated with the business question it answers

---

*Part of my data analyst portfolio. Connect with me on [LinkedIn](https://linkedin.com/in/esparagoza-mark).*
