-- page 113
DESC customer;

-- page 114
DESC address;

-- page 115
-- декартово произведение
-- каждая строка одной таблицы соединяется со каждой строкой другой таблицы
SELECT c.first_name, c.last_name, a.address
FROM customer c
    JOIN address a;

-- COUNT = 599 rows
SELECT COUNT(*)
FROM customer;

-- COUNT = 603 rows
SELECT COUNT(*)
FROM address;

-- COUNT = 599 * 603 = 361197 rows
SELECT COUNT(*)
FROM customer c
    JOIN address a;

-- page 116
-- внутренние соединения
-- 599 rows retrieved
SELECT c.first_name, c.last_name, a.address
FROM customer c
    JOIN address a
        ON a.address_id = c.address_id;

-- !!!
-- от перестановки столбцов в условии соединения в подпредложении ON результирующий набор не изменяется!!!
-- !!!
-- 599 rows retrieved
SELECT c.first_name, c.last_name, a.address
FROM customer c
    JOIN address a
        ON c.address_id = a.address_id;

-- page 117
-- ключевое слово INNER
-- !!!
-- При внутреннем соединении (INNER JOIN):
-- если значение имеется в столбце address_id одной таблицы,
-- но отсутствует в другой, то соединение для строк, содержащих это значение,
-- не выполняется, и эти строки исключаются из результирующего набора!!!
-- !!!
SELECT c.first_name, c.last_name, a.address
FROM customer c
    INNER JOIN address a
        ON a.address_id = c.address_id;

-- использование подпредложения USING
SELECT c.first_name, c.last_name, a.address
FROM customer c
    INNER JOIN address a
        USING (address_id);

-- page 118
-- синтаксис соединения ANSI
-- https://en.wikipedia.org/wiki/American_National_Standards_Institute
-- 599 rows retrieved
SELECT c.first_name, c.last_name, a.address
FROM customer c, address a
WHERE c.address_id = a.address_id;

-- то же самое
-- 599 rows retrieved
SELECT c.first_name, c.last_name, a.address
FROM customer c, address a
WHERE a.address_id = c.address_id;

-- page 119
-- 2 rows retrieved
SELECT c.first_name, c.last_name, a.address
FROM customer c, address a
WHERE c.address_id = a.address_id
    AND a.postal_code = 52137;

-- 2 rows retrieved
SELECT c.first_name, c.last_name, a.address
FROM customer c
    INNER JOIN address a
        ON a.address_id = c.address_id
WHERE a.postal_code = 52137;

-- page 120
-- соединение трех и более таблиц
DESC address;

DESC city;

-- 599 rows retrieved
SELECT c.first_name, c.last_name, ct.city
FROM customer c
    INNER JOIN address a
        ON a.address_id = c.address_id
    INNER JOIN city ct
        ON ct.city_id = a.city_id;

-- page 121
-- различные комбинации порядка таблиц при их соединении
-- во всех случаях возвращаются одни и те же результаты
-- 599 rows retrieved
SELECT c.first_name, c.last_name, ct.city
FROM customer c
    INNER JOIN address a
        ON a.address_id = c.address_id
    INNER JOIN city ct
        ON ct.city_id = a.city_id;

-- 599 rows retrieved
SELECT c.first_name, c.last_name, ct.city
FROM customer c
    INNER JOIN address a
        ON c.address_id = a.address_id
    INNER JOIN city ct
        ON ct.city_id = a.city_id;

-- 599 rows retrieved
SELECT c.first_name, c.last_name, ct.city
FROM customer c
    INNER JOIN address a
        ON a.address_id = c.address_id
    INNER JOIN city ct
        ON a.city_id = ct.city_id;

-- 599 rows retrieved
SELECT c.first_name, c.last_name, ct.city
FROM city ct
    INNER JOIN address a
        ON a.city_id = ct.city_id
    INNER JOIN customer c
        ON c.address_id = a.address_id;

-- 599 rows retrieved
SELECT c.first_name, c.last_name, ct.city
FROM city ct
    INNER JOIN address a
        ON ct.city_id = a.city_id
    INNER JOIN customer c
        ON c.address_id = a.address_id;

-- 599 rows retrieved starting
SELECT c.first_name, c.last_name, ct.city
FROM city ct
    INNER JOIN address a
        ON a.city_id = ct.city_id
    INNER JOIN customer c
        ON a.address_id = c.address_id;

-- 599 rows retrieved starting
SELECT c.first_name, c.last_name, ct.city
FROM address a
    INNER JOIN city ct
        ON a.city_id = ct.city_id
    INNER JOIN customer c
        ON c.address_id = a.address_id;

-- 599 rows retrieved
SELECT c.first_name, c.last_name, ct.city
FROM address a
    INNER JOIN city ct
        ON ct.city_id = a.city_id
    INNER JOIN customer c
        ON c.address_id = a.address_id;

-- 599 rows retrieved
SELECT c.first_name, c.last_name, ct.city
FROM address a
    INNER JOIN city ct
        ON ct.city_id = a.city_id
    INNER JOIN customer c
        ON a.address_id = c.address_id;

-- 599 rows retrieved
SELECT c.first_name, c.last_name, ct.city
FROM address a
    INNER JOIN customer c
        ON a.address_id = c.address_id
    INNER JOIN city ct
        ON ct.city_id = a.city_id;

-- 599 rows retrieved
SELECT c.first_name, c.last_name, ct.city
FROM address a
    INNER JOIN customer c
        ON c.address_id = a.address_id
    INNER JOIN city ct
        ON ct.city_id = a.city_id;

-- 599 rows retrieved
SELECT c.first_name, c.last_name, ct.city
FROM address a
    INNER JOIN customer c
        ON c.address_id = a.address_id
    INNER JOIN city ct
        ON a.city_id = ct.city_id;

-- page 122
-- 599 rows retrieved
SELECT STRAIGHT_JOIN c.first_name, c.last_name, ct.city
FROM city ct
    INNER JOIN address a
        ON a.city_id = ct.city_id
    INNER JOIN customer c
        ON c.address_id = a.address_id;


