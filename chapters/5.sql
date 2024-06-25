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

-- использование подзапросов в качестве таблиц для соединения
-- 9 rows retrieved
SELECT c.first_name,
       c.last_name,
       addr.address,
       addr.city
FROM customer c
    INNER JOIN (SELECT a.address_id,
                       a.address,
                       ct.city
                FROM address a
                    INNER JOIN city ct
                        ON ct.city_id = a.city_id
                WHERE a.district = 'California'
                ) addr
        ON addr.address_id = c.address_id;

-- page 123
-- 9 rows retrieved
SELECT a.address_id, a.address, ct.city
FROM address a
    INNER JOIN city ct
        ON ct.city_id = a.city_id
WHERE a.district = 'California';

-- page 124
-- использование одной таблицы дважды
-- 54 rows retrieved
SELECT f.title
FROM film f
    INNER JOIN film_actor fa
        ON fa.film_id = f.film_id
    INNER JOIN actor a
        ON a.actor_id = fa.actor_id
WHERE (a.first_name = 'CATE' AND a.last_name = 'MCQUEEN')
    OR (a.first_name = 'CUBA' AND a.last_name = 'BIRCH');

-- 5,462 rows retrieved
SELECT f.title
FROM film f
    INNER JOIN film_actor fa
        ON fa.film_id = f.film_id
    INNER JOIN actor a
        ON a.actor_id = fa.actor_id;

-- COUNT = 1000
SELECT COUNT(*)
FROM film;

-- COUNT = 5462
SELECT COUNT(*)
FROM film_actor;

-- COUNT = 200
SELECT COUNT(*)
FROM actor;

-- !!!
-- общее количество строк в результирующем наборе при соединении таблиц
-- равно количеству строк в таблице film_actor (связь film-actor - многие ко многим)
-- !!!
-- COUNT = 5462
SELECT COUNT(*)
FROM film f
    INNER JOIN film_actor fa
        ON fa.film_id = f.film_id
    INNER JOIN actor a
        ON a.actor_id = fa.actor_id;

-- page 125
-- 2 rows retrieved
SELECT f.title
FROM film f
    INNER JOIN film_actor fa1
        ON fa1.film_id = f.film_id
    INNER JOIN actor a1
        ON a1.actor_id = fa1.actor_id
    INNER JOIN film_actor fa2
        ON fa2.film_id = f.film_id
    INNER JOIN actor a2
        ON a2.actor_id = fa2.actor_id
WHERE (a1.first_name = 'CATE' AND a1.last_name = 'MCQUEEN')
    AND (a2.first_name = 'CUBA' AND a2.last_name = 'BIRCH');

-- COUNT = 5462
SELECT COUNT(*)
FROM film f
INNER JOIN film_actor fa1
    ON fa1.film_id = f.film_id
INNER JOIN actor a1
    ON a1.actor_id = fa1.actor_id;

-- COUNT = 35292
SELECT COUNT(*)
FROM film f
    INNER JOIN film_actor fa1
        ON fa1.film_id = f.film_id
    INNER JOIN actor a1
        ON a1.actor_id = fa1.actor_id
    INNER JOIN film_actor fa2
        ON fa2.film_id = f.film_id
    INNER JOIN actor a2
        ON a2.actor_id = fa2.actor_id;

SELECT f.title,
       CONCAT(a1.first_name, ' ', a1.last_name) actor1,
       CONCAT(a2.first_name, ' ', a2.last_name) actor2
FROM film f
    INNER JOIN film_actor fa1
        ON fa1.film_id = f.film_id
    INNER JOIN actor a1
        ON a1.actor_id = fa1.actor_id
    INNER JOIN film_actor fa2
        ON fa2.film_id = f.film_id
    INNER JOIN actor a2
        ON a2.actor_id = fa2.actor_id
ORDER BY f.film_id;

-- для лучшего понимания происходящего
-- 16 rows retrieved
SELECT f.title,
       CONCAT(a1.first_name, ' ', a1.last_name) actor1,
       CONCAT(a2.first_name, ' ', a2.last_name) actor2
FROM film f
    INNER JOIN film_actor fa1
        ON fa1.film_id = f.film_id
    INNER JOIN actor a1
        ON a1.actor_id = fa1.actor_id
    INNER JOIN film_actor fa2
        ON fa2.film_id = f.film_id
    INNER JOIN actor a2
        ON a2.actor_id = fa2.actor_id
WHERE f.film_id = 2;

-- page 126
-- самосоединения
SELECT f.title, f_parent.title prequel
FROM film f
    INNER JOIN film f_parent
        ON f_parent.film_id = f.prequel_film_id
WHERE f.prequel_film_id IS NOT NULL;

-- exercise 5.1
-- 9 rows retrieved
SELECT c.first_name,
       c.last_name,
       a.address,
       ct.city
FROM customer c
    INNER JOIN address a
        ON c.address_id = a.address_id
    INNER JOIN city ct
        ON a.city_id = ct.city_id
WHERE a.district = 'California';

-- exercise 5.2
-- 29 rows retrieved
SELECT f.title
FROM film f
    INNER JOIN film_actor fa
        ON fa.film_id = f.film_id
    INNER JOIN actor a
        ON a.actor_id = fa.actor_id
WHERE a.first_name = 'JOHN';

-- exercise 5.3
-- 603 rows retrieved
SELECT a1.address addr1,
       a2.address addr2,
       a1.city_id
FROM address a1
    INNER JOIN address a2
WHERE a1.city_id = a2.city_id
    AND a1.address_id <> a2.address_id
ORDER BY a1.city_id;

-- альтернативное решение
SELECT addr1.address addr1,
       addr2.address addr2,
       addr1.city_id
FROM (SELECT a1.address_id,
             a1.address,
             ct1.city_id
      FROM address a1
          INNER JOIN city ct1
              ON ct1.city_id = a1.city_id
      ) addr1
    INNER JOIN (SELECT a2.address_id,
                       a2.address,
                       ct2.city_id
                FROM address a2
                    INNER JOIN city ct2
                        ON ct2.city_id = a2.city_id
                ) addr2
WHERE addr1.city_id = addr2.city_id
    AND addr1.address_id <> addr2.address_id
ORDER BY addr1.city_id;
