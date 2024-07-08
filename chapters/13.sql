-- Индексы и ограничения
-- page 263
-- 3 rows retrieved
SELECT first_name, last_name
FROM customer
WHERE last_name LIKE 'Y%';

-- page 264
-- создание индекса
ALTER TABLE customer
ADD INDEX idx_email (email);

-- page 265
-- альтернативный синтаксис создания индекса
CREATE INDEX idx_email
ON customer (email);

-- использование команды SHOW INDEX FROM
-- 5 rows retrieved
SHOW INDEX FROM customer;

-- page 267
CREATE TABLE customer
(
    customer_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    store_id TINYINT UNSIGNED NOT NULL,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    email VARCHAR(50) DEFAULT NULL,
    address_id SMALLINT UNSIGNED NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    create_date DATETIME NOT NULL,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (customer_id),
    KEY idx_fk_store_id (store_id),
    KEY idx_fk_address_id (address_id),
    KEY idx_last_name (last_name),
    CONSTRAINT fk_customer_address FOREIGN KEY (address_id)
        REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_customer_store FOREIGN KEY (store_id)
        REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- удаление бесполезного индекса
ALTER TABLE customer
DROP INDEX idx_email;

-- альтернативный синтаксис
DROP INDEX idx_email ON customer;

-- page 268
-- уникальные индексы
ALTER TABLE customer
ADD UNIQUE idx_email (email);

-- [23000][1062] Duplicate entry 'ALAN.KAHN@sakilacustomer.org' for key 'customer.idx_email'
-- Дубликат значения 'ALAN.KAHN@sakilacustomer.org' для ключа 'customer.idx_email'
INSERT INTO customer (store_id,
                      first_name,
                      last_name,
                      email,
                      address_id,
                      active)
VALUES (1,
        'ALAN',
        'KAHN',
        'ALAN.KAHN@sakilacustomer.org',
        394,
        1);

-- page 269
-- многостолбцовые индексы
ALTER TABLE customer
ADD INDEX idx_full_name (last_name, first_name);

-- page 272
-- 3 rows retrieved
SELECT customer_id, first_name, last_name
FROM customer
WHERE first_name LIKE 'S%' AND last_name LIKE 'P%';

-- page 273
-- использование инструкции EXPLAIN
-- Эта инструкция просит сервер
-- показать план выполнения для запроса, но не выполнить его
-- 1 row retrieved
EXPLAIN
SELECT customer_id, first_name, last_name
FROM customer
WHERE first_name LIKE 'S%' AND last_name LIKE 'P%';

-- page 276
-- создание ограничения
CREATE TABLE customer
(
    customer_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    store_id TINYINT UNSIGNED NOT NULL,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    email VARCHAR(50) DEFAULT NULL,
    address_id SMALLINT UNSIGNED NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    create_date DATETIME NOT NULL,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- ограничение первичного ключа
    PRIMARY KEY (customer_id),

    KEY idx_fk_store_id (store_id),
    KEY idx_fk_address_id (address_id),
    KEY idx_last_name (last_name),

    -- ограничение внешнего ключа
    CONSTRAINT fk_customer_address FOREIGN KEY (address_id)
        REFERENCES address (address_id)
            ON DELETE RESTRICT ON UPDATE CASCADE,

    -- ограничение внешнего ключа
    CONSTRAINT fk_customer_store FOREIGN KEY (store_id)
        REFERENCES store (store_id)
            ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- page 277
ALTER TABLE customer
ADD CONSTRAINT fk_customer_address FOREIGN KEY (address_id)
    REFERENCES address (address_id)
        ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE customer
ADD CONSTRAINT fk_customer_store FOREIGN KEY (store_id)
    REFERENCES store (store_id)
        ON DELETE RESTRICT ON UPDATE CASCADE;

-- 1 row retrieved
SELECT c.first_name, c.last_name, c.address_id, a.address
FROM customer c
    INNER JOIN address a
        ON a.address_id = c.address_id
WHERE a.address_id = 123;

-- [23000][1451] Cannot delete or update a parent row: a foreign key constraint fails
-- (sakila.customer, CONSTRAINT fk_customer_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE)
-- Невозможно удалить или обновить родительскую строку: нарушение ограничения внешнего ключа
DELETE FROM address
WHERE address_id = 123;

-- page 278
UPDATE address
SET address_id = 9999
WHERE address_id = 123;

-- 1 row retrieved
SELECT c.first_name, c.last_name, c.address_id, a.address
FROM customer c
    INNER JOIN address a
        ON a.address_id = c.address_id
WHERE a.address_id = 9999;

-- exercise 13.1
ALTER TABLE rental
ADD CONSTRAINT fk_rental_customer FOREIGN KEY (customer_id)
    REFERENCES customer (customer_id)
        ON DELETE RESTRICT;

-- exercise 13.2
ALTER TABLE payment
ADD INDEX idx_payment_date_amount (payment_date, amount);

-- решение из книги
CREATE INDEX idx_payment01
ON payment (payment_date, amount);
