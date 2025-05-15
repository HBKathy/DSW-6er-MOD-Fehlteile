MERGE INTO temp_table_alle_kt_dsw_mod6 t 
USING ( 
SELECT  
p.teilenr, 
SUM(NVL(b.menge_bestellt, 0)) AS Gesamt_Bestellmenge 
FROM parts p  
LEFT JOIN bes_pos b ON b.teilenr = p.teilenr AND b.a_art IN ('AB', 'BE', 'RA', 'WO', 'BM')  
LEFT JOIN bes_kopf k ON b.kdnr = k.kdnr AND k.jahr = b.jahr AND b.anr = k.anr  
LEFT JOIN gepa g ON b.kdnr = g.kdnr  
LEFT JOIN status s ON b.status = s.kz  
WHERE p.teilenr IN (  
SELECT DISTINCT a.teilenr  
FROM allocs a  
WHERE a.prodauftr LIKE 'KA2018120603%'
) 
AND b.status BETWEEN 2700 AND 2950 
GROUP BY p.teilenr 
) src 
ON (t.teilenr = src.teilenr) 
WHEN MATCHED THEN 
UPDATE SET t.Bestellungen = src.Gesamt_Bestellmenge; 

