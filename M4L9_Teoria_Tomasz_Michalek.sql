
--1
 create role user_training with login password 'nxMHTJjjjhjtmXb;';

--2
 drop schema if exists training cascade;

create schema training authorization user_training;

--3
--drop role user_training;
--brak mozliwosci usuniecia

--4
reassign owned by user_training to postgres;

drop owned by user_training;

drop role user_training;

--5
reassign owned by reporting_ro to postgres;

drop owned by reporting_ro;

drop role if exists reporting_ro;

create role reporting_ro ;

grant connect on
database postgres to reporting_ro;

grant create on
schema training to reporting_ro;

grant all privileges on
all tables in schema training to reporting_ro;

--6
drop role if exists reporting_user;

create role reporting_user with login password '72KWTJmmmhjtmXb';

grant reporting_ro to reporting_user;

--7
 create table training.proba (id integer);
--tabela zostala utworzona

--8
revoke create on
schema training
from
reporting_ro;

--9
create table if not exists training.proba2 (id integer);
--permission denied
 create table if not exists public.proba2 (id integer);
--permission denied