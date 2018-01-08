#modo1
SELECT
	modelo,
	fabricante,
	equipamento,
	quantidade_motores,
	fase_operacao,
	nivel_dano
FROM
	situacao AS S
    	NATURAL JOIN
	aeronave AS A
    	NATURAL JOIN
	equipamento AS E
WHERE
           	tipo_motor= "Jato";
            
#modo2
SELECT
	modelo,
	fabricante,
	fase_operacao,
	nivel_dano
FROM
	situacao AS S NATURAL JOIN
	aeronave AS A
WHERE
           	modelo, fabricante IN ( SELECT modelo, fabricante FROM equipamento WHERE tipo_motor= "Jato")
	AND
	fabricante IN (SELECT fabricante FROM equipamento WHERE tipo_motor= "Jato")