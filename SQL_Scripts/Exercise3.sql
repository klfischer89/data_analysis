with sales as
(
select t1.ordernumber, t1.customernumber, productCode, quantityOrdered, priceEach, priceEach * quantityOrdered as sales_value,
creditLimit
from orders t1
inner join orderdetails t2
on t1.ordernumber = t2.ordernumber
inner join customers t3
on t3.customernumber = t1.customerNumber
)

select ordernumber, customernumber, 
case when creditlimit < 75000 then 'a:Less then $75K'
when creditlimit between 75000 and 100000 then 'b:$75K - $100K' 
when creditlimit between 100000 and 150000 then 'c:$100K - $150K' 
when creditlimit > 150000 then 'd:Over $150K'
else 'Other'
end as creditlimit_group,
sum(sales_value) as sales_value
from sales
group by ordernumber, customernumber, creditlimit_group