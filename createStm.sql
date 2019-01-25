CREATE DATABASE IF NOT EXISTS fitness;

USE fitness;

CREATE TABLE IF NOT EXISTS `team`
(
  name VARCHAR(20) PRIMARY KEY,
  note VARCHAR(500) NOT NULL
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS `client`
(
  fio         VARCHAR(50)      NOT NULL,
  ticket      INTEGER PRIMARY KEY AUTO_INCREMENT,
  team_name   VARCHAR(20)      NOT NULL,
  birthday    DATE             NOT NULL,
  gender      CHAR             NOT NULL,
  weigh       INTEGER UNSIGNED NOT NULL,
  startTicker DATE             NOT NULL,
  endTicket   DATE             NOT NULL,
  phone       CHAR(11)         NOT NULL,
  CONSTRAINT `fk_team_client` FOREIGN KEY (team_name) REFERENCES `team` (name) ON DELETE RESTRICT,
  CONSTRAINT `ch_gender` CHECK (gender IN ('m', 'f')),
  CONSTRAINT `ch_ticket` CHECK (endTicket >= startTicker)
) ENGINE = INNODB;

DELIMITER $$

CREATE PROCEDURE `check_client`(IN gender CHAR, IN startTime DATE, IN endTime DATE)
BEGIN
  IF NOT gender IN ('m', 'f') THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'check constraint on client.gender failed';
  END IF;

  IF startTime > endTime THEN
    SIGNAL SQLSTATE '45001'
      SET MESSAGE_TEXT = 'check constraint on client.time failed';
  END IF;
END$$

CREATE PROCEDURE `check_phone`(IN phone CHAR(11))
BEGIN
  IF REGEXP_LIKE(phone, '[^0-9]') THEN
    SIGNAL SQLSTATE '45002'
      SET MESSAGE_TEXT = 'check constraint on client.phone failed';
  END IF;
END $$

CREATE TRIGGER `client_before_insert`
  BEFORE INSERT
  ON `client`
  FOR EACH ROW
BEGIN
  CALL check_client(new.gender, new.startTicker, new.endTicket);
  CALL check_phone(new.phone);
END$$

CREATE TRIGGER `client_before_update`
  BEFORE UPDATE
  ON `client`
  FOR EACH ROW
BEGIN
  CALL check_client(new.gender, new.startTicker, new.endTicket);
  CALL check_phone(new.phone);
END$$

DELIMITER ;

CREATE TABLE IF NOT EXISTS `coach`
(
  id     NUMERIC(5) PRIMARY KEY,
  fio    VARCHAR(50) NOT NULL,
  status VARCHAR(50) NOT NULL,
  phone  CHAR(11)    NOT NULL
) ENGINE = INNODB;

DELIMITER $$

CREATE TRIGGER `coach_before_insert`
  BEFORE INSERT
  ON `coach`
  FOR EACH ROW
BEGIN
  CALL check_phone(new.phone);
END$$

CREATE TRIGGER `coach_before_update`
  BEFORE UPDATE
  ON `coach`
  FOR EACH ROW
BEGIN
  CALL check_phone(new.phone);
END$$

CREATE TABLE IF NOT EXISTS `scheduler`
(
  id          NUMERIC(6) PRIMARY KEY,
  team_name   VARCHAR(20) NOT NULL,
  coach_id    NUMERIC(5)  NOT NULL,
  kind        VARCHAR(30) NOT NULL,
  room        VARCHAR(10) NOT NULL,
  day_of_week CHAR(2)     NOT NULL,
  start       TIME        NOT NULL,
  end         TIME        NOT NULL,
  CONSTRAINT `fk_team_scheduler` FOREIGN KEY (team_name) REFERENCES `team` (name) ON DELETE RESTRICT,
  CONSTRAINT `fk_coach_scheduler` FOREIGN KEY (coach_id) REFERENCES `coach` (id) ON DELETE RESTRICT,
  CONSTRAINT `ch_room` CHECK ( room IN ('Бассейн', 'Беговой', 'Силовой', 'Альпинизм')),
  CONSTRAINT `ch_day` CHECK ( day_of_week IN ('пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс')),
  CONSTRAINT `ch_time` CHECK ( end > start )
) ENGINE = INNODB;

DELIMITER $$

CREATE PROCEDURE `check_scheduler`(IN room VARCHAR(10), IN day_of_week CHAR(2), IN startTime TIME, IN endTime TIME)
BEGIN
  IF NOT room IN ('Бассейн', 'Беговой', 'Силовой', 'Альпинизм') THEN
    SIGNAL SQLSTATE '45001'
      SET MESSAGE_TEXT = 'check constraint on scheduler.room failed';
  END IF;
  IF NOT day_of_week IN ('пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс') THEN
    SIGNAL SQLSTATE '45002'
      SET MESSAGE_TEXT = 'check constraint on scheduler.day_of_week failed';
  END IF;
  IF endTime <= startTime THEN
    SIGNAL SQLSTATE '45003'
      SET MESSAGE_TEXT = 'check constraint on scheduler.time failed';
  END IF;
END $$

CREATE TRIGGER `scheduler_before_insert`
  BEFORE INSERT
  ON `scheduler`
  FOR EACH ROW
BEGIN
  CALL check_scheduler(new.room, new.day_of_week, new.start, new.end);
END$$

CREATE TRIGGER `scheduler_before_update`
  BEFORE UPDATE
  ON `scheduler`
  FOR EACH ROW
BEGIN
  CALL check_scheduler(new.room, new.day_of_week, new.start, new.end);
END$$