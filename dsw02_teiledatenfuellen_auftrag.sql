INSERT INTO TEMP_TABLE_ALLE_KT_LPZ_techa ( 
   teilenr, 
   bez, 
   bez2, 
   zeichnungsnr, 
   dispo_gruppe, 
   Beschaffungsart, 
   VERLAGERUNGS_ART, 
  Einzelpreis_Brutto,
   Info
) 
WITH PreisSuche AS (  
    SELECT    
        teilenr,   
        Bestelldatum,   
        EINZELPreis_brutto,   
        ROW_NUMBER() OVER (PARTITION BY teilenr ORDER BY TO_date(Bestelldatum, 'dd.mm.yyyy') DESC) AS rn   
    FROM temp_table_gesamtpreise   
    WHERE EINZELPreis_brutto > 0   
),   
FinalPreis AS (  
    SELECT    
        ps.teilenr,   
        CASE    
            WHEN ps.EINZELPreis_brutto IS NULL THEN 0   
            ELSE ps.EINZELPreis_brutto  
        END AS FINAL_PREIS   
    FROM PreisSuche ps   
    WHERE ps.rn = 1 -- Nur den aktuellsten Datensatz je teilenr   
)   
SELECT    
    a.teilenr,   
    p.bez,   
    p.bez2,   
    p.zeichnungsnr,   
    p.dispo_gruppe,   
    p.kzkauf AS Beschaffungsart,   
    p.VERLAGERUNGS_ART,   
    NVL(fp.FINAL_PREIS, 0) AS Einzelpreis_Brutto,
    'Material_TechAuftrag' as Info
FROM allocs a   
JOIN parts p ON p.teilenr = a.teilenr   
LEFT JOIN FinalPreis fp ON a.teilenr = fp.teilenr   
WHERE a.prodauftr IN (    
    SELECT prodauftr    
    FROM (   
        SELECT prodauftr    
        FROM wrkord    
        CONNECT BY PRIOR prodauftr = linkauf    
        START WITH prodauftr = 'KA2022121101'    
    )   
)   
AND ((p.kzkauf = 'K' AND p.dispo_aktiv_jn != 'N') OR (a.kzkauf = 'E' AND a.kz_verlagert IN ('VO', 'VM', 'KB')))  
AND p.dispo_gruppe NOT IN ('183', '185')   
GROUP BY     
    a.teilenr,    
    p.bez,    
    p.bez2,    
    p.zeichnungsnr,    
    p.dispo_gruppe,    
    p.kzkauf,   
    p.VERLAGERUNGS_ART,   
    fp.FINAL_PREIS;  
