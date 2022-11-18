#--------------------------
# Start setup
#--------------------------
DROP SCHEMA IF EXISTS testdb;
CREATE SCHEMA IF NOT EXISTS testdb;
USE testdb ;
 
#--------------------------
# Creating tables
#--------------------------
CREATE TABLE IF NOT EXISTS testdb.Usuario (
  id            INT(11)         NOT NULL    AUTO_INCREMENT,
  nome          VARCHAR(255)    NOT NULL,
  rg            VARCHAR(255)    NOT NULL,
  cpf           VARCHAR(255)    NOT NULL,
  n_telefone    VARCHAR(255)    NULL        DEFAULT NULL,
  email         VARCHAR(255)    NOT NULL,
  usuario       VARCHAR(30)     NOT NULL,
  nascimento    DATE            NOT NULL,
  cadastro      DATE            NOT NULL    DEFAULT CURRENT_TIMESTAMP(),
  bloqueado     TINYINT(1)      NOT NULL    DEFAULT 0,
  senha         INT(11)         NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS testdb.Administrador (
  id                INT(11)     NOT NULL    AUTO_INCREMENT,
  usuario_id        INT(11)     NOT NULL,
  PRIMARY KEY (id)
);
 
CREATE TABLE IF NOT EXISTS testdb.Responsavel (
  id                INT(11)         NOT NULL    AUTO_INCREMENT,
  usuario_id        INT(11)         NOT NULL,
  matricula_id      VARCHAR(255)    NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS testdb.Aluno (
  id                INT(11)         NOT NULL    AUTO_INCREMENT,
  matricula         VARCHAR(255)    NOT NULL    UNIQUE,
  cadastrador_id    INT(11)         NOT NULL,
  responsavel_id    INT(11)         NOT NULL,
  usuario_id        INT(11)         NOT NULL,
  PRIMARY KEY (id)
);
 
CREATE TABLE IF NOT EXISTS testdb.Tarefa (
  id        INT(11)       NOT NULL  AUTO_INCREMENT,
  titulo    VARCHAR(255)  NOT NULL,
  situacao  BOOLEAN       NOT NULL DEFAULT 0,
  prazo     DATE          NOT NULL,
  notaMax   FLOAT         NOT NULL,
  nota      FLOAT         DEFAULT NULL,
  turma_id  INT(11)       NOT NULL,
  PRIMARY KEY (id)
);

#--------------------------
# Adding foreign key
#--------------------------
ALTER TABLE testdb.Administrador ADD 
    CONSTRAINT fk_usuario_administrador 
        FOREIGN KEY (usuario_id) 
        REFERENCES testdb.Usuario (id);


ALTER TABLE testdb.Responsavel ADD 
    CONSTRAINT fk_aluno_matricula 
        FOREIGN KEY (matricula_id) 
        REFERENCES testdb.Aluno (matricula);

ALTER TABLE testdb.Responsavel ADD 
    CONSTRAINT fk_usuario_responsavel 
        FOREIGN KEY (usuario_id) 
        REFERENCES testdb.Usuario (id);


ALTER TABLE testdb.Aluno ADD 
    CONSTRAINT fk_cadastrador 
        FOREIGN KEY (cadastrador_id) 
        REFERENCES testdb.Administrador (id);

ALTER TABLE testdb.Aluno ADD 
    CONSTRAINT fk_responsavel 
        FOREIGN KEY (responsavel_id) 
        REFERENCES testdb.Responsavel (id);

ALTER TABLE testdb.Aluno ADD 
    CONSTRAINT fk_usuario_aluno 
        FOREIGN KEY (usuario_id) 
        REFERENCES testdb.Usuario (id);

ALTER TABLE testdb.Tarefa ADD
     CONSTRAINT fk_turma_Tarefa 
      FOREIGN KEY (turma_id) 
      REFERENCES testdb.Turma (id);