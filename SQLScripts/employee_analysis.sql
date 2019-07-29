/*
(1.) List the following details of each employee: employee number, last name, first name, gender, and salary.

(2.) List employees who were hired in 1986.

(3.) List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.

(4.) List the department of each employee with the following information: employee number, last name, first name, and department name.

(5.) List all employees whose first name is "Hercules" and last names begin with "B."

(6.) List all employees in the Sales department, including their employee number, last name, first name, and department name.

(7.) List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.

(8.) In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
*/

--Query 1> List the following details of each employee: employee number, last name, first name, gender, and salary.
SELECT E.EMP_NO, E.LAST_NAME, E.FIRST_NAME, E.GENDER, ESAL.SALARY 
FROM T_EMPLOYEE E
    JOIN T_EMP_SALARY ESAL ON (ESAL.EMP_NO = E.EMP_NO)
ORDER BY E.EMP_NO;

--Query 2> List employees who were hired in 1986.

SELECT *
FROM T_EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE) = 1986
ORDER BY EMP_NO;

--Query 3> List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.

SELECT DEPT.DEPT_NO, DEPT.DEPT_NAME, DEPT_MGR.MGR_ID, EMP.LAST_NAME, EMP.FIRST_NAME, DEPT_MGR.FROM_DATE, DEPT_MGR.TO_DATE
FROM T_DEPARTMENT DEPT
    JOIN T_DEPT_MANAGER DEPT_MGR ON (DEPT_MGR.DEPT_NO = DEPT.DEPT_NO)
    JOIN T_EMPLOYEE EMP ON (EMP.EMP_NO = DEPT_MGR.MGR_ID)
ORDER BY DEPT.DEPT_NAME, DEPT_MGR.FROM_DATE;

--Query 4> List the department of each employee with the following information: employee number, last name, first name, and department name.

SELECT EMP.EMP_NO, EMP.LAST_NAME, EMP.FIRST_NAME, DEPT.DEPT_NAME
FROM T_EMPLOYEE EMP
    JOIN T_DEPT_EMPLOYEE EMP_DEPT ON (EMP.EMP_NO = EMP_DEPT.EMP_NO)
    JOIN T_DEPARTMENT DEPT ON (DEPT.DEPT_NO = EMP_DEPT.DEPT_NO)
ORDER BY EMP.EMP_NO;

-- Query 5> List all employees whose first name is "Hercules" and last names begin with "B."

SELECT EMP.EMP_NO, EMP.FIRST_NAME, EMP.LAST_NAME
FROM T_EMPLOYEE EMP
WHERE FIRST_NAME = 'Hercules'
    AND LAST_NAME LIKE 'B%'
ORDER BY EMP.EMP_NO;

--Query 6> List all employees in the Sales department, including their employee number, last name, first name, and department name.

SELECT EMP.EMP_NO, EMP.LAST_NAME, EMP.FIRST_NAME, DEPT.DEPT_NAME
FROM T_EMPLOYEE EMP
    JOIN T_DEPT_EMPLOYEE EMP_DEPT ON (EMP_DEPT.EMP_NO = EMP.EMP_NO)
    JOIN T_DEPARTMENT DEPT ON (DEPT.DEPT_NO = EMP_DEPT.DEPT_NO)
WHERE DEPT.DEPT_NAME = 'Sales';
--52245  Rows

--An alternate and more accurate way to determine the list of employees who are currently in Sales team
WITH EMP_CURRENT_ASSIGNMENT
AS
    (
        SELECT DISTINCT EMP_NO,  MAX(TO_DATE) AS LATEST_TO_DATE, COUNT(*) AS EMPLOYMENT_COUNT
        FROM T_DEPT_EMPLOYEE
        GROUP BY EMP_NO
    )
SELECT EMP.EMP_NO, 
       EMP.FIRST_NAME, 
       EMP.LAST_NAME, 
       DEPT.DEPT_NO, 
       DEPT.DEPT_NAME,  
       CURR_DEPT_EMP.EMPLOYMENT_COUNT
FROM T_DEPT_EMPLOYEE DEPT_EMP
    JOIN T_DEPARTMENT DEPT ON (DEPT.DEPT_NO = DEPT_EMP.DEPT_NO)
    JOIN T_EMPLOYEE EMP ON (EMP.EMP_NO = DEPT_EMP.EMP_NO)
    JOIN EMP_CURRENT_ASSIGNMENT CURR_DEPT_EMP ON (CURR_DEPT_EMP.EMP_NO = DEPT_EMP.EMP_NO AND CURR_DEPT_EMP.LATEST_TO_DATE = DEPT_EMP.TO_DATE)
WHERE DEPT.DEPT_NAME IN ('Sales')
ORDER BY CURR_DEPT_EMP.EMPLOYMENT_COUNT DESC, EMP.EMP_NO;
--46922  Rows

--Query 7> List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.

--Check to see if historical employment records in the employee_department table
select EMP_NO, COUNT(*) 
from T_DEPT_EMPLOYEE
GROUP BY EMP_NO
HAVING COUNT(*) = 1;

--Historical records exist. So first identify the latest assignment for each employee.
WITH EMP_CURRENT_ASSIGNMENT
AS
    (
        SELECT DISTINCT EMP_NO,  MAX(TO_DATE) AS LATEST_TO_DATE, COUNT(*) AS EMPLOYMENT_COUNT
        FROM T_DEPT_EMPLOYEE
        GROUP BY EMP_NO
    )
SELECT EMP.EMP_NO, 
       EMP.FIRST_NAME, 
       EMP.LAST_NAME, 
       DEPT.DEPT_NO, 
       DEPT.DEPT_NAME,  
       CURR_DEPT_EMP.EMPLOYMENT_COUNT
FROM T_DEPT_EMPLOYEE DEPT_EMP
    JOIN T_DEPARTMENT DEPT ON (DEPT.DEPT_NO = DEPT_EMP.DEPT_NO)
    JOIN T_EMPLOYEE EMP ON (EMP.EMP_NO = DEPT_EMP.EMP_NO)
    JOIN EMP_CURRENT_ASSIGNMENT CURR_DEPT_EMP ON (CURR_DEPT_EMP.EMP_NO = DEPT_EMP.EMP_NO AND CURR_DEPT_EMP.LATEST_TO_DATE = DEPT_EMP.TO_DATE)
WHERE DEPT.DEPT_NAME IN ('Sales', 'Development')
ORDER BY CURR_DEPT_EMP.EMPLOYMENT_COUNT DESC, EMP.EMP_NO;



--Query 8> In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

SELECT LAST_NAME, COUNT(*) AS "Employee Count with Same Last Name"
FROM T_EMPLOYEE
GROUP BY LAST_NAME
ORDER BY COUNT(*) DESC;