SELECT * FROM BOARD;

INSERT INTO BOARD(TITLE, CONTENTS, USERID) VALUES ('첫글~~', '1등', 'test1');

INSERT INTO BOARD VALUES (null, '2빠', '까비', 'test2',  0, now(), now());

select * from board_comment;

insert into board_comment(boardno, contents, userid, cdatetime, udatetime)
 values (1, '댓글입니다', 'test1', now(), now());

insert into board_comment(boardno, contents, userid, cdatetime, udatetime)
 values (1, '댓글입니다2', 'test3', now(), now());

insert into board_comment(boardno, contents, userid, cdatetime, udatetime)
 values (2, '댓글이당', 'test2', now(), now());


select * from board_comment;

select * from board;

select
	b.*,
    c.*
from
	board b
    join board_comment c on b.boardno = c.boardno
order by
	b.boardno asc
;


select concat(boardno, title, contents)
from board;


select 
	ifnull(cnt, 100)
from 
	board;


select 1;

select truncate(123.456, 1);

select substr('abcd', 3);

select 
	date_format(cdatetime, '%Y'),
    date_format(cdatetime, '%y'),
    date_format(cdatetime, '%m'),
    date_format(cdatetime, '%M'),
    date_format(cdatetime, '%D'),
    date_format(cdatetime, '%d'),
    date_format(cdatetime, '%H'),
    date_format(cdatetime, '%h'),
    date_format(cdatetime, '%i'),
    date_format(cdatetime, '%s'),
    date_format(cdatetime, '%Y.%m.%d %H:%i%s')
from board_comment;
