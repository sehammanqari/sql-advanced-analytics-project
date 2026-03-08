
# Advanced SQL Analytics Project

Welcome to the **Advanced SQL Analytics Project** repository.

This project demonstrates how advanced SQL techniques can be used to perform deeper analytical exploration on a structured analytical dataset. The goal is to extract meaningful business insights using SQL analytical patterns such as window functions, segmentation, cumulative analysis, and reporting views.

The dataset used in this project comes from the **Gold Layer of my Data Warehouse Project**, which provides a clean star-schema model optimized for analysis.

---

# Project Context

This project builds upon the dataset generated in my **SQL Data Warehouse Project**.

In that project, I designed and implemented a modern data warehouse using a layered architecture:

```
Bronze → Silver → Gold
```

The **Gold Layer** provides the analytical dataset used for all analyses performed in this repository.

You can explore the full warehouse implementation here:

**SQL Data Warehouse Project**
[https://github.com/sehammanqari/sql-data-warehouse-project](https://github.com/sehammanqari/sql-data-warehouse-project)

---


# Analytical Techniques Implemented

This project demonstrates several **advanced SQL analytical patterns** commonly used in data analysis.

---

## 1. Change Over Time Analysis

Analyzes how business metrics evolve across time.

Examples:

* yearly sales trends
* monthly order trends
* time-based comparisons

Techniques used:

* `GROUP BY`
* `DATE FUNCTIONS`
* `ORDER BY`

Script:

```
01_change_over_time_analysis.sql
```

---

## 2. Cumulative Analysis

Calculates running totals and moving averages to understand growth patterns.

Examples:

* running total of sales
* running total of orders
* moving averages for smoothing trends

Techniques used:

* **Window Functions**
* `SUM() OVER()`
* `AVG() OVER()`

Script:

```
02_cumulative_analysis.sql
```

---

## 3. Performance Analysis

Evaluates product performance by comparing:

* current sales
* average historical sales
* previous year sales

Techniques used:

* `WINDOW FUNCTIONS`
* `LAG()`
* `PARTITION BY`
* Year-over-year comparison

Script:

```
03_performance_analysis.sql
```

---

## 4. Part-to-Whole Analysis

Measures how much each category contributes to total sales.

Example questions:

* Which product categories drive the most revenue?
* What percentage of sales does each category represent?

Techniques used:

* window aggregation
* percentage calculations

Script:

```
04_part_to_whole_analysis.sql
```

---

## 5. Data Segmentation

Groups entities into meaningful business segments.

Examples:

* product cost segments
* customer spending segments

Techniques used:

* `CASE` logic
* grouping
* behavioral classification

Script:

```
05_data_segmentation.sql
```

---

## 6. Business Reporting Views

Final analytical reports built as **SQL views** for reuse.

### Customer Report

Key metrics include:

* customer segment
* recency
* total orders
* total sales
* average order value
* average monthly spending

### Product Report

Key metrics include:

* product performance segment
* sales totals
* quantity sold
* customer reach
* revenue metrics

Script:

```
06_reporting.sql
```

---

# SQL Concepts

This project showcases the use of advanced SQL features such as:

* Common Table Expressions (CTEs)
* Window Functions
* Running Totals
* Moving Averages
* Ranking and Lag functions
* Aggregations
* Analytical Views
* Business Segmentation
* KPI calculations

These techniques are commonly used in **data analysis, reporting, and business intelligence workflows**.

---

# Repository Structure

```
advanced-sql-analytics-project
│
├── datasets
│
├── scripts
│   ├── 01_change_over_time_analysis.sql
│   ├── 02_cumulative_analysis.sql
│   ├── 03_performance_analysis.sql
│   ├── 04_part_to_whole_analysis.sql
│   ├── 05_data_segmentation.sql
│   └── 06_reporting.sql
│
└── README.md
```

---

# About This Project

This project demonstrates my ability to apply **advanced SQL techniques to real analytical scenarios**.

It reflects practical skills used in data analytics such as:

* analytical query design
* KPI development
* customer analytics
* product performance evaluation
* building reusable reporting logic

---

# About Me

Hi, I'm **Seham Hafez Manqari**, a Data Science student focused on developing strong SQL and data analytics skills.

This project is part of my journey toward becoming a professional **Data Analyst**, where I build end-to-end analytical solutions starting from data modeling to advanced SQL analysis.

---

# Contact

Email:
[sehammanqari@gmail.com](mailto:sehammanqari@gmail.com)
