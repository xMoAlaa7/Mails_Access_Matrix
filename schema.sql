-- Tables

-- Table for Departments
CREATE TABLE IF NOT EXISTS `departments` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `department` VARCHAR(30) UNIQUE NOT NULL,
    CONSTRAINT `departments_id_pk` PRIMARY KEY (`id`)
);

-- Table for Domains
CREATE TABLE IF NOT EXISTS `domains` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `domain` VARCHAR(30) UNIQUE NOT NULL,
    CONSTRAINT `domains_id_pk` PRIMARY KEY (`id`)
);

-- Table for Users
CREATE TABLE IF NOT EXISTS `users` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `first_name` VARCHAR(30) NOT NULL,
    `last_name` VARCHAR(30) NOT NULL,
    `department_id` INT UNSIGNED,
    CONSTRAINT `users_id_pk` PRIMARY KEY (`id`),
    CONSTRAINT `users_department_id_fk` FOREIGN KEY (`department_id`) REFERENCES `departments`(`id`) ON DELETE SET NULL
);

-- Table for User mailboxes
CREATE TABLE IF NOT EXISTS `users_mbs` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `username` VARCHAR(30) NOT NULL,
    `domain_id` INT UNSIGNED NOT NULL,
    `owner_id` INT UNSIGNED NOT NULL,
    `password` VARCHAR(30) NOT NULL,
    CONSTRAINT `users_mbs_id_pk` PRIMARY KEY (`id`),
    CONSTRAINT `users_mbs_username_domain_id_uk` UNIQUE (`username`, `domain_id`),
    CONSTRAINT `users_mbs_domain_id_fk` FOREIGN KEY (`domain_id`) REFERENCES `domains`(`id`) ON DELETE CASCADE,
    CONSTRAINT `users_mbs_owner_id_fk` FOREIGN KEY (`owner_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
);

-- Table for Group mailboxes
CREATE TABLE IF NOT EXISTS `group_mbs` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `group_username` VARCHAR(30) NOT NULL,
    `domain_id` INT UNSIGNED NOT NULL,
    `department_id` INT UNSIGNED,
    `password` VARCHAR(30) NOT NULL,
    CONSTRAINT `group_mbs_id_pk` PRIMARY KEY (`id`),
    CONSTRAINT `group_mbs_group_username_domain_id_uk` UNIQUE (`group_username`, `domain_id`),
    CONSTRAINT `group_mbs_domain_id_fk` FOREIGN KEY (`domain_id`) REFERENCES `domains`(`id`) ON DELETE CASCADE,
    CONSTRAINT `group_mbs_department_id_fk` FOREIGN KEY (`department_id`) REFERENCES `departments`(`id`) ON DELETE SET NULL
);

-- Table for User access to Group mailboxes
CREATE TABLE IF NOT EXISTS `group_access` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_id` INT UNSIGNED,
    `group_mb_id` INT UNSIGNED NOT NULL,
    `app_password` VARCHAR(30),
    CONSTRAINT `group_access_id_pk` PRIMARY KEY (`id`),
    CONSTRAINT `group_access_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL,
    CONSTRAINT `group_access_group_mb_id_fk` FOREIGN KEY (`group_mb_id`) REFERENCES `group_mbs`(`id`) ON DELETE CASCADE,
    CONSTRAINT `group_access_user_group_uk` UNIQUE (`user_id`, `group_mb_id`)
);

-- Table for Logs
CREATE TABLE IF NOT EXISTS `logs` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `type` ENUM('Insert', 'Update') NOT NULL,
    `affected_table` ENUM('departments', 'domains', 'users', 'users_mbs', 'group_mbs', 'group_access') NOT NULL,
    `affected_record_id` INT UNSIGNED NOT NULL,
    `action_timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `logs_id_pk` PRIMARY KEY (`id`)
);

-- Table for Deletion Logs
CREATE TABLE IF NOT EXISTS `deletion_logs` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `affected_table` ENUM('departments', 'domains', 'users', 'users_mbs', 'group_mbs', 'group_access') NOT NULL,
    `first_identifier` VARCHAR(50),
    `second_identifier` VARCHAR(50),
    `action_timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `deletion_logs_id_pk` PRIMARY KEY (`id`)
);

-- Views

-- Views for Departments
CREATE VIEW IF NOT EXISTS `vdepartments` AS
SELECT `department`
FROM `departments`
ORDER BY `department`;

-- Views for Domains
CREATE VIEW IF NOT EXISTS `vdomains` AS
SELECT `domain`
FROM `domains`
ORDER BY `domain`;

-- Views for Users
CREATE VIEW IF NOT EXISTS `vusers` AS
SELECT
    `first_name`,
    `last_name`,
    CASE
        WHEN `department` IS NULL THEN 'Deactivated Department'
        ELSE `department`
    END AS `user_department`
FROM `users`
JOIN `departments` ON `department_id` = `departments`.`id`
ORDER BY `user_department`, `first_name`, `last_name`;

-- Views for User Mailboxes
CREATE VIEW IF NOT EXISTS `vusers_mbs` AS
SELECT
    CONCAT(`username`, '@', `domain`) AS 'mailbox_address',
    CONCAT(`first_name`, ' ', `last_name`) AS 'owner_name'
FROM `users_mbs`
JOIN `domains` ON `domain_id` = `domains`.`id`
JOIN `users` ON `owner_id` = `users`.`id`
ORDER BY `domain_id`, `username`;

-- Views for Group Mailboxes
CREATE VIEW IF NOT EXISTS `vgroup_mbs` AS
SELECT
    CONCAT(`group_username`, '@', `domain`) AS 'mailbox_address',
    CASE
        WHEN `department` IS NULL THEN 'Deactivated Department'
        ELSE `department`
    END AS `group_department`
FROM `group_mbs`
JOIN `domains` ON `domain_id` = `domains`.`id`
JOIN `departments` ON `department_id` = `departments`.`id`
ORDER BY `domain_id`, `group_username`;

-- Views for Group Access
CREATE VIEW IF NOT EXISTS `vgroup_access` AS
SELECT
    CONCAT(`first_name`, ' ', `last_name`) AS 'access_to',
    CONCAT(`group_username`, '@', `domain`) AS `access_on`
FROM `group_access`
JOIN `users` ON `user_id` = `users`.`id`
JOIN `group_mbs` ON `group_mb_id` = `group_mbs`.`id`
JOIN `domains` ON `domain_id` = `domains`.`id`
ORDER BY `access_to`, `access_on`;

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

-- Logging Triggers

DELIMITER //

-- Logging Triggers for Departments
CREATE TRIGGER IF NOT EXISTS `log_in_departments`
BEFORE INSERT ON `departments`
FOR EACH ROW
BEGIN
    CALL `log_insert`('departments', NEW.`id`);
END//

CREATE TRIGGER IF NOT EXISTS `log_up_departments`
BEFORE UPDATE ON `departments`
FOR EACH ROW
BEGIN
    CALL `log_update`('departments', OLD.`id`);
END//

CREATE TRIGGER IF NOT EXISTS `log_del_departments`
BEFORE DELETE ON `departments`
FOR EACH ROW
BEGIN
    CALL `log_delete`('departments', OLD.`department`, NULL);
END//

-- Logging Triggers for Domains
CREATE TRIGGER IF NOT EXISTS `log_in_domains`
BEFORE INSERT ON `domains`
FOR EACH ROW
BEGIN
    CALL `log_insert`('domains', NEW.`id`);
END//

CREATE TRIGGER IF NOT EXISTS `log_up_domains`
BEFORE UPDATE ON `domains`
FOR EACH ROW
BEGIN
    CALL `log_update`('domains', OLD.`id`);
END//

CREATE TRIGGER IF NOT EXISTS `log_del_domains`
BEFORE DELETE ON `domains`
FOR EACH ROW
BEGIN
    CALL `log_delete`('domains', OLD.`domain`, NULL);
    DELETE FROM `users_mbs` WHERE `domain_id` = OLD.`id`;
    DELETE FROM `group_mbs` WHERE `domain_id` = OLD.`id`;
END//

-- Logging Triggers for Users
CREATE TRIGGER IF NOT EXISTS `log_in_users`
BEFORE INSERT ON `users`
FOR EACH ROW
BEGIN
    CALL `log_insert`('users', NEW.`id`);
END//

CREATE TRIGGER IF NOT EXISTS `log_up_users`
BEFORE UPDATE ON `users`
FOR EACH ROW
BEGIN
    CALL `log_update`('users', OLD.`id`);
END//

CREATE TRIGGER IF NOT EXISTS `log_del_users`
BEFORE DELETE ON `users`
FOR EACH ROW
BEGIN
    CALL `log_delete`('users', OLD.`first_name`, OLD.`last_name`);
    DELETE FROM `users_mbs` WHERE `owner_id` = OLD.`id`;
END//

-- Logging Triggers for User Mailboxes
CREATE TRIGGER IF NOT EXISTS `log_in_users_mbs`
BEFORE INSERT ON `users_mbs`
FOR EACH ROW
BEGIN
    CALL `log_insert`('users_mbs', NEW.`id`);
END//

CREATE TRIGGER IF NOT EXISTS `log_up_users_mbs`
BEFORE UPDATE ON `users_mbs`
FOR EACH ROW
BEGIN
    CALL `log_update`('users_mbs', OLD.`id`);
END//

CREATE TRIGGER IF NOT EXISTS `log_del_users_mbs`
BEFORE DELETE ON `users_mbs`
FOR EACH ROW
BEGIN
    CALL `log_delete`('users_mbs', OLD.`username`, (SELECT `domain` FROM `domains` WHERE `id` = OLD.`domain_id`));
END//

-- Logging Triggers for Group Mailboxes
CREATE TRIGGER IF NOT EXISTS `log_in_group_mbs`
BEFORE INSERT ON `group_mbs`
FOR EACH ROW
BEGIN
    CALL `log_insert`('group_mbs', NEW.`id`);
END//

CREATE TRIGGER IF NOT EXISTS `log_up_group_mbs`
BEFORE UPDATE ON `group_mbs`
FOR EACH ROW
BEGIN
    CALL `log_update`('group_mbs', OLD.`id`);
END//

CREATE TRIGGER IF NOT EXISTS `log_del_group_mbs`
BEFORE DELETE ON `group_mbs`
FOR EACH ROW
BEGIN
    CALL `log_delete`('group_mbs', OLD.`group_username`, (SELECT `domain` FROM `domains` WHERE `id` = OLD.`domain_id`));
    DELETE FROM `group_access` WHERE OLD.`id` = `group_mb_id`;
END//

-- Logging Triggers for Group Access
CREATE TRIGGER IF NOT EXISTS `log_in_group_access`
BEFORE INSERT ON `group_access`
FOR EACH ROW
BEGIN
    CALL `log_insert`('group_access', NEW.`id`);
END//

CREATE TRIGGER IF NOT EXISTS `log_up_group_access`
BEFORE UPDATE ON `group_access`
FOR EACH ROW
BEGIN
    CALL `log_update`('group_access', OLD.`id`);
END//

CREATE TRIGGER IF NOT EXISTS `log_del_group_access`
BEFORE DELETE ON `group_access`
FOR EACH ROW
BEGIN
    DECLARE first_identifier VARCHAR(60);
    DECLARE second_identifier VARCHAR(60);

    SELECT CONCAT(`first_name`, ' ',`last_name`)
    INTO first_identifier
    FROM `users` WHERE `users`.`id` = OLD.`user_id`;

    SELECT CONCAT(`group_username`, '@', `domain`)
    INTO second_identifier
    FROM `group_mbs`
    JOIN `domains` ON `domain_id` = `domains`.`id`
    WHERE `group_mbs`.`id` = OLD.`group_mb_id`;

    CALL `log_delete`('group_access', first_identifier, second_identifier);
END//

DELIMITER ;