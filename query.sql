select * from addresses;

#1 запрос для создания временной таблицы через переменную типа TABLE
create temporary table temp
(
    id int auto_increment not null primary key ,
    text text
);

#2 запроса с использованием условной конструкции IF
select title, if (amount_sub > 30000, 'Много абонентов', 'Мало абонентов') as 'Абоненты' from ATS;
select district, street, house, if (flat is null, 'Коммерческое', 'Жилое') as 'Помещение' from addresses;

#2 запроса с использованием цикла WHILE
delimiter //
create function createArray(quantity int)
returns varchar(255)
deterministic
begin
    declare counter int;
    declare array varchar(255);
    set counter = 0;
    set array = '';
    while counter < quantity do
        set array = concat(array, counter + 1, ',');
        set counter = counter + 1;
        end while;
    return array;
end //
delimiter ;
select createArray(5);

delimiter //
create procedure createTurnArray(quantity int)
begin
    declare array varchar(255);
    declare counter int;
    set counter = quantity;
    set array = '';
    while counter > 0 do
        set array = concat(array, counter, ',');
        set counter = counter - 1;
        end while;
    select array;
end //
delimiter ;
call createTurnArray(5);

#1 запрос для создания скалярной функции
delimiter //
create function call_minutes(time_start time, time_end time)
returns int
deterministic
begin
    declare minutes int;
    set minutes = minute(time(time_end - time_start));
    return minutes;
end //
delimiter ;
select call_minutes(time_start, time_end) as minutes from call_logs;

#1 запрос для создания функции, которая возвращает табличное значение;
delimiter //
create procedure getResultATS(ind int)
begin
    select * from ATS where id = ind;
end //
delimiter ;
call getResultATS(1);

#2 запроса для создания процедуры без параметров
delimiter //
create procedure getResultsATS()
begin
    select * from ATS;
end //
delimiter ;
call getResultsATS();

delimiter //
create procedure getSumATS()
begin
    select sum(amount_sub) as 'amount subs' from ATS;
end //
delimiter ;
call getSumATS();

#2 запроса для создания процедуры c входным параметром
delimiter //
create procedure getCallLogsByDate(date date)
begin
    select * from call_logs where date_call = date;
end //
delimiter ;
call getCallLogsByDate('2022-09-08');

delimiter //
create procedure getMorePrice(price double)
begin
    select * from sub_logs where total_price > price;
end //
delimiter ;
call getMorePrice(20);

#2 запроса для создания процедуры c входными параметрами и RETURN
delimiter //
create function sumTwo(one int, two int)
returns int deterministic
begin
    return one + two;
end //
delimiter ;
select sumTwo(1, 3) as sum;

delimiter //
create function getDiscount(price double, percent double)
returns double deterministic
begin
    declare discount double;
    set discount = price * percent / 100;
    return price - discount;
end //
delimiter ;
select getDiscount(134.2, 20);

#2 запроса для создания процедуры обновления данных в таблице базы данных
delimiter //
create procedure updatePhone(phone bigint, ind int)
begin
    update subs set telephone_number = phone where id = ind;
end //
delimiter ;
call updatePhone(375297458914, 1);

delimiter //
create procedure updateAtsPrice(city double, intercity double, name varchar(255))
begin
    update ATS_prices, ATS join ATS_prices Ap on ATS.id = Ap.id_ATS
    set Ap.price_city = city,
    Ap.price_intercity = intercity
    where ATS.title = name;
end //
delimiter ;
call updateAtsPrice(12, 13, 'АТС-203');

#2 запроса для создания процедуры извлечения данных из таблиц базы данных
delimiter //
create procedure selectAllATS()
begin
    select * from ATS;
end //
delimiter ;
call selectAllATS();

delimiter //
create procedure selectATSByTitle(title varchar(255))
begin
    select * from ATS where ATS.title = title;
end //
delimiter ;
call selectATSByTitle('ATC-204');



