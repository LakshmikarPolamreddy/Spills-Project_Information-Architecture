-- create table syntax for 'spill_incidents' in our OLTP schema named 'final_project_oltp'

CREATE TABLE final_project_oltp.`spill_incidents` (
`spill_number` VARCHAR(10)  ,
  `street_address` VARCHAR(60) ,
  `locality` VARCHAR(50) ,
  `county_name` VARCHAR(50),
  `swis_code` VARCHAR(5) ,
  `dec_region` integer ,
  `spill_date` varchar(10) ,
  `receiving_date` varchar(10) ,
  `contributing_factor` VARCHAR(50) ,
  `main_source` VARCHAR(50),
  `close_date` varchar(10) ,
  `material_name` VARCHAR(125) ,
  `material_family` VARCHAR(250) ,
  `quantity` INT,
  `unit_of_measurement` VARCHAR(10)   
) ENGINE=InnoDB;

-- Inserting a new row to check the after insert trigger action in our final_project_olap schema

insert into final_project_oltp.`spill_incidents` values(
95821678, '48 high street', 'jersey city', 'new jersey',5000, 4, '08-05-2023', '08-05-2023', 
'unknown', 'unknown', '10-05-2023', 'petrolium','transformer oil', '100', 'gallons') ;
