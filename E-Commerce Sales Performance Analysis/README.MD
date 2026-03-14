# 🛒 E-Commerce Sales Performance Analysis
### A SQL Portfolio Project | PostgreSQL · Tableau · Data Cleaning ·Visualization . Business Intelligence

---

## 📋 Project Overview

This project simulates the workflow of a junior data analyst at a mid-sized e-commerce company. Given 6 months of raw transactional data across 100,000+ records, the goal was to clean the data, identify data quality issues, and answer 18 real business questions ahead of a quarterly review.

The project is structured across three phases:

| Phase | Name | Focus |
|-------|------|-------|
| 1 | Data Cleaning | Identifying and handling dirty, missing, and invalid records |
| 2 | Business KPIs | Revenue trends, customer value, product performance |
| 3 | Deeper Insights | Churn detection, growth analysis, inventory health |

---

## 🗂️ Dataset

The dataset was synthetically generated to mirror real e-commerce transaction data, with intentional data quality issues seeded in for the cleaning phase.

| Table | Rows | Description |
|-------|------|-------------|
| `customers` | 5,000 | Registered customers with signup date and country |
| `products` | 200 | Product catalogue across 10 categories |
| `orders` | 45,000 | Orders placed throughout 2023 with status |
| `order_items` | 100,000 | Individual line items linking orders to products |

### Schema

```
customers
  └── customer_id (PK)
  └── first_name, last_name, email, country, signup_date

products
  └── product_id (PK)
  └── name, category, price, stock_quantity

orders
  └── order_id (PK)
  └── customer_id (FK → customers)
  └── order_date, status

order_items
  └── item_id (PK)
  └── order_id (FK → orders)
  └── product_id (FK → products)
  └── quantity, unit_price
```

### Intentional Data Quality Issues (for cleaning exercise)
- ~50 duplicate customer email addresses
- ~100 orders with invalid or missing status values
- ~10 products with a price of $0.00
- ~200 order items with negative unit prices

---

## ❓ Business Questions Answered

### Phase 1 — Data Quality
1. Are there duplicate customers in our system (same email, multiple IDs)?
2. Do we have orders with invalid or missing statuses?
3. Are there order items with zero or negative prices?
4. Which customers have never placed an order?

### Phase 2 — Revenue & Performance
5. What is our total revenue for 2023, broken down by month?
6. What is our Average Order Value (AOV) overall and by country?
7. Which product categories generate the most revenue?
8. Who are our top 10 highest-spending customers?
9. What is our return and cancellation rate by category?

### Phase 3 — Deeper Insights
10. Which customers haven't ordered in 90+ days (churn risk)?
11. What is the month-over-month revenue growth rate?
12. Which are the top 10 best-selling products by revenue?
13. Which products have high stock but low sales (dead inventory)?

---

## 🔑 Key Findings

- **Peak revenue month** was July 2023, with December close behind, driven by seasonal demand
- **Electronics** was the highest-revenue category, accounting for over 22% of total completed order value
- **Average Order Value** varied significantly by country, with AU and DE customers spending ~18% more per order than US customers
- **Churn risk** affected approximately 31% of active customers who had not purchased in 90+ days by year end
- **Return rate** was highest in the Clothing category at ~14%, compared to a 9% overall average

---

## 📁 Project Structure

```
ecommerce-sql-analysis/
│
├── README.md
│
├── data/
│   ├── ecommerce.db          # PostgreSQL database (all 4 tables)
│   ├── customers.csv
│   ├── products.csv
│   ├── orders.csv
│   └── order_items.csv
│
├── queries/
│   ├── phase1_data_cleaning.sql
│   ├── phase2_business_kpis.sql
│   └── phase3_deeper_insights.sql
│
└── visuals/
    ├── monthly_revenue.png
    ├── revenue_by_category.png
    └── top_customers.png
```

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| **PostgreSQL** | Primary database and query engine |
| **Tableau** | Data loading, additional analysis, and chart generation |
| **GitHub** | Version control and portfolio hosting |

---
## Visualization(Dashboard)

https://public.tableau.com/views/E-COMMERCESALESPERFORMANCEDASHBOARD_17734629550190/E-COMMERCESALESPERFORMANCEDASHBOARD2023?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

---
## 💡 What I Learned

- How to audit a real-world dataset for quality issues before running any analysis
- Writing subqueries and aggregations to answer layered business questions
- Using `LAG()` window functions for period-over-period comparisons
- Thinking about data in terms of business impact, not just query output
- Structuring a SQL project for a professional portfolio

---

## 📬 Contact 
chophilip7@gmail.com

Feel free to connect if you have questions about this project or want to collaborate.

> *This dataset was synthetically generated for portfolio purposes. Any resemblance to real customer or transaction data is coincidental.*
