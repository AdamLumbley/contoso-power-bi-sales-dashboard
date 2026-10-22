# Contoso Sales Dashboard (Power BI)

A four-page Power BI report that turns about 224,000 sales lines (93,000 orders, 2016 to 2025) into answers an executive can act on: **$136M in gross profit at a 58.5% margin**, where it comes from, and how the business is shifting online. Built on SQLBI's Contoso Data Generator V2 (100K-order version) and cross-checked against a SQL Server database in T-SQL.

**Executive Overview:** Orders, revenue, cost, gross profit and margin %, gross profit by category and subcategory, and gross profit by year.

![Executive Overview](Contoso%20Overview.png)

## Key Findings

- **Computers drive the business.** They account for $59M of $136M total gross profit (about 43%).
- **Online passed in-store in 2023.** Online gross profit hit $14.7M vs. $12.6M in-store, and it has stayed ahead since. Over the full period, in-store is 60% of gross profit and online is 40%.
- **Some categories sell a lot but earn little.** Music, Movies and Audio Books (30K orders, $7.9M) and Games and Toys (20K orders, $1.1M) have high order volume and low gross profit.
- **Online delivery got much faster.** Average delivery time fell from 8.7 days in 2016 to about 3 days from 2023 on, then leveled off. The overall online average is 3.25 days.
- **Customer groups spend about the same.** Seniors and Mid-Life each have about 20K customers and Young Adults have 13K. Gross profit per customer is roughly $2.5K in all three groups, so the older groups contribute more because there are more of them. Gross profit splits 50/50 by gender.
- **Profit is spread across many customers, not concentrated in a few.** The top 5 customers together generate $202,680 in gross profit, about 0.15% of the $136.1M total. The single best customer (Giselda Fallaci, $46,422) is about 0.03%.
- **Store closures were concentrated early.** 16 of the 74 stores in the Store table have a close date. Seven closed in 2015, and one to three closed in each of the other years from 2013 to 2019. None have closed since. Contoso is synthetic, so this shows when closures happened, not why.

## Validation

The five headline KPIs (orders, revenue, cost, gross profit, margin %) were reconciled between the Power BI measures and T-SQL queries run against the Contoso V2 100K database in SQL Server Express. The results matched, for example gross profit of $136.1M.

The top 5 customers by gross profit were also reconciled three ways: a T-SQL query ([top-5-customers.sql](top-5-customers.sql)), the Power BI table, and a DAX query in DAX Studio. All three returned the same five customers and the same figures (#1 Giselda Fallaci, $46,421.95).

## The Other Pages

**Sales Breakdown:** Orders vs. gross profit by category, average delivery days, and average delivery days by year.

![Contoso Sales Breakdown](./Contoso%20Sales%20Breakdown.png?v=2)

**Store Performance:** Online vs. in-store split, top 10 stores, and online vs. in-store gross profit over time.

![Store Performance](Contoso%20Store%20Performance.png)

**Customer Insights:** Gross profit by customer continent, age group, channel and gender, customers by age group, and a top 5 customers table ranked by gross profit. The top 5 re-ranks with the slicers, so selecting a store, time period or product category shows the top 5 customers within that slice.

![Customer Insights](Contoso%20Customer%20Insights.png)

## Notes on the Numbers

- **Gross profit = revenue - cost.** Revenue is quantity x unit price and cost is quantity x unit cost. This uses list price, before discounts. Using net price (after discounts) gives $122.3M instead of $136.1M, about 10% lower.
- **Average delivery days covers online orders only.** In-store orders have no delivery time (0 days), so including them would drag the average down to about 1.4.
- **Age groups:** Young Adults = under 35, Mid-Life = 35 to 59, Seniors = 60 and over.
- **"vs Prior" cards** compare against the previous period once a date is selected, so they show 0.0% with no date filter. The cost card has no good/bad coloring, because a cost increase isn't necessarily bad: higher costs often come with higher order counts. The other cards do get it.
- Contoso is synthetic data, so the charts show patterns in the dataset, not real business causes.

## How It Was Built

**Data preparation (Power Query)**
- Loaded the Contoso CSV tables and profiled each one, checking headers, nulls, spelling, and data types.
- Renamed columns to clear, consistent names so the tables relate cleanly.
- Set the correct data type for each column.
- Profiled the dataset and found no structural damage: no nulls in any key column. Preserved nulls in descriptive columns (such as Company, Weight, and CloseDate) where a blank doesn't affect any measure, instead of dropping rows, so no valid orders were lost.
- Added an Age Group column (M code, written with AI assistance).

**Data model**
- Star schema: a Sales fact table with Product, Store, Customer and Date dimensions.

**Interactivity**
- Three visuals have drill-down hierarchies: gross profit by year on Executive Overview and average delivery days on Sales Breakdown (both year > quarter > month), and gross profit by customer location on Customer Insights. Each one packs several levels of detail into a single visual, which freed up canvas space for other content. I left hierarchies off visuals that make one clear point, like the online vs. in-store trend behind the 2023 crossover.
- The top 5 customers table uses a Top N filter on CustomerKey (not name, since many customers share a first name).

**DAX**
- Measures and the Power Query (M) code: see [dax-and-m-code.md](dax-and-m-code.md)

**SQL validation**
- Restored the Contoso V2 100K backup in SQL Server Express and queried it in SSMS with T-SQL to confirm the dashboard's totals.
- Top 5 customers by gross profit (CTE and `DENSE_RANK()`): see [top-5-customers.sql](top-5-customers.sql)

**AI assistance**
- Used Claude to write some advanced DAX measures and M code.

## Tools

Power BI Desktop, Power Query, DAX, DAX Studio, SQL Server Express, T-SQL (SSMS), Claude
