-- KA2023120891 

DECLARE
    v_start_ziffer NUMBER := 91; -- Startziffer
    v_end_ziffer   NUMBER := 98; -- Endziffer
    v_sql          VARCHAR2(4000);
BEGIN
    FOR i IN v_start_ziffer..v_end_ziffer LOOP
        v_sql := '
            MERGE INTO temp_table_ALLE_KT_DSW t
            USING
            (
                SELECT
                    a.teilenr,
                    SUM(a.resmenge) AS summe_auftrmenge
                FROM allocs a
                JOIN parts p ON p.teilenr = a.teilenr
                WHERE a.prodauftr IN (
                    SELECT prodauftr
                    FROM wrkord
                    CONNECT BY PRIOR prodauftr = linkauf
                    START WITH prodauftr = ''KA20231208' || TO_CHAR(i) || '''
                )
                AND a.kzfertig != 4800
                GROUP BY a.teilenr
            ) src
            ON (t.teilenr = src.teilenr)
            WHEN MATCHED THEN
                UPDATE SET t.BEDARF_1208' || TO_CHAR(i) || ' = src.summe_auftrmenge';
        
        EXECUTE IMMEDIATE v_sql;
    END LOOP;
END;
/
