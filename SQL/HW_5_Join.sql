-- 1. Напишите запрос, выдающий список фамилий преподавателей английского
--    языка с названиями университетов, в которых они преподают.
--    Отсортируйте запрос по городу, где расположен университ, а
--    затем по фамилии лектора.

/*select * from lecturers
select * from universities
select * from subjects
select * from subj_lect*/


  select l.surname, u.name
    from lecturers l join universities u on l.univ_id=u.id
   where l.id in (select lecturer_id
                    from subj_lect
				   where subj_id in (select id
				                       from subjects
									  where name like '%Английский%'))
order by u.city, l.surname


-- 2. Напишите запрос, который выполняет вывод данных о фамилиях, сдававших экзамены 
--    студентов, учащихся в Б.Церкви, вместе с наименованием каждого сданного ими предмета, 
--    оценкой и датой сдачи.

/*select * from students
select * from exam_marks
select * from universities
select * from subjects*/

select s.surname, sub.name, em.mark, em.exam_date
  from students s join exam_marks em on em.student_id=s.id
             left join subjects sub on em.subj_id=sub.id
 where s.univ_id in (select u.id
                       from universities u
					  where u.city like '%Белая Церковь%')


-- 3. Используя оператор JOIN, выведите объединенный список городов с указанием количества 
--    учащихся в них студентов и преподающих там же преподавателей.

/*select * from students
select * from lecturers
select * from universities*/

  select u.city, count(distinct s.id) qty_students, count(distinct l.id) qty_lecturers
    from universities u left join students s on s.univ_id=u.id
                        left join lecturers l on l.univ_id=u.id
group by u.city


-- 4. Напишите запрос который выдает фамилии всех преподавателей и наименование предметов,
--    которые они читают в КПИ

/*select * from lecturers
select * from subjects
select * from subj_lect
select * from universities*/

select l.surname, s.name
  from lecturers l left join subj_lect sl on l.id=sl.lecturer_id
                   left join subjects s on s.id=sl.subj_id
				   left join universities u on l.univ_id=u.id
 where u.name like'%КПИ%'

 
-- 5. Покажите всех студентов-двоешников, кто получил только неудовлетворительные оценки (2) 
--    и по каким предметам, а также тех кто не сдал ни одного экзамена. 
--    В выходных данных должны быть приведены фамилии студентов, названия предметов и 
--    оценка, если оценки нет, заменить ее на прочерк.

/*select * from students
select * from exam_marks
select * from subjects*/

select s.surname, isnull (sub.name, '-') subject, isnull ( convert(varchar, em.mark), '-') mark
  from students s left join exam_marks em on s.id=em.student_id
                  left join subjects sub on sub.id=em.subj_id
 where s.id in (select em.student_id
                  from exam_marks em
		      group by em.student_id
		        having max(em.mark)=2) or em.mark is null
				

-- 6. Напишите запрос, который выполняет вывод списка университетов с рейтингом, 
--    превышающим 490, вместе со значением максимального размера стипендии, 
--    получаемой студентами в этих университетах.

/*select * from universities
select * from students*/

  select u.name, max(s.stipend) max_stipend
    from universities u join students s on u.id=s.univ_id
   where u.rating>490
group by u.name


-- 7. Расчитать средний бал по оценкам студентов для каждого университета, 
--    умноженный на 100, округленный до целого, и вычислить разницу с текущим значением
--    рейтинга университета.

/*select * from universities
select * from exam_marks
select * from students*/


select u.name, new_rating, cast(rating - new_rating as int) delta
  from universities u, (select s.univ_id, cast(round(avg(em.mark)*100, 0) as int) new_rating
                          from exam_marks em join students s on s.id=em.student_id
                      group by s.univ_id) tab1
where u.id=tab1.univ_id


-- 8. Написать запрос, выдающий список всех фамилий лекторов из Киева попарно. 
--    При этом не включать в список комбинации фамилий самих с собой,
--    то есть комбинацию типа "Коцюба-Коцюба", а также комбинации фамилий, 
--    отличающиеся порядком следования, т.е. включать лишь одну из двух 
--    комбинаций типа "Хижна-Коцюба" или "Коцюба-Хижна".

/*select * from lecturers*/

select l1.surname + '-' + l2.surname pairs
  from lecturers l1 cross join lecturers l2
 where l1.city like '%Киев%' and l1.city=l2.city
                             and l1.id<>l2.id
							 and l1.id>l2.id


-- 9. Выдать информацию о всех университетах, всех предметах и фамилиях преподавателей, 
--    если в университете для конкретного предмета преподаватель отсутствует, то его фамилию
--    вывести на экран как прочерк '-' (воспользуйтесь ф-ей isnull)

/*select * from universities
select * from subjects
select * from lecturers
select * from subj_lect*/


select universities, lecturers, isnull(tab2.surname, '-') lect_surname
  from (select u.id univid, sb.id sbid, u.name universities, sb.name lecturers
          from universities u cross join subjects sb) tab1 
                               left join (select *
							                from lecturers l join subj_lect sl
											                 on l.id=sl.lecturer_id) tab2
                               on tab1.univid=tab2.univ_id and tab1.sbid=tab2.subj_id


-- 10. Кто из преподавателей и сколько поставил пятерок за свой предмет?

/*select * from lecturers
select * from students
select * from exam_marks where mark=5 order by subj_id
select * from subjects
select * from subj_lect*/


  select tab1.surname, count(tab1.surname) cnt_5
    from exam_marks em left join students s on s.id=em.student_id
                       left join (select *
					                from lecturers l join subj_lect sl on l.id=sl.lecturer_id) tab1
					   on s.univ_id=tab1.univ_id and em.subj_id=tab1.subj_id
   where em.mark=5 and tab1.surname is not null
group by tab1.surname


-- 11. Добавка для уверенных в себе студентов: показать кому из студентов какие экзамены
--     еще досдать.

/*select * from students
select * from exam_marks

  select student_id, count(*), count(distinct subj_id)
    from exam_marks
group by student_id
  having count(*)>count(distinct subj_id)

select * from subjects*/

-- Всего: 45 студентов * 7 предметов = 315 экзаменов, сдано 120 - 4 пересдачи = 116.
-- Осталось сдать 315-116=199 экзаменов.
 
select s.surname student, sub.name subject
  from students s cross join subjects sub
                   left join exam_marks em
				   on s.id=em.student_id and sub.id=em.subj_id
 where em.student_id is null and em.subj_id is null