#modo1
SELECT
	horario,
	dia_ocorrencia,
	fator,
	aspecto,
	condicionante,
	detalhe_fator
FROM
	ocorrencia
    	NATURAL JOIN
	fator_contribuinte
WHERE
	((horario >= 19 AND horario <= 24)
    	OR (horario >= 00 AND horario <= 06))
    	AND tipo = 'DESORIENTAÇÃO ESPACIAL'
    	AND area = 'FATOR HUMANO';
        
#modo2
SELECT
	horario,
	dia_ocorrencia,
	fator,
	aspecto,
	condicionante,
	detalhe_fator
FROM
	(SELECT
    	horario, dia_ocorrencia, ocorrencia_id, tipo
	FROM
    	ocorrencia
	WHERE
    	((horario >= 19 AND horario <= 24)
        	OR (horario >= 00 AND horario <= 06))) AS O
    	NATURAL JOIN
	fator_contribuinte
WHERE
	O.tipo = 'DESORIENTAÇÃO ESPACIAL'
    	AND area = 'FATOR HUMANO';