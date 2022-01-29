USE restaurent;

/* 1. Find the order details with order number 5876*/
SELECT o.*,m.price,
(o.quantity*m.price) as Item_cost FROM orders o, menu m where o.item_name=m.item_name
and order_id = 5876;

/* 2. select order_id with thier total bill amount in descending order and limit to the top 5 records*/
with cte as (select o.order_id,
					o.item_name, 
					o.quantity,
                    o.total_products, 
                    m.price,
					(o.quantity*m.price) as bill_amount
					from orders o 
					join menu m
					on o.Item_Name = m.Item_Name)
select order_id, round(sum(bill_amount), 2) as total_bill
from cte 
group by order_id
order by total_bill desc
limit 5;

/* 3. Find the details of an employee with highest salary.*/
select name,sum(salary) from employee_table
group by name
order by sum(salary) desc
LIMIT 1;

/* 4. Find the orders with item name chicken biryani and having count of orders greater than 5 */
select order_id, item_name 
from orders 
where order_id in (select order_id
					from orders
					group by order_id
					having count(order_id) > 5) and item_name = 'Chicken Biryani';

/* 5. Find the total amount earned by the restaurant in that particular year */
with cte as (select o.order_id,
					o.item_name, 
					o.quantity,
                    o.total_products, 
                    o.order_date,
                    m.price,
					(o.quantity*m.price) as bill_amount
					from orders o 
					join menu m
					on o.Item_Name = m.Item_Name)
select sum(bill_amount) as total_amount
from cte ;

/* 6. Find the 5 most ordered item and what its proportion in the total data base*/
 with a as(select o.item_name, sum(o.quantity) as total_orders, sum((o.quantity * m.price)) as total_price
 from orders o 
 join menu m 
 on o.item_name = m.item_name
 group by item_name
 order by total_orders desc)
select item_name, total_orders, cast((total_price/(select sum(total_price) from a)) as decimal(7,4)) as proportion
from a
limit 5;
 
 
 /* 7. Find the employee whose salary increased by the most percentage from start date to end data*/
 select name, (min(salary)/ max(salary)) as percentage_increase
 from employee_table 
 group by name
 order by percentage_increase desc
 limit 1;
 
 /* 8. Find the month where the max orders are placed and give the chefs and server name who prepared and served the food*/
 with c as (with b as (with a as (select order_id, item_name, quantity, prepared_by, served_by,
 case 
	when length(order_date) = 16 then right(left(order_date, 5) ,2)
    when length(order_date) = 12 then right(left(order_date, 3) ,2)
    when length(order_date) = 14 then right(left(order_date, 5) ,2)
    when length(order_date) = 13 then right(left(order_date, 4) ,2)
end as month_number
from orders)
select order_id, item_name, quantity, prepared_by, served_by, replace(month_number, '/',0) as month from a)
/*from the analysis we came to know that december is having more orders with 3986*/
select * from b where month = 12)
(select prepared_by, count(order_id) as cnt_prepared_by
from c
group by prepared_by
order by cnt_prepared_by desc
limit 1) union all (select served_by, count(order_id) as cnt_served_by
from c
group by served_by
order by cnt_served_by desc
limit 1);

