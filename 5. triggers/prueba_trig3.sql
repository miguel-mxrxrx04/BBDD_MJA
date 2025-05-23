USE trabajo;

SELECT COUNT(*) FROM PARTIDA WHERE nombre_juego = 'Scythe';

INSERT INTO JUEGO (nombre_juego) VALUES ('juegopruebaT3');

DELETE FROM JUEGO WHERE nombre_juego = 'Scythe';


DELETE FROM JUEGO WHERE nombre_juego = 'juegopruebaT3';

SELECT * FROM JUEGO WHERE nombre_juego = 'juegopruebaT3';

SELECT * FROM JUEGO WHERE nombre_juego = 'Scythe';
