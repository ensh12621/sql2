select * from student;

select * from professor;


select stu_no, stu_dept from student;

select stu_name as "이름", stu_no "학번" , stu_dept "학과 이름"
from student;

select s.stu_name "이름"
from student s;

-- 이름:홍길동, 하번:1234567, 학과: 기계

insert into student (stu_name, stu_no, stu_dept) values ('홍길동', '12345678', '기계');
commit;


update student set
    stu_grade = 3,
    stu_class = 'c'
where
    stu_name = '김철수';

desc student;
select * from student;

delete from student where stu_name = '김철수';

commit;

insert into student values('12123434', '김철수', '전기전자', 2, 'B', 'M', 174, 74);




commit;

explain plan for select * from student;
select * from table(dbms_xplan.display);