
-- 이전 강의 복습

select * from tbl_user;
select * from tbl_point;



-- student 테이블에서 키가 큰 상위 5명 출력(rownum 사용)

select
    a.*,
    rownum
from
    (
        select
            s.*
        from
            student s
        where
            stu_height is not null
        order by
            s.stu_height desc
    
    ) a
where
    rownum <= 5
;    


-- student 테이블에서 키가 큰 상위 5명 출력(rank)

desc student;

select
    a.*
from
    (
            
        select
            s.*,
            rank() over(order by stu_height desc) rnk
        from
            student s
        where   
            stu_height is not null 
            
        order by
            s.stu_height desc
    ) a
where
    a.rnk <= 5

;



-- 261001


-- view, pl/sql(사용자 정의함수, trigger, procedure ...)

select * from emp;

create or replace view emp_view as 
select e.empno, e.ename, e.job, d.dname, d.loc
from emp e
    join dept d on e.deptno = d.deptno
with read only
;



select * from emp_view;

-- view에서 수정이 가능한 경우 (밑에 4개 다 만족해야 함)
-- 1. 읽기 전용 옵션 없을 때(WITH READ ONLY 없을 때)
-- 2. join이 없을 때
-- 3. group 함수 없을 때
-- 4. distinct 없을 때
-- #. view는 왠만하면 read only 옵션 적용하는게 좋다.


select 
    distinct stu_no, enr_grade -- distinct : "모든 칼럼"이 같을 때 중복 제거
    
from enrol e;


-- 학번, 이름, 학과, 시험평균 점수를 출력하는 view 생성
-- score_view

select * from student;
select * from enrol;
select * from department;

select 
    s.stu_no, s.stu_name, stu_dept, avg(e.enr_grade)
from
    student s
    join enrol e on s.stu_no = e.stu_no
group by
    s.stu_no, s.stu_name, s.stu_dept
;

create or replace view score_view as
select 
    s.stu_no, s.stu_name, stu_dept, avg(e.enr_grade) as avg_grade
from
    student s
    join enrol e on s.stu_no = e.stu_no
group by
    s.stu_no, s.stu_name, s.stu_dept
with read only
;    


select * from score_view;



--------------------------------------------------------------------

-- pl/sql 

-- 선언부(선택), 실행부, 예외처리(선택)
-- 마지막을 '/'로 마무리



create or replace function multi(i_value in number ) 
return number
is
    -- 변수 선언
begin
    return i_value * 2;
end;
/


select multi(3) from dual;

select ename, sal, multi(sal)
from emp;

select * from tbl_user;
select * from tbl_point;


select 
    to_char(cdatetime, 'YYYY-MM-DD HH24:MI:SS')
from
    tbl_point;
    
create or replace function date_func(i_date in date) return varchar2
is
begin
    return to_char(i_date, 'YYYY-MM-DD HH24:MI:SS');
end;
/


select p.*, date_func(cdatetime)
from tbl_point p;

-- date_func2 (cdatetime, 'DATE') => 'YYYY-MM-DD'
-- seocnd param is 'date' or 'time' or 'datetime'

create or replace function date_func2(i_date in date, i_type in varchar2) return varchar2
is
    o_date varchar2(100);
begin

    if i_type = 'DATETIME' then
        o_date := to_char(i_date, 'YYYY-MM-DD HH24:MI:SS');
    elsif i_type = 'DATE' then
        o_date := to_char(i_date, 'YYYY-MM-DD');
    elsif i_type = 'TIME' then
        o_date := to_char(i_date, 'HH24:MI:SS');
    else
        o_date := '값 오류';
    end if;
    
    return o_date;

end;
/


select 
    CDATETIME,
    date_func2(CDATETIME, 'DATETIME') AS DATETIM,
    date_func2(CDATETIME, 'DATE') AS DAT,
    date_func2(CDATETIME, 'TIME') AS TIM,
    date_func2(CDATETIME, 'WEIRED') AS WEIRED
from
    TBL_POINT;
    
    
    
-- 
SELECT * FROM STU;

-- 주민 7 -> 남/여
-- 글자수가 13글자가 아니거나 1~4가 아니면 알수없음 리턴

SELECT GENDER_CHECK(JUMIN) -- 남/여 (1,3) (2,4)
        ,length(jumin)
FROM STU;
         
    
SELECT
    SUBSTR(JUMIN, 7,1)
FROM
    STU;

SELECT
    GENDER_CHECK('11')
FROM
    DUAL;
    
CREATE OR REPLACE FUNCTION GENDER_CHECK(I_JUMIN IN VARCHAR2) RETURN VARCHAR2
IS
    CHECKVAL VARCHAR2(5) := SUBSTR(I_JUMIN, 7, 1);
BEGIN
    IF LENGTH(I_JUMIN) <> '13' THEN
        RETURN '알수없음';
    ELSIF CHECKVAL IN ('1', '3' ) THEN
        RETURN '남';
    ELSIF CHECKVAL = '2' OR CHECKVAL = '4' THEN
        RETURN '여';
    ELSE
        RETURN '알수없음';
    END IF;
END;
/




SELECT 
    S.STU_NO, STU_NAME, STU_DEPT, ENR_GRADE,
    SCORE_GRADE(ENR_GRADE) AS GRADE -- 90~100A 80~89B 70~79C 60~69D 59~ F 
FROM STUDENT S
JOIN ENROL E ON S.STU_NO = E.STU_NO
;

CREATE OR REPLACE FUNCTION SCORE_GRADE(I_ENR_GRADE IN NUMBER) RETURN VARCHAR2
IS
BEGIN
    IF I_ENR_GRADE BETWEEN 90 AND 100 THEN
        RETURN 'A';
    ELSIF I_ENR_GRADE BETWEEN 80 AND 89 THEN
        RETURN 'B';
    ELSIF I_ENR_GRADE BETWEEN 70 AND 79 THEN
        RETURN 'C';
    ELSIF I_ENR_GRADE BETWEEN 60 AND 69 THEN
        RETURN 'D';
    ELSE
        RETURN 'F';
    END IF;
END;
/



-----------------------------------------------------

-- 프로시저 

CREATE OR REPLACE PROCEDURE TEMP_PROC
IS 

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello Oracle');
END;
/

set serveroutput on;
exec TEMP_PROC;

select * from emp; 

-- 사번을 입력받아 사원의 이름, 직급, 급여 정보 출력
exec empinfo_proc(1234);

select * from emp;


create or replace procedure empinfo_proc(i_empno emp.empno%type)
is
    o_ename emp.ename%type;
    o_job emp.job%type;
    o_sal emp.sal%type;
    
begin
    select
        ename, job, sal
        into o_ename, o_job, o_sal
    from
        emp
    where
        empno = i_empno;
        
    dbms_output.put_line(o_ename || '님의 직급은 ' || o_job || ', 급여는 ' || o_sal || ' 입니다.');
end;
/



exec empinfo_proc(7566);

-- exec emp_addsal_proc(사번, 급여)
-- 해당사번을 가진 사원의 급여를 두 번쨰 인자값으로 변경

create or replace procedure empinfo_proc(i_empno emp.empno%type, i_sal emp.sal%type)
is
    o_count number;
    
begin
    update emp set
        sal = i_sal
        where empno = i_empno;
    o_count := sql%rowcount;
    
    if o_count = 0 then
        dbms_output.put_line('사번을 확인해주세요');
    elsif o_count = 1 then
        dbms_output.put_line('수정되었습니다');
    else
        dbms_output.put_line('두 건 이상 수정되었습니다');
    end if;
    commit;    

end;
/


select * from emp;

exec empinfo_proc(7566, 4000);
rollback; 






-- 프로시저 호출
-- ENROL_PROC('학번', '과목번호', '수정할 점수')
-- 1. 없는 학번이나 없는 과목번호를 입력하면 '정보를 다시 확인해주세요' 출력
-- 2. 점수가 0미만, 100초과일 경우 '점수의 범위는 1~100 입니다' 출력
-- 3. 학번, 과목번호에 해당하는 점수는 3번째 인자값으로 변경

select * from student;
select * from enrol;
select * from subject;

select
    s.*,
    e.*,
    sub.*
from    
    student s
    join enrol e on s.stu_no = e.stu_no
    join subject sub on sub.sub_no = e.sub_no
;

exec enrol_proc(20131001, 101, 1005);

-- ENROL_PROC('학번', '과목번호', '수정할 점수')
-- 1. 없는 학번이나 없는 과목번호를 입력하면 '정보를 다시 확인해주세요' 출력
-- 2. 점수가 0미만, 100초과일 경우 '점수의 범위는 1~100 입니다' 출력
-- 3. 학번, 과목번호에 해당하는 점수는 3번째 인자값으로 변경


create or replace procedure ENROL_PROC(i_stu_no student.stu_no%type, i_sub_no subject.sub_no%type, i_enr_grade enrol.enr_grade%type)
is
begin

    if i_enr_grade not between 0 and 100 then
        dbms_output.put_line('점수의 범위는 1~100입니다.');
        return;
    end if;

    update enrol set
        enr_grade = i_enr_grade
        where stu_no = i_stu_no and sub_no = i_sub_no;
        
    if sql%rowcount = 1 then
        dbms_output.put_line('정보 수정 완료');
    elsif sql%rowcount = 0 then
        dbms_output.put_line('정보를 다시 확인해주세요');
    end if;
    commit;
    
end;
/
;
exec ENROL_PROC(20131001, 104, 75);
select * from enrol;


-- STUDENT 테이블에 학번, 이름, 학과를 입력받아서 저장하는 프로시저
-- 학번은 8글자 아니면 에러 문구 출력
-- 프로시저 이름 : STUINSERT_PROC 


select * from student;

create or replace procedure stuinsert_proc(i_stu_no student.stu_no%type, i_stu_name student.stu_name%type, i_stu_dept student.stu_dept%type)
is
begin
    if length(i_stu_no) <> '8' then
--        dbms_output.put_line('학번은 8글자여야 합니다.');
        RAISE_APPLICATION_ERROR(-20001, '학번은 8글자여야 합니다.');
        return;
    end if;

    insert into student(stu_no, stu_name, stu_dept)
        values (i_stu_no, i_stu_name, i_stu_dept);
    
    if sql%rowcount = 1 then
        dbms_output.put_line('정상적으로 등록되었습니다.');
    else
        dbms_output.put_line('얘기치 못한 에러가 발생했습니다.');
    end if;
end;
/

exec stuinsert_proc('20261001', '김누구', '컴퓨터정보');
select * from student;
rollback;

------------------------------------------------------------

-- TRIGGER
-- 특정 테이블에 변화가 생겼을 때 실행되는 프로시저

-- 샘플 트리거 생성
CREATE OR REPLACE TRIGGER TEMP_TRIGGER
    BEFORE  -- 트리거 실행 시점 AFTER OR BEFORE
    INSERT  OR UPDATE ON STUDENT -- STUDENT테이블이 INSERT / UPDATE 발생했을 때 실행된다.
    FOR EACH ROW -- 각 행별로 트리거 실행
                -- EX ) UPDATE로 3명의 정보가 변경되면 트리거도 3번 실행
BEGIN
    dbms_output.put_line('변경 전: ' || :OLD.stu_height);
    dbms_output.put_line('변경 후: ' || :NEW.stu_height);
END;
/


select * from student;

update student set
    stu_height = stu_height + 1
    where stu_name = '옥한빛';
    
rollback;

create table emp_log(
    l_empno number,
    o_sal number,
    n_sal number,
    o_comm number,
    n_comm number,
    l_id varchar2(50),
    event varchar2(50),
    l_time date
);


create or replace trigger emp_trigger
    before insert or update or delete on emp
    for each row
begin



    if inserting then
        if :new.comm is null or :new.comm < 0 then
            :new.comm := 0;
        end if;
        insert into emp_log values(:new.empno, :new.sal, :new.sal, :new.comm, :new.comm, sys_context('USERENV', 'SESSION_USER'), 'I', sysdate);
    elsif updating then
        insert into emp_log values(:new.empno, :old.sal, :new.sal, :old.comm, :new.comm, sys_context('USERENV', 'SESSION_USER'), 'U', sysdate);
    elsif deleting then
        raise_application_error(-20002, '사원 데이터는 삭제 불가!');
    end if;
end;
/


update emp set
    sal = sal + 50
    where empno = '7499';

commit;

select * from emp_log;

desc emp;

insert into emp(empno, ename, job) values (9988, '김누구', '주임');
select * from emp_log;
commit;

insert into emp(empno, ename, job, sal, comm) values (9989, '김뉴규', '주임', 3000, 200);
select * from emp_log;

delete from emp where ename = '김뉴규';



create table enrol_log(
    sub_no number,
    stu_no number,
    old_enr_grade number,
    new_enr_grade number,
    writer_id varchar2(50),
    job_type char(1),
    regdate date
);


--ENROL 테이블 트리거 만들기
--
--조건 1. 테이블명은 ENROL_LOG
--       컬럼은 과목번호, 학생번호, 수정전시험점수, 수정후시험점수, 작업자ID, 작업종류, 작업날짜
--조건 2. INSERT할 경우 ENROL_LOG에 해당 내용 자동 저장
--       단, 시험점수가 0~100사이가 아니면 0으로 저장
--조건 3. UPDATE할 경우 ENROL_LOG에 해당 내용 자동 저장
--       단, 시험점수가 0~100사이가 아니면 에러를 띄운 후 종료
--조건 4. DELETE할 경우 에러를 띄운 후 종료
​
select * from enrol;

create or replace trigger enrol_trigger
    before insert or update or delete on enrol
    for each row
begin
    if inserting then
        if :new.enr_grade not between 0 and 100 then
            insert into enrol_log(sub_no, stu_no, old_enr_grade, new_enr_grade, writer_id, job_type, regdate)
                values(:new.sub_no, :new.stu_no, 0, 0, sys_context('USERENV', 'SESSION_USER'), 'I', sysdate);
        else
            insert into enrol_log(sub_no, stu_no, old_enr_grade, new_enr_grade, writer_id, job_type, regdate)
                values(:new.sub_no, :new.stu_no, :new.enr_grade, :new.enr_grade, sys_context('USERENV', 'SESSION_USER'), 'I', sysdate);
        end if;
    elsif updating then
        if :new.enr_grade not between 0 and 100 then
            raise_application_error(-20003, 'enr_grade 값이 0 ~ 100 사이여야 합니다.');
        end if;
        insert into enrol_log(sub_no, stu_no, old_enr_grade, new_enr_grade, writer_id, job_type, regdate)
                values(:new.sub_no, :new.stu_no, :old.enr_grade, :new.enr_grade, sys_context('USERENV', 'SESSION_USER'), 'U', sysdate);
    elsif deleting then
        raise_application_error(-20004, 'enrol record를 삭제할 수 없습니다!');
    end if;
end; 
/

select * from enrol;

insert into enrol values (101, '20131001', 90);
select * from enrol_log;

update enrol set enr_grade = 90 where stu_no = '20131001' and sub_no = 101;
select * from enrol_log;
rollback;

select * from enrol;

delete from enrol where sub_no= 101 and stu_no='20131001';
rollback;



​




---------------------------------------------------------------------

--1. 조건을 이용한 SELECT 조회 
-- STUDENT 테이블에서 컴퓨터정보 학과(STU_DEPT) 학생들을 모두 출력하시오.
-- 난이도 : 하

select *
from student
where stu_dept = '컴퓨터정보';


--2. DML 명령어
     2-1) EMP 테이블에 INSERT 구문을 이용하여 레코드 추가
		(필수 컬럼 : EMPNO, ENAME, MGR, SAL) 
          - 데이터는 임의의 값을 넣으면 되나, MGR의 경우 EMPNO와 MGR의 관계를 고려하여 값을 넣을 것.
	 2-2) 2-1에서 만든 데이터의 SAL을 2000으로 변경
	 2-3) 2-1에서 만든 데이터를 EMPNO를 조건으로 삭제
-- 난이도 : 하

select * from emp;
insert into emp(empno, ename, mgr, sal) values(9997, '김경훈', 7698, 3500);
update emp set sal = 2000 where empno = 9997;
delete from emp where empno = 9997;


-- 4. 그룹 함수 (STUDENT)
-- STUDENT테이블에서 컴퓨터정보 학과(STU_DEPT) 학생들의 수를 구하시오.
-- 난이도 : 하

select
    count(*)
from
    student
where
    stu_dept = '컴퓨터정보';
    

-- 5. 조인 - 2문제
-- 5-1) 컴퓨터정보 학과에 속한 교수의 수업을 듣는 학생들의 목록을 출력하시오. (STUDENT, ENROL, SUBJECT)

-- 난이도 : 중


select
    s.*
from
    student s
    join enrol e on s.stu_no = e.stu_no
    join subject sub on sub.sub_no = e.sub_no
where
    sub.sub_dept = '컴퓨터정보'
;

select * from enrol;
select * from subject;

-- 5-2) EMP 테이블에 속한 사람들의 사번(EMPNO), 이름(ENAME), 급여등급을 출력하시오. (EMP, SALGRADE)

select * from emp;
select * from salgrade;

select 
    e.empno, e.ename, s.grade
from
    emp e
    join salgrade s on e.sal between s.losal and s.hisal
;

-- 6. 셀프조인 
-- 부하직원(본인을 MGR로 가지고 있는 사원)이 가장 많은 사원의 사번, 이름, 부하직원 수를 출력하시오.
-- (EMP)
-- 난이도 : 중

select * from emp;
    
select
    e3.empno, e3.ename, a.cnt
from
    emp e3
    join (
        select
            e2.mgr as mgr,
            count(*) as cnt
        from
            emp e
            join emp e2 on e.empno = e2.mgr
        group by
            e2.mgr
        order by cnt desc
    )a on e3.empno = a.mgr
where
    rownum = 1;
;




-- 7. 2개의 수업을 들은 학생들의 평균점수와 1개의 수업을 들은 학생들의 평균점수를 구하시오.
-- (수업 개수, 평균 점수 출력)
-- (STUDENT, ENROL)
-- 난이도 : 중

select * from student;
select * from enrol;


select
    avg(e.enr_grade)
from
    student s
    join (
        select 
            stu_no,
            count(*) as cnt
        from
            enrol
        group by
            stu_no
        having
            count(*)= 2
    )a on s.stu_no = a.stu_no
    join enrol e on s.stu_no = e.stu_no
union

select
    avg(e.enr_grade)
from
    student s
    join (
        select 
            stu_no,
            count(*) as cnt
        from
            enrol
        group by
            stu_no
        having
            count(*)= 1
    )a on s.stu_no = a.stu_no
    join enrol e on s.stu_no = e.stu_no
;


-- 8. 본인 학과에서 본인보다 몸무게가 큰 학생의 수를 출력하시오. ( 학번, 이름, 학과, 큰 학생 수 출력 )
-- (STUDENT)
-- 난이도 : 중

select * from student;

select
    a.stu_no,
    a.stu_name,
    a.stu_dept,
    a.stu_weight,
    
    (
        select
            count(*) as cnt
        from
            student
        where
            stu_weight >= a.stu_weight
            and stu_dept = a.stu_dept
        group by
            stu_dept
    
    ) as cnt
    
from
    (select stu_no, stu_dept, stu_name, stu_weight from student) a
;




----------------------------------------------------------

CREATE TABLE Book (
bookid NUMBER(2) PRIMARY KEY,
bookname VARCHAR2(40),
publisher VARCHAR2(40),
price NUMBER(8)
);

CREATE TABLE Customer (
custid NUMBER(2) PRIMARY KEY,
name VARCHAR2(40),
address VARCHAR2(50),
phone VARCHAR2(20)
);

CREATE TABLE Orders (
orderid NUMBER(2) PRIMARY KEY,
custid NUMBER(2), 
bookid NUMBER(2), 
saleprice NUMBER(8),
orderdate DATE
);

/* Book, Customer, Orders 데이터 생성 */
INSERT INTO Book VALUES(1, '축구의 역사', '굿스포츠', 7000);
INSERT INTO Book VALUES(2, '축구아는 여자', '나무수', 13000);
INSERT INTO Book VALUES(3, '축구의 이해', '대한미디어', 22000);
INSERT INTO Book VALUES(4, '골프 바이블', '대한미디어', 35000);
INSERT INTO Book VALUES(5, '피겨 교본', '굿스포츠', 8000);
INSERT INTO Book VALUES(6, '역도 단계별기술', '굿스포츠', 6000);
INSERT INTO Book VALUES(7, '야구의 추억', '이상미디어', 20000);
INSERT INTO Book VALUES(8, '야구를 부탁해', '이상미디어', 13000);
INSERT INTO Book VALUES(9, '올림픽 이야기', '삼성당', 7500);
INSERT INTO Book VALUES(10, 'Olympic Champions', 'Pearson', 13000);

INSERT INTO Customer VALUES (1, '박지성', '영국 맨체스타', '000-5000-0001');
INSERT INTO Customer VALUES (2, '김연아', '대한민국 서울', '000-6000-0001');
INSERT INTO Customer VALUES (3, '장미란', '대한민국 강원도', '000-7000-0001');
INSERT INTO Customer VALUES (4, '추신수', '미국 클리블랜드', '000-8000-0001');
INSERT INTO Customer VALUES (5, '박세리', '대한민국 대전', NULL);

INSERT INTO Orders VALUES (1, 1, 1, 6000, TO_DATE('2020-07-01','yyyy-mm-dd'));
INSERT INTO Orders VALUES (2, 1, 3, 21000, TO_DATE('2020-07-03','yyyy-mm-dd'));
INSERT INTO Orders VALUES (3, 2, 5, 8000, TO_DATE('2020-07-03','yyyy-mm-dd'));
INSERT INTO Orders VALUES (4, 3, 6, 6000, TO_DATE('2020-07-04','yyyy-mm-dd'));
INSERT INTO Orders VALUES (5, 4, 7, 20000, TO_DATE('2020-07-05','yyyy-mm-dd'));
INSERT INTO Orders VALUES (6, 1, 2, 12000, TO_DATE('2020-07-07','yyyy-mm-dd'));
INSERT INTO Orders VALUES (7, 4, 8, 13000, TO_DATE('2020-07-07','yyyy-mm-dd'));
INSERT INTO Orders VALUES (8, 3, 10, 12000, TO_DATE('2020-07-08','yyyy-mm-dd'));
INSERT INTO Orders VALUES (9, 2, 10, 7000, TO_DATE('2020-07-09','yyyy-mm-dd'));
INSERT INTO Orders VALUES (10, 3, 8, 13000, TO_DATE('2020-07-10','yyyy-mm-dd'));

COMMIT;


-- BOOK, CUSTOMER, ORDERS
--1. BOOK 테이블에서 PRICE 가 20000 이상인 레코드를 출력하시오.
select * from book where price >= 20000;

--2. BOOK 테이블에서 BOOKNAME 컬럼에 '야구' 가 들어간 레코드 출력하시오.

select * 
from book
where bookname like '%야구%';


--3. BOOK 테이블에서 PUBLISHER 컬럼이 '굿스포츠'인 데이터를 BOOKNAME 컬럼 내림차순으로 출력하시오.

select * 
from book
where publisher ='굿스포츠'
order by bookname desc;

--4. BOOK 테이블에서 PRICE 가 5000이상 20000이하 데이터 출력하시오.

select *
from book
where price between 5000 and 20000;

--5. CUSTOMER 테이블에서 PHONE가 NULL이 아니고 CUSTID가 3이상인 레코드 출력하시오.

select * 
from customer
where phone is not null and custid >= 3;

--6. 고객별 평균 주문 금액을 반올림한 값을 출력하시오.(고객명, 평균 주문 금액 출력)



--7. 이상미디어의 책을 구매한 고객 중에서 같은 성(姓)을 가진 사람이 몇 명이나 되는지 성별 인원수를 구하시오.
--8. 이상미디어에서 2020년 7월 7일에 주문받은 도서의 주문번호, 주문일, 고객이름, 도서번호를 모두 보이시오. 
--9. 이름, 전화번호가 포함된 고객목록을 보이시오. 단, 전화번호가 없는 고객은 ‘연락처없음’으로 표시하시오.
--10. 전체 평균 주문금액 보다 금액이 작은 주문에 대해서 주문번호와 금액을 출력하시오.
--11. ‘대한민국’에 거주하는 고객에게 판매한 도서의 총 판매액을 출력하시오.
--12. 3번 고객이 주문한 도서의 최고 금액보다 더 비싼 도서를 구입한 주문의 주문번호와 금액을 출력하시오.
--13. 이상미디어의 고객별 판매액을 보이시오(고객이름과 고객별 판매액 출력).
​
