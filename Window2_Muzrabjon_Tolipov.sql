WITH subcategory_sales
     AS (SELECT prod_subcategory,
                t.calendar_year               AS order_year,
                Sum(s.amount_sold)            AS total_sales,
                Lag(Sum(s.amount_sold))
                  OVER (
                    partition BY prod_subcategory
                    ORDER BY t.calendar_year) AS prev_year_sales
         FROM   sh.sales s
                JOIN sh.products p using(prod_id)
                JOIN sh.times t using(time_id)
         WHERE  t.calendar_year BETWEEN 1998 AND 2001
         GROUP  BY prod_subcategory,
                   t.calendar_year)
SELECT prod_subcategory,
       order_year,
       total_sales,
       prev_year_sales
FROM   subcategory_sales
WHERE  total_sales > COALESCE(prev_year_sales, 0); 