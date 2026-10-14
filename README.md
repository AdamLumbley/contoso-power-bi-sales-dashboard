# Contoso Sales Dashboard (Power BI)

A four-page Power BI report built on SQLBI's Contoso Data Generator V2 dataset (100K-order version): about 93,000 orders and 224,000 sales lines from 2016 to 2025.

![Executive Overview](Contoso_Overview.png)

## Key findings

- **Computers drive the business.** They account for $59M of $136M total gross profit (about 43%).
- **Online passed in-store in 2023.** Online gross profit hit $14.7M vs. $12.6M in-store, and it has stayed ahead since. Over the full period, in-store is 60% of gross profit and online is 40%.
- **Some categories sell a lot but earn little.** Music, Movies and Audio Books (30K orders, $7.9M) and Games and Toys (20K orders, $1.1M) have high order volume and low gross profit.
- **Online delivery got much faster.** Average delivery time fell from 8.7 days in 2016 to about 3 days from 2022 on, and it leveled off after that. The overall online average is 3.25 days.
- **Customer groups spend about the same.** Seniors and Mid-Life each have about 20K customers and Young Adults have 13K. Gross profit per customer is roughly $2.5K in all three groups, so the older groups contribute more because there are more of them. Gender splits 50/50.
- **Stores are tightly clustered.** The top 10 physical stores each earn $2.0M to $2.5M in gross profit.

## Pages

| Page | What it shows |
|---|---|
| Executive Overview | Orders, revenue, cost, gross profit and margin %, gross profit by category and subcategory, gross profit by year |
| Sales Breakdown | Orders vs. gross profit by category, average delivery days (card and by year) |
| Store Performance | Online vs. in-store split, top 10 stores, online vs. in-store gross profit over time |
| Customer Insights | Gross profit by customer continent, age group, channel and gender; customers by age group |

![Sales Breakdown](Contoso_Sales_Breakdown.png)
![Store Performance](Contoso_Store_Performance.png)
![Customer Insights](Contoso_Customer_Insights.png)

## Notes on the numbers

- **Gross profit = quantity x (unit price - unit cost)**, using list price. Using net price (after discounts) gives $122.3M instead of $136.1M, about 10% lower.
- **Average delivery days covers online orders only.** In-store orders have no delivery time (0 days), so including them would drag the average down to about 1.3.
- **Age groups:** Young Adults = [ADD RANGE], Mid-Life = [ADD RANGE], Seniors = [ADD RANGE].
- **"vs Prior" cards** compare against the previous period once a date is selected, so they show 0.0% with no date filter. Cost has no good/bad coloring, since a cost increase isn't automatically bad.
- Contoso is synthetic data, so the charts show patterns in the dataset, not real business causes.

## How it was built

- Source: SQLBI Contoso 100K CSV files, loaded and shaped in Power Query
- Star schema model: a Sales fact table with Product, Store, Customer and Date dimensions
- DAX measures for gross profit, margin %, order counts and average delivery days
- Figures were checked against the raw CSVs

## Tools

Power BI Desktop, Power Query, DAX
