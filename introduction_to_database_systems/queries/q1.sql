#modo1
SELECT
	matricula, fabricante, modelo
FROM
	aeronave
WHERE
	pais_registro != 'Brasil';
    
#modo2
SELECT
	matricula, fabricante, modelo
FROM
	(SELECT
    	*
	FROM
    	aeronave
	WHERE
    	pais_registro != 'Brasil') AS AUX;