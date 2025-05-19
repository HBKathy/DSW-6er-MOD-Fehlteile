DECLARE
    v_start_ziffer NUMBER := 1; -- Startziffer
    v_end_ziffer   NUMBER := 43; -- Endziffer
    v_sql          VARCHAR2(4000);
BEGIN
    FOR i IN v_start_ziffer..v_end_ziffer LOOP
        v_sql := '
            MERGE INTO temp_table_DSW_mod6 t
            USING
            (
                SELECT
                    a.teilenr,
                    SUM(a.resmenge) AS summe_auftrmenge
                FROM allocs a
                JOIN parts p ON p.teilenr = a.teilenr
                WHERE a.prodauftr LIKE ''KA20181206'' || TO_CHAR(' || i || ', ''FM00'') || ''%''
                AND a.kzfertig != 4800
                and a.kzfertig > 600
                GROUP BY a.teilenr
            ) src
            ON (t.teilenr = src.teilenr)
            WHEN MATCHED THEN
                UPDATE SET t.BEDARF_1206' || TO_CHAR(i, 'FM00') || ' = src.summe_auftrmenge';
        EXECUTE IMMEDIATE v_sql;
    END LOOP;
END;
/
