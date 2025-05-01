-- 1. Crear el schema y usarlo
CREATE SCHEMA IF NOT EXISTS trabajo
  DEFAULT CHARACTER SET utf8
  COLLATE utf8_spanish2_ci;
USE trabajo;

-- 2. Tablas principales

CREATE TABLE JUGADOR (
    nombre_jugador VARCHAR(60) NOT NULL,
    PRIMARY KEY (nombre_jugador)
);

CREATE TABLE JUEGO (
    nombre_juego VARCHAR(60) NOT NULL,
    PRIMARY KEY (nombre_juego)
);

CREATE TABLE COPIA_JUEGO (
    id_juego INT NOT NULL AUTO_INCREMENT,
    nombre_juego VARCHAR(60) NOT NULL,
    PRIMARY KEY (id_juego, nombre_juego),
    FOREIGN KEY (nombre_juego)
      REFERENCES JUEGO(nombre_juego)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
);

CREATE TABLE EXPANSION (
    nombre_exp VARCHAR(60) NOT NULL,
    nombre_juego VARCHAR(60) NOT NULL,
    PRIMARY KEY (nombre_exp),
    FOREIGN KEY (nombre_juego)
      REFERENCES JUEGO(nombre_juego)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
);

CREATE TABLE COPIA_EXPANSION (
    id_exp INT NOT NULL AUTO_INCREMENT,
    nombre_exp VARCHAR(60) NOT NULL,
    precio INT NOT NULL,
    PRIMARY KEY (id_exp, nombre_exp),
    FOREIGN KEY (nombre_exp)
      REFERENCES EXPANSION(nombre_exp)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
);

CREATE TABLE PERSONAL (
    nombre_personal VARCHAR(60) NOT NULL,
    PRIMARY KEY (nombre_personal)
);

-- 3. Partidas y relaciones con copias de juego

CREATE TABLE PARTIDA (
    id_partida INT NOT NULL AUTO_INCREMENT,
    id_juego     INT  NOT NULL,
    nombre_juego VARCHAR(60) NOT NULL,
    PRIMARY KEY (id_partida),
    -- FK compuesta hacia COPIA_JUEGO(id_juego, nombre_juego)
    FOREIGN KEY (id_juego, nombre_juego)
      REFERENCES COPIA_JUEGO(id_juego, nombre_juego)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
);

CREATE TABLE JUEGA (
    nombre_jugador VARCHAR(60) NOT NULL,
    id_partida     INT  NOT NULL,
    PRIMARY KEY (nombre_jugador, id_partida),
    FOREIGN KEY (nombre_jugador)
      REFERENCES JUGADOR(nombre_jugador)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (id_partida)
      REFERENCES PARTIDA(id_partida)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE GANA (
    nombre_jugador VARCHAR(60) NOT NULL,
    id_partida     INT  NOT NULL,
    PRIMARY KEY (nombre_jugador, id_partida),
    FOREIGN KEY (nombre_jugador)
      REFERENCES JUGADOR(nombre_jugador)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (id_partida)
      REFERENCES PARTIDA(id_partida)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE ORGANIZA (
    nombre_personal VARCHAR(60) NOT NULL,
    id_partida      INT  NOT NULL,
    fecha           DATE NOT NULL,
    hora            TIME NOT NULL,
    PRIMARY KEY (nombre_personal, id_partida),
    FOREIGN KEY (nombre_personal)
      REFERENCES PERSONAL(nombre_personal)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (id_partida)
      REFERENCES PARTIDA(id_partida)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

-- 4. Uso de expansiones en cada partida

CREATE TABLE UTILIZA (
    id_partida INT NOT NULL,
    id_exp     INT NOT NULL,
    nombre_exp VARCHAR(60) NOT NULL,
    PRIMARY KEY (id_partida, id_exp, nombre_exp),
    FOREIGN KEY (id_partida)
      REFERENCES PARTIDA(id_partida)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (id_exp, nombre_exp)
      REFERENCES COPIA_EXPANSION(id_exp, nombre_exp)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
);
