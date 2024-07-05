-- Соединения
-- page 223
-- 958 rows retrieved
SELECT f.film_id,
       f.title,
       COUNT(*) num_copies
FROM film f
    INNER JOIN inventory i
        ON i.film_id = f.film_id
GROUP BY f.film_id, f.title;

-- page 224
-- 1000 rows retrieved
SELECT f.film_id, f.title, COUNT(i.inventory_id) num_copies
FROM film f
    LEFT OUTER JOIN inventory i
        ON i.film_id = f.film_id
GROUP BY f.film_id, f.title;

-- page 225
-- 10 rows retrieved
SELECT f.film_id, f.title, i.inventory_id
FROM film f
    INNER JOIN inventory i
        ON i.film_id = f.film_id
WHERE f.film_id BETWEEN 13 AND 15;

-- 11 rows retrieved
SELECT f.film_id, f.title, i.inventory_id
FROM film f
    LEFT OUTER JOIN inventory i
        ON i.film_id = f.film_id
WHERE f.film_id BETWEEN 13 AND 15;

-- page 226
-- 11 rows retrieved
SELECT f.film_id, f.title, i.inventory_id
FROM inventory i
    RIGHT OUTER JOIN film f
        ON f.film_id = i.film_id
WHERE f.film_id BETWEEN 13 AND 15;

-- page 227
-- 32 rows retrieved
SELECT f.film_id, f.title, i.inventory_id, r.rental_date
FROM film f
    LEFT OUTER JOIN inventory i
        ON i.film_id = f.film_id
    LEFT OUTER JOIN rental r
        ON r.inventory_id = i.inventory_id
WHERE f.film_id BETWEEN 13 AND 15;

-- page 229
-- перекрёстное соединение
-- 96 rows retrieved
SELECT c.name category_name, l.name language_name
FROM category c
    CROSS JOIN language l;

-- page 230
SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit
UNION ALL
SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit
UNION ALL
SELECT 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit;

-- page 231
-- 400 rows retrieved
SELECT ones.num + tens.num + hundreds.num
FROM
    (
        SELECT 0 num UNION ALL
        SELECT 1 num UNION ALL
        SELECT 2 num UNION ALL
        SELECT 3 num UNION ALL
        SELECT 4 num UNION ALL
        SELECT 5 num UNION ALL
        SELECT 6 num UNION ALL
        SELECT 7 num UNION ALL
        SELECT 8 num UNION ALL
        SELECT 9 num
    ) ones
    CROSS JOIN
        (
            SELECT 0 num UNION ALL
            SELECT 10 num UNION ALL
            SELECT 20 num UNION ALL
            SELECT 30 num UNION ALL
            SELECT 40 num UNION ALL
            SELECT 50 num UNION ALL
            SELECT 60 num UNION ALL
            SELECT 70 num UNION ALL
            SELECT 80 num UNION ALL
            SELECT 90 num
        ) tens
    CROSS JOIN
        (
            SELECT 0 num UNION ALL
            SELECT 100 num UNION ALL
            SELECT 200 num UNION ALL
            SELECT 300 num
        ) hundreds;

-- page 232
-- 366 rows retrieved
SELECT DATE_ADD('2020-01-01', INTERVAL (ones.num + tens.num + hundreds.num) DAY) dt
FROM
    (
        SELECT 0 num UNION ALL
        SELECT 1 num UNION ALL
        SELECT 2 num UNION ALL
        SELECT 3 num UNION ALL
        SELECT 4 num UNION ALL
        SELECT 5 num UNION ALL
        SELECT 6 num UNION ALL
        SELECT 7 num UNION ALL
        SELECT 8 num UNION ALL
        SELECT 9 num
    ) ones
        CROSS JOIN
    (
        SELECT 0 num UNION ALL
        SELECT 10 num UNION ALL
        SELECT 20 num UNION ALL
        SELECT 30 num UNION ALL
        SELECT 40 num UNION ALL
        SELECT 50 num UNION ALL
        SELECT 60 num UNION ALL
        SELECT 70 num UNION ALL
        SELECT 80 num UNION ALL
        SELECT 90 num
    ) tens
        CROSS JOIN
    (
        SELECT 0 num UNION ALL
        SELECT 100 num UNION ALL
        SELECT 200 num UNION ALL
        SELECT 300 num
    ) hundreds
WHERE DATE_ADD('2020-01-01', INTERVAL (ones.num + tens.num + hundreds.num) DAY) < '2021-01-01'
ORDER BY 1;

-- page 234
-- 365 rows retrieved
SELECT days.dt, COUNT(r.rental_id) num_rentals
FROM rental r
    RIGHT OUTER JOIN
        (
            SELECT DATE_ADD('2005-01-01', INTERVAL (ones.num + tens.num + hundreds.num) DAY) dt
            FROM
                (
                    SELECT 0 num UNION ALL
                    SELECT 1 num UNION ALL
                    SELECT 2 num UNION ALL
                    SELECT 3 num UNION ALL
                    SELECT 4 num UNION ALL
                    SELECT 5 num UNION ALL
                    SELECT 6 num UNION ALL
                    SELECT 7 num UNION ALL
                    SELECT 8 num UNION ALL
                    SELECT 9 num
                ) ones
                    CROSS JOIN
                (
                    SELECT 0 num UNION ALL
                    SELECT 10 num UNION ALL
                    SELECT 20 num UNION ALL
                    SELECT 30 num UNION ALL
                    SELECT 40 num UNION ALL
                    SELECT 50 num UNION ALL
                    SELECT 60 num UNION ALL
                    SELECT 70 num UNION ALL
                    SELECT 80 num UNION ALL
                    SELECT 90 num
                ) tens
                    CROSS JOIN
                (
                    SELECT 0 num UNION ALL
                    SELECT 100 num UNION ALL
                    SELECT 200 num UNION ALL
                    SELECT 300 num
                ) hundreds
            WHERE DATE_ADD('2005-01-01', INTERVAL (ones.num + tens.num + hundreds.num) DAY) < '2006-01-01'
        ) days
        ON days.dt = DATE(r.rental_date)
GROUP BY days.dt
ORDER BY 1;

-- page 236
-- естественные соединения
-- 0 rows retrieved
SELECT c.first_name, c.last_name, DATE(r.rental_date)
FROM customer c
    NATURAL JOIN rental r;

-- 16044 rows retrieved
SELECT cust.first_name, cust.last_name, DATE(r.rental_date)
FROM
    (
        SELECT customer_id, first_name, last_name
        FROM customer
    ) cust
    NATURAL JOIN rental r;

-- exercise 10.1
SELECT c.name, SUM(p.amount) total_payments
FROM customer c
    LEFT OUTER JOIN payment p
        ON p.customer_id = c.customer_id
GROUP BY c.customer_id;

-- exercise 10.2
SELECT c.name, SUM(p.amount) total_payments
FROM payment p
    RIGHT OUTER JOIN customer c
        ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

-- exercise 10.3
-- 100 rows retrieved
SELECT ones.num + tens.num nmbr
FROM
    (
        SELECT 1 num UNION ALL
        SELECT 2 num UNION ALL
        SELECT 3 num UNION ALL
        SELECT 4 num UNION ALL
        SELECT 5 num UNION ALL
        SELECT 6 num UNION ALL
        SELECT 7 num UNION ALL
        SELECT 8 num UNION ALL
        SELECT 9 num UNION ALL
        SELECT 10 num
    ) ones
    CROSS JOIN
        (
            SELECT 0 num UNION ALL
            SELECT 10 num UNION ALL
            SELECT 20 num UNION ALL
            SELECT 30 num UNION ALL
            SELECT 44 num UNION ALL
            SELECT 50 num UNION ALL
            SELECT 60 num UNION ALL
            SELECT 70 num UNION ALL
            SELECT 80 num UNION ALL
            SELECT 90 num
        ) tens
ORDER BY 1;


































































