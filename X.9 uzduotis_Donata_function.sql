/* Sukurkite funkcija (FUNTION) kuriai padavus bet kokią tekstinę eilutę iš jos pašalintų balses ir gražintų tekstą be balsių.
 Funkciją išbandykite su aktoriais (actor lentelė) grąžinadami sąrašą vardų ir pavardžių be balsių */


-- considering only pure vowels: A, E, O, U, I
DROP FUNCTION IF EXISTS remove_vowels;
DELIMITER //
CREATE FUNCTION remove_vowels(c_name VARCHAR(200))
RETURNS VARCHAR(200)
BEGIN
	RETURN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c_name, 'A', ''), 'E', ''), 'O', ''), 'U', ''), 'I', '');
END //
DELIMITER ;

SELECT
	actor_id,
	remove_vowels (first_name) as first_name_coding,
    remove_vowels (last_name) as last_name_coding
FROM
	actor