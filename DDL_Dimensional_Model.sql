-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema depdimensional
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema depdimensional
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `depdimensional` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------`PRIMARY`
-- Schema depdimschema
-- -----------------------------------------------------
USE `depdimensional` ;

CREATE TABLE IF NOT EXISTS `depdimensional`.`numbers` (
  `number` BIGINT(20) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Table `classicmodelsdw`.`numbers_small`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `depdimensional`.`numbers_small` (
  `number` INT(11) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


CREATE TABLE IF NOT EXISTS `depdimensional`.`dimtime` (
  `dateId` BIGINT(20) NOT NULL,
  `date` DATE NOT NULL,
  `timestamp` BIGINT(20) NULL DEFAULT NULL,
  `weekend` CHAR(10) NOT NULL DEFAULT 'Weekday',
  `day_of_week` CHAR(10) NULL DEFAULT NULL,
  `month` CHAR(10) NULL DEFAULT NULL,
  `month_day` INT(11) NULL DEFAULT NULL,
  `year` INT(11) NULL DEFAULT NULL,
  `week_starting_monday` CHAR(2) NULL DEFAULT NULL,
  PRIMARY KEY (`dateId`),
  UNIQUE INDEX `date` (`date` ASC),
  INDEX `year_week` (`year` ASC, `week_starting_monday` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `depdimensional`.`dim_country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `depdimensional`.`dim_country` (
  `country_key` INT NOT NULL AUTO_INCREMENT,
  `country_id` INT NOT NULL,
  `country_name` VARCHAR(45) NOT NULL,
  `ISO` VARCHAR(45) NOT NULL,
  `population` INT NULL,
  `population_below_poverty_line` VARCHAR(45) NULL,
  `human_development_index` VARCHAR(45) NULL,
  `life_expectancy` VARCHAR(45) NULL,
  `mean_years_of_schooling` VARCHAR(45) NULL,
  `gross_national_income` VARCHAR(45) NULL,
  `expected_years_of_schooling` VARCHAR(45) NULL,
  `mpi_national` VARCHAR(45) NULL,
  PRIMARY KEY (`country_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `depdimensional`.`dim_region`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `depdimensional`.`dim_region` (
  `region_key` INT NOT NULL auto_increment,
  `region_id` INT NOT NULL,
  `region_name` VARCHAR(100) NOT NULL,
  `lattitude` VARCHAR(45) NULL,
  `longitude` VARCHAR(45) NULL,
  `mpi` VARCHAR(45) NULL,
  `rural_percent` VARCHAR(45) NULL,
  `country_id` INT NOT NULL,
  `country_key` INT NOT NULL,
  `population_headcount_ratio_regional` VARCHAR(45) NULL,
  `intensity_of_deprivation_regional` VARCHAR(45) NULL,
  PRIMARY KEY (`region_key`),
  INDEX `fk_dim_region_dim_country1_idx` (`country_key` ASC),
  CONSTRAINT `fk_dim_region_dim_country1`
    FOREIGN KEY (`country_key`)
    REFERENCES `depdimensional`.`dim_country` (`country_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `depdimensional`.`dim_theme`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `depdimensional`.`dim_theme` (
  `loan_theme_id` VARCHAR(100) NOT NULL,
  `loan_theme_type` VARCHAR(100) NOT NULL,
  `loan_id` INT NOT NULL,
  `loan_theme_key` INT NOT NULL AUTO_INCREMENT,
  `sector` VARCHAR(100) NULL,
  `activity` VARCHAR(100) NULL,
  `use` VARCHAR(900) NULL DEFAULT NULL,
  PRIMARY KEY (`loan_theme_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `depdimensional`.`dim_currency`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `depdimensional`.`dim_currency` (
  `currency_id` INT NOT NULL,
  `currency` CHAR(3) NOT NULL,
  `conversion_rate` FLOAT NOT NULL,
  `currency_key` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`currency_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `depdimensional`.`dim_partner`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `depdimensional`.`dim_partner` (
  `partner_id` INT NOT NULL,
  `partner_name` VARCHAR(100) NOT NULL,
  `country_code` VARCHAR(5) NOT NULL,
  `partner_key` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`partner_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `depdimensional`.`dim_date`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `depdimensional`.`dim_date` (
  `date_id` BIGINT(20) NOT NULL,
  `date` DATE NULL,
  `timestamp` BIGINT(20) NULL,
  `weekend` CHAR(10) NULL,
  `day_of_week` CHAR(10) NULL,
  `month` CHAR(10) NULL,
  `month_day` INT(11) NULL,
  `year` INT(11) NULL,
  `week_starting_monday` CHAR(2) NULL,
  PRIMARY KEY (`date_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `depdimensional`.`fact_loan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `depdimensional`.`fact_loan` (
  `loan_id` INT NOT NULL,
  `funded_amount` VARCHAR(45) NOT NULL,
  `loan_amount` DECIMAL(20,10) NOT NULL,
  `term_in_month` INT NOT NULL,
  `region_key` INT NOT NULL,
  `loan_theme_key` INT NOT NULL,
  `currency_key` INT NOT NULL,
  `partner_key` INT NULL,
  `disbursed_date_key` BIGINT(20) NULL,
  `posted_date_key` BIGINT(20) NULL,
  `funded_date_key` BIGINT(20) NULL,
  PRIMARY KEY (`loan_id`),
  INDEX `fk_fact_loan_dim_region_idx` (`region_key` ASC),
  INDEX `fk_fact_loan_Loan_Theme1_idx` (`loan_theme_key` ASC),
  INDEX `fk_fact_loan_dim_currency1_idx` (`currency_key` ASC),
  INDEX `fk_fact_loan_dim_partner1_idx` (`partner_key` ASC),
  INDEX `fk_fact_loan_dim_date1_idx` (`disbursed_date_key` ASC),
  INDEX `fk_fact_loan_dim_date2_idx` (`posted_date_key` ASC),
  INDEX `fk_fact_loan_dim_date3_idx` (`funded_date_key` ASC),
  CONSTRAINT `region_key`
    FOREIGN KEY (`region_key`)
    REFERENCES `depdimensional`.`dim_region` (`region_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_loan_Loan_Theme1`
    FOREIGN KEY (`loan_theme_key`)
    REFERENCES `depdimensional`.`dim_theme` (`loan_theme_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_loan_dim_currency1`
    FOREIGN KEY (`currency_key`)
    REFERENCES `depdimensional`.`dim_currency` (`currency_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_loan_dim_partner1`
    FOREIGN KEY (`partner_key`)
    REFERENCES `depdimensional`.`dim_partner` (`partner_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_loan_dim_date1`
    FOREIGN KEY (`disbursed_date_key`)
    REFERENCES `depdimensional`.`dim_date` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_loan_dim_date2`
    FOREIGN KEY (`posted_date_key`)
    REFERENCES `depdimensional`.`dim_date` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_loan_dim_date3`
    FOREIGN KEY (`funded_date_key`)
    REFERENCES `depdimensional`.`dim_date` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
