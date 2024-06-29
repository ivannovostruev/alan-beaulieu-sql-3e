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














