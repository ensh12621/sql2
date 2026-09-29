
select * from fruit;

SELECT * FROM STUDENT;

INSERT INTO STUDENT VALUES('1234', '홍길동', 95, 85 , 99);


select stu_no, stu_name, (java + oracle + html) / 3 as avg from student order by avg desc;

SELECT 
    S.*,
    (JAVA+ORACLE+HTML)/3 AS AVG,
    ROUND((JAVA+ORACLE+HTML)/3, 2) AS ROUND_AVG
FROM STUDENT S;


SELECT AVG(PRICE) FROM FRUIT;




rollback;

commit;