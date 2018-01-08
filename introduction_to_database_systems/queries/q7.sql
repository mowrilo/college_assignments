#modo1
SELECT
	fase_operacao, aerodromo, nivel_dano, quantidade_fatalidades, O.ocorrencia_id
FROM
	fator_contribuinte AS F,
	ocorrencia AS O,
	situacao AS S
WHERE
	F.ocorrencia_id = O.ocorrencia_id
    	AND S.ocorrencia_id = O.ocorrencia_id
    	AND fator="projeto"
    	AND aerodromo!='****'
        
#modo2
SELECT
	fase_operacao, aerodromo, nivel_dano, quantidade_fatalidades, O.ocorrencia_id
FROM
	fator_contribuinte AS F,
	ocorrencia AS O,
	situacao AS S
WHERE
	F.ocorrencia_id = O.ocorrencia_id
    	AND S.ocorrencia_id = O.ocorrencia_id