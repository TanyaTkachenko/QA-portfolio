-- /* Везде, где необходимо данные придумать самостоятельно. */
--Для каждого задания можете использовать конструкцию
-------------------------
-- начать транзакцию
begin transaction
-- проверка до изменений
SELECT * FROM EXAM_MARKS
-- изменения
-- insert into SUBJECTS (ID,NAME,HOURS,SEMESTER) values (25,'Этика',58,2),(26,'Астрономия',34,1)
-- insert into EXAM_MARKS ...
-- delete from EXAM_MARKS where SUBJ_ID in (...)
-- проверка после изменений
SELECT * FROM EXAM_MARKS --WHERE STUDENT_ID > 120
-- отменить транзакцию
rollback


-- 1. Необходимо добавить двух новых студентов для нового учебного 
--    заведения "Винницкий Медицинский Университет".

begin transaction;

select * from students
select * from universities;

insert into universities
values ((select max(id) from universities)+1, 'ВМУ', null, 'Винница');

insert into students (id, surname, name, gender, birthday, univ_id)
values ((select max(id) from students)+1, 'Иванов', 'Иван', 'm', cast('1990-07-19' as datetime), (select id from universities where name='ВМУ')),
       ((select max(id) from students)+2, 'Иванова', 'Иванна', 'f', cast('1991-05-27' as datetime), (select id from universities where name='ВМУ')); 

select * from students
select * from universities;

--commit;
rollback;



-- 2. Добавить еще один институт для города Ивано-Франковск, 
--    1-2 преподавателей, преподающих в нем, 1-2 студента,
--    а так же внести новые данные в экзаменационную таблицу.

begin transaction;

/*select * from universities
select * from lecturers
select * from students
select * from exam_marks;*/

insert into universities
values ((select max(id) from universities)+1, 'NEW', null, 'Ивано-Франковск');

insert into lecturers
values ((select max(id) from lecturers)+1, 'Иванов2', 'ИИ', 'Ивано-Франковск', (select id from universities where name like'NEW')),
       ((select max(id) from lecturers)+2, 'Ивановa2', 'АА', 'Ивано-Франковск', (select id from universities where name like'NEW'));

insert into students (id, surname, name, gender, birthday, univ_id)
values ((select max(id) from students)+1, 'Иванов', 'Иван', 'm', cast('1990-07-19' as datetime), (select id from universities where name like'NEW')),
       ((select max(id) from students)+2, 'Иванова', 'Иванна', 'f', cast('1991-05-27' as datetime), (select id from universities where name like'NEW')); 

insert into exam_marks (student_id)
values ((select id from students where surname like'Иванов')),
       ((select id from students where surname like'Иванова'));

select * from universities
select * from lecturers
select * from students
select * from exam_marks;

--commit;
rollback;



-- 3. Известно, что студенты Павленко и Пименчук перевелись в ОНПУ. 
--    Модифицируйте соответствующие таблицы и поля.


begin transaction;

select * from students where surname='Павленко' or surname='Пименчук'
select * from universities where name='ОНПУ'

insert into students_archive
select *
  from students
 where surname='Павленко' or surname='Пименчук';

update students
set univ_id=(select id
               from universities
			  where name='ОНПУ')
where surname in ('Павленко', 'Пименчук');

select * from students;
select * from students_archive;

--commit;
rollback;


-- 4. В учебных заведениях Украины проведена реформа и все студенты, 
--    у которых средний бал не превышает 3.5 балла - отчислены из институтов. 
--    Сделайте все необходимые удаления из БД.
--    Примечание: предварительно "отчисляемых" сохранить в архивационной таблице


begin transaction;

/*select * from students
select * from students_archive
select * from exam_marks*/
--select student_id from exam_marks group by student_id having avg(mark)<=3.5

insert into students_archive
select *
  from students
 where id in (select student_id
                from exam_marks
            group by student_id
              having avg(mark)<=3.5);

delete from exam_marks
where student_id in (select student_id
                       from exam_marks
                   group by student_id
                     having avg(mark)<=3.5);


/*delete from students
where id in (1, 3, 8, 11, 13, 14, 15, 16, 20, 21, 22, 24, 32, 33, 36, 38, 39, 43, 44, 45);*/
--или:
delete from students
where id in (select id
               from students_archive);


select * from students
select * from students_archive
select * from exam_marks

--commit;
rollback;

 

-- 5. Студентам со средним балом 4.75 начислить 12.5% к стипендии,
--    со средним балом 5 добавить 200 грн.
--    Выполните соответствующие изменения в БД.

begin transaction;

select * from students;
select student_id, avg(mark) from exam_marks group by student_id having avg(mark)=4.75 or avg(mark)=5;


update students
set stipend=(select
               case
			   when id in (select student_id
			                 from exam_marks
						 group by student_id
						   having avg(mark)=4.75) then stipend*1.125
			   when id in (select student_id
			                 from exam_marks
						 group by student_id
						   having avg(mark)=5) then stipend+200
			   else stipend
			   end);


select * from students;

--commit;
rollback;



-- 6. Необходимо удалить все предметы, по котором не было получено ни одной оценки.
--    Если таковые отсутствуют, попробуйте смоделировать данную ситуацию.

begin transaction;

/*select * from exam_marks;
select * from subjects where id not in (select subj_id from exam_marks);
select * from subj_lect;*/

--моделирую ситуацию:
delete from exam_marks
where subj_id in (3, 5);



delete from subj_lect
where subj_id not in (select subj_id from exam_marks);

delete from subjects
where id not in (select subj_id from exam_marks);


select * from subjects;

--commmit;
rollback;

select * from subjects;



-- 7. Лектор 3 ушел на пенсию, необходимо корректно удалить о нем данные.

begin transaction;

select * from lecturers;
select * from subj_lect;

delete from subj_lect
where lecturer_id=3;

delete from lecturers
where id=3;

select * from lecturers;

--commmit;
rollback;

select * from lecturers;