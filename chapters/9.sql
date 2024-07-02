-- Подзапросы
-- page 196
-- 1 row retrieved
SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id = (SELECT MAX(customer_id)
                     FROM customer);

-- 1 row retrieved
SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id = 599;

-- page 197
-- некоррелированные подзапросы
-- некоррелированный скалярный подзапрос
-- 540 rows retrieved
SELECT city_id, city
FROM city
WHERE country_id <> (SELECT country_id
                     FROM country
                     WHERE country = 'India');

-- page 198
-- [21000][1242] Subquery returns more than 1 row
-- Подзапрос вернул более одной строки
SELECT city_id, city
FROM city
WHERE country_id <> (SELECT country_id
                     FROM country
                     WHERE country <> 'India');

-- 108 rows retrieved
SELECT country_id
FROM country
WHERE country <> 'India';

-- page 199
-- подзапросы с несколькими строками и одним столбцом
-- 2 rows retrieved
SELECT country_id
FROM country
WHERE country IN ('Canada', 'Mexico');

-- 2 rows retrieved
SELECT country_id
FROM country
WHERE country = 'Canada' OR country = 'Mexico';

-- page 200
-- использование оператора IN
-- 37 rows retrieved
SELECT city_id, city
FROM city
WHERE country_id IN (SELECT country_id
                     FROM country
                     WHERE country IN ('Canada', 'Mexico'));

-- использование оператора NOT IN
-- 563 rows retrieved
SELECT city_id, city
FROM city
WHERE country_id NOT IN (SELECT country_id
                         FROM country
                         WHERE country IN ('Canada', 'Mexico'));

-- page 201
-- использование оператора ALL
-- 576 rows retrieved
SELECT first_name, last_name
FROM customer
WHERE customer_id <> ALL (SELECT customer_id
                          FROM payment
                          WHERE amount = 0);

-- page 202
-- 576 rows retrieved
SELECT first_name, last_name
FROM customer
WHERE customer_id NOT IN (SELECT customer_id
                          FROM payment
                          WHERE amount = 0);

-- любая попытка приравнять значение к NULL даёт unknown
-- Empty set
-- 0 rows retrieved
SELECT first_name, last_name
FROM customer
WHERE customer_id NOT IN (122, 452, NULL);

-- 1 row retrieved
SELECT customer_id, COUNT(*)
FROM rental
GROUP BY customer_id
HAVING COUNT(*) > ALL (SELECT COUNT(*)
                       FROM rental r
                            INNER JOIN customer c
                                ON c.customer_id = r.customer_id
                            INNER JOIN address a
                                ON a.address_id = c.address_id
                            INNER JOIN city ct
                                ON ct.city_id = a.city_id
                            INNER JOIN country co
                                ON co.country_id = ct.country_id
                       WHERE co.country IN ('United States', 'Canada')
                       GROUP BY r.customer_id);

-- page 203
-- использование оператора ANY
-- 6 rows retrieved
SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > ANY (SELECT SUM(p.amount)
                          FROM payment p
                            INNER JOIN customer c
                                ON c.customer_id = p.customer_id
                            INNER JOIN address a
                                ON a.address_id = c.address_id
                            INNER JOIN city ct
                                ON ct.city_id = a.city_id
                            INNER JOIN country co
                                ON co.country_id = ct.country_id
                          WHERE co.country IN ('Bolivia', 'Paraguay', 'Chile')
                          GROUP BY co.country);

-- page 204
-- многостолбцовые подзапросы
-- 11 rows retrieved
SELECT fa.actor_id, fa.film_id
FROM film_actor fa
WHERE fa.actor_id IN (SELECT actor_id
                      FROM actor
                      WHERE last_name = 'MONROE')
    AND fa.film_id IN (SELECT film_id
                       FROM film
                       WHERE rating = 'PG');

-- page 205
-- !!!
-- Проверка, встречается ли набор в наборе наборов?
-- !!!
-- 11 rows retrieved
SELECT actor_id, film_id
FROM film_actor
WHERE (actor_id, film_id) IN (SELECT a.actor_id, f.film_id
                              FROM actor a
                                CROSS JOIN film f
                              WHERE a.last_name = 'MONROE'
                                AND f.rating = 'PG');

-- page 206
-- коррелированные подзапросы
-- запрос извлекает тех клиентов,
-- которые взяли напрокат ровно 20 фильмов
-- 15 rows retrieved
SELECT c.first_name, c.last_name
FROM customer c
WHERE 20 = (SELECT COUNT(*)
            FROM rental r
            WHERE r.customer_id = c.customer_id);

-- page 207
-- 6 rows retrieved
SELECT c.first_name, c.last_name
FROM customer c
WHERE (SELECT SUM(p.amount)
       FROM payment p
       WHERE p.customer_id = c.customer_id)
    BETWEEN 180 AND 240;

-- page 208
-- использование оператора EXISTS
-- условие проверяет, вернул ли подзапрос хотя бы одну строку
-- 8 rows retrieved
SELECT c.first_name, c.last_name
FROM customer c
WHERE EXISTS
    (SELECT 1
    FROM rental r
    WHERE r.customer_id = c.customer_id
    AND DATE(r.rental_date) < '2005-05-25');

-- 8 rows retrieved
SELECT 1
FROM rental
WHERE DATE(rental_date) < '2005-05-25';

-- 8 rows retrieved
SELECT c.first_name, c.last_name
FROM customer c
WHERE EXISTS
    (SELECT r.rental_date, r.customer_id, 'ABCD' str, 2*3/7 nmbr
    FROM rental r
    WHERE r.customer_id = c.customer_id
        AND DATE(r.rental_date) < '2005-05-25');

-- page 209
-- использование оператора NOT EXISTS
-- 1 row retrieved
SELECT a.first_name, a.last_name
FROM actor a
WHERE NOT EXISTS
    (SELECT 1
    FROM film_actor fa
        INNER JOIN film f
            ON f.film_id = fa.film_id
    WHERE fa.actor_id = a.actor_id
        AND f.rating = 'R');





































































