-- Activate Sakila DB
USE sakila;

-- Turn off safe updates

SET SQL_SAFE_UPDATES = 0;

-- 1a. Display the first and last names of all actors from the table actor.
Select first_name, last_name FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name' FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name,
-- "Joe." What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:

SELECT first_name, last_name FROM actor WHERE last_name LIKE '%gen%';

-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order:

SELECT last_name, first_name FROM actor WHERE last_name LIKE '%li%';

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT country_id, country FROM country
WHERE country IN ('Afghanistan','Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
-- so create a column in the table actor named description and use the data type BLOB 
-- (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).

ALTER TABLE actor 
ADD COLUMN description BLOB NULL AFTER last_update;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.

ALTER TABLE actor 
DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.

Select last_name, COUNT(last_name) AS 'Actors with Name' FROM actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors

Select last_name, COUNT(last_name) AS 'Actors with Name' FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE actor
SET first_name = 'GROUCHO' WHERE first_name = 'HARPO';


-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

SHOW CREATE TABLE address;
 
CREATE TABLE `address` (  
`address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
`address` varchar(50) NOT NULL, 
`address2` varchar(50) DEFAULT NULL,  
`district` varchar(20) NOT NULL, 
`city_id` smallint(5) unsigned NOT NULL, 
`postal_code` varchar(10) DEFAULT NULL,  
`phone` varchar(20) NOT NULL,
`location` geometry NOT NULL,
`last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
PRIMARY KEY (`address_id`), 
KEY `idx_fk_city_id` (`city_id`), 
SPATIAL KEY `idx_location` (`location`),
CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE) 
ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:

SELECT * FROM staff LIMIT 1;
SELECT * FROM address LIMIT 1;

SELECT staff.first_name, staff.last_name, address.address
FROM staff
JOIN address ON address.address_id = staff.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT * FROM payment LIMIT 1;

SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount)
FROM staff
JOIN payment ON staff.staff_id = payment.staff_id WHERE payment_date LIKE '2005-08%'
GROUP BY staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT * FROM film LIMIT 1;
SELECT * FROM film_actor LIMIT 1;

SELECT film.film_id, film.title, COUNT(film_actor.actor_id)
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT * FROM inventory;

SELECT COUNT(inventory_id) FROM inventory
WHERE film_id
IN(SELECT film_id FROM film WHERE title = 'Hunchback Impossible');

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:

SELECT * FROM payment LIMIT 1;
SELECT * FROM customer LIMIT 1;

SELECT customer.customer_id, customer.last_name, customer.first_name, SUM(payment.amount)
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer_id
ORDER BY last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT * FROM film LIMIT 1;
SELECT * FROM language LIMIT 5;

SELECT title FROM film 
WHERE title LIKE 'K%' OR title LIKE 'Q%' AND language_id
IN(SELECT language_id FROM language WHERE `name` = 'English');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT * FROM actor LIMIT 1;
SELECT * FROM film_actor LIMIT 1;

SELECT first_name, last_name FROM actor
WHERE actor_id
IN(SELECT actor_id FROM film_actor WHERE film_id IN
(SELECT film_id FROM film WHERE title = 'Alone Trip'));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names 
-- and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT * FROM address LIMIT 1;
SELECT * FROM customer LIMIT 1;
SELECT * FROM city LIMIT 1;
SELECT * FROM country LIMIT 1;

SELECT first_name, last_name, email 
FROM customer c
INNER JOIN address a
ON (c.address_id = a.address_id)
INNER JOIN city cit
ON (a.city_id = cit.city_id)
INNER JOIN country co
ON (cit.country_id = co.country_id)
WHERE country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT * FROM film LIMIT 1;
SELECT * FROM film_category LIMIT 1;
SELECT * FROM category WHERE name LIKE 'family%';

SELECT * FROM film WHERE film_id
IN(SELECT film_id FROM film_category WHERE category_id IN
(SELECT category_id FROM category WHERE name = 'Family'));

-- 7e. Display the most frequently rented movies in descending order

SELECT * FROM rental LIMIT 5;
SELECT * FROM inventory LIMIT 1;
SELECT * FROM film LIMIT 5;

SELECT title, (SELECT COUNT(*) FROM rental WHERE inventory_id
IN(SELECT inventory_id FROM inventory WHERE film.film_id = inventory.film_id )) AS 'Number of Rentals'
FROM film
ORDER BY (`Number of Rentals`) DESC;


-- 7f. Write a query to display how much business, in dollars, each store brought in

SELECT * FROM store LIMIT 5;
SELECT * FROM staff LIMIT 1;

SELECT address_id, SUM(amount) 
FROM store s
INNER JOIN inventory i
ON (s.store_id = i.store_id)
INNER JOIN  rental r
ON (i.inventory_id = r.inventory_id)
INNER JOIN payment p
ON (r.rental_id = p.rental_id)
GROUP BY s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.

 SELECT store_id, city, country
  FROM store s
  INNER JOIN address a
  ON (s.address_id = a.address_id)
  INNER JOIN city cit
  ON (cit.city_id = a.city_id)
  INNER JOIN country ctr
  ON(cit.country_id = ctr.country_id);

-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT * FROM category LIMIT 5;
SELECT * FROM film_category LIMIT 5;
SELECT * FROM inventory LIMIT 5;
SELECT * FROM payment LIMIT 5;
SELECT * FROM rental LIMIT 5;

SELECT name AS 'Genre', SUM(amount) AS 'Total'
FROM category c
INNER JOIN film_category fc
ON (c.category_id = fc.category_id)
INNER JOIN inventory i
ON (i.film_id = fc.film_id)
INNER JOIN rental r
ON (r.inventory_id = i.inventory_id)
INNER JOIN payment p
ON (p.rental_id = r.rental_id)
GROUP BY Genre
ORDER BY (Total) DESC LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

-- NOT FINISHED!!!!!!!!!!

CREATE VIEW top_five_genres AS
SELECT name AS 'Genre', SUM(amount) AS 'Total'
FROM category c
INNER JOIN film_category fc
ON (c.category_id = fc.category_id)
INNER JOIN inventory i
ON (i.film_id = fc.film_id)
INNER JOIN rental r
ON (r.inventory_id = i.inventory_id)
INNER JOIN payment p
ON (p.rental_id = r.rental_id)
GROUP BY Genre
ORDER BY (Total) DESC LIMIT 5;

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM top_five_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW top_five_genres;