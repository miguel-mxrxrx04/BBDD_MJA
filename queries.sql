use trabajo;

# 1. Listado de jugadores: Obtén la lista de todos los jugadores que han participado en alguna partida.
SELECT DISTINCT nombre_jugador
FROM JUEGA;

# 2. Total de juegos: Cuenta el número total de juegos disponibles en el club.
SELECT COUNT(nombre_juego) FROM juego;

# 4. Partidas en enero: Lista todas las partidas jugadas entre el 1 de enero de 2023 y el 30 de enero de 2023 (ambos incluidos).
SELECT id_partida, fecha FROM organiza
WHERE fecha BETWEEN '2023-01-01' AND '2023-01-30' 
ORDER BY fecha ASC;

# 5. Juegos y expansiones: Muestra todos los juegos junto con sus respectivas expansiones, ordenados alfabéticamente por el nombre del juego.
SELECT juego.nombre_juego, expansion.nombre_expansion
FROM juego LEFT JOIN expansion ON expansion.nombre_juego = juego.nombre_juego
ORDER BY juego.nombre_juego ASC;

# 6. Historial de partidas: Lista todas las partidas, incluyendo la información del juego jugado y el resultado, ordenadas por fecha y hora.
SELECT organiza.id_partida, gana.nombre_jugador, partida.nombre_juego, organiza.fecha, organiza.hora 
FROM organiza 
JOIN partida ON organiza.id_partida = partida.id_partida
JOIN gana ON organiza.id_partida = gana.id_partida
ORDER BY fecha, hora ASC;

# 8. Personal diverso: Lista el personal que ha supervisado partidas en las que se han jugado más de tres juegos diferentes.
SELECT organiza.nombre_personal, COUNT(nombre_juego) as num_juegos
FROM organiza
INNER JOIN partida ON organiza.id_partida=partida.id_partida
GROUP BY organiza.nombre_personal
HAVING num_juegos > 3; 
# Como el máximo de juegos distintos que ha supervisado una persona es 2 no sale nada.

# 9. Jugador más activo: Determina qué jugador ha participado en el mayor número de partidas.
SELECT nombre_jugador, COUNT(id_partida) as num_partidas
FROM JUEGA
GROUP BY nombre_jugador
ORDER BY num_partidas DESC
LIMIT 1;

# 12. Organizadores selectivos: Lista el personal que ha organizado partidas 
# en las que se ha utilizado la expansión «Modo Blitz» pero no la expansión «Edición Limitada».

# Imagino que se refiere a que en esa partida específica ha usado 'Modo Blitz' pero no 'Edición Limitada'
# y que no se refiere a que ha organizado alguna partida con 'Modo Blitz' pero ningunA con 'Edición Limitada'.

SELECT DISTINCT(organiza.nombre_personal)
FROM organiza
WHERE organiza.id_partida IN(
                        SELECT utiliza.id_partida
						FROM utiliza
						WHERE utiliza.nombre_expansion = 'Modo Blitz'
                        )
AND organiza.id_partida NOT IN(
						SELECT utiliza.id_partida
                        FROM utiliza
                        WHERE utiliza.nombre_expansion = 'Edición Limitada'
                        );
                        
# 13. Trayectoria de jugadores: Identifica los jugadores que han participado en partidas
# con el juego «Catan» y, posteriormente, en partidas con el juego «Ticket to Ride».
                        
SELECT DISTINCT(juega1.nombre_jugador)
FROM juega AS juega1
JOIN partida AS partida1 ON juega1.id_partida=partida1.id_partida
JOIN organiza AS organiza1 ON partida1.id_partida = organiza1.id_partida
JOIN juega AS juega2 ON juega1.nombre_jugador = juega2.nombre_jugador
JOIN partida AS partida2 ON juega2.id_partida=partida2.id_partida
JOIN organiza AS organiza2 ON partida2.id_partida=organiza2.id_partida
WHERE partida1.nombre_juego = 'Catan' 
	  AND partida2.nombre_juego = 'Ticket to Ride'
      AND (
			(organiza1.fecha < organiza2.fecha) 
            OR
			(organiza1.fecha = organiza2.fecha AND organiza1.hora < organiza2.hora)
		  );
      
# 15 Ajedrez con expansiones: Encuentra a los jugadores que han participado en partidas de «Ajedrez»
# donde la suma del coste de las expansiones utilizadas fue menor que 55.

# La únicas expansiones que tiene el ajedrez son: "Modo Blitz", que cuesta 2095€; y "Edición Limitada", que cuesta 9999€.
# Entonces solo solo salen los jugadores que juegan partidas de ajedrez sin expansiones (0 € de expansiones).

SELECT juega.nombre_jugador
FROM juega
INNER JOIN (
		SELECT partida.id_partida, 
			   COALESCE(sum(copia_expansion.coste_expansion),0) AS suma_coste
		FROM partida
		LEFT JOIN utiliza ON partida.id_partida = utiliza.id_partida
		LEFT JOIN copia_expansion ON (copia_expansion.nombre_expansion = utiliza.nombre_expansion AND copia_expansion.id_expansion=utiliza.id_expansion)
		WHERE partida.nombre_juego = "Ajedrez" 
		GROUP BY partida.id_partida
        ) AS coste_expansiones_partida ON juega.id_partida=coste_expansiones_partida.id_partida
WHERE coste_expansiones_partida.suma_coste < 55;
        

