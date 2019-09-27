-- 1. Išrinkite visus filmus ir surūšiuokite juos pagal abėcėlę didėjimo tvarka.
SELECT * FROM film ORDER BY title ASC

-- 2. Išrinkite visus aktorius iš actor lentos ir surūšiuokite juos pagal pavardę didėjimo tvarka, jei pavardės sutampa rūšiuojama pagal vardą.
SELECT 
	*
FROM
	actor
ORDER BY last_name ASC, first_name ASC

-- 3. Panaudokite teksto jungimą ir iš lentelės customer išrinkite duomenis į vieną stulpelį. Duomenų formatas atrodo taip: first_name last_name (email).
SELECT CONCAT(first_name, " ", last_name, " (", first_name, ".", last_name, "@gmail.com") FROM customer;

-- 4. Kiek simbolių sudaro ilgiausias vardas duomenų lentelėje actor.
SELECT
	MAX(length(first_name))
FROM
	actor
WHERE
	length(first_name) = (SELECT MAX(length(first_name)) FROM actor)
    
-- 5. Kiek simbolių sudaro ilgiausia pavardė duomenų lentelėje actor.
SELECT
	MAX(length(last_name))
FROM
	actor
WHERE
	length(last_name) = (SELECT MAX(length(last_name)) FROM actor)
    
-- 6. Atidarykite ir paleiskite skriptą add_column_to_actor_table_and_fill_data.sql. Skriptas pridės stulpelius: age, date_of_birth, gender, taip pat skriptas įterps papildomų aktorių.
-- Jūsų veiksmai: atsidarom skripta ir paleidzima

-- 7. Suraskite vyriausią aktorių (actors lenta) ir rezultate turi matytis vardas, pavardė, gimimo data (subquery panaudojimas).
SELECT
	first_name,
    last_name,
    date_of_birth
FROM
	actor 
WHERE
	age = (SELECT MAX(age) FROM actor)
    
-- 8. Suraskite jauniausią aktorių.
SELECT
	first_name,
    last_name,
    date_of_birth
FROM
	actor 
WHERE
	age = (SELECT MIN(age) FROM actor)
    
-- 9. Raskite aktorių amžiaus vidurkį.
SELECT AVG(age) FROM actor

-- 10. Suskaičiuokite kiek aktorių yra moterų ir kiek aktorių yra vyrų. Naudojame agregavimo funkciją ir grupavimą.
SELECT
	gender,
    COUNT(*)
FROM
	actor
GROUP BY gender

-- 11. Suskaičiuokite kiek koks klientas buvo išsinuomojęs filmų. Rodykite tik tuos klientus, kurie išsinuomojo daugiau nei 2 filmus. Nuomos įrašai saugome lentoje rental.
SELECT
	c.first_name,
    c.last_name,
    COUNT(*)
FROM
	rental r
    INNER JOIN customer c ON c.customer_id = r.customer_id
GROUP BY c.first_name, c.last_name
HAVING COUNT(*) > 2

-- 12. Atidarykite ir paleiskite skriptą capitals.sql. Patikrinkite ar lentelėje city atsirado stulpelis IsCapital boolean tipo.
-- Jūsų veiksmai: atidarome prisgta skritą ir paleidžiame

-- 13. Peržiūrėkite miestus (city), atrinkite 10 sostinių ir naudodami update komandą pakeiskite pasirinkto miesto IsCapital stulpelio reikšmę į 1.
UPDATE city SET
	IsCapital = 1
WHERE
	city_id IN (10, 20, 30, 40 , 50, 60, 70, 80, 90, 100)
    
-- 14. Parašykite užklausą miestams ir šalims atrinkti, miestai turi būti tik sostinės.
SELECT
	ci.city,
    co.country
FROM
	city ci
    INNER JOIN country co ON co.country_id = ci.country_id
WHERE 
	ci.isCapital = 1
    
-- 15. Į lentelę city įterpikte savo gimtąjį miestą. Jei toks jau yra kitą pasirinktą miestą.
INSERT INTO city (city, country_id, IsCapital)
VALUES ("Šilalė", 56, 0)

-- 16. Parašykite užklausą, kuri atrinktų tuos miestus iš city kurių nėra address lentoje.
SELECT
	ci.city
FROM
	city ci
	LEFT JOIN address a ON a.city_id = ci.city_id
WHERE
	a.address_id IS NULL
    
-- 17. Paleiskite skriptą store_name.sql. Lentelėje store turi atsirasti stulpelis store_name, kurio varchar(50). 
-- Jei taip nėra pataisykite lentelės stulepio tipą ir pridėkite leistiną teksto simbolių skaičių.
ALTER TABLE store
MODIFY store_name VARCHAR(50);

-- 18. Sugalvokite store lentelėje esančioms parduotuvėms pavadinimus ir pakeiskite stulepio store_name reikšmes į jūsų sugalvotas.
UPDATE store SET
	store_name = CONCAT("parduotuve Nr. ", store_id)
    
-- 19. Parašykite užklausą, kuri iš customer lentos išrinktų visus parduotuvės (store) su id 1 aktyvius klientus. 
-- Rezultate turi matytis parduotuvės pavadinimas, kliento vardas ir pavardė.
SELECT
	s.store_name,
	cu.first_name,
    cu.last_name
FROM
	customer cu
    INNER JOIN store s ON s.store_id = cu.store_id
WHERE
	cu.active = 1

-- 20. Sukurkite naują parduotuvę (store). Visko ko jai trūksta (vadovo(manager), adreso ir pan.) taip pat sukurkite.
-- pirma dresas parduotuvei
INSERT INTO address (address, district, city_id, postal_code, phone, location)
VALUES ("Niekieno g.", "Šilalės", 1, "88888", "+3706855655", ST_GeomFromText('POINT(1 1)'));

-- iterpiame i staff su kitos egzistuojancios store id, tarkime tas store id cia nurodomas centrines parduotuves
INSERT INTO staff (first_name, last_name, address_id, email, store_id, active, username, password)
VALUES("JOana", "Li", 609, "joana.li@gmail.com", 1, 1, "joana", "");

-- sukuriame parduotuve su nauju adresu, bet kitos parduotuves manager
INSERT INTO store (manager_staff_id, address_id, store_name)
VALUES (3, 609, "Mano krautuvė");

-- pakeiciame naujam staff parduotuve i naujai sukurta
UPDATE staff SET
	store_id = 3
WHERE
	staff_id = 3

-- 21. Sukurkite naujai įterptos parduotuvės (store) klientą (customer). Įterpimas į customer lentą.
INSERT INTO customer (store_id, first_name, last_name, email, address_id, active, create_date)
VALUES (5, "Petras", "Petraitis", "pteras.petraitis@gmail.com", 1, 1, NOW());

-- 22. Pridėkite prie lentos customer stulpelį gender. Stulpelis turi būti NULL (neprivalomas). Stulpelio tipas BOOLEAN.
ALTER TABLE customer
ADD COLUMN gender BOOLEAN NULL;

-- 23. Pasirinkite 20 klientų (customer) ir jiems priskirkite lytį. Reikšmė 1 yra vyras, o reikšmė 0 yra moteris.
UPDATE customer SET
	gender = 1
WHERE
	customer_id IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
    
UPDATE customer SET
	gender = 0
WHERE
	customer_id IN (11, 12, 13, 14, 15, 16, 17, 18, 19, 20);
    
-- 24. Parašykite užklausą, kuri iš customer lentos išrinktų įrašus (vardas, pavardė, el. paštas, lytis). Jeigu lytis 1 rodome tekstą "Vyras", jei lytis 0 rodome tekstą "Moteris".

SELECT
	c.first_name,
    c.last_name,
    c.email,
    CASE c.gender
		WHEN 1 THEN "Vyras"
        WHEN 0 THEN "Moteris"
        ELSE "Nežinoma"
	END as gender
FROM
	customer c;
    
-- 25. Pridėkite prie lentos actor stulpelį gender. Stulpelis turi būti NULL (neprivalumas). Stuleplio tipas BOOLEAN.
-- nereikia atlikti nes padaryta buvo su pirmo skripto paleidimu

-- 26. Pasirinkite 20 aktorių (actor) ir jiems priskirkite lytį. Reikšmė 1 yra vyras, o reikšmė 0 yra moteris.
-- nereikia atlikti nes padaryta buvo su pirmo skripto paleidimu

-- 27. Parašykite užklausą, kuri iš aktorių lentos išrinktų aktorius (vardas, pavardė, el. paštas, lytis), 
-- kurių lytis nėra NULL ir kurie yra vaidinę daugiausia filmų. 
-- Rezultatus patalpinkite į laikiną lentelę pavadinimu actors_temp.
-- 1 budas

SELECT
	a.actor_id as actor_id,
	a.first_name as name,
    a.last_name as surname,
    a.email,
    a.gender,
    COUNT(*) as total
FROM
	actor a
    INNER JOIN film_actor fa ON fa.actor_id = a.actor_id
    INNER JOIN film f ON f.film_id = fa.film_id
GROUP BY a.actor_id, a.first_name, a.last_name, a.email, a.gender
HAVING 
	a.gender IS NOT NULL AND
	total = (SELECT 
					counted_group.total 
				FROM (SELECT
						a.actor_id as actor_id,
						a.first_name as name,
						a.last_name as surname,
						COUNT(*) as total
					FROM
						actor a
						INNER JOIN film_actor fa ON fa.actor_id = a.actor_id
						INNER JOIN film f ON f.film_id = fa.film_id
					GROUP BY a.actor_id, a.first_name, a.last_name
					ORDER BY total DESC
					LIMIT 1) as counted_group);
                    
-- 2 budas su tarpinemis lentelemis
CREATE TEMPORARY TABLE actors_temp(
	first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(150),
    gender BOOLEAN
);

-- susikuriame dar viena lentele kuri nepamineta salygoje tarpiniams duomenims
CREATE TEMPORARY TABLE actor_calculations(
	actor_id INT,
    played_times INT
);

-- apskaiciuojame ir iterpiame i laikina lentele duomenis apie tai kiek kartu koks aktorius vaidino
INSERT INTO actor_calculations (actor_id, played_times)
SELECT 
	a.actor_id,
	COUNT(*) counts
FROM 
	actor a
    INNER JOIN film_actor fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id;

-- susirandame didziausia reiksme is vaidinimu
SET @max = (SELECT MAX(played_times) FROM actor_calculations);

INSERT INTO actors_temp (first_name, last_name, email, gender)
SELECT 
	a.first_name,
    a.last_name,
    a.email,
    a.gender
FROM
	actor a
	INNER JOIN actor_calculations ac ON ac.actor_id = a.actor_id
WHERE
	a.gender IS NOT NULL AND ac.played_times = @max

-- 28. Parašykite užklausą, kuri iš klientų (customer) lentos išrinktų klientus (vardas, pavardė, el. paštas, lytis), kurių lytis nėra NULL ir kurie yra
-- išsinuomoję daugiausia filmų (rental lentoje įrašai apie nuomą). Rezultatus patalpinkite į laikiną lentelę pavadinimu customers_temp.

-- beveik analogiškai kaip 26 užduotyje

CREATE TEMPORARY TABLE customers_temp(
	first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(150),
    gender BOOLEAN
);

-- susikuriame dar viena lentele kuri nepamineta salygoje tarpiniams duomenims
CREATE TEMPORARY TABLE customer_calculations(
	customer_id INT,
    rental_times INT
);

-- apskaiciuojame ir iterpiame i laikina lentele duomenis apie tai kiek kartu koks klientas išsinuomojo filmus 
INSERT INTO customer_calculations (customer_id, rental_times)
SELECT 
	c.customer_id,
	COUNT(*) counts
FROM 
	customer c
    INNER JOIN rental r ON r.customer_id = c.customer_id
WHERE
	c.gender IS NOT NULL
GROUP BY c.customer_id;

-- susirandame didziausia reiksme is vaidinimu
SET @max = (SELECT MAX(rental_times) FROM customer_calculations);

INSERT INTO customers_temp (first_name, last_name, email, gender)
SELECT 
	c.first_name,
    c.last_name,
    c.email,
    c.gender
FROM
	customer c
	INNER JOIN customer_calculations cc ON cc.customer_id = c.customer_id
WHERE
	c.gender IS NOT NULL AND cc.rental_times = @max

-- 29. Sakila duomenų bazėje sukurkite pastovią lentelę best_people. Laukai: id primary key, name varchar, surname varchar, email varchar, gender (boolean). 
-- Varchar laukų ilgiai turi būti ne mažesni nei laikinose lentelėse customers_temp ir actors_temp.

CREATE TABLE best_people(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    surname VARCHAR(50),
    email VARCHAR(150),
    gender BOOLEAN
);

-- 30. Įterpkite į naujai sukurtą lentelę best_people duomenis iš lentelių customers_temp, actors_temp.
INSERT INTO best_people (name, surname, email, gender)
SELECT
	first_name,
    last_name,
    email,
    gender
FROM
	customers_temp
UNION
SELECT
	first_name,
    last_name,
    email,
    gender
FROM
	actors_temp;

-- 31. Eksportuokite duomenis iš best_people lentos į csv failą. Duomenų atskyrimui naudojamas atskyrimo simbolis |.

-- eksportavimas
SELECT "name", "surname", "email", "gender"
UNION ALL
SELECT
	name,
    surname,
    email,
    gender
FROM
	best_people
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/best_people.csv'
FIELDS TERMINATED BY '|' LINES TERMINATED BY '\r\n';

-- 32. Ištrinkite lentelę best_people.
DROP TABLE best_people