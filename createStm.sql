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
  CONSTRAINT `ch_ticket` CHECK (endTicket >= startTicker),
  CONSTRAINT `ch_phone_client` CHECK (phone NOT LIKE '%[^0-9]%')
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS `coach`
(
  id     NUMERIC(5) PRIMARY KEY,
  fio    VARCHAR(50) NOT NULL,
  status VARCHAR(50) NOT NULL,
  phone  CHAR(11)    NOT NULL,
  CONSTRAINT `ch_phone_coach` CHECK ( phone NOT LIKE '%[^0-9]%' )
) ENGINE = INNODB;

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