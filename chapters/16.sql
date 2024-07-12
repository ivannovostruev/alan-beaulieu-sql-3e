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


































