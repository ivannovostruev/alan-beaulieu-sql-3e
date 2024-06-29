-- page 146
CREATE TABLE string_table
(
    char_field  CHAR(30),
    vchar_field VARCHAR(30),
    text_field  TEXT
);

INSERT INTO string_table (char_field,
                          vchar_field,
                          text_field)
VALUES ('This is char data',
        'This is varchar data',
        'This is text data');

-- page 147
-- [22001][1406] Data truncation: Data too long for column 'vchar_field' at row 1
UPDATE string_table
SET vchar_field = 'This is a piece of extremely long data';

-- [22001][1406] Data truncation: Data too long for column 'char_field' at row 1
UPDATE string_table
SET char_field = 'This is a piece of extremely long data';

SELECT @@session.sql_mode;

SET sql_mode = 'ansi';

-- REAL_AS_FLOAT
-- PIPES_AS_CONCAT
-- ANSI_QUOTES
-- IGNORE_SPACE
-- ONLY_FULL_GROUP_BY
-- ANSI
SELECT @@session.sql_mode;

UPDATE string_table
SET vchar_field = 'This is a piece of extremely long data';

-- 0 rows retrieved
SHOW WARNINGS;

-- page 148
-- 1 row retrieved
SELECT vchar_field
FROM string_table;

-- экранирование одинарной кавычки(апострофа)
-- 1 row affected
UPDATE string_table
SET text_field = 'This string didn''t work, but it does now';

-- page 149
SELECT text_field
FROM string_table;

-- 1 row retrieved
SELECT QUOTE(text_field)
FROM string_table;

-- page 150
-- включение специальных символов
-- 1 row retrieved
SELECT 'abcdefg', CHAR(97, 98, 99, 100, 101, 102, 103);

-- !!!
-- In MySQL, CHAR() function works weird
-- https://stackoverflow.com/questions/65614116/in-mysql-char-function-works-weird
--
-- https://bugs.mysql.com/bug.php?id=99480
--
-- https://dev.mysql.com/doc/refman/8.0/en/mysql-command-options.html
-- !!!
-- символы с диактрическими знаками
-- 1 row retrieved
SELECT CHAR(128, 129, 130, 131, 132, 133, 134, 135, 136, 137);

-- символы с диактрическими знаками
-- 1 row retrieved
SELECT CHAR(138, 139, 140, 141, 142, 143, 144, 145, 146, 147);

-- символы с диактрическими знаками
-- 1 row retrieved
SELECT CHAR(148, 149, 150, 151, 152, 153, 154, 155, 156, 157);

-- символы с диактрическими знаками
-- 1 row retrieved
SELECT CHAR(158, 159, 160, 161, 162, 163, 164, 165);

-- page 151
-- 0x64616E6B6520736368946E
SELECT CONCAT('danke sch', CHAR(148), 'n');

-- CODE = 148
-- 1 row retrieved
SELECT ASCII('ö');

-- page 152
DELETE FROM string_table;

INSERT INTO string_table (char_field,
                          vchar_field,
                          text_field)
VALUES ('This string is 28 characters',
        'This string is 28 characters',
        'This string is 28 characters');

SELECT *
FROM string_table;

-- использование функции LENGTH()
-- возвращает количество символов в строке
-- 1 row retrieved
SELECT LENGTH(char_field) char_length,
       LENGTH(vchar_field) vchar_length,
       LENGTH(text_field) text_length
FROM string_table;

-- page 153
-- использование функции POSITION()
-- возвращает позицию подстроки в строке
-- 1 row retrieved
SELECT POSITION('characters' IN vchar_field)
FROM string_table;

-- использование функции LOCATE()
-- 1 row retrieved
SELECT LOCATE('is', vchar_field, 5)
FROM string_table;

-- page 154
DELETE FROM string_table;

INSERT INTO string_table (vchar_field)
VALUES ('abcd'),
       ('xyz'),
       ('QRSTUV'),
       ('qrstuv'),
       ('12345');

-- 5 rows retrieved
SELECT vchar_field
FROM string_table
ORDER BY vchar_field;

-- page 155
-- использование функции STRCMP() для сравнения строк
SELECT STRCMP('12345', '12345') 12345_12345,
       STRCMP('abcd', 'xyz') abcd_xyz,
       STRCMP('abcd', 'QRSTUV') abcd_QRSTUV,
       STRCMP('qrstuv', 'QRSTUV') qrstuv_QRSTUV,
       STRCMP('12345', 'xyz') 12345_xyz,
       STRCMP('xyz', 'qrstuv') xyz_qrstuv;

SELECT name, name LIKE '%y' ends_in_y
FROM category;

-- page 156
SELECT name, name REGEXP 'y$' ends_in_y
FROM category;

-- page 157
DELETE FROM string_table;

INSERT INTO string_table (text_field)
VALUES ('This string was 29 characters');

UPDATE string_table
SET text_field = CONCAT(text_field, ', but now it is longer');

SELECT text_field
FROM string_table;

-- 599 rows retrieved
SELECT CONCAT(first_name, ' ', last_name,
    ' has been a customer since ',
    DATE(create_date)) cust_narrative
FROM customer;

-- page 159
-- использование функции INSERT()
-- 1 row retrieved
SELECT INSERT('goodbye world', 9, 0, 'cruel ') test_string;

SELECT INSERT('goodbye world', 1, 7, 'hello') test_string;

-- page 160
-- использование функции SUBSTRING()
-- извлечение подстроки из строки
-- извлекает указанное количество символов, начиная с заданной позиции
-- Вернёт строку "cruel"
SELECT SUBSTRING('goodbye cruel world', 9, 5);

-- работа с числовыми данными
SELECT (37 * 59) / (78 - (8 * 6));

-- page 162
-- остаток от деления
-- вернёт значение = 2
SELECT MOD(10, 4);

-- вернёт значение = 2.75
SELECT MOD(22.75, 5);

-- вернёт значение = 256
SELECT POW(2, 8);

SELECT POW(2, 10) kilobyte,
       POW(2, 20) megabyte,
       POW(2, 30) gigabyte,
       POW(2, 40) terabyte;

-- page 163
SELECT CEIL(72.445),
       FLOOR(72.445);

SELECT CEIL(72.00000000),
       FLOOR(72.999999999);

SELECT ROUND(72.49999),
       ROUND(72.5),
       ROUND(72.50001);

-- page 164
SELECT ROUND(72.0909, 1),
       ROUND(72.0909, 2),
       ROUND(72.0909, 3);

SELECT TRUNCATE(72.0909, 1),
       TRUNCATE(72.0909, 2),
       TRUNCATE(72.0909, 3);

-- page 165
SELECT ROUND(17, -1), TRUNCATE(17, -1);

-- работа со знаковыми данными
SELECT account_id, SIGN(balance), ABS(balance)
FROM account;

-- page 167
SELECT @@global.time_zone, @@session.time_zone;

-- page 168
SET time_zone = 'Europe/Zurich';

SELECT @@global.time_zone, @@session.time_zone;

-- page 169
-- инструкция для изменения даты
UPDATE rental
SET return_date = '2019-09-17 15:30:00'
WHERE rental_id = 99999;

-- page 170
-- преобразование строки в дату
SELECT CAST('2019-09-17 15:30:00' AS DATETIME);

SELECT CAST('2019-09-17' AS DATE) date_field,
       CAST('108:17:57' AS TIME) time_field;

-- page 171
-- использование функции STR_TO_DATE
UPDATE rental
SET return_date = STR_TO_DATE('September 17, 2019', '%M %d, %Y')
WHERE rental_id = 99999;

-- page 172
SELECT CURRENT_DATE(),
       CURRENT_TIME(),
       CURRENT_TIMESTAMP();

-- page 173
SELECT DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY);

UPDATE rental
SET return_date = DATE_ADD(return_date, INTERVAL '3:27:11' HOUR_SECOND)
WHERE rental_id = 99999;

-- page 174
UPDATE employee
SET birth_date = DATE_ADD(birth_date, INTERVAL '9-11' YEAR_MONTH)
WHERE emp_id = 4789;

SELECT LAST_DAY('2019-09-17');

-- page 175
-- вернёт значение = "Wednesday"
SELECT DAYNAME('2019-09-18');

-- вернёт значение = 2019
SELECT EXTRACT(YEAR FROM '2019-09-18 22:19:05');

-- page 176
-- вернёт значение = 74
SELECT DATEDIFF('2019-09-03', '2019-06-21');

-- вернёт значение = 74
SELECT DATEDIFF('2019-09-03 23:59:59', '2019-06-21 00:00:01');

-- вернёт значение = -74
SELECT DATEDIFF('2019-06-21', '2019-09-03');

-- page 177
-- функции преобразования
SELECT CAST('1456328' AS SIGNED INTEGER);

-- вернёт значение = 999
SELECT CAST('999ABC111' AS UNSIGNED INTEGER);

-- Truncated incorrect INTEGER value: '999ABC111'
SHOW WARNINGS;

-- exercise 7.1
-- вернёт значение = "substring"
SELECT SUBSTRING('Please find the substring in this string', 17, 9);

-- exercise 7.2
SELECT ABS(-25.76823),
       SIGN(-25.76823),
       ROUND(-25.76823, 2);

-- exercise 7.3
SELECT EXTRACT(MONTH FROM CURRENT_DATE());
