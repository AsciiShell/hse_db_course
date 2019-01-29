use airport;
SELECT *
FROM flight
WHERE airport_in = airport_out
  AND date_out >= NOW() - 30;

SELECT *
FROM planes
WHERE business_class > 0
  AND (model = 'Boeing 737' OR model = 'Boeing 747');

SELECT *
FROM planes
WHERE first_class IS NOT NULL
  AND business_class IS NOT NULL
  AND model LIKE 'Airbus%';

SELECT *
FROM tickets
WHERE class_type IN ('First class', 'Business class')
  AND passenger_id IS NULL;

SELECT *
FROM flight
WHERE MONTH(date_out) = 3
  AND YEAR(date_out) = YEAR(NOW())
  AND airport_out = 'SVO'
ORDER BY date_out;

SELECT *
FROM flight
WHERE date_out BETWEEN '2018-03-01' AND '2018-03-31'
  AND airport_out = 'SVO'
ORDER BY date_out;

SELECT *
FROM passengers
WHERE doc_type = 'Паспорт'
  AND born >= NOW() - 14 * 365;
