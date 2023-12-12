SELECT cust_id,
       cust_first_name,
       cust_last_name,
       channel_desc,
       calendar_year,
       total_sales,
       sales_rank
FROM (
    SELECT cust.cust_id,
           cust.cust_first_name,
           cust.cust_last_name,
           ch.channel_desc,
           t.calendar_year,
           ROUND(SUM(s.amount_sold), 2) AS total_sales,
           ROW_NUMBER() OVER (PARTITION BY t.calendar_year, ch.channel_desc ORDER BY SUM(s.amount_sold) DESC) AS sales_rank
    FROM sh.customers cust
    JOIN sh.sales s USING(cust_id)
    JOIN sh.channels ch USING(channel_id)
    JOIN sh.times t USING(time_id)
    WHERE t.calendar_year IN (1998, 1999, 2001)
    GROUP BY cust.cust_id, ch.channel_desc, t.calendar_year
) AS RankedCustomers
WHERE sales_rank <= 300;