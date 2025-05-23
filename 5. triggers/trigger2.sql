DELIMITER //

CREATE TRIGGER trg_organiza_horario_insert
BEFORE INSERT ON ORGANIZA
FOR EACH ROW
BEGIN
    DECLARE v_conflicto INT DEFAULT 0;

    -- ver si el personal ya organiza otra partida en esa fecha y hora
    SELECT COUNT(*) INTO v_conflicto
    FROM ORGANIZA
    WHERE nombre_personal = NEW.nombre_personal
      AND fecha = NEW.fecha
      AND hora = NEW.hora
      AND id_partida != NEW.id_partida; -- por si alguna vez se reusara para un UPDATE
                                        
    IF v_conflicto > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Conflicto de horario: el personal ya tiene otra partida asignada en esa fecha y hora.';
    END IF;
END //

DELIMITER ;