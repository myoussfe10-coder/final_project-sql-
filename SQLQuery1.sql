--A Explore Data

select * from production.brands
select *from production.categories
select * from sales.customers
select * from sales.order_items
select * from sales.orders
select * from sales.staffs
select *from sales.stores
 SELECT * FROM production.products
 select * from production.stocks
--B. Questions
--1 Which bike is most expensive? What could be the motive behind pricing thisbike at the high price?


select top (1) *from production.products p
order by p.list_price desc 

  --2 How many total customers does BikeStore have? Would you consider people with order status 3 as customers substantiate your answer?


  select count ( c.customer_id) #number_of_custmers
  from sales.customers c

  --3 How many stores does BikeStore have?
  select count (s.store_id) #number_of_stores
  from sales.stores s

  --4 What is the total price spent per order?
  select o.order_id,sum(o.list_price * o.quantity *(1-o.discount)) total_order
  from sales.order_items o
  group by o.order_id
  
  --5 What’s the sales/revenue per store?
  select s.store_id,s.store_name,sum(o.list_price * o.quantity *(1-o.discount)) total_sales
  from sales.order_items o join sales.orders oo
  on o.order_id=oo.order_id
  join sales.stores s
  on s.store_id = oo.store_id
  group by s.store_id,s.store_name

--6 Which category is most sold?
select top 1 count( c.category_id) #total_orders, c.category_name
from production.categories c join production.products p
on c.category_id=p.category_id
join sales.order_items o 
on o.product_id =p.product_id
group by c.category_id,c.category_name 
order by #total_orders desc

--7 Which category rejected more orders?

select  top 1 count (c.category_id) as rejected_orders,c.category_name
from production.categories c join production.products p
on c.category_id =p.category_id 
join production.stocks s
on p.product_id=s.product_id
join sales.stores t
on t.store_id=s.store_id
join sales.orders o
on o.store_id=t.store_id
where o.order_status=3 
group by c.category_id,c.category_name
order by   rejected_orders  desc

--8 Which bike is the least sold?

select top 1 count (p.product_id) #orders,p.product_name,p.product_id
from production.products p join sales.order_items o
on p.product_id=o.product_id
join sales.orders s
on s.order_id=o.order_id
group by p.product_name,p.product_id
order by #orders asc

--9 What’s the full name of a customer with ID 259?

select CONCAT(c.first_name,' ',c.last_name)full_name
from sales.customers c
where c.customer_id = 259

--10 What did the customer on question 9 buy and when? What’s the status of this order?

select  o.order_date ,o.order_status,i.product_id,p.product_name
from sales.orders o join sales.order_items i
on o.order_id = i.order_id
join production.products p
on p.product_id=i.product_id
where o.order_id = 259

--11 Which staff processed the order of customer 259? And from which store?
select s.customer_id, s.staff_id ,s.store_id
from sales.orders s
where s.customer_id=259

--12 How many staff does BikeStore have? Who seems to be the lead Staff at BikeStore?

select count (s.staff_id) #staffs
from sales.staffs s

SELECT * FROM SALES.staffs
WHERE manager_id IS NULL;

--13 Which brand is the most liked?

SELECT  top 1 count (o.product_id)#orders,p.product_id,b.brand_id,b.brand_name
from sales.order_items o join production.products p
on o.product_id=p.product_id
join production.brands b
on b.brand_id=p.brand_id
group by b.brand_id,b.brand_name ,p.product_id
order by  #orders desc

--14 How many categories does BikeStore have, and which one is the least liked?

select count (c.category_id)#categories
from production.categories c

select   top 1  count (o.product_id)#orders ,c.category_name,c.category_id
from production.categories c join production.products p
on c.category_id = p.category_id
join sales.order_items o
on o.product_id=p.product_id
group by c.category_id,c.category_name
order by #orders asc

--15 Which store still have more products of the most liked brand?

select top 1 p.quantity,s.store_id,s.store_name 
from sales.stores s join production.stocks p
on s.store_id=p.store_id
WHERE p.product_id = 6 
order by p.quantity desc

--16 Which state is doing better in terms of sales?

select  TOP 1 sum(i.list_price * i.quantity *(1-i.discount))TOTAL_SALES ,c.state
from sales.customers c join sales.orders o
on c.customer_id=o.customer_id
join sales.order_items i
on i.order_id=o.order_id
group by c.state
order by TOTAL_SALES DESC

--17 What’s the discounted price of product id 259?

SELECT o.order_id, o.list_price * (1 - o.discount) AS discounted_price
from sales.order_items o
where o.order_id = 259

--18 What’s the product name, quantity, price, category, model year and brand name of product number 44?


SELECT p.product_name,p.model_year,p.list_price,c.category_name,b.brand_name,sum (s.quantity)#quantity
from production.products p join production.stocks s
on p.product_id=s.product_id
join  production.categories c
on c.category_id=p.category_id
join production.brands b
on p.brand_id = b.brand_id
where p.product_id=44
group by p.product_name,p.model_year,p.list_price,c.category_name,b.brand_name

--19 What’s the zip code of CA?

select  DISTINCT c.zip_code
from sales.customers c
where c.state = 'CA'

--20 How many states does BikeStore operate in?
select count ( s.state) #states 
from sales.stores s

--21 How many bikes under the children category were sold in the last 8 months?

select sum(o.quantity)
from sales.order_items o join production.products p
on o.product_id = p.product_id
join production.categories c
on p.category_id = c.category_id
join sales.orders s
on s.order_id=o.order_id
where c.category_id=1
and s.order_date >= DATEADD(MONTH,-8,GETDATE())

--22 What’s the shipped date for the order from customer 523

select o.shipped_date
from sales.orders o
where o.customer_id=523

 
--23 How many orders are still pending?

select count (o.order_id) #orders_are_pending
from sales.orders o
where o.order_status =1

--24 What’s the names of category and brand does "Electra white water 3i - 2018" fall under?


select b.brand_name,c.category_name
from production.brands b join production.products p
on b.brand_id = p.brand_id
join production.categories c
on c.category_id =p.category_id
where p.product_name ='Electra White Water 3i - 2018'

