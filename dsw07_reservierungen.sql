MERGE INTO temp_table_alle_kt_dsw t 
USING ( 
    SELECT  
        p.teilenr, 
        SUM(NVL(ar.reserviert_menge, 0)) AS Gesamt_ResMenge 
    FROM parts p 
    LEFT JOIN allocs_reservierung ar ON p.teilenr = ar.teilenr 
    WHERE p.teilenr IN (  
        SELECT DISTINCT a.teilenr  
        FROM allocs a 
        WHERE a.prodauftr IN (  
            SELECT prodauftr  
            FROM ( 
                SELECT prodauftr  
                FROM wrkord  
                CONNECT BY PRIOR prodauftr = linkauf  
                START WITH prodauftr = 'KA2018120689'  
  
) 
        )  
        ) 
    AND ar.reserviert_menge > 0 
    GROUP BY p.teilenr 
) src 
ON (t.teilenr = src.teilenr) 
WHEN MATCHED THEN 
    UPDATE SET t.Reservierungen = src.Gesamt_ResMenge; 

