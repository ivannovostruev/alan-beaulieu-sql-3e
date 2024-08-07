-- Работа с большими базами данных
-- page 334
-- Методы секционирования
-- секционирование по диапазону
CREATE TABLE sales
(
    sale_id     INT             NOT NULL,
    cust_id     INT             NOT NULL,
    store_id    INT             NOT NULL,
    sale_date   DATE            NOT NULL,
    amount      DECIMAL(9,2)
)
PARTITION BY RANGE (YEARWEEK(sale_date))
(
    PARTITION s1 VALUES LESS THAN (202002),
    PARTITION s2 VALUES LESS THAN (202003),
    PARTITION s3 VALUES LESS THAN (202004),
    PARTITION s4 VALUES LESS THAN (202005),
    PARTITION s5 VALUES LESS THAN (202006),
    PARTITION s999 VALUES LESS THAN (MAXVALUE)
);

-- page 335
SELECT PARTITION_NAME,
       PARTITION_METHOD,
       PARTITION_EXPRESSION
FROM information_schema.PARTITIONS
WHERE TABLE_NAME = 'sales'
ORDER BY PARTITION_ORDINAL_POSITION;

-- генерация новых разделов для хранения будущих данных
ALTER TABLE sales REORGANIZE PARTITION s999 INTO
(
    PARTITION s6 VALUES LESS THAN (202007),
    PARTITION s7 VALUES LESS THAN (202008),
    PARTITION s999 VALUES LESS THAN (MAXVALUE)
);

SELECT PARTITION_NAME,
       PARTITION_METHOD,
       PARTITION_EXPRESSION
FROM information_schema.PARTITIONS
WHERE TABLE_NAME = 'sales'
ORDER BY PARTITION_ORDINAL_POSITION;

-- page 336
INSERT INTO sales
VALUES (1, 1, 1, '2020-01-18', 2765.15),
       (2, 3, 4, '2020-02-07', 5322.08);

SELECT CONCAT('# of rows in S1 = ', COUNT(*)) partition_rowcount
FROM sales PARTITION (s1)
UNION ALL
SELECT CONCAT('# of rows in S2 = ', COUNT(*)) partition_rowcount
FROM sales PARTITION (s2)
UNION ALL
SELECT CONCAT('# of rows in S3 = ', COUNT(*)) partition_rowcount
FROM sales PARTITION (s3)
UNION ALL
SELECT CONCAT('# of rows in S4 = ', COUNT(*)) partition_rowcount
FROM sales PARTITION (s4)
UNION ALL
SELECT CONCAT('# of rows in S5 = ', COUNT(*)) partition_rowcount
FROM sales PARTITION (s5)
UNION ALL
SELECT CONCAT('# of rows in S6 = ', COUNT(*)) partition_rowcount
FROM sales PARTITION (s6)
UNION ALL
SELECT CONCAT('# of rows in S7 = ', COUNT(*)) partition_rowcount
FROM sales PARTITION (s7)
UNION ALL
SELECT CONCAT('# of rows in S999 = ', COUNT(*)) partition_rowcount
FROM sales PARTITION (s999);

-- page 337
-- секционирование по списку
CREATE TABLE sales
(
    sale_id         INT         NOT NULL,
    cust_id         INT         NOT NULL,
    store_id        INT         NOT NULL,
    sale_date       DATE        NOT NULL,
    geo_region_cd   VARCHAR(6)  NOT NULL,
    amount          DECIMAL(9,2)
)
PARTITION BY LIST COLUMNS (geo_region_cd)
(
    PARTITION NORTHAMERICA VALUES IN ('US_NE', 'US_SE', 'US_MW', 'US_NW', 'US_SW', 'CAN', 'MEX'),
    PARTITION EUROPE VALUES IN ('EUR_E', 'EUR_W'),
    PARTITION ASIA VALUES IN ('CHN', 'JPN', 'IND')
);

-- page 338
-- ERROR 1526 (HY000): Table has no partition for value from column_list
-- В таблице нет раздела для значения из column_list
INSERT INTO sales
VALUES (1, 1, 1, '2020-01-18', 'US_NE', 2765.15),
       (2, 3, 4, '2020-02-07', 'CAN', 5322.08),
       (3, 6, 27, '2020-03-11', 'KOR', 4267.12);

ALTER TABLE sales REORGANIZE PARTITION ASIA INTO
(
    PARTITION ASIA VALUES IN ('CHN', 'JPN', 'IND', 'KOR')
);

SELECT PARTITION_NAME,
       PARTITION_EXPRESSION,
       PARTITION_DESCRIPTION
FROM information_schema.PARTITIONS
WHERE TABLE_NAME = 'sales'
ORDER BY PARTITION_ORDINAL_POSITION;

-- page 339
INSERT INTO sales
VALUES (1, 1, 1, '2020-01-18', 'US_NE', 2765.15),
       (2, 3, 4, '2020-02-07', 'CAN', 5322.08),
       (3, 6, 27, '2020-03-11', 'KOR', 4267.12);

-- секционирование по хешу
CREATE TABLE sales
(
    sale_id     INT         NOT NULL,
    cust_id     INT         NOT NULL,
    store_id    INT         NOT NULL,
    sale_date   INT         NOT NULL,
    amount      DECIMAL(9,2)
)
PARTITION BY HASH (cust_id) PARTITIONS 4
(
    PARTITION H1,
    PARTITION H2,
    PARTITION H3,
    PARTITION H4
);

-- page 340
INSERT INTO sales
VALUES (1, 1, 1, '2020-01-18', 1.1),
       (2, 3, 4, '2020-02-07', 1.2),
       (3, 17, 5, '2020-01-19', 1.3),
       (4, 23, 2, '2020-02-08', 1.4),
       (5, 56, 1, '2020-01-20', 1.6),
       (6, 77, 5, '2020-02-09', 1.7),
       (7, 122, 4, '2020-01-21', 1.8),
       (8, 153, 1, '2020-02-10', 1.9),
       (9, 179, 5, '2020-01-22', 2.0),
       (10, 244, 2, '2020-02-11', 2.1),
       (11, 263, 1, '2020-01-23', 2.2),
       (12, 312, 4, '2020-02-12', 2.3),
       (13, 346, 2, '2020-01-24', 2.4),
       (14, 389, 3, '2020-02-13', 2.5),
       (15, 472, 1, '2020-01-25', 2.6),
       (16, 502, 1, '2020-02-14', 2.7);

SELECT CONCAT('# of rows in H1 = ', COUNT(*)) partition_rowcount
FROM sales PARTITION (H1)
UNION ALL
SELECT CONCAT('# or rows in H2 = ', COUNT(*)) partition_rowcount
FROM sales PARTITION (H2)
UNION ALL
SELECT CONCAT('# of rows in H3 = ', COUNT(*)) partition_rowcount
FROM sales PARTITION (H3)
UNION ALL
SELECT CONCAT('# of rows in H4 = ', COUNT(*)) partition_rowcount
FROM sales PARTITION (H4);

-- page 341
-- композитное секционирование
CREATE TABLE sales
(
    sale_id     INT         NOT NULL,
    cust_id     INT         NOT NULL,
    store_id    INT         NOT NULL,
    sale_date   INT         NOT NULL,
    amount      DECIMAL(9,2)
)
PARTITION BY RANGE (YEARWEEK(sale_date))
SUBPARTITION BY HASH (cust_id)
(
    PARTITION s1 VALUES LESS THAN (202002)
        (
            SUBPARTITION s1_h1,
            SUBPARTITION s1_h2,
            SUBPARTITION s1_h3,
            SUBPARTITION s1_h4
        ),
    PARTITION s2 VALUES LESS THAN (202003)
        (
            SUBPARTITION s2_h1,
            SUBPARTITION s2_h2,
            SUBPARTITION s2_h3,
            SUBPARTITION s2_h4
        ),
    PARTITION s3 VALUES LESS THAN (202004)
        (
            SUBPARTITION s3_h1,
            SUBPARTITION s3_h2,
            SUBPARTITION s3_h3,
            SUBPARTITION s3_h4
        ),
    PARTITION s4 VALUES LESS THAN (202005)
        (
            SUBPARTITION s4_h1,
            SUBPARTITION s4_h2,
            SUBPARTITION s4_h3,
            SUBPARTITION s4_h4
        ),
    PARTITION s5 VALUES LESS THAN (202006)
        (
            SUBPARTITION s5_h1,
            SUBPARTITION s5_h2,
            SUBPARTITION s5_h3,
            SUBPARTITION s5_h4
        ),
    PARTITION s999 VALUES LESS THAN (MAXVALUE)
        (
            SUBPARTITION s999_h1,
            SUBPARTITION s999_h2,
            SUBPARTITION s999_h3,
            SUBPARTITION s999_h4
        )
);

-- page 342
INSERT INTO sales
VALUES (1, 1, 1, '2020-01-18', 1.1),
       (2, 3, 4, '2020-02-07', 1.2),
       (3, 17, 5, '2020-01-19', 1.3),
       (4, 23, 2, '2020-02-08', 1.4),
       (5, 56, 1, '2020-01-20', 1.6),
       (6, 77, 5, '2020-02-09', 1.7),
       (7, 122, 4, '2020-01-21', 1.8),
       (8, 153, 1, '2020-02-10', 1.9),
       (9, 179, 5, '2020-01-22', 2.0),
       (10, 244, 2, '2020-02-11', 2.1),
       (11, 263, 1, '2020-01-23', 2.2),
       (12, 312, 4, '2020-02-12', 2.3),
       (13, 346, 2, '2020-01-24', 2.4),
       (14, 389, 3, '2020-02-13', 2.5),
       (15, 472, 1, '2020-01-25', 2.6),
       (16, 502, 1, '2020-02-14', 2.7);

-- извлечение данных из одного раздела
-- в этом случае извлекаются данные из четырёх подразделов, связанных с разделом
SELECT *
FROM sales PARTITION (s3);

-- извлечение данных только из подраздела s3_h3 раздела s3
SELECT *
FROM sales PARTITION (s3_h3);
