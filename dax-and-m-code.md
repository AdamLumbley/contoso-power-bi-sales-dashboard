# DAX and Power Query (M) Code

The code behind the Contoso report: DAX measures and the one Power Query step written as M code. The rest of the Power Query work (renaming columns, setting data types, handling nulls) was done with the Power Query interface and is described in the main README.

## Authorship

**Written by me:** the base measures (Total Revenue, Total Cost, Total Orders, Total Customers, Total Stores), the calculated measures built from them (Gross Profit, Margin %), the time intelligence measures (prior year and YoY % for every KPI card), and the share-of-total query (added after the report shipped, see below).

**Written with AI assistance:** Avg Delivery Days, Gross Profit YoY Label, Row Flag, and the Age Group step in Power Query (M). For each one I specified what it needed to do, then checked the results in the report to confirm it behaved correctly. For the M step this was a deliberate choice: I use AI for M syntax instead of memorizing it, which gets the step done faster and leaves my time for modeling and DAX.

**Relearned with AI help:** the share-of-total pattern (CALCULATE with REMOVEFILTERS). I had used it once before and forgot the syntax, so I had Claude walk me through it, then rewrote it myself from scratch on a different column.

## Grain of the Sales table

Before writing any measure, I used DAX Studio to check what one row in `Sales` represents. Comparing the row count to the distinct order count answers it:

```dax
EVALUATE
ROW (
    "Rows", COUNTROWS ( Sales ),
    "Distinct Orders", DISTINCTCOUNT ( Sales[OrderKey] )
)
```

Result: 223,974 rows and 93,470 distinct orders (about 2.4 lines per order). The grain is the **order line** (one row per product on an order), not the order. That is typical for e-commerce data, and it drives two decisions in this model:

- **Orders are counted with DISTINCTCOUNT, not COUNTROWS.** Counting rows would report order lines as orders.
- **Revenue and cost are calculated per line with SUMX** (unit price × quantity), because quantity lives on each line.

## Display folders

I organized the measures into six display folders so the model is easy to navigate and review:

```
01 - Base Measures
02 - Time Intelligence
03 - Ratios
04 - Labels
05 - Row Flag
06 - Delivery
```

## Measure Index

| Measure | What it does |
|---|---|
| Total Revenue | List-price revenue before discounts |
| Total Cost | Unit cost × quantity |
| Total Orders / Total Customers | Distinct counts |
| Total Stores | Count of stores |
| Gross Profit | Revenue minus cost |
| Margin % | Gross profit as a share of revenue |
| PY / YoY % / Label (×5 KPI cards) | Prior year, year-over-year change, and the "vs Prior" text on each card |
| Avg Delivery Days | Online orders only, order date to delivery date |
| Row Flag | Hardcoded presentation highlight (not live logic) |

The share-of-total query is a DAX Studio query, not a model measure, so it is not in this index.

## DAX

### Base measures

#### Total Revenue
List-price revenue (before discounts).

```dax
Total Revenue =
SUMX ( Sales, Sales[UnitPrice] * Sales[Quantity] )
```

#### Total Cost

```dax
Total Cost =
SUMX ( Sales, Sales[UnitCost] * Sales[Quantity] )
```

#### Total Orders and Total Customers
Orders use DISTINCTCOUNT because the Sales table is at order-line grain (see above).

```dax
Total Orders = DISTINCTCOUNT ( Sales[OrderKey] )

Total Customers = DISTINCTCOUNT ( Sales[CustomerKey] )
```

#### Total Stores
Stores are counted from the `Store` dimension table, which has one row per store.

```dax
Total Stores = COUNTROWS ( Store )
```

### Calculated measures

#### Gross Profit

```dax
Gross Profit = [Total Revenue] - [Total Cost]
```

#### Margin %

```dax
Margin % =
VAR Revenue = [Total Revenue]
VAR Cost = [Total Cost]
RETURN
    DIVIDE ( Revenue - Cost, Revenue )
```

### Time intelligence

Each of the five KPI cards has a base or calculated measure, a prior-year measure, a YoY % measure, and a label measure. The pattern is the same for every card, so three examples are shown here instead of the full set.

#### Gross Profit PY

```dax
Gross Profit PY =
CALCULATE ( [Gross Profit], SAMEPERIODLASTYEAR ( 'Date'[Date] ) )
```

#### Total Revenue PY

```dax
Total Revenue PY =
CALCULATE ( [Total Revenue], SAMEPERIODLASTYEAR ( 'Date'[Date] ) )
```

#### Total Revenue YoY %

```dax
Total Revenue YoY % =
DIVIDE ( [Total Revenue] - [Total Revenue PY], [Total Revenue PY] )
```

### Share of total

*Added after the report shipped.* The dashboard shows gross profit in dollars and does not use a percent-of-total view, so this is an extension, not part of the original analysis. It shows each product category's share of total gross profit.

The key piece is the denominator. Each row of the table passes its own filter (for example, `Category = Games and Toys`) to `[Gross Profit]`. Wrapping the measure in `CALCULATE` with `REMOVEFILTERS` tells that one calculation to ignore the category filter, so it returns the grand total. Without it, every row would divide by itself and show 100%.

```dax
// Share of total gross profit by product category (REMOVEFILTERS denominator)
EVALUATE
SUMMARIZECOLUMNS (
    'Product'[Category],
    "Gross Profit", [Gross Profit],
    "% of Total",
        DIVIDE (
            [Gross Profit],
            CALCULATE ( [Gross Profit], REMOVEFILTERS ( 'Product'[Category] ) )
        )
)
ORDER BY [Gross Profit] DESC
```

The same pattern works for any column, such as `Customer[Age Group]`.

### Delivery

#### Avg Delivery Days
*Written with AI assistance.* Average days from order to delivery, online orders only. In-store orders have no delivery date, so the online filter is built into the measure to keep the result correct on any visual.

```dax
Avg Delivery Days =
CALCULATE (
    AVERAGEX ( Sales, DATEDIFF ( Sales[OrderDate], Sales[DeliveryDate], DAY ) ),
    Store[Description] = "Online store"
)
```

### Formatting measures

#### Gross Profit YoY Label
*Written with AI assistance.* Builds the "vs Prior" text on the KPI cards, with an arrow and a percentage, and a dash when there is no prior period. The same pattern drives the labels on all five cards.

```dax
Gross Profit YoY Label =
VAR Pct = [Gross Profit YoY %]
RETURN
    IF (
        ISBLANK ( Pct ),
        "—",
        IF ( Pct >= 0, "▲ ", "▼ " ) & FORMAT ( ABS ( Pct ), "0.0%" )
    )
```

#### Row Flag
*Written with AI assistance.* Returns a soft yellow hex for the two categories with high order volume and low gross profit. Used as the conditional formatting color on the category table. **Intentionally hardcoded:** this highlights a one-time finding for presentation, not part of the live reporting logic. The rest of the report is built to refresh long-term.

```dax
Row Flag =
IF (
    SELECTEDVALUE ( 'Product'[Category] )
        IN { "Music, Movies and Audio Books", "Games and Toys" },
    "#FFD966"
)
```

## Power Query (M)

Most of the Power Query cleanup was done through the interface (renaming columns, setting data types, keeping nulls in non-key columns). This is the one step written as M code.

### Age Group
My gross profit by age query produced a table with 67 rows, one per distinct age. That is high cardinality for a human reader, though trivial for Power BI, so this was a readability problem, not a performance one. I bucketed customers into three groups (under 35, 35 to 59, 60 and over), cutting 67 rows to 3 and keeping the raw column in the model. I built it in Power Query instead of a DAX calculated column, because data shaping belongs upstream, close to the source.

*I used Claude to quickly and accurately write the M code and to help set the age cutoffs.*

```m
= Table.AddColumn(#"Changed Surname to Last Name", "Age Group", each
    if [Age] < 35 then "Young Adults"
    else if [Age] >= 35 and [Age] <= 59 then "Mid-Life"
    else if [Age] >= 60 then "Seniors"
    else "Unknown")
```
