DROP SCHEMA IF EXISTS trabajo;
-- 1. Crear el schema y usarlo
CREATE SCHEMA IF NOT EXISTS trabajo
  DEFAULT CHARACTER SET utf8
  COLLATE utf8_bin;
USE trabajo;

-- 2. Tablas principales

CREATE TABLE jugador (
    nombre_jugador VARCHAR(80) NOT NULL,
    PRIMARY KEY (nombre_jugador)
);

CREATE TABLE juego (
    nombre_juego VARCHAR(80) NOT NULL,
    PRIMARY KEY (nombre_juego)
);

CREATE TABLE personal (
    nombre_personal VARCHAR(80) NOT NULL,
    PRIMARY KEY (nombre_personal)
);

CREATE TABLE expansion (
    nombre_expansion VARCHAR(80) NOT NULL,
    nombre_juego VARCHAR(80) NOT NULL,
    PRIMARY KEY (nombre_expansion),
    FOREIGN KEY (nombre_juego)
      REFERENCES juego(nombre_juego)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
);

CREATE TABLE copia_juego (
    id_juego INT NOT NULL,
    nombre_juego VARCHAR(80) NOT NULL,
    coste_juego INT NOT NULL,
    PRIMARY KEY (id_juego, nombre_juego),
    FOREIGN KEY (nombre_juego)
      REFERENCES juego(nombre_juego)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
);



CREATE TABLE copia_expansion (
    id_expansion INT NOT NULL,
    nombre_expansion VARCHAR(80) NOT NULL,
    coste_expansion INT NOT NULL,
    PRIMARY KEY (id_expansion, nombre_expansion),
    FOREIGN KEY (nombre_expansion)
      REFERENCES expansion(nombre_expansion)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
);


-- 3. Partidas y relaciones con copias de juego

CREATE TABLE partida (
    id_partida INT NOT NULL AUTO_INCREMENT,
    id_juego     INT  NOT NULL,
    nombre_juego VARCHAR(80) NOT NULL,
    PRIMARY KEY (id_partida),
    -- FK compuesta hacia COPIA_JUEGO(id_juego, nombre_juego)
    FOREIGN KEY (id_juego, nombre_juego)
      REFERENCES copia_juego(id_juego, nombre_juego)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
);

CREATE TABLE juega (
    nombre_jugador VARCHAR(80) NOT NULL,
    id_partida     INT  NOT NULL,
    PRIMARY KEY (nombre_jugador, id_partida),
    FOREIGN KEY (nombre_jugador)
      REFERENCES jugador(nombre_jugador)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (id_partida)
      REFERENCES partida(id_partida)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE gana (
    nombre_jugador VARCHAR(80) NOT NULL,
    id_partida     INT  NOT NULL,
    PRIMARY KEY (nombre_jugador, id_partida),
    FOREIGN KEY (nombre_jugador)
      REFERENCES jugador(nombre_jugador)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (id_partida)
      REFERENCES partida(id_partida)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE organiza (
    nombre_personal VARCHAR(80) NOT NULL,
    id_partida      INT  NOT NULL,
    fecha           DATE NOT NULL,
    hora            TIME NOT NULL,
    PRIMARY KEY (nombre_personal, id_partida),
    FOREIGN KEY (nombre_personal)
      REFERENCES personal(nombre_personal)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (id_partida)
      REFERENCES partida(id_partida)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

-- 4. Uso de expansiones en cada partida

CREATE TABLE utiliza (
    id_partida INT NOT NULL,
    id_expansion     INT NOT NULL,
    nombre_expansion VARCHAR(80) NOT NULL,
    PRIMARY KEY (id_partida, id_expansion, nombre_expansion),
    FOREIGN KEY (id_partida)
      REFERENCES partida(id_partida)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (id_expansion, nombre_expansion)
      REFERENCES copia_expansion(id_expansion, nombre_expansion)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
);
