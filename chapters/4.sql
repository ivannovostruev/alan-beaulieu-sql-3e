-- page 95
-- условия равенства
SELECT c.email
FROM customer c
    INNER JOIN rental r
        ON r.customer_id = c.customer_id
WHERE DATE(r.rental_date) = '2005-06-14';

-- page 96
-- условия неравенства
SELECT c.email
FROM customer c
    INNER JOIN rental r
        ON r.customer_id = c.customer_id
WHERE DATE(r.rental_date) <> '2005-06-14';

-- альтернативное решение
-- использование оператора != вместо оператора <>
SELECT c.email
FROM customer c
    INNER JOIN rental r
        ON r.customer_id = c.customer_id
WHERE DATE(r.rental_date) != '2005-06-14';

-- page 97
-- модификация данных с использованием условий равенства
DELETE FROM rental
WHERE YEAR(rental_date) = 2004;

-- удаление любых строк, срок аренды которых не соответствует на 2005, ни 2006 году
DELETE FROM rental
WHERE YEAR(rental_date) <> 2005
  AND YEAR(rental_date) <> 2006;

-- page 98
-- условия диапазона
-- !!!
-- В УСЛОВИИ ДАТА УКАЗАНА В ВИДЕ СТРОКИ '2005-05-25'
-- И ЧТОБЫ СРАВНИТЬ 2 ДАТЫ
-- СЕРВЕР MYSQL АВТОМАТИЧЕСКИ ПРИВЁЛ ЭТУ СТРОКУ К ТИПУ ДАННЫХ DATETIME!!!
-- смотри стр 47
-- !!!
SELECT customer_id, rental_date
FROM rental
WHERE rental_date < '2005-05-25';

SELECT customer_id, rental_date
FROM rental
WHERE rental_date <= '2005-06-16'
    AND rental_date >= '2005-06-14';

-- page 99
-- оператор BETWEEN
-- 364 rows retrieved
SELECT customer_id, rental_date
FROM rental
WHERE rental_date BETWEEN '2005-06-14' AND '2005-06-16';

-- неверный диапазон в операторе BETWEEN
-- вначале нужно указывать нижнюю границу диапазона!!!
-- 0 rows retrieved
SELECT customer_id, rental_date
FROM rental
WHERE rental_date BETWEEN '2005-06-16' AND '2005-06-14';

-- вышеприведенная инструкция равнозначна следующей
-- 0 rows retrieved
SELECT customer_id, rental_date
FROM rental
WHERE rental_date >= '2005-06-16'
    AND rental_date <= '2005-06-14';

-- page 100
-- 114 rows retrieved
SELECT customer_id, payment_date, amount
FROM payment
WHERE amount BETWEEN 10.0 AND 11.99;

-- строковые диапазоны
-- FRANKLIN находится за пределами диапазона
-- 18 rows retrieved
SELECT last_name, first_name
FROM customer
WHERE last_name BETWEEN 'FA' AND 'FR';

-- расширение диапазона вправо
-- 22 rows retrieved
SELECT last_name, first_name
FROM customer
WHERE last_name BETWEEN 'FA' AND 'FRB';

-- page 102
-- условия членства
-- 372 rows retrieved
SELECT title, rating
FROM film
WHERE rating = 'G' OR rating = 'PG';

-- page 103
-- использование оператора IN
-- 372 rows retrieved
SELECT title, rating
FROM film
WHERE rating IN ('G', 'PG');

-- использование подзапросов
-- 372 rows retrieved
SELECT title, rating
FROM film
WHERE rating IN (SELECT rating
                 FROM film
                 WHERE title LIKE '%PET%');

-- page 104
-- использование NOT IN
-- 372 rows retrieved
SELECT title, rating
FROM film
WHERE rating NOT IN ('PG-13', 'R', 'NC-17');

-- условия соответствия
-- 3 rows retrieved
SELECT last_name, first_name
FROM customer
WHERE LEFT(last_name, 1) = 'Q';

-- page 105
-- использование оператора LIKE для создания условий, которые используют поисковые выражения
-- 3 rows retrieved
SELECT last_name, first_name
FROM customer
WHERE last_name LIKE '_A_T%S';

-- page 106
-- использование нескольких поисковых выражений
-- 6 rows retrieved
SELECT last_name, first_name
FROM customer
WHERE last_name LIKE 'Q%' OR last_name LIKE 'Y%';

-- использование регулярных выражений
-- 6 rows retrieved
SELECT last_name, first_name
FROM customer
WHERE last_name REGEXP '^[QY]';

-- page 108
-- использование оператора IS NULL
-- поиск всех фильмов, взятых напрокат, которые не были возвращены
-- 183 rows retrieved
SELECT rental_id, customer_id
FROM rental
WHERE return_date IS NULL;

-- !!!
-- некорректное использование оператора "=" для сравнения с NULL
-- !!!
-- 0 rows retrieved
SELECT rental_id, customer_id
FROM rental
WHERE return_date = NULL;

-- использование оператора IS NOT NULL
-- 15861 rows retrieved
SELECT rental_id, customer_id, return_date
FROM rental
WHERE return_date IS NOT NULL;

-- page 109
-- 62 rows retrieved
SELECT rental_id, customer_id, return_date
FROM rental
WHERE return_date NOT BETWEEN '2005-05-01' AND '2005-09-01';

-- page 110
-- 245 rows retrieved
SELECT rental_id, customer_id, return_date
FROM rental
WHERE return_date IS NULL
    OR return_date NOT BETWEEN '2005-05-01' AND '2005-09-01';

















