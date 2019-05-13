CREATE TABLE team
(
    name VARCHAR(40) PRIMARY KEY,
    note VARCHAR(500) NOT NULL
);

CREATE TABLE clients
(
    fio         VARCHAR(100) NOT NULL,
    ticket      INTEGER PRIMARY KEY,
    team_name   VARCHAR(40)  NOT NULL,
    birthday    DATE         NOT NULL,
    gender      CHAR(1)      NOT NULL CHECK ( gender IN ('m', 'f') ),
    weigh       INTEGER      NOT NULL CHECK ( weigh > 0 ),
    startTicker DATE         NOT NULL,
    endTicket   DATE         NOT NULL,
    phone       CHAR(11)     NOT NULL,
    CONSTRAINT fk_team_client FOREIGN KEY (team_name) REFERENCES team (name) ON DELETE CASCADE,
    CONSTRAINT ch_ticket CHECK (endTicket >= startTicker)
);
CREATE TABLE clients_archive
(
    fio         VARCHAR(100),
    ticket      INTEGER,
    team_name   VARCHAR(40),
    birthday    DATE,
    gender      CHAR(1),
    weigh       INTEGER,
    startTicker DATE,
    endTicket   DATE,
    phone       CHAR(11),
    archived_at DATE          NOT NULL,
    archived_by VARCHAR2(100) NOT NULL
);

CREATE TABLE coach
(
    id     NUMERIC(5) PRIMARY KEY,
    fio    VARCHAR(100) NOT NULL,
    status VARCHAR(50)  NOT NULL,
    phone  CHAR(11)     NOT NULL
);

CREATE TABLE schedulers
(
    id          NUMERIC(6) PRIMARY KEY,
    team_name   VARCHAR(40) NOT NULL,
    coach_id    NUMERIC(5)  NOT NULL,
    kind        VARCHAR(30) NOT NULL,
    room        CHAR(20)    NOT NULL CHECK (room IN ('Бассейн', 'Беговой', 'Силовой', 'Альпинизм')),
    day_of_week CHAR(4)     NOT NULL CHECK ( day_of_week IN ('вс', 'пн', 'вт', 'ср', 'чт', 'пт', 'сб') ),
    start_at    DATE        NOT NULL,
    end_at      DATE        NOT NULL,
    CONSTRAINT fk_team_scheduler FOREIGN KEY (team_name) REFERENCES team (name) ON DELETE CASCADE,
    CONSTRAINT fk_coach_scheduler FOREIGN KEY (coach_id) REFERENCES coach (id) ON DELETE CASCADE,
    CONSTRAINT ch_DATE CHECK ( end_at > start_at)
);

