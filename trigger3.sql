DELIMITER //

CREATE TRIGGER trg_juego_delete_integrity
BEFORE DELETE ON JUEGO
FOR EACH ROW
BEGIN
    DECLARE v_partidas_asociadas INT DEFAULT 0;

    -- Contar cuántas partidas están asociadas a CUALQUIER copia de este juego.
    -- La tabla PARTIDA tiene directamente nombre_juego.
    SELECT COUNT(*) INTO v_partidas_asociadas
    FROM PARTIDA
    WHERE nombre_juego = OLD.nombre_juego; -- OLD.nombre_juego es el juego que se intenta borrar

    -- Si hay partidas asociadas, impedir el borrado
    IF v_partidas_asociadas > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar el juego: existen partidas asociadas.';
    END IF;
END //

DELIMITER ;