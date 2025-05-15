/*
Procedimiento 1, Registro de jugador:
 Automatizar el proceso de registro de un nuevo jugador en la base de datos,
 asignarle su primera partida 
 y generar su primera inscripción en el sistema.
 */
DELIMITER $$

CREATE PROCEDURE sp_registrar_jugador (IN nombre_jugador_registro VARCHAR(60),
									   IN id_partida_registro INT)
BEGIN
	IF NOT EXISTS ( SELECT * 
					FROM jugador 
					WHERE nombre_jugador = nombre_jugador_registro) 
	THEN 
		INSERT INTO jugador(nombre_jugador) 
		VALUES (nombre_jugador_registro);
	END IF;

	IF NOT EXISTS ( SELECT * 
					FROM JUEGA 
					WHERE nombre_jugador = nombre_jugador_registro 
					AND id_partida = id_partida_registro)
	THEN 
		INSERT INTO JUEGA(nombre_jugador, id_partida)
		VALUES (nombre_jugador_registro, id_partida_registro);
	END IF;
END
$$


/*
Procedimiento 2, Listado de juegos y expansiones:
 Crear un procedimiento almacenado que liste todos los juegos junto con sus expansiones,
 presentando la lista de expansiones separada por comas 
 y mostrando el coste de cada una entre paréntesis.
 */
CREATE PROCEDURE sp_listado_juegos_expansiones ()
BEGIN
	SELECT juego.nombre_juego, 
	   GROUP_CONCAT(CONCAT(expansion.nombre_expansion, ' (', copia_expansion.coste_expansion, '€)')) as expansiones
	FROM juego
	JOIN expansion ON juego.nombre_juego=expansion.nombre_juego
	JOIN copia_expansion ON expansion.nombre_expansion=copia_expansion.nombre_expansion
	GROUP BY juego.nombre_juego;
END
$$

DELIMITER ;