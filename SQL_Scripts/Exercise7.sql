with cte_sales as 
(
select  
orderDate,
t1.customerNumber,
t1.ordernumber,
customername,
productcode,
creditlimit,
quantityOrdered * priceEach as sales_value
from orders t1
inner join orderdetails t2
on t1.ordernumber = t2.ordernumber
inner join customers t3
on t1.customerNumber = t3.customerNumber
),

running_total_sales_cte as
(
select *, lead(orderdate) over (partition by customernumber order by orderdate) as next_order_date
from 
(
select orderdate,
ordernumber,
customernumber,
customername,
creditlimit,
sum(sales_value) as sales_value
from cte_sales
group by orderdate,
ordernumber,
customernumber,
customername,
creditlimit
) subquery
),

payments_cte as
(
select *, sum(amount) over (partition by customernumber order by paymentdate) as running_total_payments
from payments
),

main_cte as
(
select t1.*, 
sum(sales_value) over (partition by t1.customernumber order by orderdate) as running_total_sales,
sum(amount) over (partition by t1.customernumber order by orderdate) as running_total_payments
from running_total_sales_cte t1
left join payments_cte t2
on t1.customernumber = t2.customernumber and t2.paymentdate between t1.orderdate and  case when t1.next_order_date is null then current_date else next_order_date end
)

select *, running_total_sales - running_total_payments as money_oewd,
creditlimit - (running_total_sales - running_total_payments) as difference
from main_cte