--  !!! В выходной выборке должны присутствовать только запрашиваемые в условии поля.

-- 1. Напишите один запрос с использованием псевдонимов для таблиц и псевдонимов полей, 
--    выбирающий все возможные комбинации городов (CITY) из таблиц 
--    STUDENTS, LECTURERS и UNIVERSITIES
--    строки не должны повторяться, убедитесь в выводе только уникальных троек городов
--    Внимание: убедитесь, что каждая колонка выборки имеет свое уникальное имя
   

select distinct s.city as stud_city,
                l.city as lect_city,
				u.city as univ_city
           from students as s,
		        lecturers as l,
				universities as u
       order by stud_city, lect_city, univ_city


	   
-- 2. Напишите запрос для вывода полей в следущем порядке: семестр, в котором он
--    читается, идентификатора (номера ID) предмета обучения, его наименования и 
--    количества отводимых на этот предмет часов для всех строк таблицы SUBJECTS


select semester, id, name, hours
  from subjects

  
-- 3. Выведите все строки таблицы EXAM_MARKS, в которых предмет обучения SUBJ_ID равен 4


select *
  from exam_marks
 where subj_id=4



-- 4. Необходимо выбирать все данные, в следующем порядке 
--    Стипендия, Курс, Фамилия, Имя  из таблицы STUDENTS, причем интересуют
--    студенты, родившиеся после '1993-07-21'


select stipend, course, surname, name--, birthday
  from students
 where birthday >= '1993-07-21'
  --order by birthday



-- 5. Вывести на экран все предметы: их наименования и кол-во часов для каждого из них
--    в 1-м семестре и при этом кол-во часов не должно превышать 41


select name, hours--, semester
  from subjects
 where semester=1 and hours<=41



-- 6. Напишите запрос, позволяющий вывести из таблицы EXAM_MARKS уникальные 
--    значения экзаменационных оценок, которые были получены '2012-06-12'


select distinct mark
           from exam_marks
          where exam_date='2012-06-12'

		  
-- 7. Выведите список фамилий студентов, обучающихся на третьем и последующих 
--    курсах и при этом проживающих не в Киеве, не Харькове и не Львове.


--Вариант 1:
select surname--, course, city
  from students
 where course>=3 and city<>'Киев' and city<>'Харьков' and city<>'Львов'


--Вариант 2:
   use qalight
select surname--, course, city
  from students
 where course>=3 and city not in ('Киев', 'Харьков', 'Львов')

 

-- 8. Покажите данные о фамилии, имени и номере курса для студентов, 
--    получающих стипендию в диапазоне от 450 до 650, не включая 
--    эти граничные суммы. Приведите несколько вариантов решения этой задачи.


--Вариант 1:
select surname, name, course--, stipend
  from students
 where stipend>450 and stipend<650


--Вариант 2:
select surname, name, course--, stipend
  from students
 where stipend between 450.01 and 649.99


--Вариант 3:
select surname, name, course--, stipend
  from students
 where stipend between 450 and 650 and stipend<>450 and stipend<>650



-- 9. Напишите запрос, выполняющий выборку из таблицы LECTURERS всех фамилий
--    преподавателей, проживающих во Львове, либо же преподающих в университете
--    с идентификатором 14


select surname--, city, univ_id
  from lecturers
 where city='Львов' or univ_id=14



-- 10. Выясните в каких городах (названия) расположены университеты,  
--     рейтинг которых составляет 528 +/- 47 баллов.


select city--, rating
  from universities
 where rating between 481 and 575



-- 11. Отобрать список фамилий киевских студентов, их имен и дат рождений 
--     для всех нечетных курсов.


select surname, name, birthday--, city, course
  from students
 where city='Киев' and course in (1,3,5)


 
-- 12. Упростите выражение фильтрации (избавтесь от NOT) и дайте логическую формулировку запроса?
-- SELECT * FROM STUDENTS WHERE (STIPEND < 500 OR NOT (BIRTHDAY >= '1993-01-01' AND ID > 9))
-- Подсказка: после упрощения, запрос должен возвращать ту же выборку, что и оригинальный


select *
  from students
 where stipend < 500 or birthday < '1993-01-01' or id <= 9

 
--Формулировка запроса: отобразить все данные по студентам, у которых стипендия меньше 500,
--                      либо же дата рождения до 1 января 1993 года,
--                      либо же идентификатор ниже 9 включительно.



-- 13. Упростите выражение фильтрации (избавтесь от NOT) и дайте логическую формулировку запроса?
-- SELECT * FROM STUDENTS WHERE NOT ((BIRTHDAY = '1993-06-07' OR STIPEND > 500) AND ID >= 9)
-- Подсказка: после упрощения, запрос должен возвращать ту же выборку, что и оригинальный

select *
  from students
 where birthday <> '1993-06-07' and stipend <= 500 or id < 9

--Формулировка запроса: отобразить все данные по студентам, у которых день рождение не 7 июня 1993 года,
--                      либо же стипендия меньше 500 включительно,
--                      либо же идентификатор ниже 9.

