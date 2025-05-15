DECLARE
    v_start_ziffer NUMBER := 89; -- Startwert (erste Endziffer)
    v_end_ziffer   NUMBER := 98; -- Endwert (letzte Endziffer)
    v_sql          VARCHAR2(4000);
BEGIN
    v_sql := 'UPDATE TEMP_TABLE_ALLE_KT_DSW SET ';
    
    FOR i IN v_start_ziffer..v_end_ziffer LOOP
        -- Dynamisch die Berechnung jeder Spalte hinzufügen
        v_sql := v_sql || 'KOSTEN_BEDARF_' || i || ' = NVL(ABZGL_LAGER_' || i || ', 0) * NVL(EINZELPREIS_BRUTTO, 0)';
        
        -- Komma hinzufügen, außer bei der letzten Iteration
        IF i < v_end_ziffer THEN
            v_sql := v_sql || ', ';
        END IF;
    END LOOP;

    -- Dynamisches SQL ausführen
    EXECUTE IMMEDIATE v_sql;
END;
/
