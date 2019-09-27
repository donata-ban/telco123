DROP TABLE IF EXISTS entry_log;
DROP TABLE IF EXISTS employees;


CREATE TABLE employees
	(employee_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    last_update TIMESTAMP DEFAULT (CURRENT_TIMESTAMP));

    
CREATE TABLE entry_log
	(log_id INT PRIMARY KEY AUTO_INCREMENT,
    log_datetime DATETIME NOT NULL,
    employee_id INT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id));
    
ALTER TABLE entry_log
ADD COLUMN type BOOLEAN NOT NULL AFTER employee_id;

ALTER TABLE entry_log
DROP COLUMN entry_type;

ALTER TABLE entry_log
CHANGE COLUMN type entry_type BOOLEAN NOT NULL;

RENAME TABLE entry_log TO entry_exit_log;


INSERT INTO employees (employee_id, name, surname)
VALUES
	(1, 'Jonas', 'Jonaitis');


DELETE FROM entry_exit_log


SELECT
	*
FROM
	entry_exit_log
    
    
INSERT INTO entry_exit_log (log_datetime, employee_id, entry_type)
VALUES (NOW(), 1, 1);

INSERT INTO entry_exit_log (log_datetime, employee_id, entry_type)
VALUES (NOW(), 1, 0);


  
  
SELECT
		*
FROM
		entry_exit_log;
        
        
-- export
SELECT 
	log_datetime,
    entry_type,
    employee_id
FROM
	entry_exit_log
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/exportt.csv'
FIELDS TERMINATED BY ';' LINES TERMINATED BY '\r\n';


-- import 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/logas.csv'
REPLACE INTO TABLE entry_exit_log CHARACTER SET UTF8
FIELDS TERMINATED BY ';'IGNORE 1 LINES (log_datetime, employee_id, entry_type);

