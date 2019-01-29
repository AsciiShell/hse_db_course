create database if not exists airport;
use airport;


create table planes
(
  id             numeric(5),
  constraint pk_planes primary key (id),
  first_class    numeric(3),
  business_class numeric(3),
  economy_class  numeric(3)  not null,
  constraint ch_class check (economy_class >= 0 and first_class >= 0 and business_class >= 0),
  model          varchar(10) not null
) engine = innodb;

create table flight
(
  num         char(5)    not null,
  date_out    date       not null,
  constraint pk_flight primary key (num, date_out),
  date_in     date       not null,
  constraint ch_date check (date_in >= date_out),
  airport_out char(3)    not null,
  airport_in  char(3)    not null,
  plane_id    numeric(5) not null,
  constraint fk_planes foreign key (plane_id) references planes (id)
) engine = innodb;

create table passengers
(
  full_name     varchar(50) not null,
  doc_type      varchar(20) not null,
  series_number varchar(30) not null,
  born          date        not null,
  id            numeric(8),
  constraint pk_passengers primary key (id)
) engine = innodb;

create table tickets
(
  num          numeric(8)  not null,
  position     varchar(5)  not null,
  class_type   varchar(15) not null,
  price        numeric(7)  not null,
  bagage       bool        not null,
  flight_num   char(5)     not null,
  date_out     date        not null,
  constraint fk_flight foreign key (flight_num, date_out) references flight (num, date_out),
  passenger_id numeric(8),
  constraint fk_passengers foreign key (passenger_id) references passengers (id)
) engine = innodb;


insert into planes
  (id, economy_class, model)
values (123, 123, 'Model');

insert into flight
  (num, date_out, date_in, airport_out, airport_in, plane_id)
values (123, '2000-01-01', '2000-01-01', 123, 123, 123);

insert into passengers
  (full_name, doc_type, series_number, born, id)
values ('Test Name', 'Test Doc', 123, '2000-01-01', 123);

insert into tickets
  (num, position, class_type, price, bagage, flight_num, date_out, passenger_id)
values (123, 'Place', 'Economy', 123, 1, 123, '2000-01-01', 123);

desc planes;
desc flight;
desc passengers;
desc tickets;

select*
from planes;
select*
from flight;
select*
from passengers;
select*
from tickets;
