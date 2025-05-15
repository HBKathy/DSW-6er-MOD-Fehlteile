MERGE INTO temp_table_alle_kt_mod6 target
USING (
    SELECT teilenr, nrlieferant, namelieferant
    FROM (
        SELECT 
            teilenr,
            nrlieferant,
            namelieferant,
            TO_DATE(bestelldatum, 'dd.mm.yyyy') AS bestelldatum,
            ROW_NUMBER() OVER (PARTITION BY teilenr ORDER BY TO_DATE(bestelldatum, 'dd.mm.yyyy') DESC) AS rn
        FROM temp_table_GesamtPreise
    )
    WHERE rn = 1 -- Nur die Zeile mit dem aktuellsten Bestelldatum pro Teilenummer
) source
ON (target.teilenr = source.teilenr)
WHEN MATCHED THEN
    UPDATE SET 
        target.kdnr = source.nrlieferant,
        target.lieferant = source.namelieferant;
