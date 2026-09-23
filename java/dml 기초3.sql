-- 테이블에서 김철수의 모든 칼럼 조회

select * from student; 

select * from student
where stu_name = '김철수';

-- 키가 170ㅇ상인 학생의 모든 칼럼

select * from student
where stu_height >= 170;

select stu_name, stu_height
from student
where stu_height is not null;


-- 1학년 이면서 여자 학생들 조회

select *
from student
where stu_gender = 'F' and stu_grade = 1;


--2학년 이거나 남자만

select * from student
where stu_gender = 'M' or stu_grade = 2;

-- 학생의 키가 170이상 180이하인 학생 검색
select * from student
where stu_height >= 170 and stu_height <= 180;


-- 하나의 칼럼에 대한 범위값을 구할 때 between
explain plan for select * from student
where stu_height between 170 and 180;

select * from table(dbms_xplan.display);

explain plan for select * from student
where stu_no like '2015%';
select * from table(dbms_xplan.display);


select * from professor
where email like '%net';

explain plan for 
select * from professor
where email like '%net';

select * from table(dbms_xplan.display);

select * from professor where email like '%naver%';

explain plan for
select * from professor where email like '%naver%';

select * from table(dbms_xplan.display);

select * from professor
where position like '조%';


explain plan for select * from professor
where position like '조%';

select * from table(dbms_xplan.display);


select sysdate from dual;


desc professor;



--1. 아래 정보에 맞게 PROFESSOR 테이블에 INSERT 하시오.
--   교수번호 : 1234, 이름 : 김교수, 아이디 : test12, 직급 : 정교수, 급여 : 500
--   입사일 : SYSDATE 



desc professor;
insert into professor(profno, name, id, position, pay, hiredate) values('1234', '김교수', 'test12', '정교수', 500, sysdate);
commit;


--2. 보너스가 NULL이 아닌 데이터를 조회하시오.



select * from professor
where bonus is not null;

--3. 200~400 사이의 급여를 받는 데이터를 조회하시오. ( BETWEEN 사용 )

select * from professor
where pay between 200 and 400;

--4. 이름이 '김'씨로 시작하는 데이터를 조회하시오.

select * from professor
where name like '김%';

--5. 직급이 '조교수' 이면서 급여가 250이상인 데이터를 조회하시오.

select * from professor
where position = '조교수' and pay >= 250;

--6. 직급이 '조교수' 이거나 '정교수'인 데이터를 조회하시오. ( IN 사용 )

select * from professor
where position in ('조교수', '정교수');

--7. 교수번호가 1234인 데이터의 급여를 50증가 시키시오.

update professor set
pay = pay+50
where profno = 1234;



select * from professor where profno =1234;
commit;


--8. 교수번호가 1234인 데이터를 삭제하시오.
delete from professor
where profno = 1234;
select * from professor where profno =1234;
commit;


select * from table(dbms_xplan.display);

