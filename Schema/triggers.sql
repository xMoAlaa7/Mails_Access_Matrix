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