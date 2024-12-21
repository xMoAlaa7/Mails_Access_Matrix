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