create database Testing;

use Testing;


create table Employee1 (
    emp_id int not null primary key,
    f_name varchar(20),
    l_name varchar(20),
    email varchar(20),
    phone_number int,
    hire_date date,
    job_id int,
    salary int,
    commission_pct varchar(20),
    manager_id int not null,
    department_id int not null
    -- foreign key(department_id) references department(manager_id)
);
drop table Employee1;
alter table Employee1
change l_nam l_name varchar(20);

desc Employee1;

INSERT INTO Employee1 (emp_id, f_name, l_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id) 
VALUES 
(1, 'John', 'Doe', 'john@example.com', 21332, '2023-01-05', 1, 50000, '10%', 3, 2),
(2, 'Alice', 'Smith', 'alice@example.com', 324343, '2023-01-05', 2, 60000, '15%', 3, 1),
(3, 'Bob', 'Johnson', 'bob@example.com', 54, '2022-12-15', 3, 55000, '12%', 5, 3),
(4, 'Emma', 'Brown', 'emma@example.com', 5443, '2023-03-20', 2, 62000, '18%', 5, 1),
(5, 'Mike', 'Wilson', 'mike@example.com', 342, '2023-04-25', 1, 70000, '10%', 7, 2),
(6, 'Sarah', 'Miller', 'sarah@example.com', 5433, '2023-05-30', 3, 72000, '15%', 7, 3),
(7, 'David', 'Taylor', 'david@example.com', 4532, '2023-06-05', 2, 65000, '10%', 9, 1),
(8, 'Emily', 'Anderson', 'emily@example.com', 535, '2023-07-10', 1, 55000, '8%', 9, 2),
(9, 'Daniel', 'Martinez', 'daniel@example.com', 6577, '2023-08-15', 3, 60000, '12%', 11, 1),
(10, 'Olivia', 'Garcia', 'olivia@example.com', 7654, '2023-09-20', 1, 58000, '10%', 11, 3);


desc Employee1;
select * from Employee1;

-- 										List all employees who were hired in the same date as John Doe. Do not print John Doe
select * from Employee1 e1 where hire_date = (select hire_date from Employee1 e2 where e2.f_name='John' and e2.l_name='Doe' and e1.emp_id<>e2.emp_id) ;


--------------------------- create department table
create table department(
	department_id int primary key,
    department_name varchar(20),
	manager_id int ,
    location_id int,
    foreign key (manager_id) references Employee1(emp_id)
);
desc department;
drop table department;
drop table employee;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create table Employee(
	emp_id int primary key,
    emp_name varchar(20),
    department varchar(15),
    salary int
);
INSERT INTO Employee (emp_id, emp_name, department, salary) VALUES
(6, 'Mike', 'IT', 10500),
(7, 'Sarah', 'HR', 12500),
(8, 'David', 'Finance', 15500),
(9, 'Emily', 'IT', 10800),
(10, 'Daniel', 'HR', 12800),
(11, 'Olivia', 'Finance', 15200),
(12, 'Sophia', 'IT', 11200),
(13, 'James', 'HR', 13500),
(14, 'Mia', 'Finance', 15800),
(15, 'William', 'ITI', 11500),
(16,'Abhishek','ÇS',19000);

select * from Employee;

-- 														sum() , avg() count(*), coutn(emp_id) min() max()

select sum(distinct(salary)) from employee;
select avg(distinct(salary)) from employee;

--               		                      List of employees working in department where employee strength is less than 3

Select * from Employee where department in 
(select department from Employee group by department having count(department)<3);

--                                            print employee getting the max salary in each department
Select * from employee order by salary desc;
select * from employee e1 where salary = (select max(salary) from employee e2 group by department having e1.department=e2.department);


--                                             print employee having the nth highest salary

-- approach1 ( e.g n=3)  sort the table in descending order, limit the row count to n and then again sort the table in ascending order and limit the count to 1
select * from (select * from employee order by salary desc limit 3) as e1 order by salary limit 1 ;

-- approach2  -- > outside in approach --> inner query to be processed for every row it receives from outer query
Select * from employee e1 where 2 = (select count(*) from employee e2 where e2.salary>e1.salary);


--											   print employee having the 3rd highest salary in each department

--											   print top 3 employees getting highest salary in each department
select * from 
(select *,row_number() over (partition by department order by salary desc) as row_num from employee) as temp where row_num<2 order by department;


drop table Employee;

------------------------------------------------------------------------------------------------------------------------------------------------------------
-- count(*) vs count (column_name) -> in count(*) null rows are also added
-------------------------------------------------------------------------------------------------------------------------------------------------------------

create table Employee(
	emp_id int primary key,
    emp_name varchar(20),
    address varchar(10)
);

create table project(
	proj_id int primary key,
    emp_id int,
    pname varchar(20),
    location varchar(20),
    foreign key(emp_id) references Employee(emp_id)
); 

INSERT INTO Employee (emp_id, emp_name, address) VALUES
(1, 'John', '123 Street'),
(2, 'Alice', '456 Avenue'),
(3, 'Bob', '789 Road'),
(4, 'Emma', '101 Park'),
(5, 'Mike', '202 Lane'),
(6, 'Sarah', 'Boulevard'),
(7, 'David', '404 Court'),
(8, 'Emily', '505 Place');

INSERT INTO project (proj_id, emp_id, pname, location) VALUES
(101, 1, 'Project X', 'New York'),
(102, 2, 'Project Y', 'Los Angeles'),
(103, 3, 'Project Z', 'Chicago'),
(104, 2, 'Project A', 'Houston'),
(105, 3, 'Project B', 'San Francisco');

--													Find the detail of employee who is working on at least one project
-- using in ( first inner query will be executed -> inside out approach)
select * from Employee e1 where emp_id in (select emp_id from project);

-- using exists (outside in approach)
select * from employee e1 where exists (select emp_id from project p1 where e1.emp_id=p1.emp_id);  

-- joins
select * from employee e inner join project p where e.emp_id = p.emp_id; 


drop table employee;
drop table project;

---------------------------------------------------------------------------------------------------------------------------------


create table employee(
	name varchar(20),
    age int,
    salary int
);

INSERT INTO employee (name, age, salary) VALUES 
('John', 30, 50000),
('John', 30, 50000),
('Alice', 31, 90000),
('Bob',24,10000);

select * from employee;
-- 											delete all duplicate records

-- using row_number
Delete from employee where (name,age,salary) in (select name,age,salary from 
(select name,age,salary,row_number() over (partition by name,age,salary) as row_num from employee) as duplicates where row_num>1);

--											delete duplicate records ( rowid not present in mysql but available in oracle)
Delete from employee where rowid not in (select min(rowid) from employee group by name );

select * from employee;

truncate table Employee;
------------------------------------------------------------------------------------------------------------------------------------------------------------------
create table employee(
	emp_id int primary key,
    emp_name varchar(20),
    manager_id int,
    salary int 
);

INSERT INTO employee (emp_id, emp_name, manager_id, salary)
VALUES (1, 'A', 2, 50000),
       (2, 'B', 4, 60000),
       (3, 'C', 1, 70000),
       (4, 'D', 1, 55000),  
       (5, 'E', 2, 70000),  
       (6, 'F', 3, 75000); 

-- 												employee earning more than managers ( self join)

select e.emp_id,e.emp_name,e.salary as emp_salary, e.manager_id,ee.emp_name as manager_name, ee.salary as manager_salary from employee e inner join employee ee on e.manager_id = ee.emp_id 
where e.salary>ee.salary;

select * from employee;
truncate table employee;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

create table employee(
	id int,
    salary int,
    year int
);

INSERT INTO employee (id, salary, year) VALUES
(1, 50000, 2020),
(1, 60000, 2021),
(1, 40000, 2022),
(2, 55000, 2020),
(2, 65000, 2021),
(2, 75000, 2022),
(3, 48000, 2020),
(3, 58000, 2021),
(3, 68000, 2022),
(3, 50000, 2023);

--										employee whose salary increase in 3 consecutive years
select * from employee;

select id from (select *,lead(salary,1,0) over (partition by id order by year) as increase from employee ) as temp where temp.salary<temp.increase group by id
having count(*)>=2;

truncate table employee;
drop table employee;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 										R A N K      VS       D E N S E     R A N K  

create table marks(
	marks int
);
insert into marks(marks) values (10),(11),(12),(12),(12),(13),(13);

select *,row_number() over (order by marks), rank() over (order by marks), dense_rank() over (order by marks) from marks;

drop table marks;

---------------------------------------------------------------------------- 	ON DELETE CASCADE   -------------------------------------------------------------------------
--		create table employee
create table employee(
	empid int primary key,
    empname varchar(20)
);
--		create table salary
create table salary(
	empid int,
    salary int,
    foreign key (empid) references employee(empid) on delete cascade
);
--		create table dependents
create table dependents(
	empid int,
    dependent varchar(20),
    foreign key (empid) references employee(empid) on delete cascade
);

-- Insert records into the employee table
INSERT INTO employee (empid, empname) VALUES
(1, 'John'),
(2, 'Alice'),
(3, 'Bob');

-- Insert records into the salary table
INSERT INTO salary (empid, salary) VALUES
(1, 60000),
(2, 70000),
(3, 50000);

-- Insert records into the dependents table
INSERT INTO dependents (empid, dependent) VALUES
(1, 'Child1'),
(1, 'Child2'),
(2, 'Spouse1'),
(3, 'Parent1');

desc salary;

select * from employee;

select * from salary;

select * from dependents;

delete from employee where empid=1;

drop table employee;

drop table dependents;

drop table salary;

------------------------------------------------				T R I G G E R S 			--------------------------------------------------------
create table main(
	empid int,
    emp_name varchar(20)
);

create table back_up(
	empid int,
    emp_name varchar(20)
);

create trigger t
before delete on main
for each row
insert into back_up values(old.empid,old.emp_name);

-- Insert 5 rows into the main table
INSERT INTO main (empid, emp_name) VALUES
(1, 'John'),
(2, 'Alice'),
(3, 'Bob'),
(4, 'Emma'),
(5, 'Daniel');

--				fetch nth record from the table
select * from (select *,row_number() over() row_num from main) as temp where row_num=3;

select * from back_up;

delete from main where empid =2;

truncate main;

truncate backup;

drop table main;

drop table back_up;

drop trigger t;

--------------------------------	


