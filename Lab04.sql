-- Проекция (project)

SELECT *
FROM scheduler;

SELECT DISTINCT room, day_of_week
FROM scheduler;

-- Селекция (select)

SELECT *
FROM scheduler
WHERE day_of_week = 2;

-- Декартово произведение (сartesian product)

SELECT *
FROM scheduler
       CROSS JOIN team;

-- Объединение Union
CREATE TABLE IF NOT EXISTS `scheduler_archive`
(
  id          NUMERIC(6) PRIMARY KEY,
  team_name   VARCHAR(40)                                         NOT NULL,
  coach_id    NUMERIC(5)                                          NOT NULL,
  kind        VARCHAR(30)                                         NOT NULL,
  room        ENUM ('Бассейн', 'Беговой', 'Силовой', 'Альпинизм') NOT NULL,
  day_of_week ENUM ('вс', 'пн', 'вт', 'ср', 'чт', 'пт', 'сб')     NOT NULL,
  start       TIME                                                NOT NULL,
  end         TIME                                                NOT NULL,
  CONSTRAINT `fk_team_scheduler_archive` FOREIGN KEY (team_name) REFERENCES `team` (name) ON DELETE RESTRICT,
  CONSTRAINT `fk_coach_scheduler_archive` FOREIGN KEY (coach_id) REFERENCES `coach` (id) ON DELETE RESTRICT,
  CONSTRAINT `ch_time_archive` CHECK ( end > start )
) ENGINE = INNODB;

DELIMITER $$


CREATE TRIGGER `scheduler_archive_before_insert`
  BEFORE INSERT
  ON `scheduler_archive`
  FOR EACH ROW
BEGIN
  CALL check_scheduler(new.start, new.end);
END$$

CREATE TRIGGER `scheduler_archive_before_update`
  BEFORE UPDATE
  ON `scheduler_archive`
  FOR EACH ROW
BEGIN
  CALL check_scheduler(new.start, new.end);
END$$

DELIMITER ;

INSERT INTO `scheduler_archive`
VALUES (1, 'Спортивное ориентирование', 11, 'Разминка', 'Бассейн', 'вт', '11:54', '12:37'),
       (2, 'Скалолазание', 6, 'Практика', 'Бассейн', 'сб', '13:16', '13:21'),
       (3, 'Обучение плаванию', 12, 'Интенсив', 'Беговой', 'сб', '15:38', '15:41'),
       (4, 'Синхронное плавание', 12, 'Тренировка', 'Беговой', 'пн', '13:45', '13:56'),
       (5, 'Легкая атлетика', 15, 'Разминка', 'Бассейн', 'пн', '13:11', '13:28'),
       (6, 'Тяжелая атлетика', 14, 'Тренировка', 'Силовой', 'чт', '15:01', '15:45'),
       (7, 'Брейк-данс', 8, 'Разминка', 'Альпинизм', 'пн', '16:05', '16:54'),
       (8, 'Спортивное плавание', 10, 'Интенсив', 'Беговой', 'пт', '15:41', '16:21'),
       (9, 'Бальные танцы', 2, 'Интенсив', 'Альпинизм', 'чт', '20:01', '20:53'),
       (10, 'Брейк-данс', 6, 'Теория', 'Альпинизм', 'вс', '10:51', '11:14'),
       (11, 'Брейк-данс', 1, 'Интенсив', 'Беговой', 'вт', '11:06', '11:27'),
       (12, 'Спортивное плавание', 10, 'Экскурсия', 'Бассейн', 'пн', '20:09', '20:23'),
       (13, 'Скалолазание', 7, 'Разминка', 'Альпинизм', 'пн', '10:33', '11:28'),
       (14, 'Многоборье', 15, 'Разминка', 'Бассейн', 'чт', '13:32', '13:39'),
       (15, 'Спортивное плавание', 15, 'Практика', 'Беговой', 'сб', '17:06', '17:25'),
       (16, 'Тяжелая атлетика', 19, 'Разминка', 'Силовой', 'пн', '16:48', '17:28'),
       (17, 'Бальные танцы', 18, 'Разминка', 'Альпинизм', 'пт', '13:51', '14:33'),
       (18, 'Обучение плаванию', 16, 'Интенсив', 'Бассейн', 'пн', '14:04', '15:00'),
       (19, 'Бальные танцы', 8, 'Экскурсия', 'Беговой', 'ср', '18:26', '19:24'),
       (20, 'Брейк-данс', 7, 'Практика', 'Бассейн', 'ср', '14:04', '14:36');


SELECT *
FROM scheduler
UNION
SELECT *
FROM scheduler_archive;

-- Соединение (join)

SELECT *
FROM team
       INNER JOIN scheduler on team.name = scheduler.team_name;

-- Разность (except)

SELECT *
FROM scheduler
WHERE NOT EXISTS(SELECT *
                 FROM scheduler_archive
                 WHERE scheduler_archive.id = scheduler.id
                   AND scheduler_archive.team_name = scheduler.team_name
                   AND scheduler_archive.coach_id = scheduler.coach_id
                   AND scheduler_archive.kind = scheduler.kind
                   AND scheduler_archive.room = scheduler.room
                   AND scheduler_archive.day_of_week = scheduler.day_of_week
                   AND scheduler_archive.start = scheduler.start
                   AND scheduler_archive.end = scheduler.end);


-- Пересечение (intersect)

SELECT *
FROM scheduler
WHERE EXISTS(SELECT *
             FROM scheduler_archive
             WHERE scheduler_archive.id = scheduler.id
               AND scheduler_archive.team_name = scheduler.team_name
               AND scheduler_archive.coach_id = scheduler.coach_id
               AND scheduler_archive.kind = scheduler.kind
               AND scheduler_archive.room = scheduler.room
               AND scheduler_archive.day_of_week = scheduler.day_of_week
               AND scheduler_archive.start = scheduler.start
               AND scheduler_archive.end = scheduler.end);
