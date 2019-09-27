/* Apšilimui, labai paprasta:
1. Sukurkite procedūrą (stored procedure), kurią iškvietus procedūra grąžintų visas šalis.
2. Sukurkite procedūrą su parametru. Parametras tai VARCHAR skirtas filtruoti miestams.
Iškvietus procedūra, ji gražina sąrašą šalių išfiltruotų pagal nurodytą parametrą. 
Parašykite procedūros iškvietimo kodą, paduodami parametrui reikšmę, pagal kurią filtruosite. */

-- TASK NO.1
DELIMITER //
CREATE PROCEDURE SelectAllCountriess ()
BEGIN
  SELECT 
  *
  FROM Country;
END //
DELIMITER;   
    
CALL SelectAllCountriess ();

-- TASK NO.2
DROP PROCEDURE country_by_city;
DELIMITER //
CREATE PROCEDURE country_by_city 
(this_city varchar(20))
BEGIN
  SELECT 
  c.*
  FROM country c
  INNER JOIN city ct ON ct.country_id = c.country_id
WHERE ct.city = this_city;
END //
DELIMITER ;   
    
CALL country_by_city ('Adana');


	