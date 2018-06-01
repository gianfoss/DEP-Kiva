/*
TRUNCATE STATEMENTS
if the data has to be reloaded after the initial load, truncate the existing tables first using the following:

TRUNCATE TABLE numbers_small;
TRUNCATE TABLE numbers;
TRUNCATE TABLE dim_date;
TRUNCATE TABLE dim_country;
TRUNCATE TABLE dim_region;
TRUNCATE TABLE dim_theme;
TRUNCATE TABLE dim_currency;
TRUNCATE TABLE dim_partner;
TRUNCATE TABLE fact_loan;
*/


USE depdimensional;

INSERT INTO numbers_small VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

INSERT INTO numbers
SELECT 
    thousands.number * 1000 + hundreds.number * 100 + tens.number * 10 + ones.number
FROM
    numbers_small thousands,
    numbers_small hundreds,
    numbers_small tens,
    numbers_small ones
LIMIT 1000000;

INSERT INTO dim_date (date_Id, date)
SELECT 
    number,
    DATE_ADD('2005-01-01',
        INTERVAL number DAY)
FROM
    numbers
WHERE
    DATE_ADD('2005-01-01',
        INTERVAL number DAY) BETWEEN '2005-01-01' AND '2017-01-01'
ORDER BY number;

SET SQL_SAFE_UPDATES = 0;

UPDATE dim_date 
SET 
    timestamp = UNIX_TIMESTAMP(date),
    day_of_week = DATE_FORMAT(date, '%W'),
    weekend = IF(DATE_FORMAT(date, '%W') IN ('Saturday' , 'Sunday'),
        'Weekend',
        'Weekday'),
    month = DATE_FORMAT(date, '%M'),
    year = DATE_FORMAT(date, '%Y'),
    month_day = DATE_FORMAT(date, '%d');

UPDATE dim_date 
SET 
    week_starting_monday = DATE_FORMAT(date, '%v');


insert into dim_country (
	country_id,
	country_name,
	ISO,
	population,
	population_below_poverty_line,
	human_development_index,
	life_expectancy,
	mean_years_of_schooling,
	gross_national_income,
	expected_years_of_schooling,
	mpi_national
)  
(select 
	Country.country_id,
	Country.country_name,
	Country.ISO,
	Country.population,
	Country.population_below_poverty_line,
	Country.human_development_index,
	Country.life_expectancy,
	Country.mean_years_of_schooling,
	Country.gross_national_income,
	Country.expected_years_of_schooling,
	Country.mpi_national
from deprelational.Country);


select * from dim_country;


insert into dim_region (
	region_id,
	region_name,
	lattitude,
	longitude,
	mpi,
	rural_percent,
	country_id,
	country_key,
	population_headcount_ratio_regional,
	intensity_of_deprivation_regional
)
(select 
	Region.region_id,
	Region.region_name, 
	Region.lattitude,
	Region.longitude,
	Region.mean_poverty_index,
	Region.rural_percent,
	Region.country_id,
	dim_country.country_key,
	Region.headcount_ratio_regional,
	Region.intensity_of_deprivation_regional
from
	deprelational.Region,
    dim_country
where dim_country.country_id = Region.country_id);


select * from dim_region;

insert into dim_theme(
	loan_theme_id,
	loan_theme_type,
	loan_id,
	sector,
	activity,
    `use`
)
(select 
	Loan_Theme.loan_theme_id,
	Loan_Theme.loan_theme_type,
	Loan.loan_id,
	Loan.sector, 
	Loan.activity,
    Loan.use
from 
	deprelational.Loan, 
	deprelational.Loan_Theme
where
	Loan.loan_theme_id= Loan_Theme.loan_theme_id);


select * from dim_theme;

insert into dim_currency (
	currency_id,
	currency,
	conversion_rate)
(select 
	currency_id,
	currency,
	conversion_rate
from 
	deprelational.Conversion_Rate);

select * from dim_currency;


insert into dim_partner(
	partner_id,
	partner_name,
	country_code)
(select
	partner_id,
	partner_name,
	country_id
from 
	deprelational.Partner);

select * from dim_partner;

#create temporary table lender_count
#select count(distinct Donor_Loan_Relationship.Donor_Loan_Relationship_ID) AS lender_count, Loan.loan_id

insert into fact_loan(
	loan_id,
	funded_amount,
	loan_amount,
	term_in_month,
	region_key,
	loan_theme_key,
	currency_key,
	partner_key,
	disbursed_date_key,
	posted_date_key,
	funded_date_key)
(select 
	Loan.loan_id,
	Loan.funded_amount,
	Loan.loan_amount,
	Loan.term_in_month,
	dim_region.region_key,
	dim_theme.loan_theme_key,
	dim_currency.currency_key,
	dim_partner.partner_key,
	dd.date_id,
	pd.date_id,
	fd.date_id
from 
	deprelational.Loan 
    join dim_region on Loan.region_id= dim_region.region_id
	join dim_theme on Loan.loan_id= dim_theme.loan_id
	join dim_currency on dim_currency.currency_id = Loan.currency_id
	left join dim_partner on dim_partner.partner_id = Loan.partner_id
	left join dim_date dd on DATE(dd.date) = DATE(Loan.disbursed_date)
	left join dim_date pd on DATE(pd.date) = DATE(Loan.posted_date)
	left join dim_date fd on DATE(fd.date) = DATE(Loan.funded_date)
group by 
	Loan.loan_id,
	Loan.funded_amount,
	Loan.loan_amount,
    Loan.term_in_month,
	dim_region.region_key,
	dim_theme.loan_theme_key,
	dim_currency.currency_key,
	dim_partner.partner_key,
	dd.date_id,
	pd.date_id,
	fd.date_id
);

