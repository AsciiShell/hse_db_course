CREATE DATABASE IF NOT EXISTS fitness;

USE fitness;

CREATE TABLE IF NOT EXISTS `group`
(
  name VARCHAR(20) PRIMARY KEY,
  note VARCHAR(500) NOT NULL
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS `client`
(
  fio         VARCHAR(50)      NOT NULL,
  ticket      INTEGER PRIMARY KEY AUTO_INCREMENT,
  group_name  VARCHAR(20)      NOT NULL REFERENCES `group` (name) ON DELETE SET NULL,
  birthday    DATE             NOT NULL,
  gender      CHAR             NOT NULL CHECK ( gender IN ('m', 'f') ),
  weigh       INTEGER UNSIGNED NOT NULL,
  startTicker DATE             NOT NULL,
  endTicket   DATE             NOT NULL CHECK ( endTicket >= startTicker ),
  phone       CHAR(11)         NOT NULL CHECK ( phone NOT LIKE '%[^0-9]%' )
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS `coach`
(
  id     INTEGER(5) PRIMARY KEY AUTO_INCREMENT,
  fio    VARCHAR(50) NOT NULL,
  status VARCHAR(50) NOT NULL,
  phone  CHAR(11)    NOT NULL CHECK ( phone NOT LIKE '%[^0-9]%' )
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS `scheduler`
(
  id          NUMERIC(6) PRIMARY KEY,
  group_name  VARCHAR(20) REFERENCES `group` (name) ON DELETE CASCADE,
  coach_id    NUMERIC(5)  NOT NULL,
  kind        VARCHAR(30) NOT NULL,
  room        VARCHAR(10) NOT NULL CHECK ( room IN ('Бассейн', 'Беговой', 'Силовой', 'Альминизм')),
  day_of_week CHAR(2)     NOT NULL CHECK ( day_of_week IN ('пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс')),
  start       TIME        NOT NULL,
  end         TIME        NOT NULL CHECK ( end > start )
) ENGINE = INNODB;