DECLARE
    v_start_ziffer NUMBER := 89; -- Startziffer
    v_end_ziffer   NUMBER := 90; -- Endziffer
    v_sql          VARCHAR2(4000);
BEGIN
    FOR i IN v_start_ziffer..v_end_ziffer LOOP
        v_sql := '
            MERGE INTO temp_table_ALLE_KT_DSW t
            USING
            (
                SELECT
                    teilenr,
                    LISTAGG(bedarfstermin, '','') WITHIN GROUP (ORDER BY bedarfstermin) AS bedarfstermine
                FROM (
                    SELECT DISTINCT
                        a.teilenr,
                        TO_DATE(a.enddat) AS bedarfstermin
                    FROM allocs a
                    JOIN parts p ON p.teilenr = a.teilenr
                    WHERE a.prodauftr IN (
                        SELECT prodauftr
                        FROM wrkord
                        CONNECT BY PRIOR prodauftr = linkauf
                        START WITH prodauftr = ''KA20181206' || TO_CHAR(i) || '''
                    )
                    AND a.kzfertig != 4800
                )
                GROUP BY teilenr
            ) src
            ON (t.teilenr = src.teilenr)
            WHEN MATCHED THEN
                UPDATE SET t.AGG_Bedarfstermin_' || TO_CHAR(i) || ' = src.bedarfstermine';
        
        EXECUTE IMMEDIATE v_sql;
    END LOOP;
END;
/
