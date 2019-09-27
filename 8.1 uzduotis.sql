-- 1. Parašykite užklausą, kuri iš film lentelės išrinktų filmus ir išrikiuotų juos pagal filmo ilgį mažėjančia tvarka. (7 taškai)
SELECT
	*
FROM
	film
ORDER BY length DESC;


-- 2. Parašykite užklausą, kuri iš actor lentos išrinktų aktorius ir išrikiuotų juos pagal vardą, 
-- jei vardai sutampa, tada pagal pavardę mažėjančia tvarka. Rezultate turi rodyti stulpelius (vardas, pavardė). (7 taškai)
SELECT
	first_name,
    last_name
FROM
	actor
ORDER BY 
	first_name ASC,
    last_name DESC;


-- 3. Parašykite užklausą kuri išrinktų visus filmus ir jų kategorijas.
-- Rezultate turi matytis (filmo_pavadinimas, kategorija). (7 taškai)
SELECT
	f.title,
    c.name as category
FROM
	film f
    INNER JOIN film_category fc ON fc.film_id = f.film_id
    INNER JOIN category c ON c.category_id = fc.category_id;
    

-- 4. a.)Parašykite grupavimo užklausą, kuri suskaičiuotų kiek skirtingo reitingo (rating) filmų yra film lentoje, 
-- būtinai turi matytis reitingo pavadinimas. 
-- b.) Praplėskite a.) dalyje parašytą skriptą ir rodykite tik tuos reitingus, kurių yra daugiau nei 10, Ar yra tokių? (7 taškai)
-- a)
SELECT
	rating,
    COUNT(film_id) as 'number of films'
FROM
	film
GROUP BY rating;
    
-- b)
SELECT
	rating,
    COUNT(film_id) as 'number of films'
FROM
	film
GROUP BY rating
HAVING COUNT(film_id) > 10; -- įeina visi reitingai, kaip ir a dalyje, nes filmų priklausančių kiekvienam reitingui yra virš 100


-- 5. Suskaičiuokite, kokia yra bendra replacement_cost suma (lentelėje film), filmų turinčių "Action" kategoriją. (7 taškai)
SELECT
	c.name as category,
    COUNT(f.film_id) as 'number of films in category',
    SUM(f.replacement_cost) as 'total replacement cost'
FROM
	film f
    INNER JOIN film_category fc ON fc.film_id = f.film_id
    INNER JOIN category c ON c.category_id = fc.category_id
WHERE c.name = 'action';

-- 6. Paleiskite skriptą actor_monthly_wage.sql. Patikrinkite ar po skripto palaidimo atsirado stulpelis monthly_wage decimal(10, 2).
-- Jeigu stulpelio tipas ne toks pakeiskite į decimal(10,2). (7 taškai)

DESCRIBE actor;
ALTER TABLE actor
MODIFY monthly_wage DECIMAL(10,2);


-- 7. Paleiskite skriptą fill_actor_wages.sql, jei nepavyksta, pasitikrinkite 6 užduotyje ar viską atlikote tinkamai. (7 taškai)
-- implemented

-- 8. Parašykite užklausą, kuri išrinktų aktorius iš lentos actor. Rezultate turi būti pavaizduoti stulpeliai: 
-- vardas, pavardė, atlyginimas. Atlyginimas turi būti pavaizduojamas sekančiai, jeigu atlyginimas mažiau arba lygus 1000,
-- tuomet vaizduojamas žodis "Minimalus", jeigu atlyginimas daugiau negu 1000, bet mažiau arba lygus 2000, tuomet vaizduojamas
-- žodis "Vidutinis", visais kitais atvejais vaizduojamas žodis "Aukštas". (17 taškų)

SELECT
	first_name,
    last_name,
    CASE 
		WHEN monthly_wage <= 1000 THEN 'Minimalus'
        WHEN monthly_wage > 1000 AND monthly_wage <= 2000 THEN 'Vidutinis'
        ELSE 'Aukštas'
	END as monthly_wage
FROM
	actor;

-- 9. Į lentelę actor įterpikte 3 naujus aktorius. (7 taškai)

INSERT INTO actor (first_name, last_name, monthly_wage, age)
VALUES ('Simona', 'Pakenaite', 2356.23, 95),
	('Justas', 'Poliakas', 2440.51, 13),
    ('Donata', 'Bankauskaite', 2420.30, 74);

-- 10. Visų aktorių amžių mažesnį nei 18, pakeiskite į 18 (UPDATE) (7 taškai)

UPDATE actor
SET age = 18
WHERE age < 18;


-- ----------------


-- 1. Parašykite užklausą, kuri parodytų kiek kartų ir koks klientas buvo išsinuomojęs filmų. 
-- Rezultate turi rodyti vardas, pavardė, nuomų skaičius, statusas. Statuso stulpelio rezultatas formuojamas sekančiai:
-- jeigu nuomos kartų skaičius didesnis negu 30, rodomas tekstas "VIP", kitu atveju "Standartinis". (10 taškų)

SELECT 
	c.first_name,
    c.last_name,
    COUNT(r.rental_id) rental_count,
    CASE
		WHEN COUNT(r.rental_id) > 30 THEN 'VIP'
        ELSE 'Standard'
	END as status
FROM
	customer c
    INNER JOIN rental r ON r.customer_id = c.customer_id
GROUP BY
	c.first_name,
    c.last_name;
    

-- 2. Parašykite skriptą, kuris surastų vieną daugiausiai filmų išsinuomojusį klientą ir jo vardą, pavardę bei išsinuomojimų 
-- skaičių patalpintų laikinoje lentelėje pavadinimu vip_customer. (10 taškų)
CREATE TEMPORARY TABLE vip_customer
SELECT
	c.first_name,
    c.last_name,
    COUNT(r.rental_id) rental_count
FROM
	customer c
    INNER JOIN rental r ON r.customer_id = c.customer_id
GROUP BY 
	c.first_name,
    c.last_name
ORDER by rental_count DESC
LIMIT 1;

-- 3. Parašykite skriptą, kuris surastų vieną mažiausiai filmų išsinuomojusį klientą ir jo vardą, pavardę bei išsinuomojimų
-- skaičių patalpintų laikinoje lentelėje pavadinimu standart_customer. (10 taškų)
CREATE TEMPORARY TABLE standard_customer
SELECT
	c.first_name,
    c.last_name,
    COUNT(r.rental_id) rental_count
FROM
	customer c
    INNER JOIN rental r ON r.customer_id = c.customer_id
GROUP BY 
	c.first_name,
	c.last_name
ORDER by rental_count ASC
LIMIT 1;

-- 4. Sukurkite nuolatinę lentelę pavadinimu best_and_worst_customer su laukelių pavadinimais (name varchar(50), 
-- surname varchar(50), rentals INT). (10 taškų)

CREATE TABLE best_and_worst_customer(
    name VARCHAR(50),
    surname VARCHAR(50),
    rentals INT
);
    
    
    
-- 5. Į nuolatinę lentelę best_and_worst_customer įterpkite reikšmes iš lentelių standart_customer ir vip_customer. (10 taškų)
INSERT INTO best_and_worst_customer (name, surname, rentals)
SELECT
	first_name,
    last_name,
    rental_count
FROM
	standard_customer
UNION
SELECT
	first_name,
    last_name,
    rental_count
FROM
	vip_customer;
    
-- 6. Suraskite, kuris klientas (customer) atliko daugiausia mokėjimų (payment lenta) parduotuvėje su id 1. (10 taškų)

-- showing one customer who made most payments, using LIMIT 1
SELECT
	c.customer_id,
	c.first_name,
    c.last_name,
    COUNT(p.payment_id) as payment_count,
    c.store_id
FROM
	customer c
    INNER JOIN payment p ON p.customer_id = c.customer_id
WHERE store_id = 1
GROUP BY customer_id
ORDER BY payment_count DESC
LIMIT 1;


-- In order to display all customers that made most payments (if there would be) the script below is used:

SELECT 
	c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(p.payment_id) as payment_count 
FROM
	customer c
    INNER JOIN payment p ON p.customer_id = c.customer_id
WHERE store_id = 1
GROUP BY customer_id
HAVING COUNT(p.payment_id) = (
		SELECT max_counted.payment_count
		FROM(
			SELECT
				c.customer_id,
				c.first_name,
				c.last_name,
				COUNT(p.payment_id) as payment_count 
			FROM
				customer c
				INNER JOIN payment p ON p.customer_id = c.customer_id
			WHERE store_id = 1
			GROUP BY customer_id
            ORDER BY COUNT(p.payment_id) DESC
            LIMIT 1) as max_counted);