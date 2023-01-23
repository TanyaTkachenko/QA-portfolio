-- 1. Создайте модифицируемое представление для получения сведений обо всех студентах, 
--    круглых отличниках. Используя это представление, напишите запрос обновления, 
--    "расжалующий" их в троечников.

/*select * from students
select * from exam_marks*/

create view v_students_mark5 as
select *
  from students s
 where exists (select 1
                 from exam_marks em
			 group by em.student_id
			   having avg(em.mark)=5
			      and s.id=em.student_id);

select * from exam_marks;

begin transaction;
 select * from v_students_mark5
 select * from exam_marks

update exam_marks
set mark=3
where exists (select 1
                from v_students_mark5 vsm5
			   where student_id=vsm5.id);

select * from exam_marks;
  
--commit;
rollback;



-- 2. Создайте представление для получения сведений о количестве студентов 
--    обучающихся в каждом городе.

select * from students
select * from universities

create view qty_students_in_city as
  select u.city, count(s.id) qty_students
    from students s, universities u
   where s.univ_id=u.id
group by u.city;

select * from qty_students_in_city


-- 3. Создайте представление для получения сведений по каждому студенту: 
--    его ID, фамилию, имя, средний и общий баллы.

select * from students
select * from exam_marks

create view info_students as
select tab2.id, tab2.surname, tab2.name, tab2.avg_mark, tab2.total_mark
  from (select *
          from students s left join (select em.student_id, avg(em.mark) avg_mark, sum(em.mark) total_mark
                                       from exam_marks em
                                   group by em.student_id) tab1
						  on s.id=tab1.student_id) tab2;


select * from info_students



-- 4. Создайте представление для получения сведений о студенте фамилия, 
--    имя, а также количестве экзаменов, которые он сдал успешно, и количество,
--    которое ему еще нужно досдать (с учетом пересдач двоек).

select * from students
select * from exam_marks

create view info_students_exam as
select s.surname, s.name, tab1.успешно, tab2.досдать
  from students s left join  (select student_id, count(mark) успешно
                                from exam_marks
                               where mark>=3
                            group by student_id) tab1
				         on s.id=tab1.student_id
				  left join  (select s.id, count(*) досдать
                                from students s cross join subjects sub
                                                 left join exam_marks em
				                                        on s.id=em.student_id
					                                   and sub.id=em.subj_id
					                                   and mark>2
                               where em.mark is null
                            group by s.id) tab2
						 on s.id=tab2.id;

select * from info_students_exam

-- 5. Какие из представленных ниже представлений являются обновляемыми?

C, D

-- A. CREATE VIEW DAILYEXAM AS
--    SELECT DISTINCT STUDENT_ID, SUBJ_ID, MARK, EXAM_DATE
--    FROM EXAM_MARKS


-- B. CREATE VIEW CUSTALS AS
--    SELECT SUBJECTS.ID, SUM (MARK) AS MARK1
--    FROM SUBJECTS, EXAM_MARKS
--    WHERE SUBJECTS.ID = EXAM_MARKS.SUBJ_ID
--    GROUP BY SUBJECT.ID


-- C. CREATE VIEW THIRDEXAM
--    AS SELECT *
--    FROM DAILYEXAM
--    WHERE EXAM_DATE = '2012/06/03'


-- D. CREATE VIEW NULLCITIES
--    AS SELECT ID, SURNAME, CITY
--    FROM STUDENTS
--    WHERE CITY IS NULL
--    OR SURNAME BETWEEN 'А' AND 'Д'
--    WITH CHECK OPTION


-- 6. Создайте представление таблицы STUDENTS с именем STIP, включающее поля 
--    STIPEND и ID и позволяющее вводить или изменять значение поля 
--    стипендия, но только в пределах от 100 д о 500.

--select * from students

create view STIP as
select stipend, id
  from students
 where stipend between 100 and 500
with check option;

select * from STIP