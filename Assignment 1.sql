
/* Question 1: What actors have a first name PENELOPE? */
select * from actor
WHERE first_name ='PENELOPE';

/* Question 2: What actors were in the movie ZOOLANDER FICTION? */
select first_name, last_name from actor
join film_actor on film_actor.actor_id = actor.actor_id 
join film on film.film_id = film_actor.film_id
where film.title = 'ZOOLANDER FICTION';

/*Question 3: What movies were JENNIFER DAVIS in? */
select film.title from film film 
join film_actor film_actor on film.film_id = film_actor.film_id
join actor actor on actor.actor_id = film_actor.actor_id
where actor.first_name = 'JENNIFER' and actor.last_name = 'DAVIS';

/*Question 4: What movies has LISA ANDERSON (customer id is 11) still not returned? */
select film.title from film film
join inventory inventory on inventory.film_id = film.film_id
join rental rental on rental.inventory_id = inventory.inventory_id
where rental.customer_id = 11 and rental.return_date is null; 

/*Question 5: What movies are categorized as Animations? */
select film.title from film film
join film_category filmcategory on film.film_id = filmcategory.film_id
join category category on category.category_id = filmcategory.category_id
where category.name = 'Animation' ;

/*Question 6: What did PAULA BRYANT  (customer id 95) pay to rent the movie CLOSER BANG? */
select film.rental_rate from film film
where film.title = 'ClOSER BANG';

/*Question 7: What is the first and last name of the staff who rented the move CHAINSAW UPTOWN to MARIE TURNER? */
select staff.first_name, staff.last_name from staff 
join inventory on inventory.store_id = staff.store_id
join film on film.film_id = inventory.film_id
join rental on rental.inventory_id = inventory.inventory_id
join customer on customer.customer_id = rental.customer_id
where film.title = 'CHAINSAW UPTOWN' and customer.first_name = 'MARIE' and customer.last_name = 'TURNER';