#3 простейших запроса с использованием операторов сравнения
select * from addresses where district = 'Зеленолужский';
select * from subs where benefit = true and intercity = true;
select * from call_logs where date_call < now();

#3 запроса с использованием логических операторов AND, OR и NOT
select * from addresses where flat is not null;
select * from sub_logs where minutes_city and minutes_intercity > 400;
select * from ATS where amount_sub < 30000 or kind = 'departmental';

#2 запроса на использование комбинации логических операторов
select * from addresses where flat is not null and district != 'Московский' or 'Октябрьский';
select * from subs where telephone_kind = 'parallel' or benefit = false;

#2 запроса на использование выражений над столбцами
select id_ATS, price_city + price_intercity as total_price from ATS_prices;
select sum(amount_sub) as total_sub from ATS;

#2 запроса с проверкой на принадлежность множеству
select * from addresses where district in ('Первомайский', 'Зеленолужский');
select * from ATS_prices where price_city not in (14, 24);

#2 запроса с проверкой на принадлежность диапазону значений
select * from ATS_prices where price_city between 12 and 13;
select * from sub_logs where price between 15 and 25;

#2 запроса с проверкой на соответствие шаблону
select * from subs where lower(last_name) like 'с%';
select * from ATS where title like '%-%';

#2 запроса с проверкой на неопределенное значение
select * from addresses where flat is null;
select * from subs where patronymic is null;



#2 запроса с использованием декартового произведения двух таблиц
select * from ATS cross join ATS_prices;
select * from addresses cross join ATS;

#3 запроса с использованием соединения двух таблиц по равенству
select * from ATS a join ATS_prices Ap on a.id = Ap.id_ATS;
select * from ATS join addresses a2 on ATS.id_address = a2.id;
select * from sub_logs join subs s on sub_logs.id_sub = s.id;

#2 запроса с использованием соединения двух таблиц по равенству и условием отбора
select * from ATS a join ATS_prices Ap on a.id = Ap.id_ATS where a.kind = 'city' and Ap.price_city > 13;
select * from addresses a join ATS on a.id = ATS.id_address where a.flat is null and ATS.kind = 'city';

#2 запроса с использованием соединения по трем таблицам
select * from ATS join addresses a on ATS.id_address = a.id join ATS_prices Ap on ATS.id = Ap.id_ATS;
select * from subs join sub_logs sl on subs.id = sl.id_sub join call_logs cl on subs.id = cl.id_sub;

#2 запроса с использованием левого внешнего соединения
select * from subs left join call_logs cl on subs.id = cl.id_sub;
select * from subs left join sub_logs sl on subs.id = sl.id_sub;

#2 запроса на использование правого внешнего соединения
select * from call_logs right join subs s on call_logs.id_sub = s.id;
select * from sub_logs right join subs s on sub_logs.id_sub = s.id;

#2 запроса с использованием симметричного соединения и удаление избыточности
select a1.amount_sub, a2.amount_sub, a1.city from ATS a1, ATS a2 where a1.city = a2.city
and a1.amount_sub < a2.amount_sub;
select s1.last_name, s1.id_address, s2.id_address from subs s1, subs s2 where s1.last_name = s2.last_name;



#2 запроса с использованием функции COUNT
select count(*) from ATS;
select count(*) from subs;

#2 запроса с использованием функции SUM
select sum(price_city) as total_city_price from ATS_prices;
select sum(price_intercity) as total_intercity from ATS_prices;

#2 запроса с использованием функций UPPER, LOWER
select UPPER(last_name), first_name from subs;
select LOWER(street) from addresses;

#2 запроса с использованием временных функций
select now() as now_date;
select curtime() as time;

#2 запроса с использованием группировки по одному столбцу
select kind, count(*) from ATS group by kind;
select telephone_kind, count(*) from subs group by telephone_kind;

#2 запроса на использование группировки по нескольким столбцам
select kind, city, count(*) from ATS group by kind, city;
select telephone_kind, intercity, benefit, count(*) from subs group by telephone_kind, intercity, benefit;

#2 запроса с использованием условия отбора групп HAVING
select kind, count(*), min(amount_sub) from ATS group by kind having min(amount_sub) > 21000;
select telephone_kind, count(*) from subs group by telephone_kind having count(*) > 2;

#2 запроса с использованием фразы HAVING без фразы GROUP BY
select count(*) from ATS having count(*) > 2;
select min(amount_sub) from ATS having min(amount_sub) > 21000;

#2 запроса с использованием сортировки по столбцу
select * from subs order by last_name;
select * from ATS_prices order by price_city desc;

#2 запроса на добавление новых данных в таблицу
insert into subs (last_name, first_name, patronymic, telephone_kind, telephone_number, id_address) values
('Иванов', 'Иван', 'Иванович', 'main', 375298465785, 1);
insert into ATS (title, kind, city, amount_sub, id_address) values
('АТС-300', 'city', 'Гомель', 35400, 2);

#2 запроса на добавление новых данных по результатам запроса в качестве вставляемого значения
insert into ATS_prices (id_ATS, price_city, price_intercity)
values ((select id from ATS where city = 'Витебск'), 21.20, 25.15);
insert into sub_logs (id_sub, month, year, minutes_city, minutes_intercity, price, total_price)
values ((select id from subs where intercity = 0), 'Октябрь', 2022, 300, 150, 30, 30);

#2 запроса на обновление существующих данных в таблице
update ATS set city = 'Минск' where id = 2;
update subs set id_address = 2 where last_name like 'Симонов%';

#2 запроса на обновление существующих данных по результатам подзапроса во фразе WHERE
update ATS_prices set price_city = 25 where id_ATS = (select id from ATS where title = 'АТС-206');
update sub_logs set minutes_city = 300 where id_sub = (select id from subs where last_name = 'Симонов');

#2 запроса на удаление существующих данных
delete from ATS where id = 5;
delete from call_logs where date_call < now();

