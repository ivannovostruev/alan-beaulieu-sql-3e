-- page 69
-- Empty set
SELECT first_name, last_name
FROM customer
WHERE last_name = 'ZIEGLER';

-- 16 rows in set
SELECT *
FROM category;

-- page 70
SELECT *
FROM language;

-- page 71
SELECT language_id, name, last_update
FROM language;

SELECT name
FROM language;

-- page 72
SELECT language_id,
       'COMMON' language_usage,
       language_id * 3.141597 lang_pi_value,
       UPPER(name) language_name
FROM language;

SELECT VERSION(),
       USER(),
       DATABASE();

-- page 73
SELECT language_id,
       'COMMON' AS language_usage,
       language_id * 3.1415927 AS lang_pi_value,
       UPPER(name) AS language_name
FROM language;

-- page 74
SELECT actor_id
FROM film_actor
ORDER BY actor_id;

-- удаление дубликатов строк
SELECT DISTINCT actor_id
FROM film_actor
ORDER BY actor_id;

-- page 76-77
SELECT CONCAT(cust.last_name, ', ', cust.first_name) full_name
FROM (SELECT first_name, last_name, email
      FROM customer
      WHERE first_name = 'JESSIE'
      ) cust;

-- page 77
-- создание временной таблицы
-- [HY000][1681] Integer display width is deprecated and will be removed in a future release
-- https://stackoverflow.com/questions/58938358/mysql-warning-1681-integer-display-width-is-deprecated
CREATE TEMPORARY TABLE actors_j
(
    actor_id    SMALLINT,    -- в книге используется SMALLINT(5)
    first_name  VARCHAR(45),
    last_name   VARCHAR(45)
);

INSERT INTO actors_j
SELECT actor_id,
       first_name,
       last_name
FROM actor
WHERE last_name LIKE 'J%';

-- запрос получает строки из временной таблицы
SELECT *
FROM actors_j;

-- page 78
-- создание представления
CREATE VIEW cust_vw AS
SELECT customer_id,
       first_name,
       last_name,
       active
FROM customer;

-- запрос получает строки из представления
SELECT first_name, last_name
FROM cust_vw
WHERE active = 0;

-- page 79
-- соединение (join) таблиц
SELECT customer.first_name,
       customer.last_name,
       TIME(rental.rental_date) rental_time
FROM customer
    INNER JOIN rental
        ON rental.customer_id = customer.customer_id
WHERE DATE(rental.rental_date) = '2005-06-14';

-- page 80
-- использование псевдонимов
SELECT c.first_name,
       c.last_name,
       TIME(r.rental_date) rental_time
FROM customer c
    INNER JOIN rental r
        ON r.customer_id = c.customer_id
WHERE DATE(r.rental_date) = '2005-06-14';

-- page 81
-- использование ключевого слова AS
SELECT c.first_name,
       c.last_name,
       TIME(r.rental_date) rental_time
FROM customer AS c
    INNER JOIN rental AS r
        ON r.customer_id = c.customer_id
WHERE DATE(r.rental_date) = '2005-06-14';

-- выборка только тех фильмов, которые соответствуют указанным критериям
SELECT title
FROM film
WHERE rating = 'G' AND rental_duration >= 7;

-- page 82
-- использование оператора OR для разделения условий фильтрации
SELECT title
FROM film
WHERE rating = 'G' OR rental_duration >= 7;

-- page 83
-- использование круглых скобок для группировки условий
SELECT title
FROM film
WHERE (rating = 'G' AND rental_duration >= 7)
   OR (rating = 'PG-13' AND rental_duration < 4);

-- page 84
-- использование предложений GROUP BY и HAVING
-- считаю этот запрос не совсем корректным, так как могут быть полные тёзки
-- правильнее будет группировать по столбцу customer_id
SELECT c.first_name,
       c.last_name,
       COUNT(*)
FROM customer c
    INNER JOIN rental r
        ON r.customer_id = c.customer_id
GROUP BY c.first_name, c.last_name
HAVING COUNT(*) >= 40;

-- мой вариант представленной выше инструкции
SELECT c.first_name,
       c.last_name,
       COUNT(*)
FROM customer c
    INNER JOIN rental r
        ON r.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING COUNT(*) >= 40;

-- page 85
SELECT c.first_name,
       c.last_name,
       TIME(r.rental_date) rental_time
FROM customer c
    INNER JOIN rental r
        ON r.customer_id = c.customer_id
WHERE DATE(r.rental_date) = '2005-06-14';

-- использование предложения ORDER BY
-- сортировка по столбцу last_name таблицы customer
SELECT c.first_name,
       c.last_name,
       TIME(r.rental_date) rental_time
FROM customer c
    INNER JOIN rental r
    ON r.customer_id = c.customer_id
WHERE DATE(r.rental_date) = '2005-06-14'
ORDER BY c.last_name;

-- page 87
-- сортировка по столбцам last_name и first_name таблицы customer
SELECT c.first_name,
       c.last_name,
       TIME(r.rental_date) rental_time
FROM customer c
    INNER JOIN rental r
        ON r.customer_id = c.customer_id
WHERE DATE(r.rental_date) = '2005-06-14'
ORDER BY c.last_name, c.first_name;

-- поменял порядок столбцов для эксперимента
SELECT c.first_name,
       c.last_name,
       TIME(r.rental_date) rental_time
FROM customer c
         INNER JOIN rental r
                    ON r.customer_id = c.customer_id
WHERE DATE(r.rental_date) = '2005-06-14'
ORDER BY c.first_name, c.last_name;

-- page 87-88
-- сортировка по убыванию с использованием выражения на основе данных столбца
SELECT c.first_name,
       c.last_name,
       TIME(r.rental_date) rental_time
FROM customer c
    INNER JOIN rental r
        ON r.customer_id = c.customer_id
WHERE DATE(r.rental_date) = '2005-06-14'
ORDER BY TIME(r.rental_date) DESC;

-- page 88
-- сортировка с помощью номера столбца
SELECT c.first_name,
       c.last_name,
       TIME(r.rental_date) rental_time
FROM customer c
    INNER JOIN rental r
        ON r.customer_id = c.customer_id
WHERE DATE(r.rental_date) = '2005-06-14'
ORDER BY 3 DESC;

-- exercise 3.1
-- 200 rows retrieved
SELECT actor_id,
       first_name,
       last_name
FROM actor
ORDER BY last_name, first_name;

-- альтернативное решение
-- 200 rows retrieved
SELECT actor_id,
       first_name,
       last_name
FROM actor
ORDER BY 3, 2;

-- exercise 3.2
-- 6 rows retrieved
SELECT actor_id,
       first_name,
       last_name
FROM actor
WHERE last_name = 'WILLIAMS' OR last_name = 'DAVIS';

-- альтернативное решение
-- 6 rows retrieved
SELECT actor_id,
       first_name,
       last_name
FROM actor
WHERE last_name IN ('WILLIAMS', 'DAVIS');

-- exercise 3.3
-- 27 rows retrieved
SELECT DISTINCT customer_id
FROM rental
WHERE DATE(rental_date) = '2005-07-05';

-- exercise 3.4
SELECT c.email,
       r.return_date
FROM customer c
    INNER JOIN rental r
        ON r.customer_id = c.customer_id
WHERE DATE(r.rental_date) = '2005-06-14'
ORDER BY r.return_date DESC;

-- альтернативное решение
SELECT c.email,
       r.return_date
FROM customer c
         INNER JOIN rental r
                    ON r.customer_id = c.customer_id
WHERE DATE(r.rental_date) = '2005-06-14'
ORDER BY 2 DESC;
