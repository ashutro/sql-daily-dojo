-- Active: 1756253694660@@127.0.0.1@5432@practice_db

CREATE table if not exists sales (
    sales_date date,
    revenue numeric
);

insert into sales (sales_date,revenue) VALUES
('2025-01-01', 1000),
('2025-01-02', 1500),
('2025-01-03', 800),
('2025-01-04', 1200),
('2025-01-05', 0),
('2025-01-06', 2000),
('2025-01-07', NULL),
('2025-01-08', 1700),
('2025-01-09', 900),
('2025-01-10', 2500);

select * from sales;

#1:-Given a table sales(sales_date, revenue) compute cumulative revenue ordered by date.

SELECT
    sales_date,
    sum(coalesce(revenue,0)) over (ORDER BY  sales_date) as cum_revenue
from sales;

#2:- Compute cumulative revenue but skip null revenue rows.

SELECT
    sales_date,
    sum(revenue) filter (where revenue is not null) over (order by sales_date) as cum_revenue
from sales;



#3:- Compute cumulative revenue but treat missing days as zero revenue.

WITH dates AS (
    SELECT generate_series(
        (SELECT MIN(sales_date) FROM sales),
        (SELECT MAX(sales_date) FROM sales),
        interval '1 day'
    )::date AS sale_date
),
merged AS (
    SELECT
        d.sale_date,
        COALESCE(s.revenue, 0) AS revenue
    FROM dates d
    LEFT JOIN sales s
        ON s.sales_date = d.sale_date
)
select 
    sale_date,
    revenue,
    sum(revenue) over (order by sale_date) as cum_rev
from merged;