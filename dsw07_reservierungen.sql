MERGE INTO temp_table_alle_kt_dsw_mod6 t 
USING ( 
    SELECT  
        p.teilenr, 
        SUM(NVL(ar.reserviert_menge, 0)) AS Gesamt_ResMenge 
    FROM parts p 
    LEFT JOIN allocs_reservierung ar ON p.teilenr = ar.teilenr 
    WHERE p.teilenr IN (  
        SELECT DISTINCT a.teilenr  
        FROM allocs a 
        WHERE a.prodauftr LIKE 'KA2018120603%'
        ) 
    AND ar.reserviert_menge > 0 
    GROUP BY p.teilenr 
) src 
ON (t.teilenr = src.teilenr) 
WHEN MATCHED THEN 
    UPDATE SET t.Reservierungen = src.Gesamt_ResMenge; 

