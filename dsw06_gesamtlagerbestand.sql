MERGE INTO temp_table_alle_kt_dsw t 
USING ( 
    SELECT  
        p.teilenr, 
        SUM(NVL(l.lagerb, 0)) AS Gesamt_Lagerbestand 
    FROM parts p 
    LEFT JOIN lagerpl l ON p.teilenr = l.teilenr 
    LEFT JOIN lagerorte lo ON l.lagerort = lo.lagerort 
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
    AND NVL(l.lagerb, 0) > 0 
    AND l.lagerb is not null
    GROUP BY p.teilenr 
) src 
ON (t.teilenr = src.teilenr) 
WHEN MATCHED THEN 
    UPDATE SET t.Lagerbestand = src.Gesamt_Lagerbestand; 

