DELIMITER //

CREATE PROCEDURE sp_registrar_jugador(
  IN p_nombre       VARCHAR(100),
  IN p_email        VARCHAR(100),
  IN p_id_juego_ini INT           -- por ejemplo, el ID del juego asignado en la primera partida
)
BEGIN
  DECLARE v_jugador_id INT;
  DECLARE v_partida_id INT;

  START TRANSACTION;
    -- 1) Nuevo jugador
    INSERT INTO jugadores(nombre, email, fecha_registro)
    VALUES (p_nombre, p_email, NOW());
    SET v_jugador_id = LAST_INSERT_ID();

    -- 2) Primera partida
    INSERT INTO partidas(id_jugador, id_juego, fecha_partida)
    VALUES (v_jugador_id, p_id_juego_ini, NOW());
    SET v_partida_id = LAST_INSERT_ID();

    -- 3) Inscripción inicial
    INSERT INTO inscripciones(id_jugador, id_partida, fecha_inscripcion)
    VALUES (v_jugador_id, v_partida_id, NOW());
  COMMIT;

  -- 4) Retornamos IDs para confirmación
  SELECT
    v_jugador_id AS nuevo_jugador_id,
    v_partida_id AS nueva_partida_id;
END
//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_listar_juegos_con_expansiones()
BEGIN
  SELECT
    j.id_juego,
    j.nombre           AS juego,
    COALESCE(
      GROUP_CONCAT(
        CONCAT(e.nombre, ' (', FORMAT(e.costo, 2), ')')
        ORDER BY e.nombre
        SEPARATOR ', '
      ),
      '— sin expansiones —'
    ) AS expansiones
  FROM juegos AS j
  LEFT JOIN expansiones AS e
    ON e.id_juego = j.id_juego
  GROUP BY j.id_juego, j.nombre
  ORDER BY j.nombre;
END
//

DELIMITER ;
