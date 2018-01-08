#modo1
SELECT
	classificacao,
	tipo,
	localidade,
	uf,
	pais,
	aeronaves_envolvidas
FROM
	tpibd2.ocorrencia
WHERE
	aeronaves_envolvidas > 1;

#modo2
SELECT
	classificacao,
	tipo,
	localidade,
	uf,
	pais,
	aeronaves_envolvidas
FROM
	(SELECT
    	*
	FROM
    	tpibd2.ocorrencia
	WHERE
    	aeronaves_envolvidas > 1) AS AUX;