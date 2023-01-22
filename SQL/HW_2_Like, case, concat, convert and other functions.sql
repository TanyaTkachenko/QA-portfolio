-- Внимание! Во всех результирующих выборках должны быть учтены все записи, даже
-- те, которые содержать NULL поля, однако, склейка не должна быть NULL записью!
-- В качестве <значения по умолчания> используйте строку 'unknown'.


-- 1. Составьте запрос для таблицы STUDENT таким образом, чтобы выходная таблица 
--    содержала один столбец типа varchar, содержащий последовательность разделенных 
--    символом ';' (точка с запятой) значений столбцов этой таблицы, и при этом 
--    текстовые значения должны отображаться прописными символами (верхний регистр), 
--    то есть быть представленными в следующем виде: 
--    1;КАБАНОВ;ВИТАЛИЙ;M;550;4;ХАРЬКОВ;01/12/1990;2.
--    ...
--    примечание: в выборку должны попасть студенты из любого города из 5 букв


/*select *
    from students
   where city like '_____'*/


select concat(id, ';', upper(surname), ';', upper(name), ';', upper(gender), ';', 
       convert(integer, stipend), ';', course, ';', upper(city), ';', 
	   isnull ( convert(varchar, birthday, 103), upper('unknown')), ';', 
	   isnull ( convert(varchar, univ_id), upper('unknown')))
  from students
 where len(city)=5



-- 2. Составьте запрос для таблицы STUDENT таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде: 
--    В.КАБАНОВ;местожительства-ХАРЬКОВ;родился-01.12.90
--    ...
--    примечание: в выборку должны попасть студенты, фамилия которых содержит вторую
--    букву 'е' и предпоследнюю букву 'и', либо же фамилия заканчивается на 'ц'


  /*select *
    from students
   where surname like '_е%' and surname like '%и_' or surname like '%ц'*/


  select concat(left(name,1), '.', upper(surname), ';', 'местожительства-', upper(city), ';',
               'родился-', isnull ( convert(varchar, birthday, 4), 'unknown'))
    from students
   where surname like '_е%' and surname like '%и_' or surname like '%ц'



-- 3. Составьте запрос для таблицы STUDENT таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде:
--    т.цилюрик;местожительства-Херсон; учится на IV курсе
--    ...
--    примечание: курс указать римскими цифрами (воспользуйтесь CASE), 
--    отобрать студентов, стипендия которых кратна 200


/*select *
  from students
 where stipend%200=0*/


select concat(lower(left(name,1)), '.', lower(surname), ';', 'местожительства-', city, ';', ' учится на ',
       case course 
	   when 1 then 'I'
	   when 2 then 'II'
	   when 3 then 'III'
	   when 4 then 'IV'
	   when 5 then 'V'
	    end, ' курсе')
  from students
 where stipend%200=0


-- 4. Составьте запрос для таблицы STUDENT таким образом, чтобы выборка 
--    содержала столбец в следующем виде:
--     Нина Федосеева из г.Днепропетровск родилась в 1992 году
--     ...
--     Дмитрий Коваленко из г.Хмельницкий родился в 1993 году
--     ...
--     примечание: для всех городов, в которых более 8 букв


/*select *
  from students
 where len(city)>=8*/


select name + ' ' + surname + ' из г.' + city + ' ' +
       case gender
	   when 'm' then 'родился в '
	   when 'f' then 'родилась в '
	    end 
	   + isnull (format(birthday, 'yyyy'), 'unknown') + ' году'
  from students
 where len(city)>=8

 

-- 5. Вывести фамилии, имена студентов и величину получаемых ими стипендий, 
--    при этом значения стипендий первокурсников должны быть увеличены на 17.5%

/*select *
  from students*/


select surname, name, 
       case
	   when course=1 then stipend*1.175
	   else stipend
	    end new_stipend
  from students


-- 6. Вывести наименования всех учебных заведений и их расстояния 
--    (придумать/нагуглить/взять на глаз) до Киева.

/*select *
from universities*/


select name,
       case city
	   when 'Киев' then 0
	   when 'Львов' then 541
	   when 'Харьков' then 480
	   when 'Днепропетровск' then 449
	   when 'Донецк' then 721
	   when 'Одесса' then 474
	   when 'Тернополь' then 420
	   when 'Запорожье' then 556
	   when 'Белая Церковь' then 86
	   when 'Херсон' then 546
	    end Расстояние_до_Киева
  from universities



-- 7. Вывести все учебные заведения и их две последние цифры рейтинга.

/*select *
from universities*/


select name, right(rating,2) new_rating
  from universities



-- 8. Составьте запрос для таблицы UNIVERSITY таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде:
--    Код-1;КПИ-г.Киев;Рейтинг относительно ДНТУ(501) +756
--    ...
--    Код-11;КНУСА-г.Киев;рейтинг относительно ДНТУ(501) -18
--    ...
--    примечание: рейтинг вычислить относительно ДНТУшного, а также должен 
--    присутствовать знак (+/-), рейтинг ДНТУ заранее известен = 501

/*select *
  from universities*/


select concat('Код-', id, ';', name, '-г.', city, ';', 
       case 
	   when id=1 then 'Рейтинг относительно ДНТУ(501) ' 
	   when id>1 then 'рейтинг относительно ДНТУ(501) ' 
	    end,
       case
       when rating-501>0 then concat('+', rating-501)
	   else cast(rating-501 as varchar)
        end )
  from universities



-- 9. Составьте запрос для таблицы UNIVERSITY таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде:
--    Код-1;КПИ-г.Киев;рейтинг состоит из 12 сотен
--    Код-2;КНУ-г.Киев;рейтинг состоит из 6 сотен


/*select *
  from universities*/


select concat('Код-', id, ';', name, '-г.', city, ';', 'рейтинг состоит из ',
       case 
	   when rating=1257 then 12
	   when rating>=600 then 6
	   when rating>=500 then 5
	   when rating>=400 then 4
	   when rating>=300 then 3
	   when rating<100 then 0
        end, ' сотен')
  from universities