//////////////////////////////////////////////////

/* Conceptualizing */

-- find top 10 paying customers
WITH t1 AS (
            SELECT p.customer_id AS customer_id, SUM(p.amount) AS total_spent
            FROM payment p
            JOIN customer c
            ON c.customer_id = p.customer_id
            GROUP BY p.customer_id
            ORDER BY 2 DESC
            LIMIT 10)

SELECT
        DATE_TRUNC('month', t1.payment_date) AS pay_month,
        t1.first_name || ' ' || t1.last_name AS full_name,
        COUNT(p.*) AS pay_count_per_month,
        SUM(p.amount) AS pay_amount
FROM t1



-- show # of unique payment months (only four total, 2,3,4,5 of 2017)
SELECT DATE_TRUNC('month', p.payment_date) AS pay_month
FROM payment p
GROUP BY 1
ORDER BY 1

/* Query Formulation */

WITH t1 AS (
        SELECT
    )

-- total spent per customer
SELECT p.customer_id, SUM(p.amount)
FROM payment p
GROUP BY p.customer_id
ORDER BY 2 DESC


-- # of transactions per customer
SELECT p.customer_id, COUNT(p.*)
FROM payment p
GROUP BY p.customer_id
ORDER BY 2 DESC

-- combined
SELECT p.customer_id, SUM(p.amount), COUNT(p.*)
FROM payment p
GROUP BY p.customer_id
ORDER BY 2 DESC, 3 DESC


SELECT
        DATE_TRUNC('month', p.payment_date) AS pay_month,
        first_name || ' ' || last_name AS full_name,
        COUNT(p.*) AS pay_count_per_month,
        SUM(p.amount) AS pay_amount
FROM payment p
JOIN customer c
ON c.customer_id = p.customer_id

-- progress
WITH t1 AS (
            SELECT p.customer_id AS customer_id, SUM(p.amount) AS total_spent
            FROM payment p
            JOIN customer c
            ON c.customer_id = p.customer_id
            GROUP BY p.customer_id
            ORDER BY 2 DESC
            LIMIT 10)
SELECT
        DATE_TRUNC('month', p.payment_date) AS pay_month,
        c.first_name || ' ' || c.last_name AS full_name
FROM t1
JOIN payment p
ON t1.customer_id = p.customer_id
JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY 1, 2
ORDER BY 2


-- needs to be split up using a sub
SELECT
        DATE_TRUNC('month', p.payment_date) AS pay_month,
        first_name || ' ' || last_name AS full_name,
        COUNT(p.*) AS pay_count_per_month,
        SUM(p.amount) AS pay_amount
FROM rental r
JOIN payment p
ON p.customer_id = r.customer_id
JOIN customer c
ON c.customer_id = r.customer_id
GROUP BY 2, 1
ORDER BY 1




//////////////////////////////////////////////////
/* Unnecessary Work */

SELECT *, DATE_PART('day', (DATE_TRUNC('day', return_date) - DATE_TRUNC('day', rental_date))) AS rental_duration
FROM rental r


/* Alternate Q3 */

WITH t2 AS (
        WITH t1 AS (
                SELECT
                        f.title AS film_title,
                        c.name AS category_name,
                        f.rental_duration AS rental_duration
                FROM category c
                JOIN film_category fc
                ON c.category_id = fc.category_id
                JOIN film f
                ON f.film_id = fc.film_id
                WHERE c.name in ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music'))


        SELECT
                t1.film_title AS film_title,
                t1.category_name AS category_name,
                t1.rental_duration AS rental_duration,
                NTILE(4) OVER(ORDER BY rental_duration) AS standard_quartile
        FROM t1)


SELECT
        t2.category_name AS category_name,
        t2.standard_quartile AS standard_quartile,
        count(t2.*)
FROM t2
GROUP BY 1, 2
ORDER BY 1, 2


/* Other Unused Queries */

//Problem Set 1, Q2//

WITH t1 AS (
        SELECT
  				f.title AS film_title,
                c.name AS category_name,
                f.rental_duration AS rental_duration
        FROM category c
        JOIN film_category fc
        ON c.category_id = fc.category_id
        JOIN film f
        ON f.film_id = fc.film_id
		WHERE c.name in ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music'))


SELECT
        t1.film_title AS film_title,
        t1.category_name AS category_name,
        t1.rental_duration AS rental_duration,
        NTILE(4) OVER(ORDER BY rental_duration) AS standard_quartile
FROM t1;




















//////////////////////////////////////////////////