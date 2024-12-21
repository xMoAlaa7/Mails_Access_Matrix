-- Procedures for Logging
DELIMITER //

CREATE PROCEDURE IF NOT EXISTS `log_insert`(IN `table_name` VARCHAR(30), IN `record_id` INT UNSIGNED)
BEGIN
    INSERT INTO `logs` (`type`, `affected_table`, `affected_record_id`)
    VALUES ('Insert', `table_name`, `record_id`);
END//

CREATE PROCEDURE IF NOT EXISTS `log_update`(IN `table_name` VARCHAR(30), IN `record_id` INT UNSIGNED)
BEGIN
    INSERT INTO `logs` (`type`, `affected_table`, `affected_record_id`)
    VALUES ('Update', `table_name`, `record_id`);
END//

CREATE PROCEDURE IF NOT EXISTS `log_delete`(IN `table_name` VARCHAR(30), IN `first_identifier` VARCHAR(50), IN `second_identifier` VARCHAR(50))
BEGIN
    INSERT INTO `deletion_logs` (`affected_table`, `first_identifier`, `second_identifier`)
    VALUES (`table_name`, `first_identifier`, `second_identifier`);
END//

DELIMITER ;