-- Условная логика
-- page 239
-- 599 rows retrieved
SELECT first_name,
       last_name,
       CASE
           WHEN active = 1 THEN 'ACTIVE'
           ELSE 'INACTIVE'
       END activity_type
FROM customer;

-- page 241
-- поисковые выражения CASE
-- 599 rows retrieved
SELECT c.first_name,
       c.last_name,
       CASE
           WHEN active = 0 THEN 0
           ELSE (SELECT COUNT(*)
                 FROM rental r
                 WHERE r.customer_id = c.customer_id)
       END
FROM customer c;

-- page 243
-- простые выражения CASE
CASE category.rename
    WHEN 'Children' THEN 'All Ages'
    WHEN 'Family' THEN 'All Ages'
    WHEN 'Sports' THEN 'All Ages'
    WHEN 'Animations' THEN 'All Ages'
    WHEN 'Horror' THEN 'Adult'
    WHEN 'Music' THEN 'Teens'
    WHEN 'Games' THEN 'Teens'
    ELSE 'Other'
END

-- 3 rows retrieved
SELECT MONTHNAME(rental_date) rental_month,
       COUNT(*) num_rentals
FROM rental
WHERE rental_date BETWEEN '2005-05-01' AND '2005-08-01'
GROUP BY MONTHNAME(rental_date);

-- page 244
-- 1 row retrieved
SELECT
    SUM(
        CASE
            WHEN MONTHNAME(rental_date) = 'May' THEN 1
            ELSE 0
        END
    ) May_rentals,
    SUM(
        CASE
            WHEN MONTHNAME(rental_date) = 'June' THEN 1
            ELSE 0
        END
    ) June_rentals,
    SUM(
        CASE
            WHEN MONTHNAME(rental_date) = 'July' THEN 1
            ELSE 0
        END
    ) July_rentals
FROM rental
WHERE rental_date BETWEEN '2005-05-01' AND '2005-08-01';




