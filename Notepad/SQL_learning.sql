CREATE DATABASE database_name;
CREATE TABLE table_name;

ALTER DATABASE database1 modify name=database2;

DROP DATABASE database_name;

--Note: Database cant be dropped if it is in use.

ALTER DATABASE database1 SET SINGLE_USER with ROLLBACK Immediate;

--This will rollback all incomplete connections and closes all connections to database

CREATE TABLE thbs_employee
(
emp_id INT NOT NULL AUTO_INCREMENT,
emp_name VARCHAR(20) NOT NULL,
emp_salary VARCHAR(20) NOT NULL,
emp_email VARCHAR(45) NOT NULL,
emp_age int NULL DEFAULT 0,
gen_id INT NULL,
sal_id INT NULL,
Primay key(emp_id)
CONSTRAINT emp_age_CK CHECK(emp_age >0 AND emp_age_100)
CONSTRAINT emp_email_UQ UNIQUE(emp_email)
CONSTRAINT gen_id_fk FOREIGN KEY (gen_id) 
REFERENCES thbs_gender (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION,
CONSTRAINT sal_id_fk FOREIGN KEY(sal_id)
REFERENCES thbs_salary (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION);

CREATE TABLE thbs_salary
(
id int NOT NULL AUTOINCREMENT,
cust_id int NOT NULL,
sal_value varchar(30) NOT NULL
primary key(id)
)

CREATE TABLE thbs_gender
(
id INT NOT NULL AUTO_INCREMENT,
gen_val VARCHAR(20) NOT NULL,
Primay key(gen_id));

-- Now adding foreign key constraint in thbsEmployee entity(emp_gender), primary key in thbsGender entity(gen_id)

ALTER TABLE thbsEmployee ADD CONSTRAINT gen_id_fk FOREIGN KEY (gen_id) REFERENCES thbs_gender (id);

-- Adding default constraint for existing column

ALTER TABLE thbs_employee ADD CONSTRAINT df_gen_id DEFAULT 3 FOR GEN_ID;

-- Adding default constraint for new column

ALTER TABLE thbsEmployee
ADD COLUMN is_active int NOT NULL
CONSTRAINT df_thbsEmployee_is_active DEFAULT 0;

-- Drop constraint

ALTER TABLE thbsEmployee
DROP CONSTRAINT df_thbsEmployee_is_active;

-- Cascading Referential Integrity
-------------------------------------
-- When a column is referred as foreign key in some other entity then deleting or updating a row in the parent table is restricted.
-- By default , the settings will be "update no action" and "delete no action"
-- We can set it default value / set it to NULL / cascade the action under cascading referential integrity


-- Add Check constraint

ALTER TABLE thbs_employee
ADD CONSTRAINT CK_thbs_employee_Age CHECK(emp_age > 0 AND emp_age < 100)

-- Identity column :
------------------------
-- Auto computed /Auto incremented or to be used as a identity column in the table

CREATE TABLE document
( 
document_id INT NOT NULL AUTOINCREMENT,
documemt_value VARCHAR(30) NULL 
primary key(document_id)
);

-- To supply expicitly the value for identity column

SET INDENTITY_INSERT  document ON
SET INDENTITY_INSERT  document OFF

-- to get the last generated identity column value

CREATE TABLE payment
(
id int NOT NULL IDENTITY(1,1)
val varchar(30)
primary key(id)
);

SELECT SCOPE_IDENTITY()
SELECT @@INDENTITY

-- Unique constraints

-- Differences btw unique and primary key constraints
--A table can have on primary key constraint and more than one unique constraint
--primary key doesnt allow null and unique key allow null

ALTER TABLE thbs_employee
ADD CONSTRAINT emp_email_UQ UNIQUE(empa_email)

ALTER TABLE thbs_employee
DROP CONSTRAINT emp_email_UQ

-- SELECT Statement--

SELECT * FROM thbs_employee;
SELECT emp_age FROM thbs_employee;
SELECT DISTINCT emp_email FROM thbs_employee;
SELECT * FROM thbs_employee WHERE (CONDITION)
-- {=,!=,<>,>,<,IN , NOT IN , BETWEEN, LIKE(Wildcards: % , _(One Character),[],[^]), NOT BETWEEN , NOT LIKE , NOT NULL }
-- {AND , OR Condition}
SELECT * FROM thbs_employee ORDER BY emp_id LIMIT 1;
SELECT * FROM thbs_employee ORDER BY emp_id DESC , emp_email ASC;
SELECT TOP 1 * FROM thbs_employee ORDER BY AGE DESC;

-- GROUP BY --

SELECT city, max(salary) as [Total Salary] FROM employee_details
GROUP BY city;

SELECT city,gender, max(salary) as [Total Salary] FROM employee_details
GROUP BY city,gender
ORDER BY salary DESC;

-- Filtering is performed before aggregration is done
SELECT city,gender, max(salary) as [Total Salary], COUNT[id] as [Total Employees] FROM employee_details
WHERE gender='Male'
GROUP BY city;

--Filtering is performed after aggregration is done
SELECT city,gender, max(salary) as [Total Salary], COUNT[id] as [Total Employees] FROM employee_details
GROUP BY city
HAVING gender='Male';


-- Note:
-- HAVING clause can be used only with Select query
-- Aggregrate functions cant be used with where clause
-- Aggregrate functions can be used with Having clause


-- JOINS

-- INNER JOIN will return only matching rows between two tables
-- LEFT OUTER  JOIN will return all matching rows + non matching rows of left table
-- RIGHT OUTER  JOIN will return all matching rows + non matching rows of Right table
-- FULL OUTER  JOIN will return all matching rows + non matching rows of both tables

SELECT name,age,salary,departmentname
FROM empdetails INNER JOIN departmentdetails
ON empdetails.departmentid=departmentdetails.id

SELECT name,age,salary,departmentname
FROM empdetails JOIN departmentdetails
ON empdetails.departmentid=departmentdetails.id

SELECT name,age,salary,departmentname
FROM empdetails LEFT OUTER JOIN departmentdetails
ON empdetails.departmentid=departmentdetails.id

SELECT name,age,salary,departmentname
FROM empdetails RIGHT OUTER JOIN departmentdetails
ON empdetails.departmentid=departmentdetails.id

SELECT name,age,salary,departmentname
FROM empdetails OUTER JOIN departmentdetails
ON empdetails.departmentid=departmentdetails.id

SELECT name,age,salary,departmentname
FROM empdetails CROSS JOIN departmentdetails


-- ADVANCED JOINS

-- Returning only non matching rows of left table using LEFT OUTER JOIN
-- Returning only non matching rows of Right table using RIGHT OUTER  JOIN
-- Returning only non matching rows of both tables

SELECT name,age,salary,departmentname
FROM empdetails LEFT OUTER JOIN departmentdetails
ON empdetails.departmentid=departmentdetails.id
WHERE empdetails.departmentid is NULL
OR departmentdetails.id is NULL

SELECT name,age,salary,departmentname
FROM empdetails RIGHT OUTER JOIN departmentdetails
ON empdetails.departmentid=departmentdetails.id
WHERE empdetails.departmentid is NULL
OR departmentdetails.id is NULL

SELECT name,age,salary,departmentname
FROM empdetails OUTER JOIN departmentdetails
ON empdetails.departmentid=departmentdetails.id
WHERE empdetails.departmentid is NULL
OR departmentdetails.id is NULL


-- SELF JOINS
-- INNER JOIN will return only matching rows between same tables
-- LEFT JOIN will return all matching rows + non matching rows of left table
-- RIGHT JOIN will return all matching rows + non matching rows of Right table
-- FULL OUTER  JOIN will return all matching rows + non matching rows of both tables

select ed.empname as Employee , md.managername as Manager
FROM empdetails ed INNER JOIN empdetails md
ON ed.managerid=md.empid

select ed.empname as Employee , md.managername as Manager
FROM empdetails ed LEFT JOIN empdetails md
ON ed.managerid=md.empid

select ed.empname as Employee , md.managername as Manager
FROM empdetails ed RIGHT JOIN empdetails md
ON ed.managerid=md.empid

select ed.empname as Employee , md.managername as Manager
FROM empdetails ed CROSS JOIN empdetails md

-- For eg.,
-- select ud.fname as username,md.fname as Supervisor  from user_details ud Inner join user_details md on ud.supervisor_id=md.user_id limit 20;
-- select ud.fname as username,md.fname as Supervisor  from user_details ud Left join user_details md on ud.supervisor_id=md.user_id limit 20;
-- select ud.fname as username,md.fname as Supervisor  from user_details ud Right join user_details md on ud.supervisor_id=md.user_id limit 20;
-- select ud.fname as username,md.fname as Supervisor  from user_details ud cross join user_details md limit 20;


-- ISNULL , COALESCE , CASE

select ed.empname as Employee , ISNULL(md.managername, 'No Manager') as Manager
FROM empdetails ed LEFT JOIN empdetails md
ON ed.managerid=md.empid

select ed.empname as Employee , COALESCE(md.managername, 'No Manager') as Manager
FROM empdetails ed LEFT JOIN empdetails md
ON ed.managerid=md.empid

select ed.empname as Employee , CASE WHEN md.managername IS NULL THEN 'No Manager' ELSE md.managername as Manager
FROM empdetails ed LEFT JOIN empdetails md
ON ed.managerid=md.empid

-- UNION AND UNION ALL

SELECT * FROM empdetails1
UNION
SELECT * FROM empdetails2

SELECT * FROM empdetails1
UNION ALL
SELECT * FROM empdetails2

SELECT * FROM empdetails1
UNION ALL
SELECT * FROM empdetails2
ORDER BY empname

--UNION query executes late than UNION ALL query as it removes duplicates
--For UNION /UNION ALL query to execute , datatype, number of columns , order of columns should be same in both queries


--Difference between JOINS and UNIONS:
--In short, UNION combine rows of two or more tables where as JOIN combine columns from two or more tables based on 
--logical relationship between the tables


-- STRING FUNCTIONS in sql

-- LTRIM() , RTRIM() , REVERSE(), ASCII() , LEN() , CHAR() , concat()



select u.user_id, u.sername, td.training_id, td.training_date, count(td.user_training_id) as count 
from users u 
inner join training_details td 
on u.user_id=td.user_id 
group by
u.user_id
username
training_id
training_date
Having count > 1
order by training_date desc;


select salary from employee order by salary desc limit n-1,1;

-- Second largest salary
--select salary from employee order by salary desc limit 2-1,1;
select salary from employee order by salary desc limit 1,1;

--Third largest salary:
--select salary from employee order by salary desc limit 3-1,1;
select salary from employee order by salary desc limit 2,1;

select emp2.emp_id, emp2.emp_name , avg(emp1.salary) as Average_salary_under_Manager from employee emp1 , employee emp2 where emp1.manager_id=emp2.emp_id
group by  emp2.emp_id, emp2.emp_name
order by emp2.emp_id desc;


select agent.user_id, agent.fname , agent.role_id , supervisor.user_id, supervisor.fname , supervisor.role_id, count(supervisor.user_id) as COUNT 
from user_details agent, user_details supervisor 
where agent.supervisor_id=supervisor.user_id 
group by agent.user_id, agent.fname, agent.role_id, supervisor.user_id, supervisor.fname, supervisor.role_id 
having count(agent.user_id)>1 
order by supervisor.user_id asc;


************** Query ******************************

select supervisor.user_id, supervisor.fname , supervisor.role_id, count(supervisor.user_id) as COUNT  
from user_details agent, user_details supervisor  
where agent.supervisor_id=supervisor.user_id  
group by supervisor.user_id, supervisor.fname, supervisor.role_id  
having count(agent.user_id)>1  
order by supervisor.user_id asc;


*********************Query gives all agents under the supervisor ***************

select agent.user_id as AgentId, agent.fname as AgentName , agent.role_id as AgentRoleId , supervisor.user_id as SupervisorId, supervisor.fname as SupervisorName , supervisor.role_id as SupervisorRoleId
from user_details agent, user_details supervisor  
where agent.supervisor_id=supervisor.user_id 
and supervisor.user_id='6';


Best Website to practise SQL: https://www.w3resource.com/sql-exercises/

select * from salesmen;
select name,city from salesman where city='Paris';
select * from customer where grade=200;
select order_number,order_date,purchase_amount from orders where salesman_id='5001';
select * from nobel_win where year='1970';
select winner,subject,year from nobel_win where subject='Literature' and year='1971'
select winner from nobel_win where subject='Physics' and year >= 1950;
select year, subject, winner, country from nobel_win where subject='Chemistry' and year>=1965 and year<=1975;
select * from nobel_win where winner in ('Menachem Begin','Yitzhak Rabin') and year > 1972;
select * from nobel_win where winner like 'Louis%';
select winner, subject , year from nobel_win where subject='physics' and year='1970' UNION
select winner, subject , year from nobel_win where subject='Economics' and year='1971' 

select winner from nobel_win where subject not like 'P%' order by year desc ;
select * from nobel_win where year='1970' order by subject desc , winner

select pro_com , avg(pro_price) from item_mast group by pro_com;
select name, price from item_mast where price >=250 order by price desc , name;

select distinct emp_lname from emp_details;
select * from emp_details group by emp_lname having count(emp_lname) > 1;

select * from customers where city='Newyork' or grade > 100;
select * from orders where ((ord_date <> '2012-09-10' and salesman_id<='5005') or purch_amt <='1000.00');
select * from orders where (purch_amt<200 or not(ord_date>='2012-02-10' and customer_id<3009));


select * from salesman where  city='Paris' or city='Rome';
Select * from salesman where city in ('Paris','Rome');
select * from salesman where city not in ('Paris','Rome');
select * from orders where purch_amt between 500 and 4000 and purch_amt not in ('948.50','1983.43');
select * from salesman where name like 'A%' and name like 'k%';
select * from  salesman where name like 'N__I%';
select * from customer where grade is not null;
select * from testtable where col1 not like '%/%%' Escape '/';
select * from testtable where col1 like '%/%%' Escape '/';

select * from testtable where col1 not like '%/_//%' Escape '/';

select sum(purch_amt) from orders;
select avg(purch_amt) from orders;
select count(salesman_id) from orders;
select count(customer_id) from customer where cust_name is not null;
select count(customer_id) from customer where grade is not null;
select max(purch_amt) from orders;
select min(purch_amt) from orders;

---- Write a SQL statement which selects the highest grade for each of the cities of the customers.
select cust_name, city , max(grade) from customer where grade is not null group by cust_name , city;

---- Write a SQL statement to find the highest purchase amount ordered by the each customer with their ID and highest purchase amount. 
select customer_id , max(purch_amt) from orders group by customer_id;

---- Write a SQL statement to find the highest purchase amount ordered by the each customer on a particular date with their ID, order date and highest purchase amount.
select customer_id , max(purch_amt) , ord_date from orders group by customer_id,ord_date ;

---- Write a SQL statement to find the highest purchase amount on a date '2012-08-17' for each salesman with their ID
select salesman_id , max(purch_amt) from orders where ord_date ='2012-08-17' group by salesman_id;

-- Write a query in SQL to find the number of employees in each department along with the department code
select count(emp_idno), emp_dept from emp_details group by EMP_DEPT;

--- Write a SQL query to display the average price of each company's products, along with their code
select pro_com, avg(pro_price) from item_mast group by pro_com;

--- Write a SQL query to find the number of products with a price more than or equal to Rs.350.
select count(pro_id) as numberofProducts from item_mast where pro_price>=350;

--- Write a query that counts the number of salesmen with their order date and ID registering orders for each day.
select count(salesman_id), ord_date , salesman_id from orders group by salesman_id, ord_date;

--- Write a SQL statement to find the highest purchase amount with their ID, for only those salesmen whose ID is within the range 5003 and 5008.
select salesman_id ,max(purch_amt) from orders where salesman_id between '5003' and '5008' group by salesman_id
SELECT salesman_id,MAX(purch_amt) FROM orders GROUP BY salesman_id HAVING salesman_id BETWEEN 5003 AND 5008;


--- Write a SQL statement to display customer details (ID and purchase amount) whose IDs are within the range 3002 and 3007 and highest purchase amount is more than 1000
select customer_id, max(purch_amt) from orders where customer_id between 3002 and 3007 group by customer_id having max(purch_amt)>1000;


---- Write a SQL statement to find the highest purchase amount with their ID, for only those customers whose ID is within the range 3002 and 3007
select customer_id, max(purch_amt) from customers group by customer_id having customer_id between 3002 and 3007;
select customer_id, max(purch_amt) from customers where customer_id between 3002 and 3007 group by customer_id ;

---- Write a SQL statement to find the highest purchase amount with their ID and order date, for only those customers who have a higher purchase amount in a day is within the list 2000, 3000, 5760 and 6000.
select customer_id, ord_date , max(purch_amt) from orders group by customer_id, ord_date having max(purch_amt) in ('2000','3000','5760','6000');

Multiple tables ( Not using JOIN queries)

----- Write a query to find those customers with their name and those salesmen with their name and city who lives in the same city
select cust_name , name , cus.city from customer cus inner join salesman sales on cus.city=sales.city;
select customer.cust_name , salesman.name , customer.city from customer , salesman where customer.city=salesman.city;

----- Write a SQL statement to find the names of all customers along with the salesmen who works for them.
select customer.cust_name , salesman.name from customer , salesman where customer.salesman_id=salesman.salesman_id;
select cust_name , name from customer cus inner join salesman sales on cus.salesman_id=sales.salesman_id;

------ Write a SQL statement to display all those orders by the customers not located in the same cities where their salesmen live.
SELECT ord_no, cust_name, orders.customer_id, orders.salesman_id FROM salesman, customer, orders WHERE customer.city <> salesman.city AND orders.customer_id = customer.customer_id AND orders.salesman_id = salesman.salesman_id;
select ord_no, customer.cust_name, orders.customer_id, orders.salesman_id from customer inner join salesman on customer.salesman_id=salesman.salesman_id inner join orders on customer.customer_id=orders.customer_id where customer.city <> salesman.city

------ Find all customers with orders on October 5, 2012.
select * from customers, orders where customers.customer_id=orders.customer_id and orders.ord_date='2012-10-05';

------ Write a SQL statement that produces all orders with the order number, customer name, commission rate and earned commission amount for those customers who carry their grade is 200 or more and served by an existing salesman.
select ord_no, cust_name , commission as "Commission%", (purch_amt*commission) as "Commission"  from customers, orders, salesman where customers.customer_id=orders.customer_id and orders.salesman_id=salesman.salesman_id and customer.grade >=200 ;


--- Write a query that produces all customers with their name, city, salesman and commission, who served by a salesman and the salesman works at a rate of the commission within 12% to 14%.
select cust_name , customers.city, commission from customers , salesman where customers.salesman_id=salesman.salesman_id and commission between 0.12 and 0.14;

--- Write a SQL statement that sorts out the customer and their grade who made an order. Each of the customers must have a grade and served by at least a salesman, who belongs to a city.
select cust_name , grade from customers, orders, salesman where customers.salesman_id=salesman.salesman_id and orders.customer_id=customers.customer_id and customers.grade is not null and salesman.city is not null;

USING JOINs:

Write a SQL statement to find the list of customers who appointed a salesman for their jobs who gets a commission from the company is more than 12%.


*******************************************************************************************************
Write a query in SQL to find the names of departments where more than two employees are working.
select dpt_name, count(emp_dept) 
from emp_details inner join emp_department 
on emp_details.emp_dept=emp_department.dpt_code 
group by dpt_name, emp_dept 
having count(emp_dept)> 2;

*******************************************************************************************************

Write a query in SQL to find the first name and last name of employees working for departments with a budget more than Rs. 50000.
select emp_fname, emp_lname 
from emp_details inner join emp_department 
on emp_details.emp_dept=emp_department.dpt_code
where emp_department.DPT_ALLOTMENT > 50000;

*******************************************************************************************************

Write a SQL query to display the name of each company along with the ID and price for their most expensive product.

select com_id as company_id, com_name as company_name, max(pro_price) as Expensive_product_prize 
from company_mast inner join item_mast 
on company_mast.com_id=item_mast.pro_com 
group by com_id , com_name;

*******************************************************************************************************

Write a SQL query to display the names of the company whose products have an average price larger than or equal to Rs. 350.

select com_name as company_name, avg(pro_price) as Average_price 
from company_mast inner join item_mast
on company_mast.com_id=item_mast.pro_com
group by com_id, com_name 
having avg(pro_price) >=350;
`

*******************************************************************************************************
Write a SQL query to display the average price of items of each company, showing the name of the company.

select com_name as CompanyName , avg(pro_price) as AveragePrice 
from company_mast inner join item_mast 
on company_mast.com_id=item_mast.pro_com 
group by com_name;

*******************************************************************************************************
Write a SQL query to display the item name, price, and company name of all the products.

select pro_name as ItemName , pro_price as price , com_name as CompanyName 
from company_mast inner join item_mast 
on company_mast.com_id=item_mast.pro_com;

**************************************Very Important*****************************************************************
Write a SQL statement to make a cartesian product between salesman and customer i.e. each salesman will appear for all customer and vice versa for those salesmen who must belong a city 
which is not the same as his customer and the customers should have an own grade.

Key points:
cartesian product between salesman and customer i.e., each salesman will appear for all customer and vice versa
salesmen who must belong a city
customers should have an own grade
salesmen city is not the same as his customer

select * from salesman 
cross join customers on salesman.salesman_id=customers.salesman_id 
where salesman.city is not null 
and customers.grade is not null 
and salesman.city<>customers.city;

**************************************Very Important*****************************************************************

Write a SQL statement to make a cartesian product between salesman and customer i.e. each salesman will appear for all customer and vice versa for those salesmen who belongs to a city and the customers who must have a grade

select * from salesman 
cross join customers on salesman.salesman_id=customers.salesman_id 
where salesman.city is not null 
and customers.grade is not null;

**************************************Very Important*****************************************************************

Write a SQL statement to make a cartesian product between salesman and customer i.e. each salesman will appear for all customer and vice versa for that salesman who belongs to a city.

select * from salesman 
cross join customers on salesman.salesman_id=customers.salesman_id 
where salesman.city is not null;

**************************************Very Important*****************************************************************

Write a SQL statement to make a cartesian product between salesman and customer i.e. each salesman will appear for all customer and vice versa.

select * from salesman 
cross join customers on salesman.salesman_id=customers.salesman_id;

**************************************Very Important*****************************************************************

Write a SQL statement to make a report with customer name, city, order no. order date, purchase amount for only those customers on the list who must have a grade and placed one 
or more orders or which order(s) have been placed by the customer who is neither in the list not have a grade.

select customer.cust_name , customer.city , orders.ord_no , orders.ord_date , orders.purch_amt 
from customer Full outer join orders 
on customer.customer_id=orders.customer_id 
where customer.grade is not null

**************************************Very Important*****************************************************************

Write a SQL statement to make a list for the salesmen who either work for one or more customers or yet to join any of the customer. The customer, may have placed, either one or more orders on or above order amount 2000 and must have a grade, 
or he may not have placed any order to the associated supplier.

select * from customer
right outer join salesman 
on customers.salesman_id=salesman.salesman_id  
left outer join orders 
on customer.customer_id=orders.customer_id
where orders.purch_amt >=2000
and customer.grade is not null;

**************************************Very Important*****************************************************************

Write a SQL statement to make a list for the salesmen who works either for one or more customer or not yet join under any of the customers who placed either one or more orders or no order to their supplier.

select * from customer
right outer join salesman 
on customer.salesman_id=salesman.salesman_id
left outer join orders
on customer.customer_id=orders.customer_id;

**************************************Very Important*****************************************************************

Write a SQL statement to make a list in ascending order for the salesmen who works either for one or more customer or not yet join under any of the customers.

select * from customer
right outer join salesman 
on customer.salesman_id=salesman.salesman_id
order by salesman.salesman_id;

**************************************Very Important*****************************************************************

Write a SQL statement to make a report with customer name, city, order number, order date, order amount salesman name and commission to find that either any of the existing customers have placed no order or placed one or more orders by their salesman or by own.

select customer.cust_name, customer.city, orders.ord_no, orders.ord_date, orders.purch_amt,salesman.name, salesman.commission from customer 
left outer join orders
on customer.customer_id=orders.customer_id
left outer join salesman
on orders.salesman_id=salesman.salesman_id;

**************************************Very Important*****************************************************************


Write a SQL statement to make a report with customer name, city, order number, order date, and order amount in ascending order according to the order date to find that either any of the existing customers have placed no order or placed one or more orders.

select cust_name,customer.city,ord_no,ord_date, purch_amount 
from customer left outer join orders 
on customer.customer_id=orders.customer_id 
order by ord_date;

**************************************Very Important*****************************************************************


Write a SQL statement to make a list in ascending order for the customer who holds a grade less than 300 and works either through a salesman or by own.

select customer.cust_name , customer.grade , customer.city, salesman.name from customer left outer join salesman
on customer.salesman_id=salesman.salesman_id
where customer.grade <300
order by customer.customer_id;

*********************************************** NATURAL JOIN ***********************************************
Write a SQL statement to make a join on the tables salesman, customer and orders in such a form that the same column of each table will appear once and only the relational rows will

select * from orders 
Natural join customer
Natural join salesman;

**************************************Very Important*****************************************************************


Write a SQL statement to find the details of a order i.e. order number, order date, amount of order, which customer gives the order and which salesman works for that customer and how much commission he gets for an order.

select orders.ord_no, orders.ord_date , orders.purch_amt , customer.cust_name  as CustomerName, salesman.name as "SalesMan" , salesman.commission
from orders inner join customer
on orders.customer_id=customer.customer_id
inner join salesman
on customer.salesman_id=salesman.salesman_id;

Write a SQL statement to find the list of customers who appointed a salesman for their jobs who does not live in the same city where their customer lives, and gets a commission is above 12%

select customer.cust_name as CustomerName , customer.city , salesman.name as "Salesman" , salesman.commission 
from customer inner join salesman
on customer.salesman_id=salesman.salesman_id
where salesman.city <> customer.city and salesman.commission > 0.12;



VIEWS:

create view sorder as select * from orders inner join salesman on orders.salesman_id=salesman.salesman_id where ord_date ='2012-10-17' or ord_date ='2012-10-10';


Subqueries:
Write a query to display all the orders from the orders table issued by the salesman 'Paul Adam'.
-- select * from orders where salesman_id = (select salesman_id from salesman where name='Paul Adam') ;

Write a query to display all the orders which values are greater than the average order value for 10th October 2012.
select * from orders where purch_amt > ( select avg(purch_amt) from orders where ord_date ='2012-10-10');

Write a query to display the commission of all the salesmen servicing customers in Paris.
select name , commission from salesman where salesman_id in (select salesman_id from customer where city='Paris');

Write a query to count the customers with grades above New York's average.
select count(*) from customers where grade > (select avg(grade) from customers where city='Newyork');

Write a query to find the name and numbers of all salesmen who had more than one customer.
select salesman_id, name from salesman where salesman_id in ( select salesman_id from customer group by salesman_id having count(salesman_id) > 1);

Write a query to extract the data from the orders table for those salesman who earned the maximum commission
select * from orders where salesman_id in (select salesman_id from salesman where comission =(select max(commission) from salesman));

Write a query to display all the customers with orders issued on date 17th August, 2012.
select * from customer where customer_id in (select customer_id from orders where ord_date='2012-08-17');

very important****
Write a queries to find all orders with order amounts which are on or above-average amounts for their customers.
select * from orders a where purch_amt > (select avg(purch_amt) from orders b where a.customer_id=b.customer_id);

Write a query to find the sums of the amounts from the orders table, grouped by date, eliminating all those dates where the sum was not at least 1000.00 above the maximum order amount for that date.
select ord_date , sum(purch_amt) from orders a group by ord_date having sum(purch_amt) > (select 1000.00 + max(purch_amt) from orders b on a.ord_date=b.ord_date);

Write a query to find all the salesmen who worked for only one customer. 
select * from salesman where salesman_id not in (select salesman_id from customers group by salesman_id having count(salesman_id)> 1)

select * from salesman where salesman_id in ( select salesman_id from orders a where customer_id in (select customer_id from orders b  where  a.customer_id=b.customer_id group by customer_id having sum(customer_id)>1));




