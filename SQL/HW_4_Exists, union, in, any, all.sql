-- 1. Напишите запрос с EXISTS, позволяющий вывести данные обо всех студентах, 
--    обучающихся в вузах с рейтингом не попадающим в диапазон от 488 до 571

/*select * from students
select * from universities where rating not between 488 and 571
select *
  from students
 where univ_id in (select id from universities where rating not between 488 and 571)
 order by univ_id*/


select *
  from students s
 where exists (select 1 
                 from universities u 
				where u.rating not between 488 and 571 and s.univ_id=u.id)



-- 2. Напишите запрос с EXISTS, выбирающий всех студентов, для которых в том же городе, 
--    где живет и учится студент, существуют другие университеты, в которых он не учится.


/*select city from universities group by city having count(city)>=2
select * from students s
 where s.univ_id in (select u.id from universities u where u.city=s.city)*/


select *
  from students s
 where exists (select 1 
                 from universities u 
				where u.city=s.city
				  and s.univ_id=u.id
				  and u.city in(select u.city 
				                  from universities u 
					          group by u.city 
							    having count(u.city)>=2))

																	 
-- 3. Напишите запрос, выбирающий из таблицы SUBJECTS данные о названиях предметов обучения, 
--    экзамены по которым были хоть как-то сданы более чем 12 студентами, за первые 10 дней сессии. 
--    Используйте EXISTS. Примечание: по возможности выходная выборка должна быть без пересдач.

/*select * from subjects
  select subj_id from exam_marks
   where mark>=3 and exam_date < (select min(exam_date)+10 from exam_marks)
--order by subj_id, student_id
group by subj_id having count(distinct student_id)>=12*/


select s.name
  from subjects s
 where exists (select 1
                 from exam_marks em
				where s.id=em.subj_id
				  and em.mark>=3
				  and em.exam_date < (select min(em.exam_date)+10
				                        from exam_marks em)
						            group by em.subj_id
								      having count(distinct em.student_id)>=12)

																	  
-- 4. Напишите запрос EXISTS, выбирающий фамилии всех лекторов, преподающих в университетах
--    с рейтингом, превосходящим рейтинг каждого харьковского универа.

/*select * from lecturers order by univ_id
select * from universities order by rating*/

--Вариант 1:
select lec.surname
  from lecturers lec
 where exists (select 1
                 from universities u
				where lec.univ_id=u.id and u.rating >all (select u.rating
				                                            from universities u
														   where u.city like '%Харьков%'))

--Вариант 2:
select lec.surname
  from lecturers lec
 where exists (select 1
                 from universities u
				where lec.univ_id=u.id and u.rating > (select max(u.rating)
				                                         from universities u
														where u.city like '%Харьков%'))


-- 5. Напишите 2 запроса, использующий ANY и ALL, выполняющий выборку данных о студентах, 
--    у которых в городе их постоянного местожительства нет университета.

/*select * from students order by city
select * from universities order by city*/


select *
  from students s
 where s.city <>all (select u.city
                       from universities u)


select *
  from students s
 where not s.city =any (select u.city
                          from universities u)


-- 6. Напишите запрос выдающий имена и фамилии студентов, которые получили
--    максимальные оценки в первый и последний день сессии.
--    Подсказка: выборка должна содержать по крайне мере 2х студентов.

/*select * from students
select * from exam_marks order by exam_date*/

select s.name, s.surname
  from students s
 where exists (select 1 
                 from exam_marks em
				where s.id=em.student_id
				  and ((em.mark=(select max(em.mark)
				                   from exam_marks em
						          where em.exam_date=(select min(em.exam_date)
														from exam_marks em))
														 and em.exam_date=(select min(em.exam_date)
														                     from exam_marks em))
                   or (em.mark=(select max(em.mark)
				                  from exam_marks em
								 where em.exam_date=(select max(em.exam_date)
								                       from exam_marks em))
													    and em.exam_date=(select max(em.exam_date)
														                    from exam_marks em))))


-- 7. Напишите запрос EXISTS, выводящий кол-во студентов каждого курса, которые успешно 
--    сдали экзамены, и при этом не получивших ни одной двойки.

/*select * from students order by course
select * from exam_marks*/


  select s.course, count(s.course) cnt_students
    from students s
   where exists (select 1
                 from exam_marks em
				where s.id=em.student_id and (em.mark>=3))
     and not exists (select 1
                     from exam_marks em
					where s.id=em.student_id and (em.mark=2))
group by s.course


-- 8. Напишите запрос EXISTS на выдачу названий предметов обучения, 
--    по которым было получено максимальное кол-во оценок.

/*select * from subjects
select subj_id, count(*)  from exam_marks group by subj_id*/


select sb.name
  from subjects sb
 where exists (select 1
                 from exam_marks em
				where sb.id=em.subj_id 
               having count(*) in (select max (cntmark) max_cntmark
                                    from (select em.subj_id, count(*) cntmark
                                            from exam_marks em
                                        group by em.subj_id) xxx))


-- 9. Напишите команду, которая выдает список фамилий студентов по алфавиту, 
--    с колонкой комментарием: 'успевает' у студентов , имеющих все положительные оценки, 
--    'не успевает' для сдававших экзамены, но имеющих хотя бы одну 
--    неудовлетворительную оценку, и комментарием 'не сдавал' – для всех остальных.
--    Примечание: по возможности воспользуйтесь операторами ALL и ANY.

/*select * from students
select * from exam_marks*/

--Вариант 1 (оператор any):

  select s.surname, 'успевает' Комментарии
    from students s
   where s.id =any (select em.student_id
                      from exam_marks em
				  group by em.student_id
				    having min(em.mark)>2)
   union all
  select s.surname, 'не успевает'
   from students s
   where s.id =any (select em.student_id
                      from exam_marks em
					 where em.mark=2)
   union all
  select s.surname, 'не сдавал'
    from students s
   where not s.id =any (select em.student_id
                          from exam_marks em
						 where em.mark>=2)
order by s.surname


--Вариант 2 (оператор all):

  select s.surname, 'успевает' Комментарии
    from students s
   where not s.id <>all (select em.student_id
                           from exam_marks em
					   group by em.student_id
					     having min(em.mark)>2)
   union all
  select s.surname, 'не успевает'
    from students s
   where not s.id <>all (select em.student_id
                           from exam_marks em
						  where em.mark=2)
   union all
  select s.surname, 'не сдавал'
    from students s
   where s.id <>all (select em.student_id
                       from exam_marks em
					  where em.mark>=2)
order by s.surname


-- 10. Создайте объединение двух запросов, которые выдают значения полей 
--     NAME, CITY, RATING для всех университетов. Те из них, у которых рейтинг 
--     равен или выше 500, должны иметь комментарий 'Высокий', все остальные – 'Низкий'.

/*select * from universities*/

select name, city, rating, 'Высокий' Комментарии
  from universities
 where rating>=500
 union all
select name, city, rating, 'Низкий'
  from universities
 where rating<500

 
-- 11. Напишите UNION запрос на выдачу списка фамилий студентов 4-5 курсов в виде 3х полей выборки:
--     SURNAME, 'студент <значение поля COURSE> курса', STIPEND
--     включив в список преподавателей в виде
--     SURNAME, 'преподаватель из <значение поля CITY>', <значение зарплаты в зависимости от города проживания (придумать самим)>
--     отсортировать по фамилии
--     Примечание: достаточно учесть 4-5 городов.

/*select * from students
select * from lecturers*/

  select surname, case
                     when course=4 then 'студент 4 курса'
                     when course=5 then 'студент 5 курса'
	        	  end comments, stipend payments
    from students
   where course in (4,5)
   union all
  select surname, 'преподаватель из ' + city, case
                                                 when city='Днепропетровск' then 2000
												 when city='Харьков' then 1900
												 when city='Львов' then 1800
												 when city='Киев' then 1700
												 when city='Херсон' then 1600
											   end
    from lecturers
   where city in ('Днепропетровск', 'Харьков', 'Львов', 'Киев', 'Херсон')
order by surname