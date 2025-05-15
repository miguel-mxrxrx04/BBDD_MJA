USE trabajo;

SELECT nombre_personal, id_partida, fecha, hora
FROM ORGANIZA
LIMIT 1;
INSERT INTO ORGANIZA (nombre_personal, id_partida, fecha, hora)
VALUES ('Alberto Torralba Sierra', 3, '2021-08-24', '14:44:00');

INSERT INTO ORGANIZA (nombre_personal, id_partida, fecha, hora)
VALUES ('Alberto Torralba Sierra', 3, '2021-08-24', '15:00:00'); -- hora diferente

INSERT INTO ORGANIZA (nombre_personal, id_partida, fecha, hora)
VALUES ('Joel Ángel Campillo', 3, '2021-08-24', '14:44:00'); -- personl diferente, misma hora del conflicto
