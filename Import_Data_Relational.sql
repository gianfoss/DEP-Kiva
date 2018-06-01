#ALTER TABLE loan_theme 
#ALTER COLUMN loan_theme_id VARCHAR(100) 
#COLLATE SQL_Latin1_General_CP1_CS_AS;


LOAD DATA LOCAL INFILE 'Data-Engineering-Project/Loan_Theme.csv' 
INTO TABLE Loan_Theme 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n';



LOAD DATA LOCAL INFILE 'Data-Engineering-Project/Country.csv' 
INTO TABLE Country 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n';

set sql_safe_updates=0;


LOAD DATA LOCAL INFILE 'Data-Engineering-Project/Region.csv' 
INTO TABLE Region 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE 'Data-Engineering-Project/Partner.csv' 
INTO TABLE Partner
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n';


LOAD DATA LOCAL INFILE 'Data-Engineering-Project/Conversion_Rate.csv' 
INTO TABLE Conversion_Rate
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n';


SET FOREIGN_KEY_CHECKS=0;

LOAD DATA LOCAL INFILE 'Data-Engineering-Project/Loans.csv' 
INTO TABLE Loan
FIELDS TERMINATED BY ',' 
enclosed by '"'
#LINES TERMINATED BY '\n'
LINES TERMINATED BY '\r\n'
## note use \r\n in windows, \n in linux
IGNORE 1 LINES; 

ALTER TABLE Loan MODIFY posted_date DATE;
ALTER TABLE Loan MODIFY disbursed_date DATE;
ALTER TABLE Loan MODIFY funded_date DATE;

LOAD DATA LOCAL INFILE 'Data-Engineering-Project/Borrower_Gender.csv' 
INTO TABLE Borrower_Gender
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE 'Data-Engineering-Project/Gender_Loan_Relationship.csv' 
INTO TABLE Gender_Loan_Relationship
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET FOREIGN_KEY_CHECKS=1;
