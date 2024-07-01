-- page 179
-- 16044 rows retrieved
SELECT customer_id
FROM rental;

-- page 180
-- использование предложения GROUP BY для группировки данных
-- 599 rows retrieved
SELECT customer_id
FROM rental
GROUP BY customer_id;

-- использование агрегатной функции COUNT()
-- для подсчёта количества строк в каждой группе
-- 599 rows retrieved
SELECT customer_id, COUNT(*)
FROM rental
GROUP BY customer_id;

-- page 181
-- сортировка по убыванию количества взятых напрокат фильмов
SELECT customer_id, COUNT(*)
FROM rental
GROUP BY customer_id
ORDER BY 2 DESC;

-- page 182
-- неверное применение групповой функции
-- [HY000][1111] Invalid use of group function
-- при вычислении предложения WHERE группы ещё не были сгенерированы
SELECT customer_id, COUNT(*)
FROM rental
WHERE COUNT(*) >= 40
GROUP BY customer_id;

-- предложение HAVING для фильтрации по группам
-- 7 rows retrieved
SELECT customer_id, COUNT(*)
FROM rental
GROUP BY customer_id
HAVING COUNT(*) >= 40;

-- page 183
-- Агрегатные (итоговые, групповые) функции
-- 5 агрегатных функций
-- MAX()
-- MIN()
-- AVG()
-- SUM()
-- COUNT()
-- 1 row retrieved
SELECT MAX(amount) max_amt,
       MIN(amount) min_amt,
       AVG(amount) avg_amt,
       SUM(amount) total_amt,
       COUNT(*) number_payments
FROM payment;

-- page 184
-- [42000][1140] In aggregated query without GROUP BY,
-- expression #1 of SELECT list contains nonaggregated column 'sakila.payment.customer_id';
-- this is incompatible with sql_mode=only_full_group_by
-- В агрегированном запросе без GROUP BY выражение №1 списка SELECT
-- содержит неагрегированный столбец
SELECT customer_id,
       MAX(amount) max_amt,
       MIN(amount) min_amt,
       AVG(amount) avg_amt,
       SUM(amount) total_amt,
       COUNT(*) number_payments
FROM payment;

-- предложение GROUP BY указывает, к какой группе строк
-- следует применять агрегатные функции
-- 599 rows retrieved
SELECT customer_id,
       MAX(amount) max_amt,
       MIN(amount) min_amt,
       AVG(amount) avg_amt,
       SUM(amount) total_amt,
       COUNT(*) number_payments
FROM payment
GROUP BY customer_id;

-- page 185
-- 1 row retrieved
SELECT COUNT(customer_id) number_rows,
       COUNT(DISTINCT customer_id) number_customers
FROM payment;

-- page 186
-- использование выражений
SELECT MAX(DATEDIFF(return_date, rental_date))
FROM rental;

-- обработка значений NULL
CREATE TABLE number_table
(
    val SMALLINT
);

-- 3 rows affected
INSERT INTO number_table (val)
VALUES (1),
       (3),
       (5);

-- 3 rows retrieved
SELECT *
FROM number_table;

-- page 187
-- 1 row retrieved
SELECT COUNT(*) num_rows,
       COUNT(val) num_vals,
       SUM(val) total,
       MAX(val) max_val,
       AVG(val) avg_val
FROM number_table;

-- 1 row affected
INSERT INTO number_table
VALUES (NULL);

-- 4 rows retrieved
SELECT *
FROM number_table;

-- 1 row retrieved
SELECT COUNT(*) num_rows,
       COUNT(val) num_vals,
       SUM(val) total,
       MAX(val) max_val,
       AVG(val) avg_val
FROM number_table;

-- page 188
-- группировка по одному столбцу
-- 200 rows retrieved
SELECT actor_id, COUNT(*)
FROM film_actor
GROUP BY actor_id;

-- мой эксперимент
SELECT actor_id, COUNT(*) films
FROM film_actor
GROUP BY actor_id;

-- мой эксперимент
SELECT fa.actor_id,
       CONCAT(a.first_name, ' ', a.last_name) AS full_name,
       COUNT(*) AS films
FROM film_actor AS fa
    INNER JOIN actor AS a
        ON a.actor_id = fa.actor_id
GROUP BY actor_id;

-- мой эксперимент
SELECT fa.actor_id,
       CONCAT(a.first_name, ' ', a.last_name) AS full_name,
       COUNT(*) AS films
FROM film_actor AS fa
INNER JOIN actor AS a
    ON a.actor_id = fa.actor_id
GROUP BY actor_id
ORDER BY COUNT(*) DESC;

-- page 189
-- многостолбцовая группировка
-- 996 rows retrieved
SELECT fa.actor_id, f.rating, COUNT(*)
FROM film_actor fa
    INNER JOIN film f
        ON f.film_id = fa.film_id
GROUP BY fa.actor_id, f.rating
ORDER BY 1, 2;

-- page 190
-- группировка с помощью выражений
-- 2 rows retrieved
SELECT EXTRACT(YEAR FROM rental_date) year,
       COUNT(*) how_many
FROM rental
GROUP BY EXTRACT(YEAR FROM rental_date);

-- page 191
-- генерация итоговых данных
-- использование конструкции WITH ROLLUP
-- 1197 rows retrieved
SELECT fa.actor_id, f.rating, COUNT(*)
FROM film_actor fa
    INNER JOIN film f
        ON f.film_id = fa.film_id
GROUP BY fa.actor_id, f.rating WITH ROLLUP
ORDER BY 1, 2;

-- page 192
-- условия группового фильтра
-- !!!
-- Using aggregate-free condition(s) in HAVING clause
-- might be inefficient. Consider moving them to WHERE
-- !!!
-- 16 rows retrieved
SELECT fa.actor_id, f.rating, COUNT(*)
FROM film_actor fa
    INNER JOIN film f
        ON f.film_id = fa.film_id
WHERE f.rating IN ('G', 'PG')
GROUP BY fa.actor_id, f.rating
HAVING COUNT(*) > 9;

-- page 193
-- [HY000][1111] Invalid use of group function
-- неверное применение групповой функции
-- Этот запрос не работает,
-- потому что нельзя включать агрегатную функцию в предложение WHERE,
-- так как фильтры в предложении WHERE вычисляются до группировки,
-- поэтому сервер ещё не в состоянии выполнить какие-либо функции для групп
SELECT fa.actor_id, f.rating, COUNT(*)
FROM film_actor fa
    INNER JOIN film f
        ON f.film_id = fa.film_id
WHERE f.rating IN ('G', 'PG')
    AND COUNT(*) > 9
GROUP BY fa.actor_id, f.rating;

-- exercise 8.1
-- 1 rows retrieved
-- вернёт значение = 16044
SELECT COUNT(*) num_rows
FROM payment;

-- exercise 8.2
-- 599 rows retrieved
SELECT customer_id,
       COUNT(*) payments,
       SUM(amount) total
FROM payment
GROUP BY customer_id;

-- exercise 8.3
-- 7 rows retrieved
SELECT customer_id,
       COUNT(*) payments,
       SUM(amount) total
FROM payment
GROUP BY customer_id
HAVING COUNT(*) >= 40;
