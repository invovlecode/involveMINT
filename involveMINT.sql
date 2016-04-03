-- MySQL Script generated by MySQL Workbench
-- 04/03/16 00:37:08
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema involvemint
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema involvemint
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `involvemint` DEFAULT CHARACTER SET utf8 ;
USE `involvemint` ;

-- -----------------------------------------------------
-- Table `involvemint`.`address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `involvemint`.`address` (
  `ADDRESS_PK` INT(11) NOT NULL AUTO_INCREMENT,
  `ADDR_TYPE` CHAR(1) NULL DEFAULT NULL COMMENT 'Address Type. H - Home, O - Office',
  `ADDRESS1` VARCHAR(50) NULL DEFAULT NULL,
  `ADDRESS2` VARCHAR(50) NULL DEFAULT NULL,
  `CITY` VARCHAR(50) NULL DEFAULT NULL,
  `STATE` VARCHAR(2) NULL DEFAULT NULL,
  `ZIP` VARCHAR(10) NULL DEFAULT NULL,
  `COUNTRY` VARCHAR(3) NULL DEFAULT NULL,
  `LATITUDE` DECIMAL(8,6) NULL DEFAULT NULL,
  `LONGITUDE` DECIMAL(8,6) NULL DEFAULT NULL,
  PRIMARY KEY (`ADDRESS_PK`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Address 	';


-- -----------------------------------------------------
-- Table `involvemint`.`organization`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `involvemint`.`organization` (
  `ORG_PK` INT(11) NOT NULL AUTO_INCREMENT,
  `ORG_TYPE` CHAR(1) NULL DEFAULT NULL COMMENT 'Organization Type. B - Business, O - Volunteer Organization',
  `ORG_NAME` VARCHAR(50) NULL DEFAULT NULL,
  `ORG_DESC` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Description of the organization. Stored as rich text',
  `PHONE` VARCHAR(20) NULL DEFAULT NULL,
  `EMAIL_ID` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Corporate contact e-mail',
  `WEBSITE_URL` VARCHAR(200) NULL DEFAULT NULL COMMENT 'URL of the company website',
  `IMAGE` BLOB NULL DEFAULT NULL,
  `IMAGE_URL` VARCHAR(200) NULL DEFAULT NULL COMMENT 'If the company image is available as a URL, this conatins the URL',
  `ADDRESS_PK` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`ORG_PK`),
  INDEX `fk_org_address_pk_idx` (`ADDRESS_PK` ASC),
  CONSTRAINT `fk_org_address_pk`
    FOREIGN KEY (`ADDRESS_PK`)
    REFERENCES `involvemint`.`address` (`ADDRESS_PK`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Represents an Organization, could be a Buisness/Volunteer Organization';


-- -----------------------------------------------------
-- Table `involvemint`.`user_profile`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `involvemint`.`user_profile` (
  `EMAIL_ID` VARCHAR(50) NOT NULL COMMENT 'Primary Key. E-Mail ID used as the user ID',
  `PASSWORD` VARCHAR(50) NOT NULL COMMENT 'Password of the account',
  `FIRST_NAME` VARCHAR(50) NULL DEFAULT NULL COMMENT 'First Name of the user',
  `LAST_NAME` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Last name of the user',
  `DOB` DATE NOT NULL COMMENT 'Date of Birth',
  `IMAGE` BLOB NULL DEFAULT NULL COMMENT 'Uploaded Image',
  `SEC_QUESTION1` VARCHAR(200) NULL DEFAULT NULL COMMENT 'Security Question 1 for forgot password',
  `SEC_ANSWER1` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Answer 1 for forgot password',
  `SEC_QUESTION2` VARCHAR(200) NULL DEFAULT NULL COMMENT 'Security Question 2 for forgot password',
  `SEC_ANSWER2` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Answer2 for forgot password',
  `SEC_QUESTION3` VARCHAR(200) NULL DEFAULT NULL COMMENT 'Security question 3 for forgot password',
  `SEC_ANSWER3` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Answer 3 for forgot password',
  `KEEP_LOGIN` CHAR(1) NULL DEFAULT NULL COMMENT 'Y/N flag to indicate auto login. If it is set to Y a cookie is set with sec_token and validated at the time of home page access',
  `SEC_TOKEN` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Security token (UUID) generated if keep_login is set to Y',
  `ORG_PK` INT(11) NULL DEFAULT NULL COMMENT 'Foreign Key to Organization if the user is from a Business/Volunteer organization',
  `ADDRESS_PK` INT(11) NULL DEFAULT NULL COMMENT 'Foreign Key to Address table',
  PRIMARY KEY (`EMAIL_ID`),
  INDEX `fk_up_org_pk_idx` (`ORG_PK` ASC),
  INDEX `fk_up_address_pk_idx` (`ADDRESS_PK` ASC),
  CONSTRAINT `fk_up_address_pk`
    FOREIGN KEY (`ADDRESS_PK`)
    REFERENCES `involvemint`.`address` (`ADDRESS_PK`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_up_org_pk`
    FOREIGN KEY (`ORG_PK`)
    REFERENCES `involvemint`.`organization` (`ORG_PK`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Stores user profile information';


-- -----------------------------------------------------
-- Table `involvemint`.`vol_causes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `involvemint`.`vol_causes` (
  `VOL_CAUSE_PK` INT(11) NOT NULL AUTO_INCREMENT,
  `VOL_CAUSE_NAME` VARCHAR(200) NULL DEFAULT NULL,
  `ACTIVE_IND` CHAR(1) NULL DEFAULT NULL,
  `WEIGHTAGE` DECIMAL(3,2) NULL DEFAULT NULL,
  PRIMARY KEY (`VOL_CAUSE_PK`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Cause for the volunteering activtiy';


-- -----------------------------------------------------
-- Table `involvemint`.`user_vol_causes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `involvemint`.`user_vol_causes` (
  `USER_CAUSE_PK` INT(11) NOT NULL AUTO_INCREMENT,
  `EMAIL_ID` VARCHAR(50) NULL DEFAULT NULL,
  `VOL_CAUSE_PK` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`USER_CAUSE_PK`),
  INDEX `fk_vol_causes_idx` (`VOL_CAUSE_PK` ASC),
  INDEX `fk_cause_user_profile_idx` (`EMAIL_ID` ASC),
  CONSTRAINT `fk_cause_user_profile`
    FOREIGN KEY (`EMAIL_ID`)
    REFERENCES `involvemint`.`user_profile` (`EMAIL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vol_causes`
    FOREIGN KEY (`VOL_CAUSE_PK`)
    REFERENCES `involvemint`.`vol_causes` (`VOL_CAUSE_PK`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'User preferences for volunteer causes';


-- -----------------------------------------------------
-- Table `involvemint`.`vol_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `involvemint`.`vol_types` (
  `VOL_TYPE_PK` INT(11) NOT NULL AUTO_INCREMENT,
  `VOL_TYPE_NAME` VARCHAR(50) NULL DEFAULT NULL,
  `ACTIVE_IND` CHAR(1) NULL DEFAULT NULL,
  `WEIGHTAGE` DECIMAL(3,2) NULL DEFAULT NULL,
  PRIMARY KEY (`VOL_TYPE_PK`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Volunteer Types';


-- -----------------------------------------------------
-- Table `involvemint`.`vol_projects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `involvemint`.`vol_projects` (
  `PROJECT_PK` INT(11) NOT NULL AUTO_INCREMENT,
  `PROJECT_DESC` VARCHAR(4000) NULL DEFAULT NULL,
  `EVENT_DATE` DATE NULL DEFAULT NULL,
  `START_TIME` TIME NULL DEFAULT NULL,
  `END_TIME` TIME NULL DEFAULT NULL,
  `VOL_TYPE_PK` INT(11) NULL DEFAULT NULL,
  `VOL_CAUSE_PK` INT(11) NULL DEFAULT NULL,
  `ORG_PK` INT(11) NULL DEFAULT NULL,
  `WHERE` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`PROJECT_PK`),
  INDEX `fk_prj_vol_type_pk_idx` (`VOL_TYPE_PK` ASC),
  INDEX `fk_prj_vol_cause_pk_idx` (`VOL_CAUSE_PK` ASC),
  INDEX `fk_prj_org_pk_idx` (`ORG_PK` ASC),
  CONSTRAINT `fk_prj_org_pk`
    FOREIGN KEY (`ORG_PK`)
    REFERENCES `involvemint`.`organization` (`ORG_PK`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_prj_vol_cause_pk`
    FOREIGN KEY (`VOL_CAUSE_PK`)
    REFERENCES `involvemint`.`vol_causes` (`VOL_CAUSE_PK`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_prj_vol_type_pk`
    FOREIGN KEY (`VOL_TYPE_PK`)
    REFERENCES `involvemint`.`vol_types` (`VOL_TYPE_PK`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Volunteer projects';


-- -----------------------------------------------------
-- Table `involvemint`.`user_vol_projects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `involvemint`.`user_vol_projects` (
  `USER_PROJ_PK` INT(11) NOT NULL AUTO_INCREMENT,
  `VOL_PROJ_PK` INT(11) NULL DEFAULT NULL,
  `EMAIL_ID` VARCHAR(50) NULL DEFAULT NULL,
  `TIME` INT(11) NULL DEFAULT NULL,
  `CREDITS` INT(11) NULL DEFAULT NULL,
  `STATUS` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`USER_PROJ_PK`),
  INDEX `fk_up_vol_proj_pk_idx` (`VOL_PROJ_PK` ASC),
  INDEX `fk_up_email_id_idx` (`EMAIL_ID` ASC),
  CONSTRAINT `fk_up_email_id`
    FOREIGN KEY (`EMAIL_ID`)
    REFERENCES `involvemint`.`user_profile` (`EMAIL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_up_vol_proj_pk`
    FOREIGN KEY (`VOL_PROJ_PK`)
    REFERENCES `involvemint`.`vol_projects` (`PROJECT_PK`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Projects a user signed up for';


-- -----------------------------------------------------
-- Table `involvemint`.`user_vol_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `involvemint`.`user_vol_types` (
  `USER_VOL_TYPE_PK` INT(11) NOT NULL AUTO_INCREMENT,
  `EMAIL_ID` VARCHAR(50) NULL DEFAULT NULL,
  `VOL_TYPE_PK` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`USER_VOL_TYPE_PK`),
  INDEX `fk_user_profile_idx` (`EMAIL_ID` ASC),
  INDEX `fk_vol_types_idx` (`VOL_TYPE_PK` ASC),
  CONSTRAINT `fk_user_profile`
    FOREIGN KEY (`EMAIL_ID`)
    REFERENCES `involvemint`.`user_profile` (`EMAIL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vol_types`
    FOREIGN KEY (`VOL_TYPE_PK`)
    REFERENCES `involvemint`.`vol_types` (`VOL_TYPE_PK`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'User preferences for volunteer types';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
