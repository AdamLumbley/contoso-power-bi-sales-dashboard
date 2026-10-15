# Contoso Sales Dashboard (Power BI)

A four-page Power BI report built on SQLBI's Contoso Data Generator V2 dataset (100K-order version): about 93,000 orders and 224,000 sales lines from 2016 to 2025.

## The Report

**Executive Overview:** orders, revenue, cost, gross profit and margin %, gross profit by category and subcategory, and gross profit by year.

![Executive Overview](Contoso%20Overview.png)

**Sales Breakdown:** orders vs. gross profit by category, average delivery days, and average delivery days by year.

![Sales Breakdown](Contoso%20Sales%20Breakdown.png)

**Store Performance:** online vs. in-store split, top 10 stores, and online vs. in-store gross profit over time.

![Store Performance](Contoso%20Store%20Performance.png)

**Customer Insights:** gross profit by customer continent, age group, channel and gender, plus customers by age group.

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
- **"vs Prior" cards** compare against the previous period once a date is selected, so they show 0.0% with no date filter. Cost has no good/bad coloring, since a cost increase isn't automatically bad.
- Contoso is synthetic data, so the charts show patterns in the dataset, not real business causes.

## How It Was Built

- Source: SQLBI Contoso 100K CSV files, loaded and shaped in Power Query
- Star schema model: a Sales fact table with Product, Store, Customer and Date dimensions
- DAX measures and Power Query (M) code: see [dax-and-m-code.md](dax-and-m-code.md)

## Tools

Power BI Desktop, Power Query, DAX
