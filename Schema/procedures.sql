-- Front-end Procedures

DELIMITER //

-- Departments
CREATE PROCEDURE IF NOT EXISTS `departments_view`()
BEGIN
    START TRANSACTION;
        SELECT * FROM `vdepartments`;
    COMMIT;
END//

CREATE PROCEDURE IF NOT EXISTS `departments_insert`(IN `input_v1` VARCHAR(30))
BEGIN
    START TRANSACTION;
        INSERT INTO `departments` (`department`)
        VALUES (`input_v1`);
    COMMIT;
END//

CREATE PROCEDURE IF NOT EXISTS `departments_update`(IN `input_v1` VARCHAR(30), IN `input_v2` VARCHAR(30))
BEGIN
    START TRANSACTION;
        UPDATE `departments` SET `department` = `input_v2` WHERE `department` LIKE `input_v1`;
    COMMIT;
END//

CREATE PROCEDURE IF NOT EXISTS `departments_delete`(IN `input_v1` VARCHAR(30))
BEGIN
    START TRANSACTION;
        DELETE FROM `departments` WHERE `department` LIKE `input_v1`;
    COMMIT;
END//

-- Domains
CREATE PROCEDURE IF NOT EXISTS `domains_view`()
BEGIN
    START TRANSACTION;
        SELECT * FROM `vdomains`;
    COMMIT;
END//

CREATE PROCEDURE IF NOT EXISTS `domains_insert`(IN `input_v1` VARCHAR(30))
BEGIN
    START TRANSACTION;
        INSERT INTO `domains` (`domain`)
        VALUES (`input_v1`);
    COMMIT;
END//

CREATE PROCEDURE IF NOT EXISTS `domains_update`(IN `input_v1` VARCHAR(30), IN `input_v2` VARCHAR(30))
BEGIN
    START TRANSACTION;
        UPDATE `domains` SET `domain` = `input_v2` WHERE `domain` = `input_v1`;
    COMMIT;
END//

CREATE PROCEDURE IF NOT EXISTS `domains_delete`(IN `input_v1` VARCHAR(30))
BEGIN
    START TRANSACTION;
        DELETE FROM `domains` WHERE `domain` = `input_v1`;
    COMMIT;
END//

-- Users
CREATE PROCEDURE IF NOT EXISTS `users_view`()
BEGIN
    START TRANSACTION;
        SELECT * FROM `vusers`;
    COMMIT;
END//

CREATE PROCEDURE IF NOT EXISTS `users_insert`(IN `input_v1` VARCHAR(30), IN `input_v2` VARCHAR(30), IN `input_v3` VARCHAR(30))
BEGIN
    START TRANSACTION;
        INSERT INTO `users` (`first_name`, `last_name`, `department_id`)
        VALUES (
            `input_v1`,
            `input_v2`,
            (SELECT `id` FROM `departments` WHERE `department` LIKE `input_v3`));
    COMMIT;
END//

CREATE PROCEDURE IF NOT EXISTS `users_update`(IN `input_v1` VARCHAR(30), IN `input_v2` VARCHAR(30), IN `input_v3` VARCHAR(30), IN `input_v4` VARCHAR(30), IN `input_v5` VARCHAR(30), IN `input_v6` VARCHAR(30))
BEGIN
    START TRANSACTION;
        UPDATE `users` SET
            `first_name` = `input_v1`,
            `last_name` = `input_v2`,
            `department_id` = (SELECT `id` FROM `departments` WHERE `department` = `input_v3`)
        WHERE
            `first_name` LIKE `input_v4`
            AND `last_name` LIKE `input_v5`
            AND (`department_id` = (SELECT `id` FROM `departments` WHERE `department` LIKE `input_v6`) OR `department_id` IS NULL);
    COMMIT;
END//

CREATE PROCEDURE IF NOT EXISTS `users_delete`(IN `input_v1` VARCHAR(30), IN `input_v2` VARCHAR(30))
BEGIN
    START TRANSACTION;
        DELETE FROM `users` WHERE `first_name` LIKE `input_v1` AND `last_name` LIKE `input_v2`;
    COMMIT;
END//

-- User Mailboxes
CREATE PROCEDURE IF NOT EXISTS `users_mbs_view`()
BEGIN
    START TRANSACTION;
        SELECT * FROM `vusers_mbs`;
    COMMIT;
END//

CREATE PROCEDURE IF NOT EXISTS `users_mbs_insert`(IN `input_v1` VARCHAR(30), IN `input_v2` VARCHAR(30), IN `input_v3` VARCHAR(30), IN `input_v4` VARCHAR(30), IN `input_v5` VARCHAR(30))
BEGIN
    START TRANSACTION;
        INSERT INTO `users_mbs` (`username`, `domain_id`, `owner_id`, `password`)
        VALUES (
            `input_v1`,
            (SELECT `id` FROM `domains` WHERE `domain` = `input_v2`),
            (SELECT `id` FROM `users` WHERE `first_name` LIKE `input_v3` AND `last_name` LIKE `input_v4`),
            `input_v5`);
    COMMIT;
END//

CREATE PROCEDURE IF NOT EXISTS `users_mbs_update`(IN `input_v1` VARCHAR(30), IN `input_v2` VARCHAR(30), IN `input_v3` VARCHAR(30), IN `input_v4` VARCHAR(30), IN `input_v5` VARCHAR(30), IN `input_v6` VARCHAR(30), IN `input_v7` VARCHAR(30), IN `input_v8` VARCHAR(30), IN `input_v9` VARCHAR(30), IN `input_v10` VARCHAR(30))
BEGIN
    START TRANSACTION;
        UPDATE `users_mbs` SET
            `username` = `input_v1`,
            `domain_id` = (SELECT `id` FROM `domains` WHERE `domain` = `input_v2`),
            `owner_id` = (SELECT `id` FROM `users` WHERE `first_name` LIKE `input_v3` AND `last_name` LIKE `input_v4`),
            `password` = `input_v5`
        WHERE
            `username` = `input_v6` AND
            `domain_id` = (SELECT `id` FROM `domains` WHERE `domain` = `input_v7`) AND
            `owner_id` = (SELECT `id` FROM `users` WHERE `first_name` LIKE `input_v8` AND `last_name` LIKE `input_v9`) AND
            `password` = `input_v10`;
    COMMIT;
END//

CREATE PROCEDURE IF NOT EXISTS `users_mbs_delete`(IN `input_v1` VARCHAR(30), IN `input_v2` VARCHAR(30))
BEGIN
    START TRANSACTION;
        DELETE FROM `users_mbs` WHERE `username` = `input_v1` AND `domain_id` = (SELECT `id` FROM `domains` WHERE `domain` = `input_v2`);
    COMMIT;
END//

-- Group Mailboxes
CREATE PROCEDURE IF NOT EXISTS `group_mbs_view`()
BEGIN
    START TRANSACTION;
        SELECT * FROM `vgroup_mbs`;
    COMMIT;
END//

CREATE PROCEDURE IF NOT EXISTS `group_mbs_insert`(IN `input_v1` VARCHAR(30), IN `input_v2` VARCHAR(30), IN `input_v3` VARCHAR(30), IN `input_v4` VARCHAR(30))
BEGIN
    START TRANSACTION;
        INSERT INTO `group_mbs` (`group_username`, `domain_id`, `department_id`, `password`)
        VALUES (
            `input_v1`,
            (SELECT `id` FROM `domains` WHERE `domain` = `input_v2`),
            (SELECT `id` FROM `departments` WHERE `department` LIKE `input_v3`),
            `input_v4`);
    COMMIT;
END//

CREATE PROCEDURE IF NOT EXISTS `group_mbs_update`(IN `input_v1` VARCHAR(30), IN `input_v2` VARCHAR(30), IN `input_v3` VARCHAR(30), IN `input_v4` VARCHAR(30), IN `input_v5` VARCHAR(30), IN `input_v6` VARCHAR(30), IN `input_v7` VARCHAR(30), IN `input_v8` VARCHAR(30))
BEGIN
    START TRANSACTION;
        UPDATE `group_mbs` SET
            `group_username` = `input_v1`,
            `domain_id` = (SELECT `id` FROM `domains` WHERE `domain` = `input_v2`),
            `department_id` = (SELECT `id` FROM `departments` WHERE `department` LIKE `input_v3`),
            `password` = `input_v4`
        WHERE
            `group_username` = `input_v5` AND
            `domain_id` = (SELECT `id` FROM `domains` WHERE `domain` = `input_v6`) AND
            (`department_id` = (SELECT `id` FROM `departments` WHERE `department` LIKE `input_v7`) OR `department_id` IS NULL) AND
            `password` = `input_v8`;
    COMMIT;
END//

CREATE PROCEDURE IF NOT EXISTS `group_mbs_delete`(IN `input_v1` VARCHAR(30), IN `input_v2` VARCHAR(30))
BEGIN
    START TRANSACTION;
        DELETE FROM `group_mbs` WHERE `group_username` = `input_v1` AND `domain_id` = (SELECT `id` FROM `domains` WHERE `domain` = `input_v2`);
    COMMIT;
END//

-- Group Access
CREATE PROCEDURE IF NOT EXISTS `group_access_view`()
BEGIN
    START TRANSACTION;
        SELECT * FROM `vgroup_access`;
    COMMIT;
END//

CREATE PROCEDURE IF NOT EXISTS `group_access_insert`(IN `input_v1` VARCHAR(30), IN `input_v2` VARCHAR(30), IN `input_v3` VARCHAR(30), IN `input_v4` VARCHAR(30), IN `input_v5` VARCHAR(30))
BEGIN
    START TRANSACTION;
        INSERT INTO `group_access` (`user_id`, `group_mb_id`, `app_password`)
        VALUES (
            (SELECT `id` FROM `users` WHERE `first_name` LIKE `input_v1` AND `last_name` LIKE `input_v2`),
            (SELECT `id` FROM `group_mbs` WHERE `group_username` = `input_v3` AND `domain_id` = (SELECT `id` FROM `domains` WHERE `domain` = `input_v4`)),
            `input_v5`);
    COMMIT;
END//

CREATE PROCEDURE IF NOT EXISTS `group_access_update`(IN `input_v1` VARCHAR(30), IN `input_v2` VARCHAR(30), IN `input_v3` VARCHAR(30), IN `input_v4` VARCHAR(30), IN `input_v5` VARCHAR(30), IN `input_v6` VARCHAR(30), IN `input_v7` VARCHAR(30), IN `input_v8` VARCHAR(30), IN `input_v9` VARCHAR(30), IN `input_v10` VARCHAR(30))
BEGIN
    START TRANSACTION;
        UPDATE `group_access` SET
            `user_id` = (SELECT `id` FROM `users` WHERE `first_name` LIKE `input_v1` AND `last_name` LIKE `input_v2`),
            `group_mb_id` = (SELECT `id` FROM `group_mbs` WHERE `group_username` = `input_v3` AND `domain_id` = (SELECT `id` FROM `domains` WHERE `domain` = `input_v4`)),
            `app_password` = `input_v5`
        WHERE
            (`user_id` = (SELECT `id` FROM `users` WHERE `first_name` LIKE `input_v6` AND `last_name` LIKE `input_v7`) OR `user_id` IS NULL ) AND
            `group_mb_id` = (SELECT `id` FROM `group_mbs` WHERE `group_username` = `input_v8` AND `domain_id` = (SELECT `id` FROM `domains` WHERE `domain` = `input_v9`)) AND
            `app_password` = `input_v10`;
    COMMIT;
END//

CREATE PROCEDURE IF NOT EXISTS `group_access_delete`(IN `input_v1` VARCHAR(30), IN `input_v2` VARCHAR(30), IN `input_v3` VARCHAR(30), IN `input_v4` VARCHAR(30))
BEGIN
    START TRANSACTION;
        DELETE FROM `group_access` WHERE `user_id` = (SELECT `id` FROM `users` WHERE `first_name` LIKE `input_v1` AND `last_name` LIKE `input_v2`) AND `group_mb_id` = (SELECT `id` FROM `group_mbs` WHERE `group_username` = `input_v3` AND `domain_id` = (SELECT `id` FROM `domains` WHERE `domain` = `input_v4`));
    COMMIT;
END//

DELIMITER ;