SELECT team.name, Count(*) AS COUNT_OF_PEOPLE
FROM scheduler
       INNER JOIN (team INNER JOIN client ON team.name = client.team_name) ON scheduler.team_name = team.name
WHERE (((scheduler.day_of_week) = "пн"))
GROUP BY team.name;
