DROP TRIGGER IF EXISTS trg_organiza_copia_juego_insert;
DROP TRIGGER IF EXISTS trg_organiza_copia_juego_update;
DROP TRIGGER IF EXISTS trg_utiliza_copia_exp_insert;

-- disponibilidad de copia de juego en INSERT de ORGANIZA
DELIMITER //
CREATE TRIGGER trg_organiza_copia_juego_insert
BEFORE INSERT ON ORGANIZA
FOR EACH ROW
BEGIN
    DECLARE v_id_juego_partida INT;
    DECLARE v_nombre_juego_partida VARCHAR(60);
    DECLARE v_conflicto INT DEFAULT 0;

    SELECT id_juego, nombre_juego INTO v_id_juego_partida, v_nombre_juego_partida
    FROM PARTIDA
    WHERE id_partida = NEW.id_partida;

    IF v_id_juego_partida IS NOT NULL THEN

        SELECT COUNT(*) INTO v_conflicto
        FROM PARTIDA p
        JOIN ORGANIZA o ON p.id_partida = o.id_partida
        WHERE p.id_juego = v_id_juego_partida
          AND p.nombre_juego = v_nombre_juego_partida
          AND o.fecha = NEW.fecha
          AND o.hora = NEW.hora
          AND p.id_partida != NEW.id_partida;

        IF v_conflicto > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Conflicto de horario (Juego): La copia específica del juego base ya está asignada a otra partida en esa fecha y hora.';
        END IF;
    END IF;
END //
DELIMITER ;

-- disponibilidad de copia de juego en UPDATE de ORGANIZA
DELIMITER //
CREATE TRIGGER trg_organiza_copia_juego_update
BEFORE UPDATE ON ORGANIZA
FOR EACH ROW
BEGIN
    DECLARE v_id_juego_partida INT;
    DECLARE v_nombre_juego_partida VARCHAR(60);
    DECLARE v_conflicto INT DEFAULT 0;

    -- solo comprobar si la fecha o la hora han cambiado
    IF NEW.fecha != OLD.fecha OR NEW.hora != OLD.hora THEN
        SELECT id_juego, nombre_juego INTO v_id_juego_partida, v_nombre_juego_partida
        FROM PARTIDA
        WHERE id_partida = NEW.id_partida; 

        IF v_id_juego_partida IS NOT NULL THEN
            SELECT COUNT(*) INTO v_conflicto
            FROM PARTIDA p
            JOIN ORGANIZA o ON p.id_partida = o.id_partida
            WHERE p.id_juego = v_id_juego_partida
              AND p.nombre_juego = v_nombre_juego_partida
              AND o.fecha = NEW.fecha
              AND o.hora = NEW.hora
              AND p.id_partida != NEW.id_partida; -- menos la partida que se está actualizando

            IF v_conflicto > 0 THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Conflicto de horario (Juego): La copia específica del juego base ya está asignada a otra partida en la nueva fecha y hora.';
            END IF;
        END IF;
    END IF;
END //
DELIMITER ;

-- disponibilidad de copia de expansión en INSERT de UTILIZA
DELIMITER //
CREATE TRIGGER trg_utiliza_copia_exp_insert
BEFORE INSERT ON UTILIZA 
FOR EACH ROW
BEGIN
    DECLARE v_fecha_partida DATE;
    DECLARE v_hora_partida TIME;
    DECLARE v_conflicto INT DEFAULT 0;

    SELECT fecha, hora INTO v_fecha_partida, v_hora_partida
    FROM ORGANIZA
    WHERE id_partida = NEW.id_partida 
    LIMIT 1;

    IF v_fecha_partida IS NOT NULL AND v_hora_partida IS NOT NULL THEN
        SELECT COUNT(*) INTO v_conflicto
        FROM UTILIZA u  
        JOIN ORGANIZA o ON u.id_partida = o.id_partida
        WHERE u.id_expansion = NEW.id_expansion       
          AND u.nombre_expansion = NEW.nombre_expansion 
          AND o.fecha = v_fecha_partida
          AND o.hora = v_hora_partida
          AND u.id_partida != NEW.id_partida; -- menos la propia partida

        IF v_conflicto > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Conflicto de horario (Expansión): La copia específica de la expansión ya está asignada a otra partida en esa fecha y hora.';
        END IF;
    END IF;
END //
DELIMITER ;