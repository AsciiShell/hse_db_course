SELECT *
FROM electronic.components
WHERE name = 'resistor'
  AND nominal > 100000
  AND nominal < 10000000;

SELECT *
FROM electronic.components
WHERE name = 'LED'
  AND nominal = 100
  AND delivery_date > NOW() - INTERVAL 3 MONTH;

SELECT *
FROM electronic.components
WHERE name = 'capacity'
  AND nominal >= 10
  AND nominal <= 100
  AND count_ > 10
  AND count_ < 50;