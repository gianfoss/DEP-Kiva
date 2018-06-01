-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema deprelational
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema deprelational
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `deprelational` DEFAULT CHARACTER SET utf8 ;
USE `deprelational` ;

-- -----------------------------------------------------
-- Table `deprelational`.`Country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `deprelational`.`Country` (
  `country_id` INT NOT NULL,
  `country_name` VARCHAR(100) NOT NULL,
  `ISO` VARCHAR(100) NOT NULL,
  `population` INT NULL DEFAULT NULL,
  `population_below_poverty_line` VARCHAR(45) NULL DEFAULT NULL,
  `human_development_index` VARCHAR(45) NULL DEFAULT NULL,
  `life_expectancy` VARCHAR(45) NULL DEFAULT NULL,
  `mean_years_of_schooling` VARCHAR(45) NULL DEFAULT NULL,
  `gross_national_income` VARCHAR(45) NULL DEFAULT NULL,
  `expected_years_of_schooling`  VARCHAR(45) NULL DEFAULT NULL,
  `mpi_national` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`country_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `deprelational`.`Region`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `deprelational`.`Region` (
  `region_id` INT NOT NULL,
  `region_name` VARCHAR(100) NOT NULL,
  `lattitude` VARCHAR(45) NULL ,
  `longitude` VARCHAR(45) NULL,
  `mean_poverty_index` VARCHAR(45) NULL DEFAULT NULL,
  `country_id` INT NOT NULL, 
  `headcount_ratio_regional` VARCHAR(45) NULL DEFAULT NULL,
  `intensity_of_deprivation_regional` VARCHAR(45) NULL DEFAULT NULL,
  `rural_percent` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`region_id`),
  INDEX `fk_Region_Country1_idx` (`country_id` ASC),
  CONSTRAINT `fk_Region_Country1`
    FOREIGN KEY (`country_id`)
    REFERENCES `deprelational`.`Country` (`country_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `deprelational`.`Loan_Theme`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `deprelational`.`Loan_Theme` (
  `loan_theme_id` VARCHAR(100) NOT NULL,
  `loan_theme_type` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`loan_theme_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `deprelational`.`Partner`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `deprelational`.`Partner` (
  `partner_id` INT NOT NULL,
  `partner_name` VARCHAR(100) NOT NULL,
  `country_id` INT NOT NULL,
  PRIMARY KEY (`partner_id`),
  INDEX `fk_Partner_Country1_idx` (`country_id` ASC),
  CONSTRAINT `fk_Partner_Country1`
    FOREIGN KEY (`country_id`)
    REFERENCES `deprelational`.`Country` (`country_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `deprelational`.`Conversion_Rate`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `deprelational`.`Conversion_Rate` (
  `currency_id` INT NOT NULL,
  `currency` CHAR(3) NOT NULL,
  `conversion_rate` decimal(20,10) NOT NULL,
  PRIMARY KEY (`currency_id`))
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `deprelational`.`Loan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `deprelational`.`Loan` (
  `loan_id` INT NOT NULL,
  `funded_amount` VARCHAR(100) NOT NULL,
  `loan_amount` DECIMAL(20,10) NOT NULL,
  `activity` VARCHAR(100) NOT NULL,
  `sector` VARCHAR(100) NOT NULL,
  `repayment_interval` VARCHAR(100) NOT NULL,
  `tags` VARCHAR(500) NULL DEFAULT NULL,
  `term_in_month` INT NULL DEFAULT NULL,
  `loan_theme_id` VARCHAR(45) NOT NULL,
  `region_id` INT NULL DEFAULT NULL,
  `partner_id` INT NULL DEFAULT NULL,
  `currency_id` INT NOT NULL,
  `use` VARCHAR(900) NULL DEFAULT NULL,
  `posted_date` VARCHAR(15) NULL DEFAULT NULL,
  `disbursed_date` VARCHAR(15) NULL DEFAULT NULL,
  `funded_date` VARCHAR(15) NULL DEFAULT NULL,
  PRIMARY KEY (`loan_id`),
  INDEX `fk_Loan_loan_theme_idx` (`loan_theme_id` ASC),
  INDEX `fk_Loan_Region1_idx` (`region_id` ASC),
  INDEX `fk_Loan_Partner1_idx` (`partner_id` ASC),
  INDEX `fk_Loan_Conversion_Rate1_idx` (`currency_id` ASC),
  CONSTRAINT `fk_Loan_loan_theme`
    FOREIGN KEY (`loan_theme_id`)
    REFERENCES `deprelational`.`Loan_Theme` (`loan_theme_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Loan_Region1`
    FOREIGN KEY (`region_id`)
    REFERENCES `deprelational`.`Region` (`region_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Loan_Partner1`
    FOREIGN KEY (`partner_id`)
    REFERENCES `deprelational`.`Partner` (`partner_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Loan_Conversion_Rate1`
    FOREIGN KEY (`currency_id`)
    REFERENCES `deprelational`.`Conversion_Rate` (`currency_id`)
	ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `deprelational`.`Borrower_Gender`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `deprelational`.`Borrower_Gender` (
  `gender_id` INT NOT NULL,
  `gender` VARCHAR(10) NULL,
  PRIMARY KEY (`gender_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `deprelational`.`Gender_Loan_Relationship`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `deprelational`.`Gender_Loan_Relationship` (
  `Gender_Loan_ID` INT NOT NULL,
  `gender_id` INT NOT NULL,
  `loan_id` INT NOT NULL,
  PRIMARY KEY (`Gender_Loan_ID`),
  INDEX `fk_Borrower Gender_has_Loan_Loan1_idx` (`loan_id` ASC),
  INDEX `fk_Borrower Gender_has_Loan_Borrower Gender1_idx` (`gender_id` ASC),
  CONSTRAINT `fk_Borrower Gender_has_Loan_Borrower Gender1`
    FOREIGN KEY (`gender_id`)
    REFERENCES `deprelational`.`Borrower_Gender` (`gender_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Borrower Gender_has_Loan_Loan1`
    FOREIGN KEY (`loan_id`)
    REFERENCES `deprelational`.`Loan` (`loan_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
