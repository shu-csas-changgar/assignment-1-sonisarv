use sakila;

/* Question 1: List each customer’s customer id, first and last name, 
sorted alphabetically by last name and the total amount spent on rentals.
 The name of the total amount column should be TOTAL SPENT. */

select customer.customer_id, first_name, last_name,
sum(amount) as 'TOTAL SPENT' 
from sakila.payment
join sakila.customer on payment.customer_id = customer.customer_id
group by payment.customer_id
order by last_name ASC,
sum(amount) DESC;
 
/*Question 2: List the unique (no duplicates) District and 
city name where the postal code is null or empty. */

select distinct a.district, a.city_id 
from address a
join city c on a.city_id = c.city_id
where postal_code = '';

/*Question 3: List all the films have the words DOCTOR or FIRE in their title? */
select title
from sakila.film
where title like '%DOCTOR%' 
OR title like '%FIRE%' ;

/*Question 4: List each actor’s actor id, first and last name, sorted alphabetically 
by last name and the total number of films they have been in. There should be no duplicates. 
You should have one row per actor. The name of the number of films column should be NUMBER OF MOVIES. */

select distinct a.actor_id, a.last_name, a.first_name, 
count(f.film_id) as 'NUMBER OF MOVIES'
from actor a 
join film_actor fa using (actor_id) 
join film f using (film_id)
group by a.actor_id order by a.last_name, count(film_id);

/* Question 5: What is the average run time of each film by category? 
Order the results by the average run time lowest to highest. */

select c.name, avg (f.length) 
from film f
join film_category fc on f.film_id = fc.film_id
join category c
on c.category_id = fc.category_id
group by c.name order by avg(f.length);

/* Question 6: How much business (in dollars) did each store bring in? 
There should be no duplicates. Just list of each store id and the total 
dollar amount. Order the result by dollar amount greatest to lowest. */

select store.store_id, sum(amount) 
from sakila.store
join sakila.staff on store.store_id = staff.store_id
join sakila.payment on staff.staff_id = payment.staff_id
group by store.store_id;

/* Question 7: What is the first and last name, email and total amount 
spent on movies by customers in Canada? Order alphabetically by their last name.*/

select c.first_name, c.last_name, c.email, sum(amount) as 'Total Amount Spent'
from city ci join country co on ci.country_id = co.country_id
join address a on ci.city_id = a.city_id 
join customer c on a.address_id = c.address_id
join payment p on c.customer_id = p.customer_id
where co.country = 'Canada' group by c.customer_id order by c.last_name;

/*Question 8: MATHEW BOLIN would like to rent the movie HUNGER ROOF from staff JON 
STEPHENS at store 2 today. The rental fee is 2.99. Insert this rental and payment into the database. */

select * from sakila.customer 
where customer.first_name = 'MATHEW' and customer.last_name = 'BOLIN'; #539 
select * from sakila.film 
where film.title = 'HUNGER ROOF'; #440
select * from sakila.staff 
where staff.first_name = 'JON' and staff.last_name = 'STEPHENS'; #2
select * from sakila.inventory 
where inventory.film_id = '440'; #2026

start transaction;

insert into rental(rental_date, inventory_id, customer_id, staff_id, last_update) 
value(now(), '2026', '539', '2', now());

select rental_id 
from rental where customer_id = '539' and staff_id = '2' and inventory_id = '2026';

insert into payment(customer_id, staff_id, rental_id, amount, payment_date, last_update)
values ('539', '2', '16050', '2.99', now(), now());

rollback;
commit;

/* Question 9: TRACY COLE would like to return the movie ALI FOREVER. 
Update the rental table to reflect this. You can write multiple queries to get the IDs before writing 
the update statement. You can also do it in a single update statement using joins or sub queries. */

start transaction;

update rental
	join inventory
    on rental.inventory_id = inventory.inventory_id
    join film 
    on inventory.film_id = film.film_id
    join customer
    on rental.customer_id = customer.customer_id
	set rental.return_date = now()
	where customer.first_name = "Tracy" and customer.last_name = "Cole" and film.title = "Ali Forever";

Rollback;
commit;

/*Question 10: Change the original language id for all films in the category ANIMATION to JAPANESE. */
start transaction;

update sakila.category set name = replace(name, 'Animation', 'Japanese') 
where category_id = '2';

Rollback;
commit;