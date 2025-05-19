DECLARE
    v_start_ziffer NUMBER := 1; -- Startziffer
    v_end_ziffer   NUMBER := 43; -- Endziffer
    v_sql          VARCHAR2(4000);
BEGIN
    FOR i IN v_start_ziffer..v_end_ziffer LOOP
        v_sql := '
            MERGE INTO temp_table_DSW_MOD6 t
            USING
            (
                SELECT
                    a.teilenr AS teilenr, -- Eindeutig qualifiziert
                    TO_CHAR(MIN(a.enddat), ''dd.mm.yyyy'') AS bedarfstermin -- Jüngstes Datum ermitteln und formatieren
                FROM allocs a
                JOIN parts p ON p.teilenr = a.teilenr
                WHERE a.prodauftr LIKE ''KA20181206'' || TO_CHAR(' || i || ', ''FM00'')
                AND a.kzfertig != 4800
                GROUP BY a.teilenr
            ) src
            ON (t.teilenr = src.teilenr)
            WHEN MATCHED THEN
                UPDATE SET t.Bedarfstermin_' || TO_CHAR(i, 'FM00') || ' = src.bedarfstermin'; -- Jüngstes Datum schreiben';
        
        -- SQL-Ausgabe zur Überprüfung
        DBMS_OUTPUT.PUT_LINE(v_sql);
        
        -- Ausführen der dynamischen SQL-Anweisung
        EXECUTE IMMEDIATE v_sql;
    END LOOP;
END;
/
