USE trabajo;
-- Juego Base: 'Catan'
-- Copia específica de Catan: id_juego = 8 (asume que esta es una PK de COPIA_JUEGO junto con 'Catan')
-- Expansión: 'Navegadores'
-- Copia específica de Navegadores: id_expansion = 8 (asume que esta es una PK de COPIA_EXPANSION junto con 'Navegadores')
-- Fecha y Hora Ocupada: '2025-10-10', '10:00:00'
-- Partida A (la que ocupa): id_partida = 701
-- Personal para organizar: 'OrganizadorBonus'

INSERT IGNORE INTO PARTIDA (id_partida, id_juego, nombre_juego) VALUES (701, 8, 'Catan');
INSERT IGNORE INTO ORGANIZA (nombre_personal, id_partida, fecha, hora)
VALUES ('OrganizadorBonus', 701, '2025-10-10', '10:00:00');
INSERT IGNORE INTO UTILIZA (id_partida, id_expansion, nombre_expansion)
VALUES (701, 8, 'Navegadores');

SELECT * FROM ORGANIZA WHERE id_partida = 701;
SELECT * FROM UTILIZA WHERE id_partida = 701 AND id_expansion = 8 AND nombre_expansion = 'Navegadores';

INSERT IGNORE INTO PARTIDA (id_partida, id_juego, nombre_juego) VALUES (702, 8, 'Catan'); -- MISMA copia de juego que Partida A
INSERT INTO ORGANIZA (nombre_personal, id_partida, fecha, hora)
VALUES ('OrganizadorBonus', 702, '2025-10-10', '10:00:00'); -- MISMA fecha y hora
DELETE FROM ORGANIZA WHERE id_partida = 702;
DELETE FROM PARTIDA WHERE id_partida = 702;


INSERT IGNORE INTO PARTIDA (id_partida, id_juego, nombre_juego) VALUES (702, 8, 'Catan'); -- MISMA copia de juego
INSERT INTO ORGANIZA (nombre_personal, id_partida, fecha, hora)
VALUES ('OrganizadorBonus', 702, '2025-10-10', '11:00:00'); -- OTRA hora

SELECT * FROM ORGANIZA WHERE id_partida = 702;


UPDATE ORGANIZA
SET hora = '10:00:00' 
WHERE id_partida = 702;

UPDATE ORGANIZA
SET hora = '12:00:00' -- Hora diferente, libre
WHERE id_partida = 702;

SELECT * FROM ORGANIZA WHERE id_partida = 702;

DELETE FROM UTILIZA WHERE id_partida = 702;
DELETE FROM ORGANIZA WHERE id_partida = 702;
DELETE FROM PARTIDA WHERE id_partida = 702;

INSERT IGNORE INTO PARTIDA (id_partida, id_juego, nombre_juego) VALUES (703, 9, 'Catan'); -- USA OTRA COPIA DE JUEGO (ej. 9)
INSERT INTO ORGANIZA (nombre_personal, id_partida, fecha, hora)
VALUES ('OrganizadorBonus', 703, '2025-10-10', '10:00:00'); -- MISMA hora que Partida A

SELECT * FROM ORGANIZA WHERE id_partida = 703;


INSERT INTO UTILIZA (id_partida, id_expansion, nombre_expansion)
VALUES (703, 8, 'Navegadores'); 

INSERT INTO UTILIZA (id_partida, id_expansion, nombre_expansion)
VALUES (703, 9, 'Navegadores'); -- OTRA copia de expansión (ej. 9)

SELECT * FROM UTILIZA WHERE id_partida = 703;


-- conflicto con COPIA DE JUEGO:
INSERT IGNORE INTO PARTIDA (id_partida, id_juego, nombre_juego) VALUES (702, 8, 'Catan'); 
INSERT INTO ORGANIZA (nombre_personal, id_partida, fecha, hora)
VALUES ('OtroOrganizador', 702, '2025-10-10', '10:00:00');