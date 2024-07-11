-- Метаданные
-- Данные о данных
-- page 297
-- information_schema
SELECT TABLE_NAME, TABLE_TYPE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'sakila'
ORDER BY 1;

SELECT TABLE_NAME, TABLE_TYPE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'sakila'
    AND TABLE_TYPE = 'BASE TABLE'
ORDER BY 1;

-- page 298
-- получение информации о представлениях
SELECT TABLE_NAME, IS_UPDATABLE
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = 'sakila'
ORDER BY 1;

-- 13 rows retrieved
-- получение информации о столбцах
SELECT COLUMN_NAME,
       DATA_TYPE,
       CHARACTER_MAXIMUM_LENGTH char_max_len,
       NUMERIC_PRECISION num_prcsn,
       NUMERIC_SCALE num_scale
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'sakila' AND TABLE_NAME = 'film'
ORDER BY ORDINAL_POSITION;

-- page 299
-- получение информации об индексах таблицы
-- 7 rows retrieved
SELECT INDEX_NAME,
       NON_UNIQUE,
       SEQ_IN_INDEX,
       COLUMN_NAME
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'sakila' AND TABLE_NAME = 'rental'
ORDER BY 1, 3;

-- page 300
-- получение информации об ограничениях
SELECT CONSTRAINT_NAME,
       TABLE_NAME,
       CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'sakila'
ORDER BY 3, 1;

-- page 302
-- работа с метаданными
CREATE TABLE category (
    category_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(25) NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- page 303
-- сценарии генерации схемы
SELECT 'CREATE TABLE category (' create_table_statement
UNION ALL
SELECT cols.txt
FROM (
    SELECT CONCAT(' ', COLUMN_NAME, ' ', COLUMN_TYPE,
        CASE
            WHEN IS_NULLABLE = 'NO'
                THEN ' NOT NULL'
            ELSE ''
        END,
        CASE
            WHEN EXTRA IS NOT NULL AND EXTRA LIKE 'DEFAULT_GENERATED%'
                THEN CONCAT(' DEFAULT ', COLUMN_DEFAULT, SUBSTR(EXTRA, 18))
            WHEN EXTRA IS NOT NULL THEN CONCAT(' ', EXTRA)
            ELSE ''
        END,
        ',') txt
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'sakila' AND TABLE_NAME = 'category'
    ORDER BY ORDINAL_POSITION
     ) cols
UNION ALL
SELECT CONCAT(' constraint primary key (')
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'sakila' AND TABLE_NAME = 'category'
    AND CONSTRAINT_TYPE = 'PRIMARY KEY'
UNION ALL
SELECT cols.txt
FROM (
    SELECT CONCAT(
        CASE
            WHEN ORDINAL_POSITION > 1
                THEN ' ,'
            ELSE ' '
        END,
        COLUMN_NAME) txt
    FROM information_schema.KEY_COLUMN_USAGE
    WHERE TABLE_SCHEMA = 'sakila' AND TABLE_NAME = 'category'
        AND CONSTRAINT_NAME = 'PRIMARY'
    ORDER BY ORDINAL_POSITION
     ) cols
UNION ALL
SELECT ' )'
UNION ALL
SELECT ')';

-- page 305
-- проверка базы данных
-- 16 rows retrieved
SELECT tbl.TABLE_NAME,
       (SELECT COUNT(*)
        FROM information_schema.COLUMNS clm
        WHERE clm.TABLE_SCHEMA = tbl.TABLE_SCHEMA
            AND clm.TABLE_NAME = tbl.TABLE_NAME) num_columns,
       (SELECT COUNT(*)
        FROM information_schema.STATISTICS sta
        WHERE sta.TABLE_SCHEMA = tbl.TABLE_SCHEMA
            AND sta.TABLE_NAME = tbl.TABLE_NAME) num_indexes,
        (SELECT COUNT(*)
         FROM information_schema.TABLE_CONSTRAINTS tc
         WHERE tc.TABLE_SCHEMA = tbl.TABLE_SCHEMA
            AND tc.TABLE_NAME = tbl.TABLE_NAME
            AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY') num_primary_keys
FROM information_schema.TABLES tbl
WHERE tbl.TABLE_SCHEMA = 'sakila' AND tbl.TABLE_TYPE = 'BASE TABLE'
ORDER BY 1;

-- page 307
-- динамическая генерация SQL
SET @qry = 'SELECT customer_id, first_name, last_name FROM customer';

PREPARE dynsql1 FROM @qry;

EXECUTE dynsql1;

DEALLOCATE PREPARE dynsql1;

-- использование заполнителей (символ ? в конце инструкции)
SET @qry = 'SELECT customer_id, first_name, last_name FROM customer WHERE customer_id = ?';

PREPARE dynsql2 FROM @qry;

SET @custid = 9;

EXECUTE dynsql2 USING @custid;

SET @custid = 145;

EXECUTE dynsql2 USING @custid;

DEALLOCATE PREPARE dynsql2;

-- page 308-310
SELECT CONCAT('SELECT ',
    CONCAT_WS(',',
        cols.col1,
        cols.col2,
        cols.col3,
        cols.col4,
        cols.col5,
        cols.col6,
        cols.col7,
        cols.col8,
        cols.col9),
    ' FROM customer WHERE customer_id = ?')
INTO @qry
FROM
    (SELECT
         MAX(
             CASE
                 WHEN ORDINAL_POSITION = 1
                     THEN COLUMN_NAME
                 ELSE NULL
             END) col1,
         MAX(
             CASE
                 WHEN ORDINAL_POSITION = 2
                     THEN COLUMN_NAME
                 ELSE NULL
             END) col2,
         MAX(
             CASE
                 WHEN ORDINAL_POSITION = 3
                     THEN COLUMN_NAME
                 ELSE NULL
             END) col3,
         MAX(
             CASE
                 WHEN ORDINAL_POSITION = 4
                     THEN COLUMN_NAME
                 ELSE NULL
             END) col4,
         MAX(
             CASE
                 WHEN ORDINAL_POSITION = 5
                     THEN COLUMN_NAME
                 ELSE NULL
             END) col5,
         MAX(
             CASE
                 WHEN ORDINAL_POSITION = 6
                     THEN COLUMN_NAME
                 ELSE NULL
             END) col6,
         MAX(
             CASE
                 WHEN ORDINAL_POSITION = 7
                     THEN COLUMN_NAME
                 ELSE NULL
             END) col7,
         MAX(
             CASE
                 WHEN ORDINAL_POSITION = 8
                     THEN COLUMN_NAME
                 ELSE NULL
             END) col8,
         MAX(
             CASE
                 WHEN ORDINAL_POSITION = 9
                     THEN COLUMN_NAME
                 ELSE NULL
             END) col9
     FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = 'sakila' AND TABLE_NAME = 'customer'
     GROUP BY TABLE_NAME
) cols;

SELECT @qry;

PREPARE dynsql3 FROM @qry;

SET @custid = 45;

EXECUTE dynsql3 USING @custid;

DEALLOCATE PREPARE dynsql3;

-- exercise 15.1
SELECT INDEX_NAME, TABLE_NAME
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'sakila'
ORDER BY INDEX_NAME;

-- exercise 15.2
SELECT 'ALTER TABLE customer'
UNION ALL
SELECT CONCAT(
    'ADD INDEX ',
    st.INDEX_NAME,
    ' (',
    GROUP_CONCAT(st.COLUMN_NAME SEPARATOR ', '),
    '),'
    ) txt
FROM information_schema.STATISTICS st
WHERE st.TABLE_SCHEMA = 'sakila'
  AND st.TABLE_NAME = 'customer'
GROUP BY st.INDEX_NAME;

-- решение из книги
WITH idx_info AS (SELECT s1.TABLE_NAME,
                         s1.INDEX_NAME,
                         s1.COLUMN_NAME,
                         s1.SEQ_IN_INDEX,
                         (SELECT MAX(s2.SEQ_IN_INDEX)
                          FROM information_schema.STATISTICS s2
                          WHERE s2.TABLE_SCHEMA = s1.TABLE_SCHEMA
                            AND s2.TABLE_NAME = s1.TABLE_NAME
                            AND s2.INDEX_NAME = s1.INDEX_NAME) num_columns
                  FROM information_schema.STATISTICS s1
                  WHERE s1.TABLE_SCHEMA = 'sakila' AND s1.TABLE_NAME = 'customer'
)
SELECT CONCAT(
    CASE
        WHEN SEQ_IN_INDEX = 1
            THEN CONCAT(
                'ALTER TABLE ',
                TABLE_NAME,
                ' ADD INDEX ',
                INDEX_NAME,
                ' (',
                COLUMN_NAME)
        ELSE CONCAT(' , ', COLUMN_NAME)
    END,
    CASE
        WHEN SEQ_IN_INDEX = num_columns THEN ');'
        ELSE ''
    END
    ) index_creation_statement
FROM idx_info
ORDER BY INDEX_NAME, SEQ_IN_INDEX;
