-- Queries

-- Departments
CALL `departments_view`();
CALL `departments_insert`('Technicians');
CALL `departments_update`('Technicians', 'Techs');
CALL `departments_delete`('Techs');

-- Domains
CALL `domains_view`();
CALL `domains_insert`('example.com');
CALL `domains_update`('example.com', 'example.org');
CALL `domains_delete`('example.org');

-- Users
Call `users_view`();
CALL `users_insert`('Mo', 'Alaa', 'Sales');
CALL `users_update`('Emily', 'Milla', 'finance', 'emily', 'miller', 'finance');
CALL `users_delete`('john', 'doe');

-- User Mailboxes
CALL `users_mbs_view`();
CALL `users_mbs_insert`('moalaa', 'example1.com', 'mo', 'alaa', 'bigger');
CALL `users_mbs_update`('lucygreen', 'example4.com', 'david', 'wilson', 'password101', 'lucybrown', 'example4.com', 'lucy', 'brown', 'password101');
CALL `users_mbs_delete`('davidwilson', 'example3.com');

-- Group Mailboxes
CALL `group_mbs_view`();
CALL `group_mbs_insert`('moalaatraining', 'example1.com', 'Risk', 'passwd1');
CALL `group_mbs_update`('financegroup', 'example2.com', 'finance', 'group456', 'financegroup', 'example1.com', 'finance', 'group456');
CALL `group_mbs_delete`('financegroup', 'example1.com');

-- Group Access
CALL `group_access_view`();
CALL `group_access_insert`('mark', 'johnson', 'businessgroup', 'example3.com', 'access505');
CALL `group_access_update`('michael', 'davis', 'salesgroup', 'example2.com', 'access202', 'michael', 'davis', 'legalgroup', 'example4.com', 'access202');
CALL `group_access_delete`('sarah', 'moore', 'businessgroup', 'example3.com');