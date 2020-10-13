
drop role if exists expense_tracker_user;

create role expense_tracker_user with login password '3k345jmmmkjtmxb';

revoke create on schema public from expense_tracker_user;

reassign owned by expense_tracker_group to postgres;

drop owned by expense_tracker_group;

drop role if exists expense_tracker_group;

create role expense_tracker_group;

drop schema if exists expense_tracker cascade;

create schema if not exists expense_tracker authorization expense_tracker_group;

grant connect on database postgres to expense_tracker_group;

grant all privileges on schema expense_tracker to expense_tracker_group; 

grant expense_tracker_group to expense_tracker_user;

---------------------------------------------------------------------------------

drop table if exists expense_tracker.users;

create table expense_tracker.users( 
id_user integer primary key, 
user_login varchar(25) not null, 
user_name varchar(50) not null, 
user_password varchar(100) not null, 
password_salt varchar(100) not null, 
active boolean default true not null, 
insert_date timestamp default current_timestamp, 
update_date timestamp default current_timestamp);


drop table if exists expense_tracker.transaction_type;

create table expense_tracker.transaction_type( 
id_trans_type integer primary key, 
transaction_type_name varchar(50) not null, 
active boolean default true not null, 
insert_date timestamp default current_timestamp, 
update_date timestamp default current_timestamp);



drop table if exists expense_tracker.transaction_category;

create table expense_tracker.transaction_category( 
id_trans_cat integer primary key, 
category_name varchar(50) not null, 
category_description varchar(250), 
active boolean default true not null, 
insert_date timestamp default current_timestamp, 
update_date timestamp default current_timestamp);


drop table if exists expense_tracker.bank_account_owner;

create table expense_tracker.bank_account_owner( 
id_ba_own integer primary key, 
owner_name varchar(50) not null, 
user_login integer not null, 
active boolean default true not null, 
insert_date timestamp default current_timestamp, 
update_date timestamp default current_timestamp);


drop table if exists expense_tracker.transaction_subcategory;

create table expense_tracker.transaction_subcategory(
id_trans_subcat integer primary key, 
id_trans_cat integer, 
subcategory_name varchar(50) not null, 
subcategory_description varchar(250), 
active boolean default true not null, 
insert_date timestamp default current_timestamp, 
update_date timestamp default current_timestamp,
foreign key (id_trans_cat) references expense_tracker.transaction_category(id_trans_cat));


drop table if exists expense_tracker.bank_account_types;

create table expense_tracker.bank_acount_types( 
id_ba_type integer primary key, 
ba_type varchar(50)not null, 
ba_desc varchar(250), 
active boolean default true not null,
is_common_account boolean default false not null, 
id_ba_own integer, insert_date timestamp default current_timestamp, 
update_date timestamp default current_timestamp,
foreign key(id_ba_own) references expense_tracker.bank_account_owner(id_ba_own));


drop table if exists expense_tracker.transaction_bank_account;

create table expense_tracker.transaction_bank_account( 
id_trans_ba integer primary key,
id_ba_own integer, 
id_ba_type integer, 
bank_account_name varchar(50) not null, 
ban_account_desc varchar(250), 
active boolean default true not null, 
insert_date timestamp default current_timestamp, 
update_date timestamp default current_timestamp,
foreign key(id_ba_own) references expense_tracker.bank_account_owner(id_ba_own),
foreign key(id_ba_type) references expense_tracker.bank_acount_types(id_ba_type));


drop table if exists expense_tracker.transactions;

create table expense_tracker.transactions( 
id_transaction integer primary key, 
id_trans_ba integer, 
id_trans_cat integer, 
id_trans_subcat integer, 
id_trans_type integer, 
id_user integer, 
transaction_date date default current_date, 
transaction_value numeric(9,2), 
transaction_description text, 
insert_date timestamp default current_timestamp, 
update_date timestamp default current_timestamp,
foreign key(id_trans_ba) references expense_tracker.transaction_bank_account(id_trans_ba),
foreign key(id_trans_cat) references expense_tracker.transaction_category(id_trans_cat),
foreign key(id_trans_subcat) references expense_tracker.transaction_subcategory(id_trans_subcat),
foreign key(id_trans_type) references expense_tracker.transaction_type(id_trans_type),
foreign key(id_user) references expense_tracker.users(id_user));










