-- Top 5 customers by gross profit (list price basis)
-- Contoso V2 100K, SQL Server
WITH top_customers AS (
    SELECT  c.CustomerKey,
            c.GivenName,
            c.Surname,
            SUM(s.UnitPrice * s.Quantity) - SUM(s.UnitCost * s.Quantity) AS gross_profit,
            DENSE_RANK() OVER (ORDER BY SUM(s.UnitPrice * s.Quantity) - SUM(s.UnitCost * s.Quantity) DESC) AS gross_profit_ranking
    FROM Data.Customer c
    JOIN Data.Sales s ON c.CustomerKey = s.CustomerKey
    GROUP BY c.CustomerKey, c.GivenName, c.Surname
)
SELECT *
FROM top_customers
WHERE gross_profit_ranking <= 5;
