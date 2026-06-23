# E-Commerce Marketplace Analytics Dashboard (Power BI + SQL)

## Project Overview

This project analyzes a real-world e-commerce marketplace dataset from Olist (Brazilian E-Commerce Dataset) using SQL and Power BI.

The objective was to transform raw transactional data into actionable business insights by analyzing customer behavior, product performance, seller performance, revenue trends, order fulfillment, and regional sales patterns.

The project follows a business-oriented analytics approach commonly used by Data Analysts to answer questions such as:

* Which product categories generate the highest revenue?
* Which cities and states contribute the most customers and sales?
* How has customer growth changed over time?
* Which sellers drive the majority of marketplace revenue?
* What are the key revenue and order trends across the business?

The final solution includes an interactive Power BI dashboard with Executive Overview, Customer Analytics, and Product & Seller Analytics pages supported by SQL-based business analysis.

## Dataset

**Dataset Name:** Brazilian E-Commerce Public Dataset by Olist

**Source:** Kaggle

The dataset contains information about customers, orders, products, sellers, payments, reviews, and product categories from a real-world e-commerce marketplace.

Key tables used:

* Customers
* Orders
* Order Items
* Products
* Sellers
* Payments
* Category Translation

---

## Tools & Technologies

* SQL (MySQL)
* Power BI
* Data Modeling
* DAX Measures
* Data Cleaning
* Business Analytics

---

## Dashboard Pages

### 1. Executive Overview

* Total Revenue
* Total Orders
* Total Customers
* Average Order Value (AOV)
* Delivery Performance
* Revenue & Order Trends

### 2. Customer Analytics

* Customer Growth Trend
* Repeat Customer Analysis
* Revenue per Customer
* Top Cities by Revenue
* Top Cities by Orders
* Top States by Customers

### 3. Product & Seller Analytics

* Product Category Performance
* Seller Performance
* Product Revenue Trends
* Product Order Trends
* Top Sellers by Revenue
* Revenue Contribution Analysis

## Key Business Insights

### Revenue Performance

* Total marketplace revenue exceeded **13.5 million**.
* Health & Beauty, Watches & Gifts, and Bed Bath & Table were the highest revenue-generating product categories.
* Revenue growth showed strong acceleration during 2017–2018, indicating rapid marketplace expansion.

### Customer Analytics

* The platform served approximately **96K unique customers**.
* Repeat customers represented a small percentage of the customer base, highlighting an opportunity to improve customer retention and loyalty programs.
* Customer growth increased consistently across the analyzed period, demonstrating strong customer acquisition.

### Geographic Insights

* Revenue and orders were concentrated in a limited number of cities and states.
* Certain regions contributed significantly more customers and revenue than others, indicating potential geographic concentration risk and expansion opportunities.

### Product Analytics

* Product performance varied significantly across categories.
* A small number of categories generated a disproportionately large share of revenue, following a Pareto-like distribution.

### Seller Analytics

* Revenue contribution was concentrated among a relatively small group of sellers.
* Top-performing sellers generated significantly higher revenue compared to the marketplace average.
* Seller performance analysis can help identify strategic partners and marketplace growth opportunities.

---

## Business Questions Answered

* Which product categories generate the highest revenue?
* Which cities and states contribute the most customers and sales?
* How has customer growth changed over time?
* Which sellers drive marketplace performance?
* What are the major revenue and order trends?
* Where are the biggest opportunities for growth and retention?

# Dashboard Preview

## Executive Overview

![Executive Overview](Images/exucutive_dashboard.png)

---

## Customer Analytics

![Customer Analytics](Images/customer_dashboard.png)

---

## Product & Seller Analytics

![Product & Seller Analytics](Images/product_dashboard.png)


# Tech Stack

- Power BI
- SQL
- DAX
- Data Modeling
- Data Visualization
- Business Intelligence
- Data Analytics

# Project Structure

```text
E-Commerce-Marketplace-Analytics-PowerBI-SQL
│
├── images/
│   ├── exucutive_dashboard.png
│   ├── customer_dashboard.png
│   └── product_dashboard.png
│
├── sql/
│   └── business_analysis_queries.sql
│
└── README.md
```

# Dashboard Pages

### 1. Executive Overview
- Total Revenue
- Total Customers
- Total Orders
- Average Order Value (AOV)
- Average Delivery Days
- Monthly Revenue Trend
- Monthly Orders Trend
- Order Status Distribution
- Top Product Categories

### 2. Customer Analytics
- Total Customers
- Revenue Per Customer
- Repeat Customers
- Repeat Customer %
- Top Cities by Revenue
- Top Cities by Orders
- Customer Growth Trend
- Top States by Customers

### 3. Product & Seller Analytics
- Total Sellers
- Total Products
- Revenue Per Seller
- Top Product Categories by Revenue
- Monthly Product Revenue Trend
- Top States by Product Revenue

# Key Business Insights

- Revenue crossed ₹13.59M across the marketplace.
- Health & Beauty generated the highest category revenue.
- São Paulo contributed the largest share of customers and revenue.
- Repeat customers accounted for approximately 3.12% of total customers.
- Delivered orders represented more than 97% of all orders.
- Product demand and revenue showed steady growth over time.

# Skills Demonstrated

- SQL Joins
- SQL Aggregations
- Window Functions
- Business KPI Analysis
- Data Modeling
- DAX Measures
- Power BI Dashboard Development
- Data Visualization
- Customer Analytics
- Product Analytics
- Business Intelligence Reporting

# Business Impact & Recommendations

## Business Problem

The marketplace generates millions in revenue across multiple product categories, sellers, customers, and regions. However, business leaders need visibility into revenue concentration, customer behavior, seller performance, and growth trends to make data-driven decisions.

## Analytical Approach

* Performed SQL-based exploratory business analysis.
* Built a relational data model in Power BI.
* Created DAX measures for revenue, orders, customers, AOV, repeat customers, and seller performance.
* Designed interactive dashboards for executive, customer, and product-level decision making.

## Key Findings

* A small number of product categories contribute a significant share of total revenue.
* Revenue is concentrated in a limited number of cities and states.
* Repeat customer percentage is relatively low, indicating customer retention opportunities.
* Marketplace growth accelerated significantly during the analyzed period.
* A small group of sellers contributes disproportionately to overall revenue.

## Recommendations

### Increase Customer Retention

Implement loyalty programs, personalized offers, and remarketing campaigns to improve repeat purchases.

### Focus on High-Performing Categories

Allocate additional marketing budget toward top-performing product categories with proven demand.

### Geographic Expansion

Identify underpenetrated regions and expand seller and customer acquisition efforts.

### Seller Development

Provide incentives and operational support to high-performing sellers while helping mid-tier sellers scale.

### Executive Monitoring

Track revenue growth, customer growth, repeat customer rate, and seller concentration on an ongoing basis.
