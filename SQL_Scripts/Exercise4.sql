with main_cte as 
(
select ordernumber, orderdate, customernumber, sum(sales_value) as sales_value
from
(select t1.ordernumber, orderdate, customernumber, productcode, quantityOrdered * priceEach as sales_value
from orders t1
inner join orderdetails t2
on t1.ordernumber = t2.ordernumber) main
group by ordernumber, orderdate, customernumber
),

sales_query as 
( 
select t1.*, customerName, row_number() over (partition by customername order by orderdate) as purchase_number,
lag(sales_value) over (partition by customername order by orderdate) as prev_sales_value
from main_cte t1
inner join customers t2
on t1.customernumber = t2.customernumber
)

select *, sales_value - prev_sales_value as purchase_value_change
from sales_query
where prev_sales_value is not null