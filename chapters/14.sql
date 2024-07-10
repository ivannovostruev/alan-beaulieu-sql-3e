-- Представления
-- page 282
CREATE VIEW customer_vw (
    customer_id,
    first_name,
    last_name,
    email
) AS
SELECT customer_id,
       first_name,
       last_name,
       CONCAT(SUBSTR(email, 1, 2), '*****', SUBSTR(email, -4)) email
FROM customer;

-- 599 rows retrieved
SELECT first_name, last_name, email
FROM customer_vw;

-- page 283
-- 4 rows retrieved
DESCRIBE customer_vw;

-- 2 rows retrieved
SELECT first_name,
       COUNT(*),
       MIN(last_name),
       MAX(last_name)
FROM customer_vw
WHERE first_name LIKE 'J%'
GROUP BY first_name
HAVING COUNT(*) > 1
ORDER BY 1;

-- соединение представления с другой таблицей
-- 10 rows retrieved
SELECT cv.first_name, cv.last_name, p.amount
FROM customer_vw cv
    INNER JOIN payment p
        ON p.customer_id = cv.customer_id
WHERE p.amount >= 11;

-- page 284
-- представление с предложением WHERE
-- для указания, к каким строкам могут иметь доступ пользователи
CREATE VIEW active_customer_vw (
    customer_id,
    first_name,
    last_name,
    email
) AS
SELECT customer_id,
       first_name,
       last_name,
       CONCAT(SUBSTR(email, 1, 2), '*****', SUBSTR(email, -4)) email
FROM customer
WHERE active = 1;

-- page 285
-- агрегация данных
CREATE VIEW sales_by_film_category AS
SELECT c.name AS category,
       SUM(p.amount) AS total_sales
FROM payment AS p
    INNER JOIN rental AS r
        ON r.rental_id = p.rental_id
    INNER JOIN inventory AS i
        ON i.inventory_id = r.inventory_id
    INNER JOIN film AS f
        ON f.film_id = i.film_id
    INNER JOIN film_category AS fc
        ON fc.film_id = f.film_id
    INNER JOIN category AS c
        ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY total_sales DESC;

-- page 286
-- сокрытие сложности
-- 1000 rows retrieved
CREATE VIEW film_stats AS
SELECT f.film_id,
       f.title,
       f.description,
       f.rating,
       (SELECT c.name
        FROM category c
            INNER JOIN film_category fc
                ON fc.category_id = c.category_id
        WHERE fc.film_id = f.film_id) categroy_name,
        (SELECT COUNT(*)
         FROM film_actor fa
         WHERE fa.film_id = f.film_id) num_actors,
        (SELECT COUNT(*)
         FROM inventory i
         WHERE i.film_id = f.film_id) inventory_cnt,
        (SELECT COUNT(*)
         FROM inventory i
            INNER JOIN rental r
                ON r.inventory_id = i.inventory_id
         WHERE i.film_id = f.film_id) num_rentals
FROM film f;

-- page 287
-- соединение разделенных данных
CREATE VIEW payment_all (
    payment_id,
    customer_id,
    staff_id,
    rental_id,
    amount,
    payment_date,
    last_update
) AS
SELECT payment_id,
       customer_id,
       staff_id,
       rental_id,
       amount,
       payment_date,
       last_update
FROM payment_historic
UNION ALL
SELECT payment_id,
       customer_id,
       staff_id,
       rental_id,
       amount,
       payment_date,
       last_update
FROM payment_current;

-- page 289
-- обновление простых представлений
CREATE VIEW customer_vw (
    customer_id,
    first_name,
    last_name,
    email
) AS
SELECT customer_id,
       first_name,
       last_name,
       CONCAT(SUBSTR(email, 1, 2), '*****', SUBSTR(email, -4)) email
FROM customer;

-- 1 row affected
UPDATE customer_vw
SET last_name = 'SMITH-ALLEN'
WHERE customer_id = 1;

-- 1 row retrieved
SELECT first_name, last_name, email
FROM customer
WHERE customer_id = 1;

-- [HY000][1348] Column 'email' is not updatable
-- Столбец 'email' является необновляемым
UPDATE customer_vw
SET email = 'MARY.SMITH-ALLEN@sakilacustomer.org'
WHERE customer_id = 1;

-- page 290
-- [HY000][1471] The target table customer_vw of the INSERT is not insertable-into
-- Целевая таблица customer_vw инструкции INSERT не допускает вставку
INSERT INTO customer_vw (customer_id,
                         first_name,
                         last_name)
VALUES (99999,
        'ROBERT',
        'SIMPSON');

-- обновление сложных представлений
CREATE VIEW customer_details AS
SELECT c.customer_id,
       c.store_id,
       c.first_name,
       c.last_name,
       c.address_id,
       c.active,
       c.create_date,
       a.address,
       ct.city,
       cn.country,
       a.postal_code
FROM customer c
    INNER JOIN address a
        ON a.address_id = c.address_id
    INNER JOIN city ct
        ON ct.city_id = a.city_id
    INNER JOIN country cn
        ON cn.country_id = ct.country_id;

-- 599 rows retrieved
SELECT *
FROM customer_details;

-- page 291
-- 1 row affected
UPDATE customer_details
SET last_name = 'SMITH-ALLEN',
    active = 0
WHERE customer_id = 1;

-- 1 row affected
UPDATE customer_details
SET address = '999 Mockingbird Lane'
WHERE customer_id = 1;

-- [HY000][1393] Can not modify more than one base table
-- through a join view 'sakila.customer_details'
-- Невозможно изменить более одной базовой таблицы
-- с помощью соединяющего представления 'sakila.customer_details'
UPDATE customer_details
SET last_name = 'SMITH-ALLEN',
    active = 0,
    address = '999 Mockingbird Lane'
WHERE customer_id = 1;

-- page 292
-- 1 row affected
INSERT INTO customer_details (customer_id,
                              store_id,
                              first_name,
                              last_name,
                              address_id,
                              active,
                              create_date)
VALUES (9998,
        1,
        'BRIAN',
        'SALAZAR',
        5,
        1,
        NOW());

-- [HY000][1393] Can not modify more than one base table
-- through a join view 'sakila.customer_details'
-- Невозможно изменить более одной базовой таблицы
-- с помощью соединяющего представления 'sakila.customer_details'
INSERT INTO customer_details (customer_id,
                              store_id,
                              first_name,
                              last_name,
                              address_id,
                              active,
                              create_date,
                              address)
VALUES (9999,
        2,
        'THOMAS',
        'BISHOP',
        7,
        1,
        NOW(),
        '999 Mockingbird Lane');

-- exercise 14.1
CREATE VIEW film_ctgry_actor (
    title,
    category_name,
    first_name,
    last_name
) AS
SELECT f.title,
       c.name,
       a.first_name,
       a.last_name
FROM film f
    INNER JOIN film_category fc
        ON fc.film_id = f.film_id
    INNER JOIN category c
        ON c.category_id = fc.category_id
    INNER JOIN film_actor fa
        ON fa.film_id = f.film_id
    INNER JOIN actor a
        ON a.actor_id = fa.actor_id;

-- 40 rows retrieved
SELECT title, category_name, first_name, last_name
FROM film_ctgry_actor
WHERE last_name = 'FAWCETT';

-- exercise 14.2
CREATE VIEW payments_by_country AS
SELECT cn.country,
       (SELECT SUM(p.amount)
        FROM payment p
            INNER JOIN customer c
                ON c.customer_id = p.customer_id
            INNER JOIN address a
                ON a.address_id = c.address_id
            INNER JOIN city ct
                ON ct.city_id = a.city_id
            WHERE ct.country_id = cn.country_id) total_payments
FROM country cn;

-- 109 rows retrieved
SELECT country, total_payments
FROM payments_by_country;
