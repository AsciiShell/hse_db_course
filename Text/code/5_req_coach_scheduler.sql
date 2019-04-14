SELECT coach.id              AS coach_id,
       coach.fio             AS coach_fio,
       coach.status          AS coach_status,
       coach.phone           AS coach_phone,
       scheduler.team_name   AS scheduler_team_name,
       scheduler.kind        AS scheduler_kind,
       scheduler.room        AS scheduler_room,
       scheduler.day_of_week AS scheduler_day_of_week,
       scheduler.start       AS scheduler_start,
       scheduler.end         AS scheduler_end
FROM coach
       INNER JOIN scheduler ON coach.id = scheduler.coach_id;
