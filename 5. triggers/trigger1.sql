DELIMITER //

CREATE TRIGGER trg_juega_horario_insert
BEFORE INSERT ON JUEGA
FOR EACH ROW
BEGIN
    DECLARE v_fecha DATE;
    DECLARE v_hora TIME;
    DECLARE v_conflicto INT DEFAULT 0;

    -- cogemos la fehca y hora
    SELECT fecha, hora INTO v_fecha, v_hora
    FROM ORGANIZA
    WHERE id_partida = NEW.id_partida
    LIMIT 1;

    IF v_fecha IS NOT NULL AND v_hora IS NOT NULL THEN
        -- seleccionamos si el jugador ha participado ya en otra
        SELECT COUNT(*) INTO v_conflicto
        FROM JUEGA j
        JOIN ORGANIZA o ON j.id_partida = o.id_partida
        WHERE j.nombre_jugador = NEW.nombre_jugador
          AND o.fecha = v_fecha
          AND o.hora = v_hora
          AND j.id_partida != NEW.id_partida; 

        -- lanzamos el error si hay conflicto
        IF v_conflicto > 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Conflicto de horario: El jugador ya tiene otra partida programada en esa fecha y hora.';
        END IF;
    END IF;
END //

DELIMITER ;