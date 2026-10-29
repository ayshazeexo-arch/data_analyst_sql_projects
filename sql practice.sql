-- sql practice

use parks_and_recreation;
select* 
from employee_demographics;

-- SELECT
select first_name,age, age+10
from employee_demographics;

SELECT DISTINCT GENDER
from employee_demographics;

-- WHERE CLAUSE
SELECT*
FROM EMPLOYEE_SALARY
WHERE FIRST_NAME ='LESLIE' ;

SELECT *
FROM EMPLOYEE_SALARY
WHERE SALARY > 50000;

SELECT *
FROM employee_demographics
WHERE GENDER = 'FEMALE';

SELECT *
FROM employee_demographics
WHERE GENDER != 'FEMALE';

-- logical operators(and or not)
SELECT *
FROM employee_demographics
WHERE birth_date>'1985-01-01'
and gender = 'male';

SELECT *
FROM employee_demographics
WHERE birth_date>'1985-01-01'
or gender = 'male';

SELECT *
FROM employee_demographics
WHERE birth_date>'1985-01-01'
or not gender = 'male';

SELECT *
FROM employee_demographics
WHERE (first_name='leslie' and age=44)
or age>55 ;

-- like statement (% & _)
SELECT *
FROM employee_demographics
WHERE first_name like '%er%';

SELECT *
FROM employee_demographics
WHERE first_name like 'a__';

SELECT *
FROM employee_demographics
WHERE first_name like 'a__%';

SELECT *
FROM employee_demographics
WHERE birth_date like '1994%';

-- group by
SELECT gender
FROM employee_demographics
group by gender ;

SELECT gender, avg(age)
FROM employee_demographics
group by gender ;

SELECT gender, avg(age), max(age), min(age)
FROM employee_demographics
group by gender ;

SELECT gender, count(age)
FROM employee_demographics
group by gender ;

-- order by
SELECT *
FROM employee_demographics
order by first_name ;

SELECT *
FROM employee_demographics
order by first_name desc ;

SELECT *
FROM employee_demographics
order by gender,age ;

SELECT *
FROM employee_demographics
order by gender,age desc ;

SELECT *
FROM employee_demographics
order by age,gender ;

-- having vs where 
select gender, avg(age)
from employee_demographics
group by gender
having avg(age)>40;

select occupation, avg(salary)
from employee_salary
where occupation like '%manager%'
group by occupation
having avg(salary) > 75000;

-- limit & aliasing
select *
from employee_demographics
limit 3;

select *
from employee_demographics
order by age desc
limit 1,1;

select gender, avg(age) as avg_age
from employee_demographics
group  by gender
having avg_age>40;

-- joins
select *
from employee_demographics;

select *
from employee_salary;

select *
from employee_demographics
inner join employee_salary
	on employee_demographics.employee_id = employee_salary.employee_id;
    
    select *
from employee_demographics as dem
inner join employee_salary as sal
	on dem.employee_id = sal.employee_id;
    
        select *
from employee_demographics as dem
left join employee_salary as sal
	on dem.employee_id = sal.employee_id;
    
           select *
from employee_demographics as dem
right join employee_salary as sal
	on dem.employee_id = sal.employee_id;
    
-- self join
select emp1.employee_id as emp_santa,
emp1.first_name as first_name_santa,
emp1.last_name as last_name_santa,
emp2.employee_id as emp_employee,
emp2.first_name as first_name_emp,
emp2.last_name as last_name_emp
from employee_salary emp1
 join employee_salary emp2
	on emp1.employee_id + 1 = emp2.employee_id;
    

    
    select *
    from employee_demographics 
    inner join employee_salary
		on employee_demographics.employee_id = employee_salary.employee_id
        inner join parks_departments dp
        on employee_salary.dept_id= dp.department_id;
        
        select *
        from parks_departments;
        
-- unions
select first_name,last_name
from employee_demographics
union
select first_name,last_name
from employee_salary;

-- string functions
select length ('skyfall');

select upper('sky');
select lower('SKY');
SELECT FIRST_NAME,UPPER(FIRST_NAME)
FROM EMPLOYEE_DEMOGRAPHICS;

SELECT TRIM('            SKY              ');

SELECT FIRST_NAME, left(FIRST_NAME,4)
FROM EMPLOYEE_DEMOGRAPHICS;

SELECT FIRST_NAME, RIGHT(FIRST_NAME,4)
FROM EMPLOYEE_DEMOGRAPHICS;

SELECT FIRST_NAME, SUBSTRING(FIRST_NAME,3,2)
FROM EMPLOYEE_DEMOGRAPHICS;

SELECT FIRST_NAME, REPLACE(FIRST_NAME,'A','Z')
FROM EMPLOYEE_DEMOGRAPHICS;

SELECT LOCATE('X','ALEXANDER');

SELECT FIRST_NAME, LOCATE('AN',FIRST_NAME)
FROM EMPLOYEE_DEMOGRAPHICS;

SELECT FIRST_NAME,LAST_NAME,
CONCAT (FIRST_NAME,'  ',LAST_NAME) AS FULL_NAME
FROM EMPLOYEE_DEMOGRAPHICS;

-- CASE  STATEMENTS
SELECT FIRST_NAME,LAST_NAME,AGE,
CASE
WHEN AGE<=30 THEN 'YOUNG'
WHEN AGE BETWEEN 31 AND 50 THEN 'OLD'
WHEN AGE>=50 THEN 'ON DEATHS DOOR'
END
FROM EMPLOYEE_DEMOGRAPHICS;

SELECT SALARY,FIRST_NAME,LAST_NAME,
CASE
WHEN SALARY<50000 THEN SALARY+(SALARY*1.05)
WHEN SALARY>50000 THEN SALARY+(SALARY*1.07)
END AS NEW_SALARY,
CASE
	WHEN DEPT_ID=6 THEN SALARY * .10
    END AS BONUS
FROM EMPLOYEE_SALARY
;

-- SUBQUERIES
SELECT *
FROM EMPLOYEE_DEMOGRAPHICS
WHERE EMPLOYEE_ID IN (SELECT EMPLOYEE_ID
FROM EMPLOYEE_SALARY
WHERE DEPT_ID = 1);

select *
from
(select gender,avg(age),max(age),min(age),count(age)
from employee_demographics
group by gender ) agg_table;

-- window function
select dem.first_name, dem.last_name, gender, avg(salary)
over(partition by gender)
from employee_demographics dem
join employee_salary sal
on dem.employee_id = sal.employee_id;

select dem.first_name, dem.last_name, gender, sum(salary)
over(partition by gender)
from employee_demographics dem
join employee_salary sal
on dem.employee_id = sal.employee_id;

select dem.first_name, dem.last_name, gender, sum(salary)
over(partition by gender 
order by dem.employee_id) as rolling_total
from employee_demographics dem
join employee_salary sal
on dem.employee_id = sal.employee_id;

select dem.first_name, dem.last_name, gender, salary, 
row_number()  over()
from employee_demographics dem
join employee_salary sal
on dem.employee_id = sal.employee_id;

select dem.first_name, dem.last_name, gender, salary, 
row_number()  over(partition by gender 
order by salary desc)
from employee_demographics dem
join employee_salary sal
on dem.employee_id = sal.employee_id;

select dem.first_name, dem.last_name, gender, salary, 
rank()  over(partition by gender 
order by salary desc)
from employee_demographics dem
join employee_salary sal
on dem.employee_id = sal.employee_id;

select dem.first_name, dem.last_name, gender, salary, 
dense_rank()  over(partition by gender 
order by salary desc)
from employee_demographics dem
join employee_salary sal
on dem.employee_id = sal.employee_id;

-- cte
with cte_example as
(
select gender,avg(salary) avg_sal, max(salary),min(salary),count(salary)
from employee_demographics dem
join employee_salary sal
on dem.employee_id = sal.employee_id
group by gender
)
select avg(avg_sal)
from (cte_example);

with cte_example as
(
select employee_id,gender,birth_date
from employee_demographics
where birth_date> '1985-01-01'
),
cte_example2 as
(
select employee_id,salary
from employee_salary
where salary>50000 
)
select *
from cte_example
join cte_example2
on cte_example.employee_id = cte_example2.employee_id;

-- temporary tables
create temporary table salary_over_50000
select *
from employee_salary
where salary>=50000;
select *
from salary_over_50000;

-- stored procedures
create procedure large_salaries()
select *
from employee_salary
where salary>= 50000;
call large_salaries();

-- delimetter $$
 DELIMITER $$
create procedure large_salaries3()
begin
	select *
	from employee_salary
	where salary >= 50000 ;
	select *
	from employee_salary
	where salary>= 10000 ;
	end $$
	delimiter ;
    
        CALL large_salaries3();

DELIMITER $$
CREATE PROCEDURE LARGE_SALARIES4(P_EMPLOYEE_ID INT)
BEGIN
SELECT SALARY
FROM EMPLOYEE_SALARY
WHERE EMPLOYEE_ID=P_EMPLOYEE_ID
;
END $$
DELIMITER ;
CALL LARGE_SALARIES4(1);

-- TRIGGERS 

DELIMITER $$
CREATE TRIGGER employee_insert
AFTER INSERT ON employee_salary
FOR EACH ROW
BEGIN
    INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END$$

DELIMITER ;
INSERT INTO employee_salary 
VALUES (13, 'henry', 'simone', 'entertainment', 1000000, NULL);

SELECT * FROM employee_salary;

-- events
select *
from employee_demographics;
delimiter $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
    delete 
    FROM employee_demographics 
    WHERE age >= 60;
END$$

DELIMITER ;