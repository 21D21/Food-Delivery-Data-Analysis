
select user_id, name, email, password from customers;
select order_id, user_id, r_id, amount, `date`, delivery_time, delivery_rating, restaurant_rating from orders;
select r_id, r_name, cuisine, address, city, state, zipcode, phone from cuisine;

select id, order_id, f_id from details;
select menu_id, r_id, f_id, price from card;
select f_id, f_name, `type` from dish;


1) Details of customers whose name starts with 'A' and have gmail id

select * from customers where name like 'a%';

2) Details of customers containing 3 times 5 in password

select * from customers where password regexp '5.*5.*5';

3) Name & address of North Indian restaurant which is situated in 456 Elm St

select * from cuisine where cuisine = 'North Indian' and address = '456 Elm St';

4) Names of restaurant which is either Italian or situated in '433 Oak St'

select r_name 'Resturant Name', cuisine, address from cuisine where cuisine = 'Italian' or address = '433 Oak St';

5) How many orders were palced with amount 650 or more

select count(*) from orders where amount >=650;

6) Find details of those customers who have never ordered 

select customers.name 'Customer Name' , count(order_id) 'Number of orders' from customers 
left join orders
on customers.user_id = orders.user_id
group by customers.name
having count(orders.order_id) <1 ;

7) Find out details of restaurants having sales greater than x (1000 or any amount)


create procedure salesRest (in x int)
select r_name 'Resturant Name', cuisine, address, city, state, zipcode, phone ,sum(amount) from cuisine 
inner join orders 
on cuisine.r_id = orders.r_id
group by  r_name, cuisine, address, city, state, zipcode, phone 
having sum(amount) > x;

call salesRest(1000);

8) Show all order details for a particular customer ('Vartika')

select customers.name 'Customer Name', order_id, r_id, amount, `date`, delivery_time, delivery_rating, restaurant_rating from customers
inner join orders 
on customers.user_id = orders.user_id 
where customers.name ='Vartika';


9) What is the average Price per dish 

select dish.f_name 'Dish Name' ,round(avg(card.price)) 'Avg Price' from dish
inner join card 
on dish.f_id = card.f_id 
group by dish.f_name;

10) Find out number of times each customer ordered food from each restaurants 


select customers.name 'Customer Name', cuisine.r_name 'Resturant Name',count(orders.order_id) 'Number of time Ordered' from customers
inner join orders 
on customers.user_id = orders.user_id 
inner join cuisine 
on orders.r_id = cuisine.r_id
group by customers.name , cuisine.r_name;

11) Find the top restaurant in terms of the number of orders for a given month      

create procedure orderPerMonth(in x int)
select r_name 'Resturant Name',count(orders.order_id) 'Number of time Ordered' from cuisine 
inner join orders 
on cuisine.r_id = orders.r_id
where month(date) = x
group by  r_name
order by count(orders.order_id) desc;


call orderPerMonth(7);

12) Who is most loyal customer of dominos?

select customers.name 'Customer Name', cuisine.r_name 'Resturant Name',count(orders.order_id) 'Number of time Ordered' from customers
inner join orders 
on customers.user_id = orders.user_id 
inner join cuisine 
on orders.r_id = cuisine.r_id
where cuisine.r_name = 'dominos'
group by customers.name , cuisine.r_name
order by count(orders.order_id) desc limit 1;

13) What is the favorite food of each customer?


select customers.name 'Customer Name',dish.f_name ,count(orders.order_id) 'Number of time Ordered' from customers
inner join orders 
on customers.user_id = orders.user_id 
inner join details
on orders.order_id = details.order_id 
inner join dish
on details.f_id = dish.f_id 
group by customers.name,dish.f_name
order by count(orders.order_id) desc;

14) What is the favorite food of each customer along with customer details

select customers.user_id, name, email ,dish.f_name ,count(orders.order_id) 'Number of time Ordered',row_number() over (partition by customers.user_id order by count(details.order_id) desc)
from customers
inner join orders 
on customers.user_id = orders.user_id 
inner join details
on orders.order_id = details.order_id 
inner join dish
on details.f_id = dish.f_id 
group by customers.user_id,customers.name,email,dish.f_name;


order by count(orders.order_id) desc;

select customers.user_id, name, email ,dish.f_name ,count(orders.order_id) 'Number of time Ordered'from customers
inner join orders 
on customers.user_id = orders.user_id 
inner join details
on orders.order_id = details.order_id 
inner join dish
on details.f_id = dish.f_id 
group by customers.user_id,customers.name,email,dish.f_name
order by customers.name , count(orders.order_id) desc ;

15) For each restaurant find out user who has ordered maximum number of times

select  cuisine.r_name 'Resturant Name',customers.name 'Customer Name' ,count(orders.order_id) 'Number of time Ordered',
row_number() over (partition by cuisine.r_id order by count(orders.order_id) desc)
from customers
inner join orders 
on customers.user_id = orders.user_id 
inner join cuisine 
on orders.r_id = cuisine.r_id
group by customers.name , cuisine.r_name,cuisine.r_id;

order by count(orders.order_id) desc;