INSERT INTO `departments` (`id`, `department`)
VALUES
(1, 'Risk'),
(2, 'Business Development'),
(3, 'Procurement'),
(4, 'Marketing'),
(5, 'Sales'),
(6, 'Finance'),
(7, 'IT'),
(8, 'Legal'),
(9, 'Quality Assurance'),
(10, 'Payments and Onboarding');

INSERT INTO `domains` (`id`, `domain`)
VALUES
(1, 'example1.com'),
(2, 'example2.com'),
(3, 'example3.com'),
(4, 'example4.com');

INSERT INTO `users` (`id`, `first_name`, `last_name`, `department_id`)
VALUES
(1, 'John', 'Doe', 1),
(2, 'Jane', 'Smith', 2),
(3, 'Mark', 'Johnson', 3),
(4, 'Lucy', 'Brown', 4),
(5, 'Michael', 'Davis', 5),
(6, 'Emily', 'Miller', 6),
(7, 'David', 'Wilson', 7),
(8, 'Sarah', 'Moore', 8),
(9, 'James', 'Taylor', 9),
(10, 'Linda', 'Anderson', 10);

INSERT INTO `users_mbs` (`id`, `username`, `domain_id`, `owner_id`, `password`)
VALUES
(1, 'johndoe', 1, 1, 'password123'),
(2, 'janesmith', 2, 2, 'password456'),
(3, 'markjohnson', 3, 3, 'password789'),
(4, 'lucybrown', 4, 4, 'password101'),
(5, 'michaeldavis', 1, 5, 'password202'),
(6, 'emilymiller', 2, 6, 'password303'),
(7, 'davidwilson', 3, 7, 'password404'),
(8, 'sarahmoore', 4, 8, 'password505'),
(9, 'jamestaylor', 1, 9, 'password606'),
(10, 'lindaanderson', 2, 10, 'password707');

INSERT INTO `group_mbs` (`id`, `group_username`, `domain_id`, `department_id`, `password`)
VALUES
(1, 'marketinggroup', 4, 4, 'group123'),
(2, 'financegroup', 1, 6, 'group456'),
(3, 'salesgroup', 2, 5, 'group789'),
(4, 'itgroup', 3, 7, 'group101'),
(5, 'legalgroup', 4, 8, 'group202'),
(6, 'qualitygroup', 1, 9, 'group303'),
(7, 'procurementgroup', 2, 3, 'group404'),
(8, 'businessgroup', 3, 2, 'group505'),
(9, 'paymentsgroup', 4, 10, 'group606'),
(10, 'onboardinggroup', 1, 10, 'group707');

INSERT INTO `group_access` (`id`, `user_id`, `group_mb_id`, `app_password`)
VALUES
(1, 1, 1, 'access123'),
(3, 3, 3, 'access789'),
(4, 4, 4, 'access101'),
(5, 5, 5, 'access202'),
(6, 6, 6, 'access303'),
(7, 7, 7, 'access404'),
(8, 8, 8, 'access505'),
(9, 9, 9, 'access606'),
(10, 10, 10, 'access707');