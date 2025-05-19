DECLARE
    i NUMBER := 1; -- Startindex für die Schleife
    max_num NUMBER := 43; -- Maximale Anzahl von LAGER- und BEDARF-Spalten (REST_LAGER_01 bis REST_LAGER_03, BEDARF_121101 bis BEDARF_121103)
    sql_stmt VARCHAR2(4000); -- Dynamisches SQL-Statement
BEGIN
    -- Dynamisches Update für jede Nummer
    FOR i IN 1..max_num LOOP
        -- Generiere das dynamische SQL-Statement
        sql_stmt := 'UPDATE TEMP_TABLE_DSW_MOD6 SET ' ||
                    'REST_LAGER_' || LPAD(i, 2, '0') || ' = CASE ' ||
                    'WHEN NVL(' || CASE WHEN i = 1 THEN 'LAGERBESTAND' ELSE 'REST_LAGER_' || LPAD(i-1, 2, '0') END || ', 0) > NVL(BEDARF_1206' || LPAD(i, 2, '0') || ', 0) ' ||
                    'THEN NVL(' || CASE WHEN i = 1 THEN 'LAGERBESTAND' ELSE 'REST_LAGER_' || LPAD(i-1, 2, '0') END || ', 0) - NVL(BEDARF_1206' || LPAD(i, 2, '0') || ', 0) ' ||
                    'ELSE NULL END, ' ||
                    'ABZGL_LAGER_' || LPAD(i, 2, '0') || ' = CASE ' ||
                    'WHEN NVL(' || CASE WHEN i = 1 THEN 'LAGERBESTAND' ELSE 'REST_LAGER_' || LPAD(i-1, 2, '0') END || ', 0) < NVL(BEDARF_1206' || LPAD(i, 2, '0') || ', 0) ' ||
                    'THEN NVL(BEDARF_1206' || LPAD(i, 2, '0') || ', 0) - NVL(' || CASE WHEN i = 1 THEN 'LAGERBESTAND' ELSE 'REST_LAGER_' || LPAD(i-1, 2, '0') END || ', 0) ' ||
                    'ELSE NULL END';
        
        -- Führe das dynamische SQL-Statement aus
        EXECUTE IMMEDIATE sql_stmt;
    END LOOP;
END;
/
