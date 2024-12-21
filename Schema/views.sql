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