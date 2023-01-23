-- I'm a restaurant owner 
-- 5 tables
--1x fact , 4x dimension
-- search google, how to add foreign key
-- write sql 3-5 queries analyze data
-- 1x subquery/with
--dimension table 
-- dim no.1
CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  customer_name text,
  customer_age int,
  customer_gender text,
  customer_location text,
  customer_phone text
);
INSERT INTO customers values
  (1,'Zen',25,'M','Nonthabure','055-555-5555'),
  (2,'Kiri',18,'M','Bangkok','065-526-7896'),
  (3,'Kaopunz',25,'M','Bangkok','084-557-9214'),
  (4,'X',25,'M',"Bangkok",'088-412-6528'),
  (5,'Nong_P',25,'F',"Bangkok","016-959-8874") ;

--sqlite command
.mode column --.mode markdown ใส่ก่อนรัน select 
.header on 
--run check dim 1
--select * from customers ;
--dimension no.2

CREATE TABLE menus (
  menu_id INT PRIMARY KEY,
  menu_name text,
  menu_price int,
  menu_type text
  );

INSERT INTO menus values
  (1,'Pizza',299,'Food'),
  (2,'Fried Rice',150,'Food'),
  (3,'Carbonara',100,'Food'),
  (4,'Tom-Yum Noodles',120,'Food'),
  (5,'Pork steak',59,'Food'),
  (6,'Frenchfried',49,'Appetizer'),
  (7,'Fried Chicken',59,'Appetizer'),
  (8,'Pepsi',30,'Beverage'),
  (9,'Water',15,'Beverage'),
  (10,'Orange Juice',39,'Beverage')
  ;

--select * from menu;

--dim 3
CREATE TABLE services (
  service_id int primary key,
  service_type text
);

INSERT INTO services values
  (1,"eat here"),
  (2,"take away"),
  (3,"delivery")
  ;
--select * from services ;

--dim 4
Create table staffs (
  Staff_ID int primary key,
  Staff_name varchar(20),
  Staff_position varchar(20)
);

INSERT INTO staffs values 
  (1,"Make","Waiter"),
  (2,"Zorro","Bikeman"),
  (3,"Nami","Waitress"),
  (4,"Sanji","Waiter"),
  (5,"Robin","Waitress")
  ;
--select * from staff;

Create table payment (
  payment_id int primary key,
  payment_method varchar(20)
);

INSERT INTO payment values 
  (1,"QR code"),
  (2,"Cash"),
  (3,"Credit Card")
  ;

--select * from payment;

/*Fact Table */
CREATE TABLE orders (
  order_id INT PRIMARY KEY ,
  order_date text,
  customer_id int ,
  staff_id int,
  menu_id int,
  amout int ,
  service_id int ,
  payment_id int,
  foreign key (customer_id) references customers(customer_id),
  foreign key (staff_id) references staffs(staff_id),
  foreign key (menu_id) references menus(menu_id),
  foreign key (service_id) references services(service_id)
  foreign key (payment_id) references payment(payment_id)
);

INSERT INTO orders values
  (1,"2022-08-15",4,3,2,2,3,2),
  (2,"2022-08-17",1,2,1,5,1,1),
  (3,"2022-08-25",2,2,8,2,2,3),
  (4,"2022-08-29",3,4,8,1,2,1),
  (5,"2022-09-02",5,1,5,2,2,3),
  (6,"2022-09-08",1,3,4,4,3,2),
  (7,"2022-09-09",4,5,10,6,2,3),
  (8,"2022-09-19",5,3,9,4,1,1),
  (9,"2022-09-23",2,1,3,2,2,1),
  (10,"2022-09-25",1,5,5,3,2,3)
  ;
--select * from orders

--query 1  top 5 menus
select
  me.menu_name,
  o.amout,
  o.amout* me.menu_price AS profit
from menus as me 
join orders as o
on me.menu_id = o.menu_id
order by o.amout desc 
limit 5;

--query 2 most use service in September 
select
  se.service_type,
  count(se.service_type)
from orders as o
join services as se on o.service_id = se.service_id
where strftime('%m',order_date) == "09"
group by se.service_type;

--query 3 Most hard work staff
select
  count(o.staff_id),
  st.staff_name,
  st.staff_position
from orders as o 
join staffs as st 
on o.staff_id = st.staff_id
group by st.staff_id 
order by 1 DESC ;

-- Query 4 sales in August
select 
  menu_name,
  amout,
  menu_type,
  menu_price as price_per_1,
  amout*menu_price as total_price,
  service_type,
  payment_method
from(
  select *
  from orders as o 
  join menus as me 
  on o.menu_id = me.menu_id
  join services as se 
  on o.service_id = se.service_id
  join payment as pe 
  on o.payment_id = pe.payment_id
  where strftime('%m',o.order_date) == "08"
  )AS sub
order by total_price DESC ;
