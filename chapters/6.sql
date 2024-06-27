-- page 132
-- теория множеств на практике
DESC customer;

DESC city;

-- page 133
-- 2 rows retrieved
SELECT 1 num, 'abc' str
UNION
SELECT 9 num, 'xyz' str;

-- page 134
-- оператор UNION ALL
-- при использовании оператора UNION ALL
-- количество строк в окончательном наборе данных
-- всегда будет равно сумме количеств строк в объединяемых наборах данных
-- 799 rows retrieved
SELECT 'CUST' typ, c.first_name, c.last_name
FROM customer c
UNION ALL
SELECT 'ACTR' typ, a.first_name, a.last_name
FROM actor a;

-- page 135
-- 400 rows retrieved
SELECT 'ACTR' typ, a.first_name, a.last_name
FROM actor a
UNION ALL
SELECT 'ACTR' typ, a.first_name, a.last_name
FROM actor a;

-- 200 rows retrieved starting
SELECT 'ACTR' typ, a.first_name, a.last_name
FROM actor a
ORDER BY first_name, last_name;

-- поиск дубликатов
-- 1 row retrieved starting
-- first_name = SUSAN, last_name = DAVIS
SELECT first_name, last_name
FROM actor
GROUP BY first_name, last_name
HAVING COUNT(*) > 1;

-- 199 rows retrieved starting
-- SUSAN DAVIS встречается дважды в таблице actor!!!
SELECT 'ACTR' typ, a.first_name, a.last_name
FROM actor a
UNION
SELECT 'ACTR' typ, a.first_name, a.last_name
FROM actor a;

-- page 136
-- 5 rows retrieved starting
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
UNION ALL
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';

-- оператор UNION
-- сортирует объединяемый набор и удаляет дубликаты
-- 4 rows retrieved
-- из результирующего набора исключены повторяющиеся строки
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
UNION
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';

-- page 140
-- сортировка результатов составного запроса
-- рекомендуется давать столбцам в обоих запросах одинаковые псевдонимы столбцов
-- 5 rows retrieved
SELECT a.first_name fname, a.last_name lname
FROM actor a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
UNION ALL
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
ORDER BY lname, fname;

-- [42S22][1054] Unknown column 'last_name' in 'order clause'
SELECT a.first_name fname, a.last_name lname
FROM actor a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
UNION ALL
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
ORDER BY last_name, first_name;

-- page 141
-- приоритеты операций над множествами
-- 6 rows retrieved
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
UNION ALL
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'M%' AND a.last_name LIKE 'T%'
UNION
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%';

-- 7 rows retrieved
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
UNION
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'M%' AND a.last_name LIKE 'T%'
UNION ALL
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%';

-- exercise 6.1
-- A = {L,M,N,O,P}
-- B = {P,Q,R,S,T}
-- A union B = {L,M,N,O,P,Q,R,S,T}
-- A union all B = {L,M,N,O,P,P,Q,R,S,T}
-- A intersect B = {P}
-- A except B = {L,M,N,O}

-- exercise 6.2
-- 24 rows retrieved
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.last_name LIKE 'L%'
UNION ALL
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.last_name LIKE 'L%';

-- альтернативный вариант
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE 'L%'
UNION ALL
SELECT first_name, last_name
FROM customer
WHERE last_name LIKE 'L%';

-- exercise 6.3
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE 'L%'
UNION ALL
SELECT first_name, last_name
FROM customer
WHERE last_name LIKE 'L%'
ORDER BY last_name;
