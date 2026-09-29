
select concat(stu_no, stu_name) from student;

select stu_no || stu_name from student;


select id, length(id)
from professor;


select * from stu;

select
    name, 
    substr(jumin, 3, 2),
    substr(jumin, 1, 6),
    substr(jumin, 7)
from 
    stu;
    
select
    name,
    decode(substr(jumin, 7,1), 1, '남자', '여자') "성별"
from
    stu;
    

select
    upper('aaa'),
    lower('aaa')
from dual;

select
    email,
--    instr(email, '@'),
    substr(email, instr(email, '@')+1)
from professor;

select
    trim('    Hello oralce '),
    ltrim('    Hello oralce '),
    rtrim('    Hello oralce ')
from
    dual;
    
    
select 
    lpad(id, 10, '*'),
    rpad(id, 10, '*')
from
    professor
;


select
    id,
    rpad(substr(id, 1, 3), length(id), '*')    
from
    professor
    ;




-- 아이디의 마지막 3글자만 *로 출력

select
    id,
    rpad(substr(id, 0, length(id) -3), length(id), '*')
from
    professor;


-- captain@abc.net => captain@******
select 
    email,
    rpad(substr(email, 0, instr(email, '@')), length(email), '*' )
from
    professor;
    
--    ;; 이게 왜 됐지;; 걍해봤는데

select * from professor;

select
    substr(name, 0, 1),
    length(name)-1,
    rpad(substr(name, 0, 1), length(name)-1, '*') || substr(name, length(name)-1)
from
    professor;

