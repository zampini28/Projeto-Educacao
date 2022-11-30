#--------------------------
# Start setup
#--------------------------
DROP SCHEMA IF EXISTS testdb;
CREATE SCHEMA IF NOT EXISTS testdb;
USE testdb;

#--------------------------
# Creating tables
#--------------------------
CREATE TABLE IF NOT EXISTS testdb.Usuario (
    id          INT             NOT NULL    AUTO_INCREMENT,
    nome        VARCHAR(255)    NOT NULL,
    rg          VARCHAR(255)    NOT NULL,
    cpf         VARCHAR(255)    NOT NULL,
    n_telefone  VARCHAR(255)    NULL        DEFAULT NULL,
    email       VARCHAR(255)    NOT NULL,
    usuario     VARCHAR(255)    NOT NULL,
    nascimento  DATE            NOT NULL,
    cadastro    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP(),
    bloqueado   TINYINT         NOT NULL    DEFAULT 0,
    senha       VARCHAR(255)    NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS testdb.Administrador (
    id          INT NOT NULL    AUTO_INCREMENT,
    usuario_id  INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS testdb.Professor (
    id              INT NOT NULL    AUTO_INCREMENT,
    disciplina_id   INT NOT NULL,
    usuario_id      INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS testdb.Responsavel (
    id              INT             NOT NULL    AUTO_INCREMENT,
    cadastrador_id  INT             NOT NULL,
    usuario_id      INT             NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS testdb.Aluno (
    id              INT             NOT NULL    AUTO_INCREMENT,
    matricula       VARCHAR(255)    NOT NULL    UNIQUE,
    cadastrador_id  INT             NOT NULL,
    usuario_id      INT             NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS testdb.Turma (
    id  INT NOT NULL    AUTO_INCREMENT,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS testdb.Nota (
    id          INT     NOT NULL    AUTO_INCREMENT,
    aluno_id    INT     NOT NULL,
    turma_id    INT     NOT NULL,
    prova       DOUBLE  NULL        DEFAULT NULL,
    trabalho    DOUBLE  NULL        DEFAULT NULL,
    nota_final  DOUBLE  NULL        DEFAULT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS testdb.FAQ (
    id                  INT         NOT NULL    AUTO_INCREMENT,
    autor_usuario_id    INT         NOT NULL,
    conteudo            TEXT        NOT NULL,
    `data`              DATETIME    NOT NULL    DEFAULT CURRENT_TIMESTAMP(),
    turma_id            INT         NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS testdb.Tarefa (
    id          INT             NOT NULL    AUTO_INCREMENT,
    titulo      VARCHAR(255)    NOT NULL,
    `status`    TINYINT         NOT NULL    DEFAULT 0,
    prazo       DATETIME        NOT NULL,
    notaMax     DOUBLE          NOT NULL    DEFAULT 10,
    nota        DOUBLE          NULL        DEFAULT NULL,
    turma_id    INT             NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS testdb.Feedback (
    id          INT             NOT NULL    AUTO_INCREMENT,
    titulo      VARCHAR(255)    NOT NULL,
    `data`      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP(),
    turma_id    INT             NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS testdb.Calendario (
    id          INT             NOT NULL    AUTO_INCREMENT,
    titulo      VARCHAR(255)    NOT NULL,
    turma_id    INT             NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS testdb.Notificacao (
    id          INT NOT NULL    AUTO_INCREMENT,
    aluno_id    INT NOT NULL,
    turma_id    INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS testdb.Material (
    id          INT             NOT NULL    AUTO_INCREMENT,
    titulo      VARCHAR(255)    NOT NULL,
    `data`      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP(),
    turma_id    INT             NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS testdb.Disciplina (
    id          INT             NOT NULL    AUTO_INCREMENT,
    disciplina  VARCHAR(255)    NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS testdb.Aluno_Responsavel (
    id              INT NOT NULL    AUTO_INCREMENT,
    responsavel_id  INT NOT NULL,
    aluno_id        INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS testdb.Analysis (
    id  INT             NOT NULL    AUTO_INCREMENT  PRIMARY KEY,
    ac  VARCHAR(100)    NOT NULL    DEFAULT '111',
    aj  VARCHAR(92)     NULL        DEFAULT '{"x": 333}',
    bx  INT             NOT NULL    DEFAULT '50123111'
);

DROP TABLE testdb.Analysis;

#--------------------------
# Adding Foreign Key
#--------------------------
ALTER TABLE testdb.Administrador
    ADD CONSTRAINT fk_usuario_administrador
        FOREIGN KEY (usuario_id)
        REFERENCES testdb.Usuario (id);


ALTER TABLE testdb.Professor
    ADD CONSTRAINT fk_disciplina_professor
        FOREIGN KEY (disciplina_id)
        REFERENCES testdb.Disciplina (id),

        ADD CONSTRAINT fk_usuario_professor
        FOREIGN KEY (usuario_id)
        REFERENCES testdb.Usuario (id);


ALTER TABLE testdb.Responsavel
    ADD CONSTRAINT fk_administrador_responsavel
        FOREIGN KEY (cadastrador_id)
        REFERENCES testdb.Administrador (id),

    ADD CONSTRAINT fk_usuario_responsavel
        FOREIGN KEY (usuario_id)
        REFERENCES testdb.Usuario (id);


ALTER TABLE testdb.Aluno
    ADD CONSTRAINT fk_administrador_aluno
        FOREIGN KEY (cadastrador_id)
        REFERENCES testdb.Administrador (id),
  
    ADD CONSTRAINT fk_usuario_aluno
        FOREIGN KEY (usuario_id)
        REFERENCES testdb.Usuario (id);
    

ALTER TABLE testdb.Nota
    ADD CONSTRAINT fk_aluno_nota
        FOREIGN KEY (aluno_id)
        REFERENCES testdb.Aluno (id),

    ADD CONSTRAINT fk_turma_nota
        FOREIGN KEY (turma_id)
        REFERENCES testdb.Turma (id);


ALTER TABLE testdb.FAQ
    ADD CONSTRAINT fk_usuario_faq
        FOREIGN KEY (autor_usuario_id)
        REFERENCES testdb.Usuario (id),
    
    ADD CONSTRAINT fk_turma_faq
        FOREIGN KEY (turma_id)
        REFERENCES testdb.Turma (id);


ALTER TABLE testdb.Tarefa
    ADD CONSTRAINT fk_turma_tarefa
        FOREIGN KEY (turma_id)
        REFERENCES testdb.Turma (id);


ALTER TABLE testdb.Feedback
    ADD CONSTRAINT fk_turma_feedback
        FOREIGN KEY (turma_id)
        REFERENCES testdb.Turma (id);


ALTER TABLE testdb.Calendario
    ADD CONSTRAINT fk_turma_calendario
        FOREIGN KEY (turma_id)
        REFERENCES testdb.Turma (id);


ALTER TABLE testdb.Notificacao
    ADD CONSTRAINT fk_aluno_notificacao
        FOREIGN KEY (aluno_id)
        REFERENCES testdb.Aluno (id),

    ADD CONSTRAINT fk_turma_notificacao
        FOREIGN KEY (turma_id)
        REFERENCES testdb.Turma (id);


ALTER TABLE testdb.Material
    ADD CONSTRAINT fk_turma_material
        FOREIGN KEY (turma_id)
        REFERENCES testdb.Turma (id);


ALTER TABLE testdb.Aluno_Responsavel
    ADD CONSTRAINT fk_responsavel_alunoreponsavel
        FOREIGN KEY (responsavel_id)
        REFERENCES testdb.Responsavel (id),

    ADD CONSTRAINT fk_aluno_alunoreponsavel
        FOREIGN KEY (aluno_id)
        REFERENCES testdb.Aluno (id);

#--------------------------
# Inserting new records
#--------------------------
