#modo1
SELECT
	O.ocorrencia_id,
	fase_operacao,
	nivel_dano,
	quantidade_fatalidades,
	dia_ocorrencia
FROM
	ocorrencia as O
    	JOIN
	situacao as S
WHERE
	localidade = 'Belo Horizonte'
    	AND O.ocorrencia_id = S.ocorrencia_id
        
#modo2
SELECT
	ocorrencia_id,
	fase_operacao,
	nivel_dano,
	quantidade_fatalidades,
	dia_ocorrencia
FROM
	ocorrencia
    	NATURAL JOIN
	situacao
WHERE
	localidade = 'Belo Horizonte'