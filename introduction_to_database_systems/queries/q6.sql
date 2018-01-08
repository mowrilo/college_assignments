#modo1
SELECT
	A.aeronave_id, A.modelo, A.ano_fabricacao, S.nivel_dano
FROM
	situacao AS S,
	aeronave AS A,
	equipamento AS E
WHERE
	S.aeronave_id = A.aeronave_id
    	AND A.modelo = E.modelo
    	AND A.fabricante = E.fabricante
 	   AND peso_maximo_decolagem > 50000
    	AND ano_fabricacao > 1990
ORDER BY aeronave_id;

#modo2
SELECT
	A.aeronave_id, A.modelo, A.ano_fabricacao, S.nivel_dano
FROM
	situacao AS S
    	NATURAL JOIN
	aeronave AS A
WHERE
	ano_fabricacao > 1990
    	AND modelo IN (SELECT
                                                       	modelo
                                        	FROM
                                                       	equipamento
                                        	WHERE
                                        	           	peso_maximo_decolagem > 50000)
ORDER BY aeronave_id;