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

UPDATE customer c
SET c.last_update = (SELECT MAX(r.rental_date)
                     FROM rental r
                     WHERE r.customer_id = c.customer_id);

-- page 210
UPDATE customer c
SET c.last_update = (SELECT MAX(r.rental_date)
                     FROM rental r
                     WHERE r.customer_id = c.customer_id)
WHERE EXISTS
    (SELECT 1
    FROM rental r
    WHERE r.customer_id = c.customer_id);

DELETE FROM customer
WHERE 365 < ALL (SELECT DATEDIFF(NOW(), r.rental_date) days_since_last_rental
                 FROM rental r
                 WHERE r.customer_id = customer.customer_id);

-- page 211
-- подзапросы как источники данных
-- 599 rows retrieved
SELECT c.first_name,
       c.last_name,
       pymnt.num_rentals,
       pymnt.total_payments
FROM customer c
    INNER JOIN (SELECT customer_id,
                       COUNT(*) num_rentals,
                       SUM(amount) total_payments
                FROM payment
                GROUP BY customer_id
                ) pymnt
        ON pymnt.customer_id = c.customer_id;

-- page 213
SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit
UNION ALL
SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit
UNION ALL
SELECT 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit;

-- 3 rows retrieved
SELECT pymnt_groups.name, COUNT(*) num_customers
FROM (SELECT customer_id,
             COUNT(*) num_rentals,
             SUM(amount) total_payments
      FROM payment
      GROUP BY customer_id
      ) pymnt
    INNER JOIN (SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit
                UNION ALL
                SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit
                UNION ALL
                SELECT 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit
                ) pymnt_groups
        ON pymnt.total_payments
            BETWEEN pymnt_groups.low_limit AND pymnt_groups.high_limit
GROUP BY pymnt_groups.name;

-- page 215
-- 599 rows retrieved
SELECT c.first_name,
       c.last_name,
       ct.city,
       SUM(p.amount) total_payments,
       COUNT(*) total_rentals
FROM payment p
    INNER JOIN customer c
        ON c.customer_id = p.customer_id
    INNER JOIN address a
        ON a.address_id = c.address_id
    INNER JOIN city ct
        ON ct.city_id = a.city_id
GROUP BY c.first_name, c.last_name, ct.city;

-- 599 rows retrieved
SELECT customer_id,
       COUNT(*) total_rentals,
       SUM(amount) total_payments
FROM payment
GROUP BY customer_id;

-- page 216
-- 599 rows retrieved
SELECT c.first_name,
       c.last_name,
       ct.city,
       pymnt.total_payments,
       pymnt.total_rentals
FROM (SELECT customer_id,
             COUNT(*) total_rentals,
             SUM(amount) total_payments
      FROM payment
      GROUP BY customer_id
      ) pymnt
    INNER JOIN customer c
        ON c.customer_id = pymnt.customer_id
    INNER JOIN address a
        ON a.address_id = c.address_id
    INNER JOIN city ct
        ON ct.city_id = a.city_id;

-- page 217
-- Common table expression
-- CTE
-- обобщённые табличные выражения
-- именованные подзапросы
-- использование выражения WITH
-- 9 rows retrieved
WITH actors_s AS (SELECT actor_id,
                         first_name,
                         last_name
                  FROM actor
                  WHERE last_name LIKE 'S%'),
    actors_s_pg AS (SELECT s.actor_id,
                           s.first_name,
                           s.last_name,
                           f.film_id, f.title
                    FROM actors_s s
                        INNER JOIN film_actor fa
                            ON fa.actor_id = s.actor_id
                        INNER JOIN film f
                            ON f.film_id = fa.film_id
                    WHERE f.rating = 'PG'
                    ),
    actors_s_pg_revenue AS (SELECT spg.first_name,
                                   spg.last_name,
                                   p.amount
                            FROM actors_s_pg spg
                                INNER JOIN inventory i
                                    ON i.film_id = spg.film_id
                                INNER JOIN rental r
                                    ON r.inventory_id = i.inventory_id
                                INNER JOIN payment p
                                    ON p.rental_id = r.rental_id
                            ) -- конец предложения WITH
SELECT spg_rev.first_name,
       spg_rev.last_name,
       SUM(spg_rev.amount) total_revenue
FROM actors_s_pg_revenue spg_rev
GROUP BY spg_rev.first_name, spg_rev.last_name
ORDER BY 3 DESC;

-- page 218
-- использование коррелированных скалярных подзапросов в предложении SELECT
-- 599 rows retrieved
SELECT
    (SELECT c.first_name
    FROM customer c
    WHERE c.customer_id = p.customer_id) first_name,
    (SELECT c.last_name
     FROM customer c
     WHERE c.customer_id = p.customer_id) last_name,
    (SELECT ct.city
     FROM customer c
        INNER JOIN address a
            ON a.address_id = c.address_id
        INNER JOIN city ct
            ON ct.city_id = a.city_id
     WHERE c.customer_id = p.customer_id) city,
    SUM(p.amount) total_payments,
    COUNT(*) total_rentals
FROM payment p
GROUP BY p.customer_id;

-- page 219
-- 200 rows retrieved
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
ORDER BY (SELECT COUNT(*)
          FROM film_actor fa
          WHERE fa.actor_id = a.actor_id) DESC;

-- page 220
INSERT INTO film_actor (actor_id,
                        film_id,
                        last_update)
VALUES (
        (SELECT actor_id
         FROM actor
         WHERE first_name = 'JENNIFER' AND last_name = 'DAVIS'),
        (SELECT film_id
         FROM film
         WHERE title = 'ACE GOLDFINGER'),
        NOW());

-- exercise 9.1
-- 64 rows retrieved
SELECT film_id, title
FROM film
WHERE film_id IN (SELECT fc.film_id
                  FROM film_category fc
                      INNER JOIN category c
                          ON c.category_id = fc.category_id
                  WHERE c.name = 'Action');

SELECT fc.film_id
FROM film_category fc
    INNER JOIN category c
        ON c.category_id = fc.category_id
WHERE c.name = 'Action';

-- exercise 9.2
-- 64 rows retrieved
SELECT f.film_id, f.title
FROM film f
WHERE EXISTS
    (SELECT 1
    FROM film_category fc
        INNER JOIN category c
            ON c.category_id = fc.category_id
    WHERE c.name = 'Action'
        AND fc.film_id = f.film_id);

-- exercise 9.3
SELECT 'Hollywood Star' level, 30 min_roles, 99999 max_roles
UNION ALL
SELECT 'Prolific Actor' level, 20 min_roles, 29 max_roles
UNION ALL
SELECT 'Newcomer' level, 1 min_roles, 19 max_roles;

-- моё решение
-- 200 rows retrieved
SELECT a.actor_id,
       a.first_name,
       a.last_name,
       levels.level
FROM actor a
    INNER JOIN film_actor fa
        ON fa.actor_id = a.actor_id
    INNER JOIN (SELECT 'Hollywood Star' level, 30 min_roles, 99999 max_roles
                UNION ALL
                SELECT 'Prolific Actor' level, 20 min_roles, 29 max_roles
                UNION ALL
                SELECT 'Newcomer' level, 1 min_roles, 19 max_roles) levels
WHERE (SELECT COUNT(*)
       FROM film_actor fa
       WHERE fa.actor_id = a.actor_id
       GROUP BY fa.actor_id) BETWEEN levels.min_roles AND levels.max_roles
GROUP BY a.actor_id, levels.level
ORDER BY a.actor_id;

-- решение из книги
-- 200 rows retrieved
SELECT actr.actor_id, grps.level
FROM
    (SELECT actor_id, COUNT(*) num_roles
     FROM film_actor
     GROUP BY actor_id
     ) actr
    INNER JOIN
        (SELECT 'Hollywood Star' level, 30 min_roles, 99999 max_roles
        UNION ALL
        SELECT 'Prolific Actor' level, 20 min_roles, 29 max_roles
        UNION ALL
        SELECT 'Newcomer' level, 1 min_roles, 19 max_roles
        ) grps
        ON actr.num_roles BETWEEN grps.min_roles AND grps.max_roles;
