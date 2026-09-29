
select
    e1.empno,
    e1.ename,
    e2.empno,
    e2.ename
from emp e1
    join emp e2 on e1.mgr = e2.empno
;

select *
from department;


-- 학과, 학부, 대학  출력

select 
    d1.dname, d2.dname, d3.dname
from department d1
    join department d2 on d1.part = d2.deptno
    join department d3 on d2.part = d3.deptno;
    
    
-- '공과대학'에 속한 학생들 출력(주전공, deptno1 기준)
select * from department;

select 
    s.*,
    d3.dname
from stu s
join department d1 on s.deptno1 = d1.deptno
    join department d2 on d1.part = d2.deptno
    join department d3 on d2.part = d3.deptno
where
    d3.dname = '공과대학'
;

-- 각 대학별 (공과대학, 인문대학) 교수의 수 구하기

select * from department;

select 
    d3.deptno,
    d3.dname,
    count(*)
from professor p
    join department d1 on p.deptno = d1.deptno
    join department d2 on d1.part = d2.deptno
    join department d3 on d2.part = d3.deptno
group by
    d3.deptno, d3.dname
;


-- 본인의 부하직우너 수 구하기(이름, 부하직원 수 출력)

select * from emp;

select e.mgr, e2.ename,count(*) 
from emp e
    join emp e2 on e.mgr = e2.empno
group by e.mgr, e2.ename;


select 
    *
from student
where
    stu_height = (select max(stu_height) from student)
;

-- union 결과 합치는 기능

select 
    *
from
    student
where
    stu_height in(
        select max(stu_height) as height from student
        union
        select min(stu_height) as height from student
    );

    

-- 각 학과별 가장 키가 큰 친구 구하기

select
    *
from
    student
where
    stu_height in (
        select max(stu_height) from student group by stu_dept
    );



-- 아래처럼 하면 다른 학과의 동일 키를 가진 학생도 조회할 수 있다.

select
    *
from
    student
where
    (stu_dept, stu_height) in (
        select stu_dept, max(stu_height) from student group by stu_dept
    )
;



-- professor 테이블 각 직급별 가장 높은 급여를 받는 교수의 이름, 직급, 급여 출력
select * from professor;

select
    name, position, pay
from
    professor
where
    (position, pay) in (
        select
            position,
            max(pay)
        from
            professor
        group by
            position    
    )
;

    

-- student, enrol 
-- 시험점수가 본인의 학과 평균 점수보다 높은 평균 점수를 가진 학새으이 학번, 이름, 평균 점수 출력

select * from student;
select * from enrol;


select
    s.stu_no,
    s.stu_name,
    e.enr_grade
from
    student s
    join enrol e on s.stu_no = e.stu_no
where
    (s.stu_dept, e.enr_grade) in (     
        select 
            stu_dept,
            avg(enr_grade) as dept_grade
        from student s
            join enrol e on s.stu_no = e.stu_no
        group by
            stu_dept
    
    )

;


select
    s.stu_no, stu_name, s.stu_dept, avg(e.enr_grade) as enr_grade,
    t.dept_score
from
    student s
    inner join enrol e on s.stu_no = e.stu_no
    inner join (
        select stu_dept, avg(enr_grade) as dept_score
        from student s
            inner join enrol e on s.stu_no = e.stu_no
        group by
            stu_dept
    ) T on T.stu_dept = s.stu_dept
group by
    s.stu_no, s.stu_name, s.stu_dept, t.dept_score
having
    avg(enr_grade) > dept_score
order by
    stu_dept;
    
    
    
    
select
    a.stu_no, a.stu_name, a.stu_dept
from
    (select stu_no, stu_name, stu_dept from student ) a
;    






-- 각 학과의 평균 키보다 큰 학생들을 출력

select
    s1.*
from
    student s1
    inner join (
        select stu_dept, avg(stu_height) as avg_height
        from student
        group by
            stu_dept    
    ) s2 on s1.stu_dept = s2.stu_dept and s1.stu_height > s2.avg_height
;






select * from table(dbms_xplan.display);









-- PROFESSOR




-- 1. 가장 높은 급여를 받는 사람의 교수번호, 이름, 급여 출력
select
    profno, name, pay
    
from 
    professor
where
    pay = ( select max(pay) from professor )
;


-- 2. 전체 평균 급여보다 높은 급여를 받는 교수의 교수번호, 이름, 급여 출력
select
    profno, name, pay
from
    professor
where
    pay > (select avg(pay) from professor)
;

-- 3. 본인의 직급 평균 급여보다 높은 급여를 받는 교수의 교수번호, 이름, 급여 출력

select
    p.profno, p.name, p.pay
from
    professor p
    inner join (
        select
            position,
            avg(pay) avgpay
        from
            professor
        group by
            position
    ) p2 on p.position = p2.position and p.pay > p2.avgpay
;
    


-- 4. 가장 높은 급여를 받는 사람과 가장 적은 급여를 받는 사원의 사번, 이름, 급여 출력

select
    empno, ename, sal
from   
    emp
where
    sal = (select max(sal) from emp)
union
select
    empno, ename, sal
from   
    emp
where
    sal = (select min(sal) from emp)
;

​

-- EMP, SALGRADE

-- 5. 부서별(DEPTNO) 가장 높은 급여를 받는 사람과 가장 적은 급여를 받는 사람의 사번, 이름, 부서명, 급여 출력

select
    *
from
    emp
where
    (deptno, sal) in (
                select deptno, max(sal)
                from emp
                group by deptno    
    )
union
select
    *
from
    emp
where
    (deptno, sal) in (
                select deptno, min(sal)
                from emp
                group by deptno    
    )
;    
    
    
-- EMP, SALGRADE


-- 6. 본인 직급의 평균 급여 등급보다 높은 급여등급을 가진 사람의 사번, 이름, 급여등급 출력

select * from emp;
select * from salgrade;


select
    e.empno, e.ename, e.sal,
    e2.avgsal
from
    emp e
    join (
        select deptno, avg(sal) as avgsal
        from emp
        group by
            deptno
    ) e2 on e.deptno = e2.deptno and e.sal > e2.avgsal
    join salgrade s on e.sal between s.losal and s.hisal
;
    
    
    
    select * from table(dbms_xplan.display);


    