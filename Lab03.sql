-- 1.	Представление "Тренеры, у которых нет занятий".

-- Not support update
CREATE OR REPLACE VIEW free_coach AS
SELECT coach.*
FROM coach
       LEFT OUTER JOIN scheduler ON coach.id = scheduler.coach_id
WHERE scheduler.id IS NULL;

-- Support update & insert & delete
CREATE OR REPLACE VIEW free_coach AS
SELECT coach.*
FROM coach
WHERE coach.id NOT IN (SELECT DISTINCT coach_id FROM scheduler);

SELECT * FROM free_coach;

INSERT INTO free_coach VALUES (21, 'Тренер Без Занятий', 'Инструктор', '86547539426');
UPDATE free_coach SET phone = '80000000000' WHERE id = 1;
DELETE FROM free_coach WHERE id = 3;

-- Rollback
INSERT INTO free_coach VALUES (1, 'Сидоров Антон Александвич', 'Младший тренер', '89747827752'),
                              (3, 'Егоров Алексей Георгивич', 'Старший тренер', '89902017277');
DELETE FROM free_coach WHERE id = 21;


-- 2.	Представление "Тренеры групп": группа – тренер.
CREATE OR REPLACE VIEW coach_group
AS
SELECT coach.id              AS coach_id,
       coach.fio             AS coach_fio,
       coach.status          AS coach_status,
       coach.phone           AS coach_phone,
       scheduler.id          AS scheduler_id,
       scheduler.team_name   AS scheduler_team_name,
       scheduler.kind        AS scheduler_kind,
       scheduler.room        AS scheduler_room,
       scheduler.day_of_week AS scheduler_day_of_week,
       scheduler.start       AS scheduler_start,
       scheduler.end         AS scheduler_end
FROM coach
            INNER JOIN scheduler on coach.id = scheduler.coach_id;

SELECT * FROM coach_group ORDER BY coach_id;
-- Wrong
INSERT INTO coach_group VALUES (22, 'Иванов Иван Иванович', 'Новый тренер', '88005553535', 21, 'Спортивное ориентирование', 'Разминка', 'Бассейн', 'вт', '11:54', '12:37');
-- Ok
UPDATE coach_group SET coach_phone = '00000000000' WHERE coach_id = 2;
-- Wrong
DELETE FROM  coach_group WHERE coach_id = 2 AND scheduler_id = 9;
-- Rollback
UPDATE coach_group SET coach_phone = '89687427124' WHERE coach_id = 2;



-- 3.	Представление "Количество текущих клиентов по видам занятий": вид занятий - количество клиентов-мужчин – количество клиентов-женщин.
CREATE OR REPLACE VIEW client_by_kind AS
SELECT scheduler.kind,
       count(case when client.gender = 'm' then 1 else null end) as males,
       count(case when client.gender = 'f' then 1 else null end) as females
FROM client
     INNER JOIN  team on team.name = client.team_name
     INNER JOIN  scheduler on scheduler.team_name = team.name
GROUP BY scheduler.kind;

SELECT * FROM client_by_kind;

-- Wrong
DELETE FROM client_by_kind;
-- Wrong
UPDATE client_by_kind SET kind = 'Супер интенсив' WHERE kind = 'Интенсив';
