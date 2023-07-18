create database hr_project;
use hr_project;
select * from hr;

--data cleaning and preprocessing--

alter table hr
change column ï»¿id emp_id varchar(20) null;
describe hr;

SET sql_safe_updates = 0;

UPDATE hr
SET birthdate = CASE
		WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
        WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
        ELSE NULL
		END;
	
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

--change the data format and datatypes of hire_date column


UPDATE hr
SET hire_date = CASE
		WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
        WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
        ELSE NULL
		END;
        
ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

-- change the date format and datatpye of termdate column--
UPDATE hr
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate !='';

UPDATE hr
SET termdate = NULL
WHERE termdate = '';

--create age column--
Alter table hr
add column age INT;

select * from hr;
 update hr
 set age=timestampdiff(YEAR,birthdate,curdate())
 select min(age), max(age) from hr
 
 
 --1. what is the gender breakdown of employees in the company
 
 select * from hr;
 
 select gender, count(*) as count
 from hr where termdate is null
 group by gender;
 
 --2. what is the race breakdown of employee in the company
 select * from hr;
 select race, count(*) as count
 from hr where termdate is null
 group by race;
 
 --3 what is the age distribution of employee in the company
 select * from hr;
 select 
    Case
        when age>=18 and age<=24 then '18-24'
        when age>=25 and age<=34 then '25-34'
        when age>=35 and age<=44 then '35-44'
        when age>=45 and age<=54 then '45-54'
        when age>=55 and age<=64 then '55-64'
        else '65+'
end as age_group,
count(*) as count
from hr
where termdate is null
group by age_group
order by age_group; 

--4 how many employee work at HQ vs remote
select location, count(*) as count
from hr where termdate is null
group by location;

--5 what is the average length of employement who have been terminated
select round(avg(year(termdate)-year(hire_date)),0) as length_of_employee
from hr
where termdate is not null and termdate <=curdate()

--6. how does the gender distribution vary across dept. and job titles
select * from hr;

select department, jobtitle,gender,count(*) as count
from hr
where termdate is not null
group by department, jobtitle, gender
order by department,jobtitle,gender

select department,gender,count(*) as count
from hr
where termdate is not null
group by department,gender
order by department,gender

--7 what is the distribution of jobtitle across the company

select jobtitle, count(*) as count
from hr
where termdate is null
group by jobtitle

--8 which department has higher turnover/termination rate

SELECT department,
		COUNT(*) AS total_count,
        COUNT(CASE
				WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 
				END) AS terminated_count,
		ROUND((COUNT(CASE
					WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 
                    END)/COUNT(*))*100,2) AS termination_rate
		FROM hr
        GROUP BY department
        ORDER BY termination_rate DESC
        
 9-- what is the distribution of employee across location
 
 select location_state, count(*) as count
 from hr
 where termdate is null
 group by location_state
 
 select location_city,count(*) as count
 from hr
 where termdate is null 
 group by location_city
 
 --10 what is the tenure distribution for each dept.
 select department, round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
 from hr
 where termdate is not null and termdate<=curdate()
 group by department