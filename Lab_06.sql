CREATE OR REPLACE FUNCTION time_end(start_at DATE, duration NUMERIC)
    RETURN CHAR
IS
BEGIN
    return to_char(start_at + duration, 'hh24:mi');
END;


SELECT time_end(sysdate, 1 / 24)
FROM DUAL;

CREATE OR REPLACE PROCEDURE print_scheduler(room char)
IS
    lastDayPrint VARCHAR2(40);
    type sched IS TABLE OF SCHEDULERS%ROWTYPE;
    lastRow sched;
BEGIN
    DBMS_OUTPUT.put_line('==========');
    DBMS_OUTPUT.put_line('Зал ' || room || '  Дата:' || sysdate);
    SELECT * BULK COLLECT INTO lastRow FROM schedulers WHERE SCHEDULERS.ROOM = room ORDER BY DAY_OF_WEEK, START_AT;
    DBMS_OUTPUT.put_line(lastRow(1).DAY_OF_WEEK || ' ' || to_char(lastRow(1).START_AT, 'hh24:mi') || ' - ' || to_char(lastRow(1).END_AT, 'hh24:mi') || ' - ' || lastRow(1).TEAM_NAME);

    FOR i IN 2 .. lastRow.COUNT
        LOOP
            if lastRow(i - 1).DAY_OF_WEEK != lastRow(i).DAY_OF_WEEK THEN
                lastDayPrint := lastRow(i).DAY_OF_WEEK || '';
            else
                lastDayPrint := '  ';
            end if;

            DBMS_OUTPUT.put(lastDayPrint || ' ' || to_char(lastRow(i).START_AT, 'hh24:mi') || ' - ' || to_char(lastRow(i).END_AT, 'hh24:mi') || ' - ' || lastRow(i).TEAM_NAME);
            if lastRow(i - 1).END_AT > lastRow(i).START_AT AND lastRow(i - 1).DAY_OF_WEEK = lastRow(i).DAY_OF_WEEK then
                DBMS_OUTPUT.PUT_LINE('   !WARNING! conflict');
            else
                DBMS_OUTPUT.PUT_LINE('');
            end if;
        end loop;
END;

begin
    print_scheduler('Бассейн');
end ;