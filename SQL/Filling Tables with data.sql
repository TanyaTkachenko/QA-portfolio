
USE EXAM

BEGIN
    INSERT INTO makers (id, name, country) 
    VALUES  (1,  N'Виробник1', N'Україна'),
            (2,  N'Виробник2', N'Україна'),
			(3,  N'Виробник3', N'США'),
			(4,  N'Виробник4', N'Польща'),
			(5,  N'Виробник5', N'США'),
			(6,  N'Виробник6', N'Польща'),
			(7,  N'Виробник7', N'Україна');
END;

BEGIN
    INSERT INTO products (id, name, price, maker_id) 
    VALUES  (1,  N'Продукт1', 55.80, 5),
	        (2,  N'Продукт2', 19.25, 7),
			(3,  N'Продукт3', 09.17, 1),
			(4,  N'Продукт4', 32.50, 3),
			(5,  N'Продукт5', 77.88, 6),
			(6,  N'Продукт6', 19.25, 7),
			(7,  N'Продукт7', 128.48, 4),
			(8,  N'Продукт8', 325.14, 2);
END;

BEGIN
    INSERT INTO clients(id, name, surname, city, gender, birthday, phone, discount) 
    VALUES  (1,  'Імя1', 'Прізвище1', 'Київ', 'm', CONVERT(DATETIME, N'1990.12.25', 101), '0508887791', 5),
	        (2,  'Імя2', 'Прізвище2', 'Львів', 'f', CONVERT(DATETIME, N'1978.11.29', 101), '0668887792', null),
			(3,  'Імя3', 'Прізвище3', 'Харків', null, null, '0508887793', null),
			(4,  'Імя4', 'Прізвище4', 'Миколаїв', 'f', CONVERT(DATETIME, N'1998.10.19', 101), '0958887794', 17),
			(5,  'Імя5', 'Прізвище5', 'Львів', 'm', CONVERT(DATETIME, N'1988.09.29', 101), '0638887795', null),
			(6,  'Імя6', 'Прізвище6', 'Львів', 'm', CONVERT(DATETIME, N'1988.09.29', 101), '0678887796', 25),
			(7,  'Імя7', 'Прізвище7', 'Львів', null, CONVERT(DATETIME, N'2001.11.15', 101), '0378887797', 45);
END;

BEGIN
    UPDATE clients 
    SET  phone='0678887797'
	where id=7
END;


BEGIN
    INSERT INTO orders(id, client_id, order_date, done_date, ship_type, ship_city) 
    VALUES  (1, 5, '2022.09.02', null, 'mail', 'Київ'),
	        (2, 3, '2022.09.02', '2022.09.04', 'self', 'Львів'),
			(3, 1, '2022.09.01', '2022.09.04', 'self', 'Харків'),
			(4, 7, '2022.08.25', '2022.09.07', 'mail', 'Львів'),
			(5, 2, '2022.08.25', null, 'mail', 'Ужгород'),
			(6, 4, '2022.08.29', '2022.09.03', 'mail', 'Львів'),
			(7, 6, '2022.08.25', null, 'mail', 'Львів');
END;

BEGIN
    INSERT INTO order_basket(order_id, product_id, quantity) 
    VALUES  (3, 5, 11);
END;


DELETE from order_basket


BEGIN
    INSERT INTO order_basket(order_id, product_id, quantity, discount) 
    VALUES  (1, 5, 11, null),
	        (2, 3, 25, 5),
			(3, 7, 11, 45),
			(4, 1, 36, 5),
			(5, 2, 77, 11),
			(6, 4, 66, null),
			(7, 6, 30, 9);
END;
