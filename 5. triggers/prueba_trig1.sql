USE trabajo;
-- partida 1
SELECT nombre_jugador FROM JUEGA WHERE id_partida = 1 LIMIT 1; 
SELECT fecha, hora FROM ORGANIZA WHERE id_partida = 1;

-- partida 2
SELECT fecha, hora FROM ORGANIZA WHERE id_partida = 2;

UPDATE ORGANIZA SET fecha = '2021-08-24', hora = '14:44:00' WHERE id_partida = 2;
-- intentar añadir el mismo jugador a la partida que está a la misma hora
INSERT INTO JUEGA (nombre_jugador, id_partida) VALUES ('Melisa de Barrera', 2);

UPDATE ORGANIZA SET fecha = '2023-07-02', hora = '18:43:00' WHERE id_partida = 2; 

-- DELETE FROM JUEGA WHERE id_partida IN (9001, 9002);
-- DELETE FROM ORGANIZA WHERE id_partida IN (9001, 9002);
-- DELETE FROM PARTIDA WHERE id_partida IN (9001, 9002);
-- DELETE FROM JUGADOR WHERE nombre_jugador = 'JugadorDePruebaTrigger';
-- DELETE FROM PERSONAL WHERE nombre_personal = 'PersonalDePrueba';
-- DELETE FROM COPIA_JUEGO WHERE id_juego IN (100, 101);
-- DELETE FROM JUEGO WHERE nombre_juego = 'JuegoParaPrueba';