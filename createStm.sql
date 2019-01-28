CREATE DATABASE IF NOT EXISTS fitness;

USE fitness;

CREATE TABLE IF NOT EXISTS `team`
(
  name VARCHAR(40) PRIMARY KEY,
  note VARCHAR(500) NOT NULL
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS `client`
(
  fio         VARCHAR(50)      NOT NULL,
  ticket      INTEGER PRIMARY KEY AUTO_INCREMENT,
  team_name   VARCHAR(40)      NOT NULL,
  birthday    DATE             NOT NULL,
  gender      ENUM ('m', 'f')  NOT NULL,
  weigh       INTEGER UNSIGNED NOT NULL,
  startTicker DATE             NOT NULL,
  endTicket   DATE             NOT NULL,
  phone       CHAR(11)         NOT NULL,
  CONSTRAINT `fk_team_client` FOREIGN KEY (team_name) REFERENCES `team` (name) ON DELETE RESTRICT,
  CONSTRAINT `ch_ticket` CHECK (endTicket >= startTicker)
) ENGINE = INNODB;

DELIMITER $$

CREATE PROCEDURE `check_client`(IN startTime DATE, IN endTime DATE)
BEGIN
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
  CALL check_client(new.startTicker, new.endTicket);
  CALL check_phone(new.phone);
END$$

CREATE TRIGGER `client_before_update`
  BEFORE UPDATE
  ON `client`
  FOR EACH ROW
BEGIN
  CALL check_client(new.startTicker, new.endTicket);
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
  team_name   VARCHAR(40)                                         NOT NULL,
  coach_id    NUMERIC(5)                                          NOT NULL,
  kind        VARCHAR(30)                                         NOT NULL,
  room        ENUM ('Бассейн', 'Беговой', 'Силовой', 'Альпинизм') NOT NULL,
  day_of_week ENUM ('вс', 'пн', 'вт', 'ср', 'чт', 'пт', 'сб')     NOT NULL,
  start       TIME                                                NOT NULL,
  end         TIME                                                NOT NULL,
  CONSTRAINT `fk_team_scheduler` FOREIGN KEY (team_name) REFERENCES `team` (name) ON DELETE RESTRICT,
  CONSTRAINT `fk_coach_scheduler` FOREIGN KEY (coach_id) REFERENCES `coach` (id) ON DELETE RESTRICT,
  CONSTRAINT `ch_time` CHECK ( end > start )
) ENGINE = INNODB;

DELIMITER $$

CREATE PROCEDURE `check_scheduler`(IN startTime TIME, IN endTime TIME)
BEGIN
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
  CALL check_scheduler(new.start, new.end);
END$$

CREATE TRIGGER `scheduler_before_update`
  BEFORE UPDATE
  ON `scheduler`
  FOR EACH ROW
BEGIN
  CALL check_scheduler(new.start, new.end);
END$$

DELIMITER ;


