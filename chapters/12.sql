-- Транзакции
-- page 254
START TRANSACTION;

-- page 257
-- отключает режим автоматической фиксации
SET AUTOCOMMIT = 0

-- завершение транзакции
-- фиксация изменений и освобождение ресурсов сервера БД
COMMIT;

-- откат изменений с момента начала транзакции
-- после завершения отката любые ресурсы, используемые сеансом, освобождаются
ROLLBACK;

-- page 260
-- чтобы представить данные в виде списка, а не в виде таблицы
-- можно в консоли в конце инструкции добавить флаг: \G
-- 1 row retrieved
SHOW TABLE STATUS LIKE 'customer';

-- page 261
-- создание точки сохранения
SAVEPOINT my_savepoint;

-- откат к определённой точке сохранения
ROLLBACK TO SAVEPOINT my_savepoint;

-- пример
-- начало транзакции
START TRANSACTION;

UPDATE product
SET date_retired = CURRENT_TIMESTAMP()
WHERE product_cd = 'XYZ';

SAVEPOINT before_close_accounts;

UPDATE account
SET status = 'CLOSED',
    close_date = CURRENT_TIMESTAMP(),
    last_activity_date = CURRENT_TIMESTAMP()
WHERE product_cd = 'XYZ';

ROLLBACK TO SAVEPOINT before_close_accounts;
COMMIT;
-- конец транзакции

-- exercise 12.1
START TRANSACTION;

UPDATE account
SET avail_balance = avail_balance - 50,
    last_activity_date = NOW()
WHERE account_id = 123;

INSERT INTO transaction (txn_id,
                         txn_date,
                         account_id,
                         txn_type_cd,
                         amount)
VALUES (1003,
        NOW(),
        123,
        'D',
        50);

UPDATE account
SET avail_balance = avail_balance + 50,
    last_activity_date = NOW()
WHERE account_id = 789;

INSERT INTO transaction (txn_id,
                        txn_date,
                        account_id,
                        txn_type_cd,
                        amount)
VALUES (1004,
        NOW(),
        789,
        'C',
        50);

ROLLBACK;
COMMIT;

-- решение из книги
START TRANSACTION;

INSERT INTO transaction
    (txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES (1003, NOW(), 123, 'D', 50);

INSERT INTO transaction
    (txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES (1004, NOW(), 789, 'C', 50);

UPDATE account
SET avail_balance = avail_balance - 50,
    last_activity_date = NOW()
WHERE account_id = 123;

UPDATE account
SET avail_balance = avail_balance + 50,
    last_activity_date = NOW()
WHERE account_id = 789;

COMMIT;
