#modo1
CREATE OR REPLACE VIEW tabela AS
    SELECT 
		a.fabricante,
		a.modelo,
		o.tipo
    FROM 
		ocorrencia o JOIN situacao s ON o.ocorrencia_id = s.ocorrencia_id JOIN aeronave a ON s.aeronave_id = a.aeronave_id
    ORDER BY fabricante ASC, modelo ASC;
    
CREATE OR REPLACE VIEW tabela2 AS
    SELECT 
fabricante,
modelo,
tipo,
count(tipo) AS conta
    FROM tabela
    GROUP BY fabricante, modelo, tipo;
    
SELECT 
fabricante,
modelo, 
tipo
FROM tabela2 t
WHERE t.conta IN (SELECT max(conta)
				FROM tabela2 t1
				WHERE
             	     t1.fabricante = t.fabricante 
						AND
                      t1.modelo = t.modelo);
                      
                      
#modo2
CREATE OR REPLACE VIEW countipo AS
    SELECT 
aeronave_id,
tipo,
count(tipo) AS conta
FROM ocorrencia o JOIN situacao s 
         ON o.ocorrencia_id = s.ocorrencia_id
GROUP BY aeronave_id, tipo;


CREATE OR REPLACE VIEW nocorrencias AS
SELECT 
fabricante,
modelo,
tipo,
sum(conta) AS soma
    FROM countipo c JOIN aeronave a 
                ON c.aeronave_id = a.aeronave_id
    GROUP BY fabricante, modelo, tipo;
    
CREATE OR REPLACE VIEW maxocor AS
    SELECT 
fabricante,
modelo,
max(soma) AS maximo
    FROM nocorrencias
    GROUP BY fabricante, modelo;
    
SELECT 
m.fabricante,
n.modelo,
n.tipo
FROM nocorrencias n JOIN maxocor m 
ON n.fabricante = m.fabricante 
AND n.modelo = m.modelo
WHERE n.soma = m.maximo