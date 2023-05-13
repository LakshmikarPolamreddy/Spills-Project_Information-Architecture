
-- Create table syntax for schema named 'final_project_olap'
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------

-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema final_project_olap
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema final_project_olap
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `final_project_olap` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `final_project_olap` ;

-- -----------------------------------------------------
-- Table `final_project_olap`.`county_dim`
-- -----------------------------------------------------



CREATE TABLE IF NOT EXISTS `final_project_olap`.`county_dim` (
  `county_dim_id` INT NOT NULL AUTO_INCREMENT,
  `county_name` VARCHAR(50) NULL DEFAULT NULL,
  `swis_code` VARCHAR(5) NULL DEFAULT NULL,
  `dec_region` INT NULL DEFAULT NULL,
  PRIMARY KEY (`county_dim_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `final_project_olap`.`facility_dim`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project_olap`.`facility_dim` (
  `facility_dim_id` INT NOT NULL AUTO_INCREMENT,
  `street_address` VARCHAR(60) NULL DEFAULT NULL,
  `locality` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`facility_dim_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `final_project_olap`.`spill_dim`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project_olap`.`spill_dim` (
  `spill_dim_id` INT NOT NULL AUTO_INCREMENT,
  `spill_number` VARCHAR(10) NULL DEFAULT NULL,
  `spill_date` varchar(10) NULL DEFAULT NULL,
  `receiving_date` varchar(10) NULL DEFAULT NULL,
  `contributing_factor` VARCHAR(50) NULL DEFAULT NULL,
  `main_source` VARCHAR(50) NULL DEFAULT NULL,
  `close_date`varchar(10) NULL DEFAULT NULL,
  PRIMARY KEY (`spill_dim_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `final_project_olap`.`spill_material_dim`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project_olap`.`spill_material_dim` (
  `spill_material_dim_id` INT NOT NULL AUTO_INCREMENT,
  `material_name` VARCHAR(125) NULL DEFAULT NULL,
  `material_family_name` VARCHAR(250) NULL DEFAULT NULL,
  `unit_of_measurement` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`spill_material_dim_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `final_project_olap`.`spill_fact`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `final_project_olap`.`spill_fact` (
  `spill_id` INT NOT NULL,
  `facility_id` INT NOT NULL,
  `county_id` INT NOT NULL,
  `spill_material_id` INT NOT NULL,
  `quantity` INT NULL DEFAULT NULL,
  INDEX `facility_id` (`facility_id` ASC) VISIBLE,
  INDEX `county_id` (`county_id` ASC) VISIBLE,
  INDEX `spill_id` (`spill_id` ASC) VISIBLE,
  INDEX `spill_material_id` (`spill_material_id` ASC) VISIBLE,
  CONSTRAINT `spill_fact_ibfk_1`
    FOREIGN KEY (`facility_id`)
    REFERENCES `final_project_olap`.`facility_dim` (`facility_dim_id`),
  CONSTRAINT `spill_fact_ibfk_2`
    FOREIGN KEY (`county_id`)
    REFERENCES `final_project_olap`.`county_dim` (`county_dim_id`),
  CONSTRAINT `spill_fact_ibfk_3`
    FOREIGN KEY (`spill_id`)
    REFERENCES `final_project_olap`.`spill_dim` (`spill_dim_id`),
  CONSTRAINT `spill_fact_ibfk_4`
    FOREIGN KEY (`spill_material_id`)
    REFERENCES `final_project_olap`.`spill_material_dim` (`spill_material_dim_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Inserting Data into county_dim table from OLTP Spill_incident table using Insert Statment

insert into final_project_olap.county_dim
(county_name, swis_code, dec_region)
select county_name, swis_code, dec_region
from final_project_oltp.spill_incidents ;

-- Inserting Data into facility_dim table from OLTP Spill_incident table using Insert Statment
insert into final_project_olap.facility_dim
(street_address, locality)
select street_address, locality
from final_project_oltp.spill_incidents ;

-- Inserting Data into spill_dim table from OLTP Spill_incident table using Insert Statment
insert into final_project_olap.spill_dim
(spill_number, spill_date, receiving_date, contributing_factor, main_source, close_date)
select spill_number, spill_date, receiving_date, contributing_factor, main_source, close_date
from final_project_oltp.spill_incidents ;

-- Inserting Data into spill_material_dim table from OLTP Spill_incident table using Insert Statment
insert into final_project_olap.spill_material_dim
(material_name, material_family_name, unit_of_measurement)
select material_name, material_family, unit_of_measurement
from final_project_oltp.spill_incidents ;

-- Inserting Data into spill_fact table from OLTP Spill_incident table using Insert Statment



INSERT INTO final_project_olap.spill_fact 
(spill_id, facility_id, county_id, spill_material_id, quantity)
SELECT s.spill_dim_id, f.facility_dim_id, c.county_dim_id, m.spill_material_dim_id, si.quantity
FROM final_project_oltp.spill_incidents si
JOIN final_project_olap.spill_dim s ON si.spill_number = s.spill_number
JOIN final_project_olap.facility_dim f ON si.street_address = f.street_address
JOIN final_project_olap.county_dim c ON si.county_name = c.county_name
JOIN final_project_olap.spill_material_dim m ON si.material_name = m.material_name
WHERE NOT EXISTS (
  SELECT 1 FROM final_project_olap.spill_fact 
  WHERE spill_id = s.spill_dim_id 
  AND facility_id = f.facility_dim_id 
  AND county_id = c.county_dim_id 
  AND spill_material_id = m.spill_material_dim_id
)
LIMIT 400000;


-- After insert Trigger to update rows in all the dimension and fact table in OLAP Schema after insertion of row in final_project_oltp

DELIMITER $$
CREATE TRIGGER `update_olap_schema` AFTER
 INSERT ON `final_project_oltp`.`spill_incidents` FOR EACH ROW
BEGIN
    INSERT INTO `final_project_olap`.`spill_dim` 
    (`spill_number`, `spill_date`, `receiving_date`, `contributing_factor`, `main_source`, `close_date`)
    VALUES (NEW.`spill_number`, NEW.`spill_date`, NEW.`receiving_date`, NEW.`contributing_factor`, NEW.`main_source`, NEW.`close_date`);
    
    INSERT INTO `final_project_olap`.`facility_dim` (`street_address`, `locality`)
    VALUES (NEW.`street_address`, NEW.`locality`);
    
    INSERT INTO `final_project_olap`.`county_dim` (`county_name`, `swis_code`, `dec_region`)
    VALUES (NEW.`county_name`, NEW.`swis_code`, NEW.`dec_region`);
    
    INSERT INTO `final_project_olap`.`spill_material_dim` (`material_name`, `material_family_name`, `unit_of_measurement`)
    VALUES (NEW.`material_name`, NEW.`material_family`, NEW.`unit_of_measurement`);
    
    SET @spill_dim_id = LAST_INSERT_ID();
    SET @facility_dim_id = LAST_INSERT_ID();
    SET @county_dim_id = LAST_INSERT_ID();
    SET @spill_material_dim_id = LAST_INSERT_ID();
    
    INSERT INTO `final_project_olap`.`spill_fact` (`spill_id`, `facility_id`, `county_id`, `spill_material_id`, `quantity`)
    VALUES (@spill_dim_id, @facility_dim_id, @county_dim_id, @spill_material_dim_id, NEW.`quantity`);
END$$
DELIMITER ;


-- A stored Procedure UpdateSpillIncident() that will update all table in OLAP Data Warehouse

DELIMITER //

CREATE PROCEDURE final_project_olap.UpdateSpillIncident()
BEGIN
    -- Update county_dim
    UPDATE final_project_olap.county_dim c
    JOIN final_project_oltp.spill_incidents i ON i.county_name = c.county_name
    SET c.swis_code = i.swis_code,
        c.dec_region = i.dec_region
    WHERE i.county_name IS NOT NULL;

    -- Update facility_dim
    UPDATE final_project_olap.facility_dim f
    JOIN final_project_oltp.spill_incidents i ON i.street_address = f.street_address
    SET f.locality = i.locality
    WHERE i.street_address IS NOT NULL;

    -- Update spill_dim
    UPDATE final_project_olap.spill_dim d
    JOIN final_project_oltp.spill_incidents i ON i.spill_number = d.spill_number
    SET d.spill_date = i.spill_date,
        d.receiving_date = i.receiving_date,
        d.contributing_factor = i.contributing_factor,
        d.main_source = i.main_source,
        d.close_date = i.close_date
    WHERE i.spill_number IS NOT NULL;

    -- Update spill_material_dim
    UPDATE final_project_olap.spill_material_dim m
    JOIN final_project_oltp.spill_incidents i ON i.material_name = m.material_name
    SET m.material_family_name = i.material_family,
        m.unit_of_measurement = i.unit_of_measurement
    WHERE i.material_name IS NOT NULL;

    -- Update spill_fact
    UPDATE final_project_olap.spill_fact sf
    JOIN final_project_oltp.spill_incidents i ON sf.spill_id = (SELECT spill_dim_id FROM final_project_olap.spill_dim WHERE spill_number = i.spill_number)
                                              AND sf.facility_id = (SELECT facility_dim_id FROM final_project_olap.facility_dim WHERE street_address = i.street_address)
                                              AND sf.county_id = (SELECT county_dim_id FROM final_project_olap.county_dim WHERE county_name = i.county_name)
                                              AND sf.spill_material_id = (SELECT spill_material_dim_id FROM final_project_olap.spill_material_dim WHERE material_name = i.material_name)
    SET sf.quantity = i.quantity
    WHERE i.spill_number IS NOT NULL;

    COMMIT;
END //

DELIMITER ;

-- Calling Stored Procedure
CALL final_project_olap.UpdateSpillIncident();







