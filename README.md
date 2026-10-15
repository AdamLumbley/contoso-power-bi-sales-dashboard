# Contoso Sales Dashboard (Power BI)

A four-page Power BI report built on SQLBI's Contoso Data Generator V2 dataset (100K-order version): about 93,000 orders and 224,000 sales lines from 2016 to 2025.

## The Report

**Executive Overview:** Orders, revenue, cost, gross profit and margin %, gross profit by category and subcategory, and gross profit by year.

![Executive Overview](Contoso%20Overview.png)

**Sales Breakdown:** Orders vs. gross profit by category, average delivery days, and average delivery days by year.

![Sales Breakdown](Contoso%20Sales%20Breakdown.png)

**Store Performance:** Online vs. in-store split, top 10 stores, and online vs. in-store gross profit over time.

![Store Performance](Contoso%20Store%20Performance.png)

**Customer Insights:** Gross profit by customer continent, age group, channel and gender, plus customers by age group.

![Customer Insights](Contoso%20Customer%20Insights.png)

## Key Findings

- **Computers drive the business.** They account for $59M of $136M total gross profit (about 43%).
- **Online passed in-store in 2023.** Online gross profit hit $14.7M vs. $12.6M in-store, and it has stayed ahead since. Over the full period, in-store is 60% of gross profit and online is 40%.
- **Some categories sell a lot but earn little.** Music, Movies and Audio Books (30K orders, $7.9M) and Games and Toys (20K orders, $1.1M) have high order volume and low gross profit.
- **Online delivery got much faster.** Average delivery time fell from 8.7 days in 2016 to about 3 days from 2022 on, and it leveled off after that. The overall online average is 3.25 days.
- **Customer groups spend about the same.** Seniors and Mid-Life each have about 20K customers and Young Adults have 13K. Gross profit per customer is roughly $2.5K in all three groups, so the older groups contribute more because there are more of them. Gender splits 50/50.
- **Stores are tightly clustered.** The top 10 physical stores each earn $2.0M to $2.5M in gross profit.

## Notes on the Numbers

- **Gross profit = revenue - cost.** Revenue is quantity x unit price and cost is quantity x unit cost. This uses list price, before discounts. Using net price (after discounts) gives $122.3M instead of $136.1M, about 10% lower.
- **Average delivery days covers online orders only.** In-store orders have no delivery time (0 days), so including them would drag the average down to about 1.3.
- **Age groups:** Young Adults = under 35, Mid-Life = 35 to 59, Seniors = 60 and over.
- **"vs Prior" cards** compare against the previous period once a date is selected, so they show 0.0% with no date filter. The cost card has no good/bad coloring, because a cost increase isn't necessarily bad: higher costs often come with higher order counts. The other cards do get it.
- Contoso is synthetic data, so the charts show patterns in the dataset, not real business causes.

## How It Was Built

**Data preparation (Power Query)**
- Loaded the Contoso CSV tables and profiled each one, checking headers, nulls, spelling, and data types.
- Renamed columns to clear, consistent names so the tables relate cleanly.
- Set the correct data type for each column.
- Kept rows with missing values in non-key columns instead of dropping them. Roughly 30,000 rows had blank zip codes, and removing them would have thrown away valid orders over a column the report doesn't use. The order and customer keys on those rows were intact.
- Added an Age Group column (M code, written with AI assistance).

**Data model**
- Star schema: a Sales fact table with Product, Store, Customer and Date dimensions.

**DAX**
- Measures and the Power Query (M) code: see [dax-and-m-code.md](dax-and-m-code.md)

## Tools

Power BI Desktop, Power Query, DAX
