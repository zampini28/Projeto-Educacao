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
    usuario     VARCHAR(255)    NOT NULL    UNIQUE,
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
# Stored Procedures
#--------------------------
DELIMITER $$
CREATE PROCEDURE adicionar_administrador (
 IN nome_ VARCHAR(255), IN rg_ VARCHAR(255), IN cpf_ VARCHAR(255),
 IN n_telefone_ VARCHAR(255), IN email_ VARCHAR(255), IN usuario_ VARCHAR(255),
 IN nascimento_ VARCHAR(255), IN senha_ VARCHAR(255)
 )
BEGIN
    INSERT INTO testdb.Usuario VALUES 
    (DEFAULT, nome_, rg_, cpf_, n_telefone_, email_, usuario_, nascimento_, DEFAULT, DEFAULT, senha_);
    INSERT INTO testdb.Administrador VALUES
    (DEFAULT, (SELECT id FROM testdb.Usuario WHERE usuario=usuario_));
END $$

CREATE PROCEDURE adicionar_professor (
 IN nome_ VARCHAR(255), IN rg_ VARCHAR(255), IN cpf_ VARCHAR(255),
 IN n_telefone_ VARCHAR(255), IN email_ VARCHAR(255), IN usuario_ VARCHAR(255),
 IN nascimento_ VARCHAR(255), IN senha_ VARCHAR(255), IN disciplina_ VARCHAR(255))
BEGIN
    INSERT INTO testdb.Usuario VALUES 
    (DEFAULT, nome_, rg_, cpf_, n_telefone_, email_, usuario_, nascimento_, DEFAULT, DEFAULT, senha_);
    INSERT INTO testdb.Professor VALUES
    (DEFAULT, (SELECT id FROM testdb.Disciplina WHERE disciplina=disciplina_), 
    (SELECT id FROM testdb.Usuario WHERE usuario=usuario_));
END $$

CREATE PROCEDURE adicionar_responsavel (
 IN nome_ VARCHAR(255), IN rg_ VARCHAR(255), IN cpf_ VARCHAR(255),
 IN n_telefone_ VARCHAR(255), IN email_ VARCHAR(255), IN usuario_ VARCHAR(255),
 IN nascimento_ VARCHAR(255), IN senha_ VARCHAR(255), IN cadastrador INT)
BEGIN
    INSERT INTO testdb.Usuario VALUES 
    (DEFAULT, nome_, rg_, cpf_, n_telefone_, email_, usuario_, nascimento_, DEFAULT, DEFAULT, senha_);
    INSERT INTO testdb.Responsavel VALUES
    (DEFAULT, cadastrador, (SELECT id FROM testdb.Usuario WHERE usuario=usuario_));
END $$

CREATE PROCEDURE adicionar_aluno (
 IN nome_ VARCHAR(255), IN rg_ VARCHAR(255), IN cpf_ VARCHAR(255),
 IN n_telefone_ VARCHAR(255), IN email_ VARCHAR(255), IN usuario_ VARCHAR(255),
 IN nascimento_ VARCHAR(255), IN senha_ VARCHAR(255), IN matricula_ VARCHAR(255), 
 IN cadastrador_id_ INT)
BEGIN
    INSERT INTO testdb.Usuario VALUES 
    (DEFAULT, nome_, rg_, cpf_, n_telefone_, email_, usuario_, nascimento_, DEFAULT, DEFAULT, senha_);
    INSERT INTO testdb.Aluno VALUES
    (DEFAULT, matricula_, cadastrador_id_, (SELECT id FROM testdb.Usuario WHERE usuario=usuario_));
END $$
DELIMITER ;

#--------------------------
# Inserting new records
#--------------------------
SET @id_do_cadastrador = 1;

INSERT INTO testdb.Disciplina 
 (disciplina)
VALUES
 ('Língua Portuguesa'), ('Matemática'), ('História'), ('Geografia'),
 ('Ciências'), ('Artes'), ('Educação Física'), ('Inglês');
 
CALL testdb.adicionar_administrador (
 'Fernanda Araujo Souza', '49.296.479-8', '645.170.901-83', 
 '(11) 99681-2557', 'FernandaAraujoSouza@gmail.com', 
 'FernandaSouza', '1996-01-31', 'eeFee6ohl');

CALL testdb.adicionar_professor (
 'Júlio Costa Souza', '47.166.673-3', '404.836.087-69', 
 '(11) 97527-7296', 'JulioCostaSouza@gmail.com', 
 'JúlioCosta', '1991-04-28', 'oov7fu8I', 'Matemática');

CALL testdb.adicionar_professor (
 'Eduarda Pereira Oliveira', '54.820.520-4', '328.620.228-29', 
 '(11) 93283-3603', 'EduardaPereiraOliveira@gmail.com', 
 'EduardaPOliveira', '1998-03-30', 'Quoor5OoGh2', 'Língua Portuguesa');
 
CALL testdb.adicionar_responsavel (
 'Breno Fernandes Rodrigues', '45.392.117-4', '507.346.788-43', 
 '(11) 94690-3040', 'BrenoFernandesRodrigues@gmail.com', 
 'Breno_Fernandes', '1951-07-30', 'iqu2dohPhai', @id_do_cadastrador);

CALL testdb.adicionar_responsavel (
 'Daniel Araujo Carvalho', '45.392.179-3', '269.857.143-82', 
 '(11) 95062-5064', 'DanielAraujoCarvalho@gmail.com', 
 'DanielAraujo_Carvalho', '1989-04-19', 'Biezae4aer', @id_do_cadastrador);

CALL testdb.adicionar_responsavel (
 'Mariana Santos Rocha', '49.298.328-8', '459.842.703-58', 
 '(11) 92981-3140', 'MarianaSantosRocha@gmail.com', 
 'Mariana.S.Rocha', '1977-01-21', 'Neip0unai0', @id_do_cadastrador);
 
CALL testdb.adicionar_aluno (
 'Luana Rocha Sousa', '45.560.970-9', '551.296.556-56', 
 '(11) 96845-6020', 'LuanaRochaSousa@gmail.com', 
 'LuanaRocha', '2006-06-12', 'ahShoop7ath', '2009201003009-8', @id_do_cadastrador);

CALL testdb.adicionar_aluno ('
 Melissa Ferreira Barbosa', '53.459.957-9', '162.146.465-27', 
 '(11) 97058-6574', 'MelissaFerreiraBarbosa@gmail.com', 
 'MFerreira', '2006-09-13', 'Piej8eeYi', '2529701099009-4', @id_do_cadastrador);
 
CALL testdb.adicionar_aluno (
 'Luis Silva Pinto', '52.606.404-2', '283.707.729-19', 
 '(11) 92215-2205', 'LuisSilvaPinto@gmail.com', 
 'LuizSPinto', '2006-10-22', 'cah9tah2Ei', '5821201033009-6', @id_do_cadastrador);

CALL testdb.adicionar_aluno (
 'Carla Correia Rocha', '55.422.483-9', '998.224.670-44', 
 '(11) 98255-7689', 'CarlaCorreiaRocha@gmail.com', 
 'CCrocha', '2006-12-29', 'ahsheiG4oogh', '9425501033029-5', @id_do_cadastrador);
 
UPDATE testdb.Professor
SET disciplina_id = (SELECT id FROM testdb.Disciplina WHERE disciplina='Ciências')
WHERE usuario_id=(SELECT id FROM testdb.Usuario WHERE usuario='JúlioCosta');

CALL testdb.adicionar_administrador (
 'Nicole Santos Castro', '54.004.755-5', '955.915.067-71',
 '(11) 96512-7796', 'NicoleSantosCastro@gmail.com',
 'NicoleCastro', '1957-07-08', 'No4nee6zaigh');


DELETE FROM testdb.Administrador WHERE usuario_id=
 (SELECT id FROM testdb.Usuario WHERE usuario='NicoleCastro');

DELETE FROM testdb.Usuario WHERE usuario='NicoleCastro';
