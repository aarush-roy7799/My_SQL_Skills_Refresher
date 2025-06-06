# Creating a new database and using it
CREATE DATABASE company;
USE company;

# Creating the 'departments' table
CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(255) NOT NULL,
    location VARCHAR(255)
);

# Creating the 'workers' table with a foreign key linking to departments
CREATE TABLE workers (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    hire_date DATE,
    salary INT,
    place VARCHAR(255),
    dept_id INT,
    FOREIGN KEY (dept_id)
        REFERENCES departments (dept_id)
);

# View all department records
select * from departments;

# View all worker records
SELECT * FROM workers;

# Combine workers and departments into a new 'employees' table using union of left and right joins
create table employees as
select emp_id, first_name, last_name, email, hire_date, salary, place, dept_name, location 
from workers
left join departments on workers.dept_id=departments.dept_id
union
select emp_id, first_name, last_name, email, hire_date, salary, place, dept_name, location 
from workers
right join departments on workers.dept_id=departments.dept_id;

# View combined employee data
select * from employees;

# basic queries

# Retrieve employees located in London
select * from employees where place = "London";

# Retrieve employees from all locations except Leeds
select * from employees where place !="Leeds";

# Retrieve employees working in either London or Oxford
select * from employees where place in("London", "Oxford");

# Retrieve employees earning more than £80,000
select * from employees where salary > 80000 ;

# Get the highest salary from the employees table
select max(salary) from employees;

# Get the average salary from the employee table
select avg(salary) from employees;

# Get the second highest salary
select max(salary) from employees
where salary < (select max(salary) from employees);

# Get top 3 highest paid employees
select * from employees
order by salary desc 
limit 3;

# Get the total salary paid to all employees
select sum(salary) from employees;

# Retrieve employees earning between £60,000 and £70,000, working in Cambridge or Oxford
select * from employees where (salary > 60000 and salary < 70000) 
and (place = "Cambridge" or place = "Oxford");
-- or
select * from employees where salary between 60000 and 70000 
and (place = "Cambridge" or place = "Oxford");

# List all distinct departments from the employees table
select distinct (dept_name) from employees;

# Nested Queries

# Retrieve employees earning above average salary of London employees
select * from employees where salary > (select avg(salary) from employees where place = "London");

# Retrieve London-based Operations employees earning more than the average salary of Sales/Marketing employees in London/Leeds
select * from employees where place = "London" and dept_name = "Operations" and 
salary > (select avg(salary) from employees where place= "Leeds" or place= "London" and 
dept_name= "Sales" or dept_name= "Marketing");


# Group By

#Count employees in each department and show only those with more than 550 employees
select dept_name, count(*) from employees group by dept_name having count(*) > 550;

# Count employees working in Oxford, grouped by department
select dept_name, place, count(*) from employees where place="Oxford" 
group by dept_name, Place;


# order by

# Fetch departments with more than 550 employees, sorted by count
select dept_name, count(*) from employees group by dept_name
having count(*)>550 order by count(*) desc;


# 	Case and View statement

# Create a view that categorizes employees by salary
Create View staff as
select *, case
when salary >= 90000
then "high"
when salary >= 80000 and salary < 60000
then "average"
else "low"
end income_status 
from employees order by salary;

#View contents of the 'staff' view
select * from staff;