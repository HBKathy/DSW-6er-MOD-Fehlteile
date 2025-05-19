DECLARE
    i NUMBER := 1; -- Startindex für die Schleife
    max_num NUMBER := 43; -- Maximale Anzahl von KOSTEN_BEDARF-Spalten (KOSTEN_BEDARF_01 bis KOSTEN_BEDARF_25)
    sql_stmt VARCHAR2(4000); -- Dynamisches SQL-Statement
BEGIN
    -- Dynamisches Update für jede Nummer
    sql_stmt := 'UPDATE TEMP_TABLE_DSW_MOD6 SET ';
    
    FOR i IN 1..max_num LOOP
        -- Ergänze das dynamische SQL-Statement für jede Spalte
        IF i > 1 THEN
            sql_stmt := sql_stmt || ', ';
        END IF;

        sql_stmt := sql_stmt || 'KOSTEN_BEDARF_' || LPAD(i, 2, '0') || 
                    ' = NVL(ABZGL_LAGER_' || LPAD(i, 2, '0') || ', 0) * NVL(EINZELPREIS_BRUTTO, 0)';
    END LOOP;

    -- Führe das dynamische SQL-Statement aus
    EXECUTE IMMEDIATE sql_stmt;
END;
/
