WITH rankedcustomers
     AS (SELECT cust_id,
                cust_first_name,
                cust_last_name,
                channel_desc,
                calendar_year,
                Round(Sum(amount_sold), 2)          AS total_sales,
                Rank()
                  OVER (
                    partition BY calendar_year, channel_desc
                    ORDER BY Sum(amount_sold) DESC) AS sales_rank
         FROM   sh.customers cust
                JOIN sh.sales s using (cust_id)
                JOIN sh.channels ch using (channel_id)
                JOIN sh.times t using (time_id)
         WHERE  t.calendar_year IN ( 1998, 1999, 2001 )
         GROUP  BY cust_id,
                   channel_desc,
                   calendar_year)
SELECT cust_id,
       cust_first_name,
       cust_last_name,
       channel_desc,
       calendar_year,
       total_sales,
       sales_rank
FROM   rankedcustomers
WHERE  sales_rank <= 300; 