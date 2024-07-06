-- Условная логика
-- page 239
-- 599 rows retrieved
SELECT first_name,
       last_name,
       CASE
           WHEN active = 1 THEN 'ACTIVE'
           ELSE 'INACTIVE'
       END activity_type
FROM customer;

-- page 241
-- поисковые выражения CASE
-- 599 rows retrieved
SELECT c.first_name,
       c.last_name,
       CASE
           WHEN active = 0 THEN 0
           ELSE (SELECT COUNT(*)
                 FROM rental r
                 WHERE r.customer_id = c.customer_id)
       END
FROM customer c;

-- page 243
-- простые выражения CASE
CASE category.rename
    WHEN 'Children' THEN 'All Ages'
    WHEN 'Family' THEN 'All Ages'
    WHEN 'Sports' THEN 'All Ages'
    WHEN 'Animations' THEN 'All Ages'
    WHEN 'Horror' THEN 'Adult'
    WHEN 'Music' THEN 'Teens'
    WHEN 'Games' THEN 'Teens'
    ELSE 'Other'
END

-- 3 rows retrieved
SELECT MONTHNAME(rental_date) rental_month,
       COUNT(*) num_rentals
FROM rental
WHERE rental_date BETWEEN '2005-05-01' AND '2005-08-01'
GROUP BY MONTHNAME(rental_date);

-- page 244
-- 1 row retrieved
SELECT
    SUM(
        CASE
            WHEN MONTHNAME(rental_date) = 'May' THEN 1
            ELSE 0
        END
    ) May_rentals,
    SUM(
        CASE
            WHEN MONTHNAME(rental_date) = 'June' THEN 1
            ELSE 0
        END
    ) June_rentals,
    SUM(
        CASE
            WHEN MONTHNAME(rental_date) = 'July' THEN 1
            ELSE 0
        END
    ) July_rentals
FROM rental
WHERE rental_date BETWEEN '2005-05-01' AND '2005-08-01';

-- page 245
-- проверка существования
-- 22 rows retrieved
SELECT a.first_name,
       a.last_name,
       CASE
           WHEN EXISTS (SELECT 1
                        FROM film_actor fa
                            INNER JOIN film f
                                ON f.film_id = fa.film_id
                        WHERE fa.actor_id = a.actor_id
                            AND f.rating = 'G')
               THEN 'Y'
           ELSE 'N'
       END g_actor,
       CASE
           WHEN EXISTS (SELECT 1
                        FROM film_actor fa
                            INNER JOIN film f
                                ON f.film_id = fa.film_id
                        WHERE fa.actor_id = a.actor_id
                            AND f.rating = 'PG')
               THEN 'Y'
           ELSE 'N'
       END pg_actor,
       CASE
           WHEN EXISTS (SELECT 1
                        FROM film_actor fa
                            INNER JOIN film f
                                ON f.film_id = fa.film_id
                        WHERE fa.actor_id = a.actor_id
                            AND f.rating = 'NC-17')
               THEN 'Y'
           ELSE 'N'
       END nc17_actor
FROM actor a
WHERE a.last_name LIKE 'S%' OR a.first_name LIKE 'S%';

-- использование встроенной в MySQL функции IF()
-- 22 rows retrieved
SELECT a.first_name,
       a.last_name,
       IF(EXISTS(SELECT 1
                 FROM film_actor fa
                     INNER JOIN film f
                         ON f.film_id = fa.film_id
                 WHERE fa.actor_id = a.actor_id
                   AND f.rating = 'G'), 'Y', 'N')  g_actor,
       IF(EXISTS(SELECT 1
                 FROM film_actor fa
                     INNER JOIN film f
                         ON f.film_id = fa.film_id
                 WHERE fa.actor_id = a.actor_id
                   AND f.rating = 'PG'), 'Y', 'N') pg_actor,
       IF(EXISTS(SELECT 1
                 FROM film_actor fa
                     INNER JOIN film f
                         ON f.film_id = fa.film_id
                 WHERE fa.actor_id = a.actor_id
                   AND f.rating = 'NC-17'), 'Y', 'N') nc17_actor
FROM actor a
WHERE a.last_name LIKE 'S%' OR a.first_name LIKE 'S%';

-- page 246
-- 1000 rows retrieved
SELECT f.title,
       CASE (SELECT COUNT(*)
             FROM inventory i
             WHERE i.film_id = f.film_id)
           WHEN 0 THEN 'Out Of Stock'
           WHEN 1 THEN 'Scarce'
           WHEN 2 THEN 'Scarce'
           WHEN 3 THEN 'Available'
           WHEN 4 THEN 'Available'
           ELSE 'Common'
       END film_availablity
FROM film f;

-- page 247
-- ошибки деления на ноль
-- [22012][1365] Division by 0
-- 1 row retrieved
-- вернёт значение = NULL
SELECT 100 / 0;

-- 599 rows retrieved
SELECT c.first_name,
       c.last_name,
       SUM(p.amount) total_payment_amt,
       COUNT(p.amount) num_payments,
       SUM(p.amount) /
        CASE
            WHEN COUNT(p.amount) = 0 THEN 1
            ELSE COUNT(p.amount)
        END avg_payment
FROM customer c
    LEFT OUTER JOIN payment p
        ON p.customer_id = c.customer_id
GROUP BY c.first_name, c.last_name;

-- альтернатива с использованием встроенной функции IF()
-- 599 rows retrieved
SELECT c.first_name,
       c.last_name,
       SUM(p.amount) total_payment_amt,
       COUNT(p.amount) num_payments,
       SUM(p.amount) /
       IF(COUNT(p.amount) = 0, 1, COUNT(p.amount)) avg_payment
FROM customer c
    LEFT OUTER JOIN payment p
        ON p.customer_id = c.customer_id
GROUP BY c.first_name, c.last_name;

-- !!!
-- МОЁ ОТКРЫТИЕ: Если группировка выполняется по ПЕРВИЧНОМУ КЛЮЧУ
-- то СУБД позволяет использовать в списке SELECT столбцы,
-- которые не указаны в предложении GROUP BY!!!
-- !!!
-- 599 rows retrieved
SELECT c.first_name,
       c.last_name,
       SUM(p.amount) total_payment_amt,
       COUNT(p.amount) num_payments,
       SUM(p.amount) / IF(COUNT(p.amount) = 0, 1, COUNT(p.amount)) avg_payment
FROM customer c
    LEFT OUTER JOIN payment p
        ON p.customer_id = c.customer_id
GROUP BY c.customer_id;

-- page 248
-- условные обновления
UPDATE customer
SET active =
    CASE
        WHEN 90 <= (SELECT DATEDIFF(NOW(), MAX(rental_date))
                    FROM rental r
                    WHERE r.customer_id = c.customer_id)
            THEN 0
        ELSE 1
    END
WHERE active = 1;

-- альтернативный вариант
UPDATE customer
SET active =
        IF(90 <= (SELECT DATEDIFF(NOW(), MAX(rental_date))
                  FROM rental r
                  WHERE r.customer_id = c.customer_id), 0, 1)
WHERE active = 1;

-- page 249
-- обработка значений NULL
-- 599 rows retrieved
SELECT c.first_name,
       c.last_name,
       CASE
           WHEN a.address IS NULL
               THEN 'Unknown'
           ELSE a.address
       END address,
       CASE
           WHEN ct.city IS NULL
               THEN 'Unknown'
           ELSE ct.city
       END city,
       CASE
           WHEN cn.country IS NULL
               THEN 'Unknown'
           ELSE cn.country
       END country
FROM customer c
    LEFT OUTER JOIN address a
        ON a.address_id = c.address_id
    LEFT OUTER JOIN city ct
        ON ct.city_id = a.city_id
    LEFT OUTER JOIN country cn
        ON cn.country_id = ct.country_id;

-- альтернатива с использованием встроенной функции IF()
SELECT c.first_name,
       c.last_name,
       IF(a.address IS NULL, 'Unknown', a.address) AS address,
       IF(ct.city IS NULL, 'Unknown', ct.city) AS city,
       IF(cn.country IS NULL, 'Unknown', cn.country) AS country
FROM customer c
    LEFT OUTER JOIN address a
        ON a.address_id = c.address_id
    LEFT OUTER JOIN city ct
        ON ct.city_id = a.city_id
    LEFT OUTER JOIN country cn
        ON cn.country_id = ct.country_id;

-- exercise 11.1
-- 6 rows retrieved
SELECT name,
       CASE name
           WHEN 'English' THEN 'latin1'
           WHEN 'Italian' THEN 'latin1'
           WHEN 'French' THEN 'latin1'
           WHEN 'German' THEN 'latin1'
           WHEN 'Japanese' THEN 'utf8'
           WHEN 'Mandarin' THEN 'utf8'
           ELSE 'Unknown'
       END character_set
FROM language;

-- 6 rows retrieved
SELECT name,
       CASE
           WHEN name IN ('English', 'Italian', 'French', 'German')
               THEN 'latin1'
           WHEN name IN ('Japanese', 'Mandarin')
               THEN 'utf8'
           ELSE 'Unknown'
       END character_set
FROM language;

-- exercise 11.2
-- 5 rows retrieved
SELECT rating, COUNT(*)
FROM film
GROUP BY rating;

-- 1 row retrieved
SELECT
       SUM(
           CASE
               WHEN rating = 'PG'
                   THEN 1
               ELSE 0
           END
       ) AS PG,
       SUM(
           CASE
               WHEN rating = 'G'
                   THEN 1
               ELSE 0
           END
       ) AS G,
       SUM(
           CASE
               WHEN rating = 'NC-17'
                   THEN 1
               ELSE 0
           END
       ) AS 'NC-17',
       SUM(
           CASE
               WHEN rating = 'PG-13'
                   THEN 1
               ELSE 0
           END
       ) AS 'PG-13',
       SUM(
           CASE
               WHEN rating = 'R'
                   THEN 1
               ELSE 0
           END
       ) AS R
FROM film;

-- альтернативное форматирование
SELECT
    SUM(CASE WHEN rating = 'PG' THEN 1 ELSE 0 END) AS PG,
    SUM(CASE WHEN rating = 'G' THEN 1 ELSE 0 END) AS G,
    SUM(CASE WHEN rating = 'NC-17' THEN 1 ELSE 0 END) AS 'NC-17',
    SUM(CASE WHEN rating = 'PG-13' THEN 1 ELSE 0 END) AS 'PG-13',
    SUM(CASE WHEN rating = 'R' THEN 1 ELSE 0 END) AS R
FROM film;

-- альтернативное решение
-- 1 row retrieved
SELECT
    SUM(IF(rating = 'PG', 1, 0)) AS PG,
    SUM(IF(rating = 'G', 1, 0)) AS G,
    SUM(IF(rating = 'NC-17', 1, 0)) AS 'NC-17',
    SUM(IF(rating = 'PG-13', 1, 0)) AS 'PG-13',
    SUM(IF(rating = 'R', 1, 0)) AS R
FROM film;
