create database electronic;

use electronic;

create table if not exists `components`
(
  id            int primary key auto_increment,
  name          varchar(50)  not null,
  nominal       NUMERIC(20)  not null,
  count_        int unsigned not null,
  delivery_date DATE         not null
);

INSERT INTO `components`
value (null, 'resistor', 100, 100, '2018-12-31'),
       (null, 'resistor', 200, 100, '2018-12-1'),
       (null, 'resistor', 300, 100, '2018-12-2'),
       (null, 'resistor', 100000, 100, '2018-12-3'),
       (null, 'resistor', 200000, 100, '2018-12-4'),
       (null, 'resistor', 300000, 100, '2018-12-5'),
       (null, 'resistor', 30000000, 100, '2018-12-6'),
       (null, 'resistor', 9000000, 100, '2018-12-7'),
       (null, 'resistor', 50000000, 100, '2018-12-8'),
       (null, 'resistor', 60000000, 100, '2018-12-9'),

       (null, 'LED', 111, 100, '2018-12-1'),
       (null, 'LED', 100, 100, '2018-12-2'),
       (null, 'LED', 10, 100, '2018-12-3'),
       (null, 'LED', 1, 100, '2018-12-4'),
       (null, 'LED', 101, 100, '2018-12-5'),
       (null, 'LED', 110, 100, '2018-12-6'),
       (null, 'LED', 11, 100, '2018-12-7'),
       (null, 'LED', 100, 100, '2018-10-8'),
       (null, 'LED', 100, 100, '2018-11-9'),
       (null, 'LED', 100, 100, '2017-12-10'),

       (null, 'capacity', 10, 0, '2018-12-31'),
       (null, 'capacity', 20, 10, '2018-12-1'),
       (null, 'capacity', 30, 20, '2018-12-2'),
       (null, 'capacity', 40000, 30, '2018-12-3'),
       (null, 'capacity', 50, 40, '2018-12-4'),
       (null, 'capacity', 60, 50, '2018-12-5'),
       (null, 'capacity', 70, 60, '2018-12-6'),
       (null, 'capacity', 100, 70, '2018-12-7'),
       (null, 'capacity', 200, 80, '2018-12-8'),
       (null, 'capacity', 300, 90, '2018-12-9');



