USE hr_analytics_db;

SELECT * FROM performance limit 10;

-- 1 Total Employees
SELECT COUNT(*) AS total_employees
FROM employees;
-- 2. Active Employees
SELECT COUNT(*) as active_employees
FROM employees 
WHERE employment_status = "Active"; 

-- 3. Employee Attrition Rate
SELECT SUM(CASE WHEN employment_status IN ('Resigned','Terminated')
    THEN 1 ELSE 0 END)* 100.0/ COUNT(*) AS attrition_rate_percent
FROM employees;

-- 4. Average Employee Salary
SELECT ROUND(AVG(salary),2) AS avg_salary
FROM employees;

-- 5. sALARY BY DEPARTMENT
SELECT d.department_name, ROUND(AVG(e.salary),2) AS avg_salary
FROM employees e
JOIN departments d ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY avg_salary DESC;

-- 6.Salary by designation
SELECT designation, ROUND(AVG(salary),2) as avg_salary
FROM employees
GROUP BY designation
ORDER BY avg_salary DESC;

-- 7. aVERAGE PERFORMANCE RATING

-- 8. top performers
SELECT e.employee_id, e.employee_name, p.performance_rating
FROM employees e
JOIN performance p ON e.employee_id = p.employee_id
ORDER BY p.performance_rating DESC
limit 10;

-- 9. bonus distribution
SELECT 
    CASE
       WHEN bonus<10000 THEN '0-10000'
       WHEN bonus<20000 THEN '10000-20000'
       WHEN bonus<30000 THEN '20000-30000'
       WHEN bonus<40000 THEN '30000-40000'
    ELSE '40000-50000'
    END as bonus_range,
    COUNT(*) as employee_count
FROM performance
GROUP BY bonus_range
ORDER BY bonus_range;

-- 10.  department wise headcount
SELECT d.department_name, COUNT(e.employee_id) as headcount
FROM departments d
LEFT JOIN employees e on d. department_id = e.department_id
GROUP BY d.department_name
ORDER BY headcount DESC;
-- 11. GENDER DIVERSITY RATIO
SELECT gender, count(*) as  total,
    ROUND(COUNT(*) * 100/ (select COUNT(*) from employees),2) AS pct
    FROM employees 
    GROUP BY gender;
    
    -- 12.age distribution
SELECT 
    CASE
       WHEN age BETWEEN 20 AND 29 THEN '20-29'
       WHEN age BETWEEN 30 AND 39 THEN '30-39'
       WHEN age BETWEEN 40 and 49 THEN '40-49'
       ELSE '50-59'
	END as age_group,
    count(*) as employee_count
    FROM employees
    GROUP BY age_group
    ORDER BY age_group;
    
    -- 13. average employee tenure
    SELECT ROUND(AVG(DATEDIFF(CURDATE(), hire_date)) / 365,2) as avg_tenure_years
    FROM employees;
    
    -- 14. new hires by month
    SELECT date_format(hire_date, '%Y-%M') AS hire_month, COUNT(*) AS new_hires
    FROM employees
    GROUP BY hire_month
    ORDER BY hire_month;
    
    -- 15.employee attendance rate
SELECT ROUND(SUM(CASE WHEN status = 'Present' THEN 1 ELSE 0 END) * 100/
	COUNT(*), 2)
        AS attendance_rate_percent
	FROM attendance;
    
-- 16. leave utilization
SELECT COUNT(*) AS leave_days
FROM attendance
where status = 'Leave';

-- 17. absenteeism rate
SELECT round(sum(CASE WHEN status = 'Absent' THEN 1 ELSE 0 END) *100 /
    COUNT(*) , 2)
    AS absent_rate_per
FROM attendance;
    
-- 18. highest paying department
SELECT d.department_name, ROUND(AVG(e.salary),2) as avg_salary
FROM employees e
JOIN departments d ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY avg_salary DESC
limit 1;
    
-- 19. highest job role
SELECT designation, ROUND(AVG(e.salary),2) AS avg_salary
FROM employees e
GROUP BY designation
ORDER BY avg_salary desc
limit 1;

-- 20. promotion eligibility list
SELECT e.employee_id , e.employee_name, p.performance_rating
FROM employees e
JOIN performance p on e.employee_id = p.employee_id
WHERE p.performance_rating > 4.5
ORDER BY p.performance_rating DESC;

-- 21.Performance rating distribution
SELECT 
    CASE
       WHEN performance_rating < 2 THEN '1.00 - 1.99'
       WHEN performance_rating < 3 THEN '2.00 - 2.99'
       WHEN performance_rating < 4 THEN '3.00 - 3.99'
       ELSE '4.00 - 5.00'
	END AS rating_range,
    COUNT(*) as employees_count
FROM performance
GROUP BY rating_range
ORDER BY rating_range;

-- 22. employee growth trend
SELECT year(hire_date) as hire_year, count(*) as employees_hired
FROM employees
GROUP BY hire_year
ORDER BY hire_year;

-- 23. employees by city
SELECT city, count(*) as employee_count
FROM employees
GROUP BY city
ORDER BY employee_count DESC;

-- 24. DEPARTMENT WISE ATTRITION
SELECT d.department_name,
    ROUND(SUM(CASE WHEN e.employment_status IN ('Resigned' , 'Terminated')
       THEN 1 ELSE 0 END) * 100 / COUNT(*) , 2) AS attrition_rate_per
	FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    GROUP BY d.department_name
    ORDER BY attrition_rate_per desc;
    
    -- 25. workforce dashboard metrics
SELECT 
     (SELECT COUNT(*) FROM employees) AS total_employees,
     (SELECT COUNT(*) FROM employees WHERE employment_status = 'Active') AS
     active_emp,
     (SELECT ROUND(SUM(CASE WHEN employment_status IN ('Resigned' , 'Terminated')
          THEN 1 ELSE 0 END) * 100 / COUNT(*) , 2) FROM employees) AS attrition_rate_per,
      (SELECT ROUND(AVG(salary),2) FROM employees) AS avg_salary,
      (SELECT ROUND(AVG(performance_rating) ,2) FROM performance) as avg_performance_rating;