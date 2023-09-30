/* Query 1 - query shows rental count for each film from a family-friendly category -- used agg, window, and CTE --  related to QS1-Q1 */

WITH sub1 AS (
        SELECT
  				f.title AS film_title,
                c.name AS category_name,
                COUNT(i.inventory_id) OVER (PARTITION BY f.film_id ORDER BY f.title) AS rental_count
        FROM category c
        JOIN film_category fc
        ON c.category_id = fc.category_id
        JOIN film f
        ON f.film_id = fc.film_id
        JOIN inventory i
        ON i.film_id = f.film_id
        JOIN rental r
        ON r.inventory_id = i.inventory_id
		WHERE c.name in ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music'))


SELECT sub1.film_title, sub1.category_name, sub1.rental_count
FROM sub1
GROUP BY 1, 2, 3
ORDER BY 2, 1;

/* Query 2 - query shows number of movies rented out by category and quartile related to rental duration -- used agg, window, and CTE -- related to QS1-Q3*/

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
                WHERE c.name in ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')),
    t2 AS (
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
ORDER BY 1, 2;

/* Query 3 - query shows total # of rentals per store for each month and year -- used agg -- related to QS2-Q1 */

SELECT DATE_PART('month',rental_date) AS rental_month,
        DATE_PART('year',rental_date) AS rental_year,
        sto.store_id AS store_id,
        COUNT(*)
FROM rental r
JOIN staff sta
ON sta.staff_id = r.staff_id
JOIN store sto
ON sto.store_id = sta.store_id
GROUP BY 1, 2, 3
ORDER BY 4 DESC;

/* Query 4 - query shows top 10 customers (by total spent) and shows quantity of rentals and $ spent per month -- used agg & CTE -- related to QS2-Q2 */

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
        c.first_name || ' ' || c.last_name AS full_name,
        COUNT(p.*) AS pay_count_per_month,
        SUM(p.amount) AS pay_amount
FROM t1
JOIN payment p
ON t1.customer_id = p.customer_id
JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY 1, 2
ORDER BY 2;
