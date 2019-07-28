drop table if exists t_emp_salary;

drop table if exists t_emp_title;

drop table if exists t_dept_employee;

drop table if exists t_dept_manager;

drop table if exists t_employee;

drop table if exists t_department;

create table t_department
    (
        dept_no             varchar(100)            primary key,
        dept_name           varchar(1000)           not null
    );
    
create table t_employee
    (
        emp_no              integer                  primary key,
        birth_date          date,
        first_name          varchar(100),
        last_name           varchar(100),
        gender              varchar(1),
        hire_date           date        
    );
    
create table t_dept_manager
    (
        dept_no             varchar(100)            not null,
        mgr_id              integer                 not null,
        from_date           date,
        to_date             date,
        foreign key(dept_no) references t_department(dept_no),
        foreign key(mgr_id) references t_employee(emp_no)
    );
    
create table t_dept_employee
    (
        emp_no                  integer,
        dept_no                 varchar(100),
        from_date               date,
        to_date                 date,
        foreign key(emp_no) references t_employee(emp_no),
        foreign key(dept_no) references t_department(dept_no)
    );
    
create table t_emp_salary
    (
        emp_no              integer,
        salary              float,
        from_date           date,
        to_date             date,
        foreign key(emp_no) references t_employee(emp_no)
    );
    
create table t_emp_title
    (
        emp_no              integer,
        title               varchar(100),
        from_date           date,
        to_date             date,
        foreign key(emp_no) references t_employee(emp_no)
    );