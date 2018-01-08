#modo1
SELECT 
             fabricante,
             sum(quantidade_fatalidades),
             count(quantidades_fatalidades),
             avg(quantidades_fatalidades)
FROM
             aeronave a JOIN situacao s
                     ON a.aeronave_id = s.aeronave_id
GROUP BY fabricante
HAVING sum(quantidade_fatalidades) != 0
ORDER BY sum(quantidade_fatalidades) ASC;

#modo2
CREATE OR REPLACE VIEW fabmortes AS
     SELECT
            fabricante,
sum(quantidade_fatalidades) AS soma,                                                                                                      count(quantidade_fatalidades) AS conta,
avg(quantidade_fatalidades) AS media
    FROM 
aeronave a JOIN situacao s 
         ON a.aeronave_id = s.aeronave_id
    GROUP BY fabricante
    ORDER BY sum(quantidade_fatalidades) ASC;
    
SELECT *
FROM fabmortes
WHERE soma > 0;