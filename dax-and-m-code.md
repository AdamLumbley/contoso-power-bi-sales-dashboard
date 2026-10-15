# DAX and Power Query (M) Code

The code behind the Contoso report: DAX measures and one Power Query (M) step.

## Authorship

- **Written by me:** the base measures (Total Revenue, Total Cost, Gross Profit, Margin %, Total Orders, Total Customers) and the time intelligence measures (prior year and YoY % for each KPI card).
- **Written with AI assistance:** Avg Delivery Days, Gross Profit YoY Label, Row Flag, and the Age Group step in Power Query (M). I described what I needed, then reviewed the logic and checked the output against the source data. I can read and explain this code, but I could not write the M code on my own.

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

#### Total Orders and Total Customers

```dax
Total Orders = DISTINCTCOUNT ( Sales[OrderKey] )

Total Customers = DISTINCTCOUNT ( Sales[CustomerKey] )
```

### Time intelligence

Each of the five KPI cards has a base measure, a prior-year measure, a YoY % measure, and a label measure. The pattern is the same for every card, so three examples are shown here instead of the full set.

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
*Written with AI assistance.* Returns a soft yellow hex for the two categories with high order volume and low gross profit. Used as the conditional formatting color on the category table.

```dax
Row Flag =
IF (
    SELECTEDVALUE ( 'Product'[Category] )
        IN { "Music, Movies and Audio Books", "Games and Toys" },
    "#FFD966"
)
```

## Power Query (M)

### Age Group
*Written with AI assistance.* Buckets customers into three age groups, similar in logic to a DAX SWITCH or a SQL CASE statement.

```m
= Table.AddColumn(#"Changed Surname to Last Name", "Age Group", each
    if [Age] < 35 then "Young Adults"
    else if [Age] >= 35 and [Age] <= 59 then "Mid-Life"
    else if [Age] >= 60 then "Seniors"
    else "Unknown")
```
