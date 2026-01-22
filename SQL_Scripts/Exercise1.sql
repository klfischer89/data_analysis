select t1.orderDate, t1.orderNumber, quantityOrdered, priceEach, productName, productLine, buyPrice, country, city 
from orders t1
inner join orderdetails t2
on t1.ordernumber = t2.ordernumber
inner join products t3
on t2.productCode = t3.productCode
inner join customers t4
on t4.customerNumber = t1.customerNumber
where year(orderDate) = 2004