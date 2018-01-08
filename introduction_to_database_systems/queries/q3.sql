#modo1
SELECT DISTINCT
	fabricante,
	tipo_operacao,
	fase_operacao,
	aeroporto_origem,
	aeroporto_destino,
	nivel_dano,
	quantidade_fatalidades
FROM
	situacao AS S
    	JOIN
	aeronave AS A ON A.aeronave_id = S.aeronave_id
WHERE
	fabricante = 'Embraer'
    	AND nivel_dano = 'DESTRUÍDA'
ORDER BY tipo_operacao , fase_operacao;

#modo2
SELECT DISTINCT
	A.fabricante,
	S.tipo_operacao,
	S.fase_operacao,
	S.aeroporto_origem,
	S.aeroporto_destino,
	S.nivel_dano,
	S.quantidade_fatalidades
FROM
	situacao AS S,
	aeronave AS A
WHERE
	A.fabricante = 'Embraer'
    	AND S.nivel_dano = 'DESTRUÍDA'
    	AND A.aeronave_id = S.aeronave_id
ORDER BY S.tipo_operacao , S.fase_operacao;