CREATE OR REPLACE TRIGGER client_check
    BEFORE INSERT OR UPDATE
    ON CLIENTS
    FOR EACH ROW
BEGIN
    IF :new.BIRTHDAY is not null and (sysdate - :new.BIRTHDAY) / 365 < 14 THEN
        RAISE_APPLICATION_ERROR(num => -20000, msg => 'User age must be more than 14');
    end if;
    IF :new.GENDER is not null and (:new.GENDER NOT IN ('m', 'f')) THEN
        RAISE_APPLICATION_ERROR(num => -20000, msg => 'User gender must be м or ж');
    end if;
    IF :new.WEIGH is not null and (:new.WEIGH < 40) THEN
        RAISE_APPLICATION_ERROR(num => -20000, msg => 'User should eat more');
    end if;

    IF :new.ENDTICKET is not null and :new.STARTTICKER is not null and (:new.ENDTICKET <= :new.STARTTICKER) THEN
        RAISE_APPLICATION_ERROR(num => -20000, msg => 'Ticket should end after start');
    end if;


    IF (:new.STARTTICKER IS NULL) and :old.STARTTICKER IS NULL THEN
        :new.STARTTICKER := sysdate;
    end if;
END;

CREATE OR REPLACE TRIGGER client_archive
    BEFORE UPDATE OR DELETE
    ON CLIENTS
    FOR EACH ROW
BEGIN
    INSERT INTO clients_archive
    VALUES (:OLD.FIO,
            :old.TICKET,
            :old.TEAM_NAME,
            :OLD.BIRTHDAY,
            :old.GENDER,
            :old.WEIGH,
            :OLD.STARTTICKER,
            :old.ENDTICKET,
            :old.PHONE,
            sysdate,
            USER);
END;

drop trigger client_check;
INSERT into CLIENTS
values ('Ivanov Ivan', 1231222, 'Break-dance', '2000-01-01', 'm', 50, '2018-01-01', '2019-12-31', '8005553535');

UPDATE CLIENTS
set GENDER = 'f'
WHERE TICKET = 1231222;
SELECT (sysdate - BIRTHDAY) / 365
FROM CLIENTS;
delete
from CLIENTS
where TICKET = 1231222;
SELECT *
from CLIENTS
where TICKET = 1231222;

SELECT *
from clients_archive;