DECLARE
    v_start_ziffer NUMBER := 89; -- Startwert (erste Endziffer)
    v_end_ziffer   NUMBER := 98; -- Endwert (letzte Endziffer)
    v_sql          VARCHAR2(4000);
    v_summe        VARCHAR2(4000);
BEGIN
    -- Initialisieren der Summen-Berechnung
    v_summe := '';

    -- Dynamisch die NVL-Berechnung für jede Spalte generieren
    FOR i IN v_start_ziffer..v_end_ziffer LOOP
        IF i > v_start_ziffer THEN
            v_summe := v_summe || ' + '; -- Nur ein "+" hinzufügen, wenn es nicht der erste Eintrag ist
        END IF;
        v_summe := v_summe || 'NVL(ABZGL_LAGER_' || i || ', 0)';
    END LOOP;

    -- Dynamisches SQL-Statement zusammenstellen
    v_sql := 'UPDATE TEMP_TABLE_ALLE_KT_DSW SET Gesamtfehlteile = ' || v_summe;

    -- Dynamisches SQL ausführen
    EXECUTE IMMEDIATE v_sql;
END;
/
