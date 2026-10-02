-- 1. EMP 테이블에서 급여(SAL)가 3000이상인 사원의 사번, 이름, 급여를 출력하시오

select
    empno, ename, sal
from
    emp
where
    sal >= 3000
;


-- 2. TBL_EMP 테이블에 데이터를 삽입, 수정, 삭제하시오. 
-- 조건 1. 데이터 삽입 시 들어갈 내용은 자유롭게 정의하되, manager_id 컬럼은 테이블의 연관성을 고려하여 삽입한다. (NULL 금지)
-- 조건 2. 조건 1에서 삽입한 직원의 급여 정보를 10%로 증가한다. 
-- 조건 3. 조건 1에서 삽입한 직원을 PK를 조건으로 삭제 한다.

select * from tbl_emp;


--------------------------- 조건 1
insert into tbl_emp values ('E1008', '김누구', '사원', 'E1007', sysdate, 3500000, 'DO3');

--------------------------- 조건 2
update tbl_emp set salary = salary * 1.1 where emp_id = 'E1008';

--------------------------- 조건 3
delete from tbl_emp where emp_id = 'E1008';



-- 3. 시험 점수가 80점 이상이면 'A', 70점 이상이면 'B', 60점 이상이면 'C', 그외는 '노력요망' 으로 출력하시오. 
-- 사용테이블 : ENROL
-- 출력 컬럼 : 학생번호, 평가정보


-- 구글링: oracle case syntax
-- 참조URL: https://gent.tistory.com/311

select
    stu_no as "학생번호",
    case 
        when enr_grade >= 80 then
            'A'
        when enr_grade >= 70 then
            'B'
        when enr_grade >= 60 then
            'C'
        else
            '노력요망'
    END CASE 
from
    enrol e
;    



-- 4. PROFESSOR테이블에서 직급(POSITION)이 '정교수'인 데이터의 수를 구하시오.

SELECT
    COUNT(*)
FROM
    PROFESSOR
WHERE
    POSITION = '정교수'
;


-- 5. PROFESSOR테이블에서 EMAIL컬럼 내용 중 아이디(@이전 값들)만 추출하여 출력하시오.


-- 구글링: oracle instr
-- 참조 URL: https://mine-it-record.tistory.com/55

SELECT
    SUBSTR(EMAIL, 0, INSTR(EMAIL, '@') -1 ) AS EMAIL_ID
FROM
    PROFESSOR
;    


-- 6. PROFESSOR테이블에서 월별 입사한 사람의 수를 구하시오.
-- 출력 : 월, 입사한 사람 수

SELECT
    to_char(hiredate, 'MM') as monthly,
    count(*) as "입사한 사람 수"
FROM
    PROFESSOR p
group by
    to_char(hiredate, 'MM')
order by
    monthly asc
;    




-- 7. 조인 - 2문제 (STU, PROFESSOR, DEPARTMENT)
-- 7-1) 컴퓨터공학과에 속한 교수의 교수번호, 이름, 직급, 학과명을 출력하시오.
select
    p.profno 교수번호,
    p.name 이름,
    p.position 직급,
    d.dname 학과명
from
    professor p
    join department d on d.deptno = p.deptno
where
    d.dname = '컴퓨터공학과'
;


-- 7-2) 학생들의 학번, 이름, 부전공명을 출력하시오. 단, 부전공이 없으면 '해당없음' 으로 출력하시오.
select
    s.stuno 학번,
    s.name 이름,
    nvl(d.dname, '해당없음') 부전공명
from stu s
    left join department d on s.deptno2 = d.deptno
;

    


-- 8. 셀프조인 
-- emp 테이블에서 부하직원(본인을 MGR로 가지고 있는 사원)이 1명도 없는 사원의 사번, 이름을 출력하시오.

select * from emp;

select 
    e2.empno 사번,
    e2.ename 이름
from 
    emp e1
    right join emp e2 on e1.mgr = e2.empno 
    -- e2가 매니저
where
    e1.empno is null
;





-- 9. PROFESSOR테이블에서 보너스가 높은 순으로 출력하시오. 단, 보너스가 없을 경우 '없음'으로 출력하시오.
-- 출력 : 교수번호, 이름, 급여, 보너스 
-- 보너스가 없을 경우 제일 마지막에 출력

-- 구글링 oracle order by null last
-- 참조 url : https://milku.tistory.com/99#google_vignette

select
    p.profno 교수번호,
    p.name 이름,
    p.pay 급여,
    nvl(to_char(bonus), '없음') 보너스
from
    professor p
order by
    bonus desc nulls last
;    


-- 10. (TBL_EMP, TBL_DEPT) 각 부서의 부서아이디, 부서이름, 지역, 부서장 이름, 부서에 속한 사원의 수를 출력하시오.

select * from tbl_emp;
select * from tbl_dept;

select
    d.dept_id 부서아이디,
    d.dept_name 부서이름,
    d.location 지역,
    e.emp_name 부서장이름,
    (
        select
            count(*)
        from
            tbl_emp
        where
            dept_id = d.dept_id
            
        
    ) 속한사원수
from
    tbl_dept d
    join tbl_emp e on d.dept_id = e.dept_id and d.head_id = e.emp_id

;



-- 11. (TBL_EMP, TBL_DEPT) 본인 부서에서 본인보다 높은 급여를 받는 사원의 수를 출력하시오.
-- 출력 : 사원아이디, 이름, 부서명, 본인 부서에서 본인보다 높은 급여를 받는 사원의 수
-- 없으면 0 출력

-- 이전 실습문제 참조함.


select
    e.emp_id 사원아이디,
    e.emp_name 이름,
    d.dept_name 부서명,
    (
        select 
            count(*) - 1 cnt
        from
            tbl_emp
        where
            dept_id = e.dept_id 
            and salary >= e.salary
            
    ) as "본인보다 높은 급여를 받는 사람의 수"
from
    tbl_emp e
    join tbl_dept d on e.dept_id = d.dept_id
;


-- 12. (신규 테이블 기준) 사원 아이디, 이름, 진행중인 프로젝트 명, 진행 부서명, 해당 프로젝트 투입 인원 수를 출력하시오.
-- 진행중인 프로젝트가 없으면 아이디, 이름 외에 다른 정보를 NULL로 출력하시오.


SELECT * FROM TBL_EMP;
SELECT * FROM TBL_DEPT;
SELECT * FROM TBL_PROJECT;
SELECT * FROM TBL_ASSIGNMENT;
​


select
    a.empid 사원아이디,
    a.empname 사원이름,
    a.proj_name "진행중인 프로젝트명",
    case
        when a.attend_cnt = 0 then
            NULL
        when a.attend_cnt <> 0 then
            a.deptname
        end "진행부서명",
    
    case
        when a.attend_cnt = 0 then
            NULL
        when a.attend_cnt <> 0 then
            a.attend_cnt
        end "해당 프로젝트 투입 인원 수"
from
    (
        select 
            e.emp_id empid,
            e.emp_name empname,
            d.dept_name deptname,
            p.proj_name,
           
            (
                select
                    count(*)
                from
                    tbl_assignment
                where
                    proj_id = p.proj_id
            ) attend_cnt
        from 
            tbl_emp e
            join tbl_dept d on e.dept_id = d.dept_id
            left join tbl_project p on d.dept_id = p.dept_id
    ) a
order by
    deptname nulls last
;


-- 13. (신규 테이블 기준) 부서별 급여합산이 가장 높은 부서의 부서이름, 급여합산 결과를 출력하시오.


SELECT * FROM TBL_EMP;
SELECT * FROM TBL_DEPT;
SELECT * FROM TBL_PROJECT;
SELECT * FROM TBL_ASSIGNMENT;
​

select
    d.dept_name 부서이름,
    a.sum_sal 급여합산결과
from
    (
        select
            e.dept_id,
            sum(salary) sum_sal
        from
            tbl_emp e
        group by
            e.dept_id
        order by
            sum_sal desc    
    )a
    join tbl_dept d on a.dept_id = d.dept_id
where
    rownum = 1


;




-- 14. (SAL, SALGRADE) 급여등급이 3이상인 사람의 수와 3미만인 사람의 수를 구하시오.
-- (출력결과는 아래 이미지와 동일해야 함)

select * from emp;
select * from salgrade;

select
    '3등급이상' 카테고리,
    count(*) 인원수
from
    emp e
    join salgrade s on e.sal >= s.losal and e.sal <= s.hisal
where
    s.grade >= 3
union
select
    '3등급미만' 카테고리,
    count(*) 인원수
from
    emp e
    join salgrade s on e.sal >= s.losal and e.sal <= s.hisal
where
    s.grade < 3
;




