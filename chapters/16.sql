-- Аналитические функции
-- page 312
-- окна данных
-- 4 rows retrieved
SELECT QUARTER(payment_date) quarter,
       MONTHNAME(payment_date) month_name,
       SUM(amount) monthly_sales
FROM payment
WHERE YEAR(payment_date) = 2005
GROUP BY QUARTER(payment_date), MONTHNAME(payment_date);

-- 4 rows retrieved
SELECT QUARTER(payment_date) quarter,
       MONTHNAME(payment_date) month_name,
       SUM(amount) monthly_sales,
       MAX(SUM(amount))
           OVER () max_overall_sales,
       MAX(SUM(amount))
           OVER (PARTITION BY QUARTER(payment_date)) max_quarter_sales
FROM payment
WHERE YEAR(payment_date) = 2005
GROUP BY QUARTER(payment_date), MONTHNAME(payment_date);

-- page 313
-- локализованная сортировка
-- !!!
-- ОШИБКА: [42000][1055]
-- [42000][1055] Expression #2 of ORDER BY clause is not in GROUP BY clause and contains nonaggregated column 'sakila.payment.payment_date' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by
-- РЕШЕНИЕ:
-- Disable ONLY_FULL_GROUP_BY
-- https://stackoverflow.com/questions/23921117/disable-only-full-group-by
-- ВВЕСТИ КОМАНДУ:
-- SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''))
-- ПОСМОТРЕТЬ РЕЗУЛЬТАТ:
-- SELECT @@sql_mode
-- !!!
-- https://johnemb.blogspot.com/2014/09/adding-or-removing-individual-sql-modes.html
-- 4 rows retrieved
SELECT QUARTER(payment_date) quarter,
       MONTHNAME(payment_date) month_name,
       SUM(amount) monthly_sales,
       RANK()
           OVER (ORDER BY SUM(amount) DESC) sales_rank
FROM payment
WHERE YEAR(payment_date) = 2005
GROUP BY QUARTER(payment_date), MONTHNAME(payment_date)
ORDER BY 1, MONTH(payment_date);

-- page 314
-- множественные предложения ORDER BY
-- 4 rows retrieved
SELECT QUARTER(payment_date) quarter,
       MONTHNAME(payment_date) month_name,
       SUM(amount) monthly_sales,
       RANK()
           OVER (PARTITION BY QUARTER(payment_date)
               ORDER BY SUM(amount) DESC) quarter_sales_rank
FROM payment
WHERE YEAR(payment_date) = 2005
GROUP BY QUARTER(payment_date), MONTHNAME(payment_date)
ORDER BY 1, MONTH(payment_date);

-- page 316
-- ранжирование
-- 599 rows retrieved
SELECT customer_id,
       COUNT(*) num_rentals
FROM rental
GROUP BY customer_id
ORDER BY 2 DESC;

-- page 317
SELECT customer_id,
       COUNT(*) num_rentals,
       ROW_NUMBER()
           OVER (ORDER BY COUNT(*) DESC) row_number_rnk,
       RANK()
           OVER (ORDER BY COUNT(*) DESC) rank_rnk,
       DENSE_RANK()
           OVER (ORDER BY COUNT(*) DESC) dense_rank_rnk
FROM rental
GROUP BY customer_id
ORDER BY 2 DESC;

-- page 319
-- генерация нескольких рейтингов
-- 2466 rows retrieved
SELECT customer_id,
       MONTHNAME(rental_date) rental_month,
       COUNT(*) num_rentals
FROM rental
GROUP BY customer_id, MONTHNAME(rental_date)
ORDER BY 2, 3 DESC;

-- page 320
SELECT customer_id,
       MONTHNAME(rental_date) rental_month,
       COUNT(*) num_rentals,
       RANK()
           OVER (PARTITION BY MONTHNAME(rental_date)
               ORDER BY COUNT(*) DESC) rank_rnk
FROM rental
GROUP BY customer_id, MONTHNAME(rental_date)
ORDER BY 2, 3 DESC;

-- page 321
SELECT customer_id,
       rental_month,
       num_rentals,
       rank_rnk ranking
FROM
    (SELECT customer_id,
            MONTHNAME(rental_date) rental_month,
            COUNT(*) num_rentals,
            RANK()
                OVER (PARTITION BY MONTHNAME(rental_date)
                    ORDER BY COUNT(*) DESC) rank_rnk
     FROM rental
     GROUP BY customer_id, MONTHNAME(rental_date)
     ) cust_rankings
WHERE rank_rnk <= 5
ORDER BY rental_month, num_rentals DESC, rank_rnk;

-- page 322
-- функции отчётности
-- 114 rows retrieved
SELECT MONTHNAME(payment_date) payment_month,
       amount,
       SUM(amount) OVER (PARTITION BY MONTHNAME(payment_date)) monthly_total,
       SUM(amount) OVER () grand_total
FROM payment
WHERE amount >= 10
ORDER BY 1;

-- page 323
-- 5 rows retrieved
SELECT MONTHNAME(payment_date) payment_month,
       SUM(amount) month_total,
       ROUND(SUM(amount) / SUM(SUM(amount))
           OVER () * 100, 2) percent_of_total
FROM payment
GROUP BY MONTHNAME(payment_date);

-- 5 rows retrieved
SELECT MONTHNAME(payment_date) payment_month,
       SUM(amount) month_total,
       CASE SUM(amount)
           WHEN MAX(SUM(amount)) OVER () THEN 'Highest'
           WHEN MIN(SUM(amount)) OVER () THEN 'Lowest'
           ELSE 'Middle'
       END descriptor
FROM payment
GROUP BY MONTHNAME(payment_date);

-- page 324
-- рамки окон
-- 11 rows retrieved
SELECT YEARWEEK(payment_date) payment_week,
       SUM(amount) week_total,
       SUM(SUM(amount)) OVER (ORDER BY YEARWEEK(payment_date)
           ROWS UNBOUNDED PRECEDING) rolling_sum
FROM payment
GROUP BY YEARWEEK(payment_date)
ORDER BY 1;

-- 11 rows retrieved
SELECT YEARWEEK(payment_date) payment_week,
       SUM(amount) week_total,
       AVG(SUM(amount)) OVER (ORDER BY YEARWEEK(payment_date)
           ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) rolling_3week_avg
FROM payment
GROUP BY YEARWEEK(payment_date)
ORDER BY 1;

-- page 326
SELECT DATE(payment_date),
       SUM(amount),
       AVG(SUM(amount)) OVER (ORDER BY DATE(payment_date)
           RANGE BETWEEN INTERVAL 3 DAY PRECEDING
           AND INTERVAL 3 DAY FOLLOWING) 7_day_avg
FROM payment
WHERE payment_date BETWEEN '2005-07-01' AND '2005-09-01'
GROUP BY DATE(payment_date)
ORDER BY 1;

-- page 327
-- запаздывание и опережение
-- 11 rows retrieved
SELECT YEARWEEK(payment_date) payment_week,
       SUM(amount) week_total,
       LAG(SUM(amount), 1)
           OVER (ORDER BY YEARWEEK(payment_date)) prev_week_total,
       LEAD(SUM(amount), 1)
           OVER (ORDER BY YEARWEEK(payment_date)) next_week_total
FROM payment
GROUP BY YEARWEEK(payment_date)
ORDER BY 1;

-- page 328
-- 11 rows retrieved
SELECT YEARWEEK(payment_date) payment_week,
       SUM(amount) week_total,
       ROUND((SUM(amount) - LAG(SUM(amount), 1)
           OVER (ORDER BY YEARWEEK(payment_date)))
           / LAG(SUM(amount), 1)
               OVER (ORDER BY YEARWEEK(payment_date))
           * 100, 1) percent_diff
FROM payment
GROUP BY YEARWEEK(payment_date)
ORDER BY 1;

-- page 329
-- конкатенация значений в столбце
-- 119 rows retrieved
SELECT f.title,
       GROUP_CONCAT(a.last_name ORDER BY a.last_name
           SEPARATOR ', ') actors
FROM actor a
    INNER JOIN film_actor fa
        ON fa.actor_id = a.actor_id
    INNER JOIN film f
        ON f.film_id = fa.film_id
GROUP BY f.title
HAVING COUNT(*) = 3;

-- exercise 16.1
SELECT year_no,
       month_no,
       tot_sales,
       RANK() OVER (ORDER BY tot_sales DESC) sales_rank
FROM sales_fact;

-- exercise 16.2
SELECT year_no,
       month_no,
       tot_sales,
       RANK() OVER (PARTITION BY year_no
           ORDER BY tot_sales DESC) sales_rank
FROM sales_fact;

-- exercise 16.3
SELECT year_no,
       month_no,
       tot_sales,
       LAG(tot_sales, 1) OVER (ORDER BY month_no) prev_month_total
FROM sales_fact
WHERE year_no = 2020;
