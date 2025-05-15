MERGE INTO temp_table_alle_kt_dsw t 
USING  
( 
   SELECT  
        a.teilenr,  
        SUM(a.resmenge) AS summe_auftrmenge 
FROM allocs a 
 WHERE a.prodauftr IN (  
        SELECT prodauftr  
        FROM wrkord  
        CONNECT BY PRIOR prodauftr = linkauf  
        START WITH prodauftr = 'KA2018120689' 
    ) 
   GROUP BY a.teilenr 
) src 
ON (t.teilenr = src.teilenr) 
WHEN MATCHED THEN 
    UPDATE SET t.DSW_MENGE_1AUFTR = src.summe_auftrmenge; 

