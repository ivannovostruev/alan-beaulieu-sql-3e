-- page 39
SHOW DATABASES;

USE sakila;

SELECT NOW();

-- page 40
SELECT NOW()
FROM dual;

-- page 42
SHOW CHARACTER SET;

-- page 52
CREATE TABLE person
(
    person_id   SMALLINT UNSIGNED,
    fname       VARCHAR(20),
    lname       VARCHAR(20),
    eye_color   CHAR(2),
    birth_date  DATE,
    street      VARCHAR(30),
    city        VARCHAR(20),
    state       VARCHAR(20),
    country     VARCHAR(20),
    postal_code VARCHAR(20),
    CONSTRAINT pk_person PRIMARY KEY (person_id)
);

-- проверочное ограничение для столбца eye_color
CREATE TABLE person
(
    person_id   SMALLINT UNSIGNED,
    fname       VARCHAR(20),
    lname       VARCHAR(20),
    eye_color   CHAR(2)         CHECK (eye_color IN ('BR','BL','GR')),
    birth_date  DATE,
    street      VARCHAR(30),
    city        VARCHAR(20),
    state       VARCHAR(20),
    country     VARCHAR(20),
    postal_code VARCHAR(20),
    CONSTRAINT pk_person PRIMARY KEY (person_id)
);

-- символьный тип данных ENUM для столбца eye_color
CREATE TABLE person
(
    person_id   SMALLINT UNSIGNED,
    fname       VARCHAR(20),
    lname       VARCHAR(20),
    eye_color   ENUM('BR','BL','GR'),
    birth_date  DATE,
    street      VARCHAR(30),
    city        VARCHAR(20),
    state       VARCHAR(20),
    country     VARCHAR(20),
    postal_code VARCHAR(20),
    CONSTRAINT pk_person PRIMARY KEY (person_id)
);

-- page 54
DESCRIBE person;

-- псевдоним
DESC person;

-- SQL keys, MUL vs PRI vs UNI
-- https://stackoverflow.com/questions/5317889/sql-keys-mul-vs-pri-vs-uni
SHOW COLUMNS FROM person;

-- page 55
CREATE TABLE favorite_food
(
    person_id   SMALLINT UNSIGNED,
    food        VARCHAR(20),
    CONSTRAINT pk_favorite_food PRIMARY KEY (person_id, food),
    CONSTRAINT fk_fav_food_person_id FOREIGN KEY (person_id) REFERENCES person (person_id)
);

-- page 57
-- Решение ошибки: [HY000][1833] Cannot change column 'person_id': used in a foreign key constraint 'fk_fav_food_person_id' of table 'sakila.favorite_food'
-- https://stackoverflow.com/questions/13606469/cannot-change-column-used-in-a-foreign-key-constraint
SET FOREIGN_KEY_CHECKS = 0;
ALTER TABLE person
MODIFY person_id SMALLINT UNSIGNED AUTO_INCREMENT;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO person (person_id,
                    fname,
                    lname,
                    eye_color,
                    birth_date)
VALUES (NULL,
        'William',
        'Turner',
        'BR',
        '1972-05-27');

-- page 58
SELECT person_id, fname, lname, birth_date
FROM person
WHERE lname = 'Turner';

-- page 59
INSERT INTO favorite_food (person_id, food)
VALUES (1, 'pizza');

INSERT INTO favorite_food (person_id, food)
VALUES (1, 'cookies');

INSERT INTO favorite_food (person_id, food)
VALUES (1, 'nachos');

SELECT food
FROM favorite_food
WHERE person_id = 1
ORDER BY food;

INSERT INTO person (person_id,
                    fname,
                    lname,
                    eye_color,
                    birth_date,
                    street,
                    city,
                    state,
                    country,
                    postal_code)
VALUES (NULL,
        'Susan',
        'Smith',
        'BL',
        '1975-11-02',
        '23 Maple St.',
        'Arlington',
        'VA',
        'USA',
        '20220');

-- page 61
UPDATE person
SET street = '1225 Tremont St',
    city = 'Boston',
    state = 'MA',
    country = 'USA',
    postal_code = '02138'
WHERE person_id = 1;

DELETE FROM person
WHERE person_id = 2;

-- page 62
-- не уникальный первичный ключ
-- [23000][1062] Duplicate entry '1' for key 'person.PRIMARY'
INSERT INTO person (person_id,
                    fname,
                    lname,
                    eye_color,
                    birth_date)
VALUES (1,
        'Charles',
        'Fulton',
        'GR',
        '1968-01-15');

-- несуществующий внешний ключ
-- [23000][1452] Cannot add or update a child row: a foreign key constraint fails (`sakila`.`favorite_food`, CONSTRAINT `fk_fav_food_person_id` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`))
INSERT INTO favorite_food (person_id, food)
VALUES (999, 'lasagna');

-- page 63
-- нарушение значения столбца
-- [01000][1265] Data truncated for column 'eye_color' at row 1
UPDATE person
SET eye_color = 'ZZ'
WHERE person_id = 1;

-- некорректное преобразование данных
-- [22001][1292] Data truncation: Incorrect date value: 'DEC-21-1980' for column 'birth_date' at row 1
UPDATE person
SET birth_date = 'DEC-21-1980'
WHERE person_id = 1;

-- page 64
-- в общем случае всегда рекомендуется явно указывать строку формата,
-- а не полагаться на формат по умолчанию
UPDATE person
SET birth_date = STR_TO_DATE('DEC-21-1980', '%b-%d-%Y')
WHERE person_id = 1;

-- page 65
-- чтобы увидеть таблицы, доступные в базе данных
SHOW TABLES;

-- page 66
-- удаление таблицы favorite_food
DROP TABLE favorite_food;

-- удаление таблицы person
DROP TABLE person;


