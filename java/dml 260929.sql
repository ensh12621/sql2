DESC STUDENT;

SELECT 
    STU_DEPT,
    AVG(STU_HEIGHT) 
FROM STUDENT
GROUP BY STU_DEPT
;


SELECT
    STU_DEPT,
    AVG(STU_HEIGHT)
FROM
    STUDENT
WHERE
    STU_HEIGHT <= 170
GROUP BY
    STU_DEPT;
    

SELECT
    STU_DEPT,
    AVG(STU_HEIGHT)
FROM
    STUDENT
GROUP BY
    STU_DEPT
HAVING
    AVG(STU_HEIGHT) >= 170;



SELECT COUNT(*), COUNT(STU_NO), COUNT(STU_HEIGHT)
FROM STUDENT;

SELECT * FROM STUDENT;


SELECT * FROM ENROL;
select * from student;
select * from subject;



select * from emp e
    inner join salgrade s on e.sal between losal and hisal;
    
    


select * from stu;
select * from department;
select * from professor;

-- 학번, 학생이름, 하고가, 담당교수명 출력

select s.stuno, s.name as stuname, d.dname, p.name as profname
from stu s
    inner join department d on s.deptno1 = d.deptno
    join professor p on s.profno = p.profno;
    
    
-- 각 학과별 학생 수 출력(학과명, 학생 수)
select * from department;
select * from stu;

select d.dname, count(*)
from stu s
    join department d on s.deptno1 = d.deptno
group by d.deptno, d.dname;





