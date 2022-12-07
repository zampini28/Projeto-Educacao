#--------------------------
# Start setup
#--------------------------

# -- Configuration for the functions to work correctly --
SET GLOBAL log_bin_trust_function_creators = 1;
SET SQL_SAFE_UPDATES = 0;

# -- DROP database --
DROP SCHEMA IF EXISTS testdb;

# -- CREATE & USE database --
CREATE SCHEMA IF NOT EXISTS testdb;
USE testdb;

#--------------------------
# Creating tables
#--------------------------

# -- TABLE Usuario --
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

# -- TABLE Administrador --
CREATE TABLE IF NOT EXISTS testdb.Administrador (
    id          INT NOT NULL    AUTO_INCREMENT,
    usuario_id  INT NOT NULL,
    PRIMARY KEY (id)
);

# -- TABLE Professor --
CREATE TABLE IF NOT EXISTS testdb.Professor (
    id              INT NOT NULL    AUTO_INCREMENT,
    disciplina_id   INT NOT NULL,
    usuario_id      INT NOT NULL,
    PRIMARY KEY (id)
);

# -- TABLE Responsavel --
CREATE TABLE IF NOT EXISTS testdb.Responsavel (
    id              INT NOT NULL    AUTO_INCREMENT,
    cadastrador_id  INT NOT NULL,
    usuario_id      INT NOT NULL,
    PRIMARY KEY (id)
);

# -- TABLE Aluno --
CREATE TABLE IF NOT EXISTS testdb.Aluno (
    id              INT             NOT NULL    AUTO_INCREMENT,
    matricula       VARCHAR(255)    NOT NULL    UNIQUE,
    cadastrador_id  INT             NOT NULL,
    usuario_id      INT             NOT NULL,
    PRIMARY KEY (id)
);

# -- TABLE Turma --
CREATE TABLE IF NOT EXISTS testdb.Turma (
    id              INT             NOT NULL    AUTO_INCREMENT,
    nome            VARCHAR(255)    NOT NULL,
    disciplina_id   INT             NOT NULL,
    PRIMARY KEY (id)
);

# -- TABLE Nota --
CREATE TABLE IF NOT EXISTS testdb.Nota (
    id          INT     NOT NULL    AUTO_INCREMENT,
    aluno_id    INT     NOT NULL,
    turma_id    INT     NOT NULL,
    prova       DOUBLE  NULL        DEFAULT NULL,
    trabalho    DOUBLE  NULL        DEFAULT NULL,
    nota_final  DOUBLE  NULL        DEFAULT NULL,
    PRIMARY KEY (id)
);

# -- TABLE FAQ --
CREATE TABLE IF NOT EXISTS testdb.FAQ (
    id                  INT         NOT NULL    AUTO_INCREMENT,
    autor_usuario_id    INT         NOT NULL,
    conteudo            TEXT        NOT NULL,
    `data`              DATETIME    NOT NULL    DEFAULT CURRENT_TIMESTAMP(),
    turma_id            INT         NOT NULL,
    PRIMARY KEY (id)
);

# -- TABLE Tarefa --
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

# -- TABLE Feedback --
CREATE TABLE IF NOT EXISTS testdb.Feedback (
    id          INT             NOT NULL    AUTO_INCREMENT,
    titulo      VARCHAR(255)    NOT NULL,
    `data`      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP(),
    turma_id    INT             NOT NULL,
    PRIMARY KEY (id)
);

# -- TABLE Calendario --
CREATE TABLE IF NOT EXISTS testdb.Calendario (
    id                  INT             NOT NULL    AUTO_INCREMENT,
    titulo              VARCHAR(255)    NOT NULL,
    link                VARCHAR(255)    NOT NULL,
    administrador_id    INT             NOT NULL,
    PRIMARY KEY (id)
);

# -- TABLE Notificacao --
CREATE TABLE IF NOT EXISTS testdb.Notificacao (
    id          INT             NOT NULL    AUTO_INCREMENT,
    conteudo    VARCHAR(255)    NOT NULL,
    aluno_id    INT             NOT NULL,
    turma_id    INT             NOT NULL,
    PRIMARY KEY (id)
);

# -- TABLE Material --
CREATE TABLE IF NOT EXISTS testdb.Material (
    id          INT             NOT NULL    AUTO_INCREMENT,
    titulo      VARCHAR(255)    NOT NULL,
    `data`      DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP(),
    turma_id    INT             NOT NULL,
    PRIMARY KEY (id)
);

# -- TABLE Disciplina --
CREATE TABLE IF NOT EXISTS testdb.Disciplina (
    id          INT             NOT NULL    AUTO_INCREMENT,
    disciplina  VARCHAR(255)    NOT NULL,
    PRIMARY KEY (id)
);

# -- TABLE Aluno_Responsavel --
CREATE TABLE IF NOT EXISTS testdb.Aluno_Responsavel (
    id              INT NOT NULL    AUTO_INCREMENT,
    responsavel_id  INT NOT NULL,
    aluno_id        INT NOT NULL,
    PRIMARY KEY (id)
);

# -- DROP TABLE Analysis -- 
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

# -- ALTER TABLE ADD FK Usuario.id -> Administrador -- 
ALTER TABLE testdb.Administrador
    ADD CONSTRAINT fk_usuario_administrador
        FOREIGN KEY (usuario_id)
        REFERENCES testdb.Usuario (id);


# -- ALTER TABLE ADD FK Disciplina.id & Usuario.id -> Professor -- 
ALTER TABLE testdb.Professor
    ADD CONSTRAINT fk_disciplina_professor
        FOREIGN KEY (disciplina_id)
        REFERENCES testdb.Disciplina (id),

        ADD CONSTRAINT fk_usuario_professor
        FOREIGN KEY (usuario_id)
        REFERENCES testdb.Usuario (id);


# -- ALTER TABLE ADD FK Administrador.id & Usuario.id -> Responsavel -- 
ALTER TABLE testdb.Responsavel
    ADD CONSTRAINT fk_administrador_responsavel
        FOREIGN KEY (cadastrador_id)
        REFERENCES testdb.Administrador (id),

    ADD CONSTRAINT fk_usuario_responsavel
        FOREIGN KEY (usuario_id)
        REFERENCES testdb.Usuario (id);


# -- ALTER TABLE ADD FK Administrador.id & Usuario.id -> Aluno -- 
ALTER TABLE testdb.Aluno
    ADD CONSTRAINT fk_administrador_aluno
        FOREIGN KEY (cadastrador_id)
        REFERENCES testdb.Administrador (id),
  
    ADD CONSTRAINT fk_usuario_aluno
        FOREIGN KEY (usuario_id)
        REFERENCES testdb.Usuario (id);
    

# -- ALTER TABLE ADD FK Disciplina.id -> Turma -- 
ALTER TABLE testdb.Turma
    ADD CONSTRAINT fk_disciplina_turma
        FOREIGN KEY (disciplina_id)
        REFERENCES testdb.Disciplina (id);

# -- ALTER TABLE ADD FK Aluno.id & Turma.id -> Nota -- 
ALTER TABLE testdb.Nota
    ADD CONSTRAINT fk_aluno_nota
        FOREIGN KEY (aluno_id)
        REFERENCES testdb.Aluno (id),

    ADD CONSTRAINT fk_turma_nota
        FOREIGN KEY (turma_id)
        REFERENCES testdb.Turma (id);


# -- ALTER TABLE ADD FK Usuario.id & Turma.id -> FAQ -- 
ALTER TABLE testdb.FAQ
    ADD CONSTRAINT fk_usuario_faq
        FOREIGN KEY (autor_usuario_id)
        REFERENCES testdb.Usuario (id),
    
    ADD CONSTRAINT fk_turma_faq
        FOREIGN KEY (turma_id)
        REFERENCES testdb.Turma (id);


# -- ALTER TABLE ADD FK Turma.id -> Tarefa -- 
ALTER TABLE testdb.Tarefa
    ADD CONSTRAINT fk_turma_tarefa
        FOREIGN KEY (turma_id)
        REFERENCES testdb.Turma (id);


# -- ALTER TABLE ADD FK Turma.id -> Feedback -- 
ALTER TABLE testdb.Feedback
    ADD CONSTRAINT fk_turma_feedback
        FOREIGN KEY (turma_id)
        REFERENCES testdb.Turma (id);


# -- ALTER TABLE ADD FK Turma.id -> Calendario -- 
ALTER TABLE testdb.Calendario
    ADD CONSTRAINT fk_administrador_calendario
        FOREIGN KEY (administrador_id)
        REFERENCES testdb.Administrador (id);


# -- ALTER TABLE ADD FK Aluno.id & Turma.id -> Notificacao -- 
ALTER TABLE testdb.Notificacao
    ADD CONSTRAINT fk_aluno_notificacao
        FOREIGN KEY (aluno_id)
        REFERENCES testdb.Aluno (id),

    ADD CONSTRAINT fk_turma_notificacao
        FOREIGN KEY (turma_id)
        REFERENCES testdb.Turma (id);


# -- ALTER TABLE ADD FK Turma.id -> Material -- 
ALTER TABLE testdb.Material
    ADD CONSTRAINT fk_turma_material
        FOREIGN KEY (turma_id)
        REFERENCES testdb.Turma (id);


# -- ALTER TABLE ADD FK Responsavel.id & Aluno.id -> Aluno_Responsavel -- 
ALTER TABLE testdb.Aluno_Responsavel
    ADD CONSTRAINT fk_responsavel_alunoresponsavel
        FOREIGN KEY (responsavel_id)
        REFERENCES testdb.Responsavel (id),

    ADD CONSTRAINT fk_aluno_alunoresponsavel
        FOREIGN KEY (aluno_id)
        REFERENCES testdb.Aluno (id);

#--------------------------
# Functions
#--------------------------
DELIMITER $$

# -- FUNCTION GET Turma.nome RETURN Turma.id --
CREATE FUNCTION turma_nome_pegar_turma_id(nome_ VARCHAR(255))
RETURNS INT
BEGIN
    SET @turma_id_ = (SELECT id FROM testdb.Turma WHERE nome=nome_);
    RETURN @turma_id_;
END $$


# -- FUNCTION GET Usuario.usuario RETURN Aluno.id --
CREATE FUNCTION usuario_pegar_aluno_id(usuario_ VARCHAR(255))
RETURNS INT
BEGIN
    SET @usuario_id_ = (SELECT id FROM testdb.Usuario WHERE usuario=usuario_);
    SET @aluno_id_ = (SELECT id FROM testdb.Aluno WHERE usuario_id=@usuario_id_);
    RETURN @aluno_id_;
END $$


# -- FUNCTION GET Disciplina.disciplina RETURN Disciplina.id --
CREATE FUNCTION disciplina_nome_pegar_id(disciplina_ VARCHAR(255))
RETURNS INT
BEGIN
    set @disciplina_id_ = (SELECT id FROM testdb.Disciplina WHERE disciplina=disciplina_);

    return @disciplina_id_;
END $$


# -- FUNCTION GET Usuario.usuario RETURN Usuario.id --
CREATE FUNCTION usuario_pegar_usuario_id(usuario_ VARCHAR(255))
RETURNS INT
BEGIN
    set @usuario_id_ = (SELECT id FROM testdb.Usuario WHERE usuario=usuario_);

    return @usuario_id_;
END $$

# -- FUNCTION GET Usuario.usuario RETURN Responsavel.id --
CREATE FUNCTION usuario_pegar_responsavel_id(usuario_ VARCHAR(255))
RETURNS INT
BEGIN
    set @responsavel_ = (SELECT id FROM testdb.Responsavel WHERE usuario_id=(SELECT id FROM testdb.Usuario WHERE usuario=usuario_));

    return @usuario_id_;
END $$

DELIMITER ;

#--------------------------
# Stored Procedures
#--------------------------
DELIMITER $$

# -- PROCEDURE TO INSERT INTO Administrador TABLE --
CREATE PROCEDURE adicionar_administrador (
 IN nome_ VARCHAR(255), IN rg_ VARCHAR(255), IN cpf_ VARCHAR(255),
 IN n_telefone_ VARCHAR(255), IN email_ VARCHAR(255), IN usuario_ VARCHAR(255),
 IN nascimento_ VARCHAR(255), IN senha_ VARCHAR(255))
BEGIN
    INSERT INTO testdb.Usuario VALUES 
    (DEFAULT, nome_, rg_, cpf_, n_telefone_, email_, usuario_, nascimento_, DEFAULT, DEFAULT, senha_);
    INSERT INTO testdb.Administrador VALUES
    (DEFAULT, (SELECT id FROM testdb.Usuario WHERE usuario=usuario_));
END $$


# -- PROCEDURE TO INSERT INTO Professor TABLE --
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


# -- PROCEDURE TO INSERT INTO Responsavel TABLE --
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


# -- PROCEDURE TO INSERT INTO Aluno TABLE --
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


# -- PROCEDURE TO INSERT INTO Nota TABLE --
CREATE PROCEDURE adicionar_aluno_turma (IN aluno_ INT, IN turma_ INT)
BEGIN
    INSERT INTO testdb.Nota (aluno_id, turma_id) VALUES (aluno_, turma_);
END $$

# -- PROCEDURE TO INSERT INTO aluno_responsavel TABLE --
CREATE PROCEDURE adicionar_relacao_aluno_responsavel (IN aluno_ INT, IN responsavel_ INT)
BEGIN
    INSERT INTO testdb.Aluno_Responsavel (aluno_id, responsavel_id) VALUES
        (aluno_, responsavel_);
END $$

DELIMITER ;

#--------------------------
# Views
#--------------------------

# -- VIEW "Dados de todos usuarios não sensíveis" --
CREATE VIEW dados_de_usuario_nao_sensiveis AS
SELECT testdb.Usuario.nome, testdb.Usuario.n_telefone, testdb.Usuario.email, testdb.Usuario.nascimento
FROM testdb.Usuario;


# -- VIEW "Dados de todos alunos não sensíveis" --
CREATE VIEW dados_de_usuario_nao_sensiveis_do_aluno AS
SELECT testdb.Usuario.nome, testdb.Usuario.n_telefone, testdb.Usuario.email, testdb.Usuario.nascimento
FROM testdb.Usuario
WHERE testdb.Usuario.id IN (SELECT usuario_id FROM testdb.Aluno);


# -- VIEW "Dados de todos professores não sensíveis" --
CREATE VIEW dados_de_usuario_nao_sensiveis_do_professor AS
SELECT testdb.Usuario.nome, testdb.Usuario.n_telefone, testdb.Usuario.email, testdb.Usuario.nascimento
FROM testdb.Usuario
WHERE testdb.Usuario.id IN (SELECT usuario_id FROM testdb.Professor);


# -- VIEW "Dados de todos responsáveis não sensíveis" --
CREATE VIEW dados_de_usuario_nao_sensiveis_do_responsavel AS
SELECT testdb.Usuario.nome, testdb.Usuario.n_telefone, testdb.Usuario.email, testdb.Usuario.nascimento
FROM testdb.Usuario
WHERE testdb.Usuario.id IN (SELECT usuario_id FROM testdb.Responsavel);


# -- VIEW "Dados de todos administrador não sensíveis" --
CREATE VIEW dados_de_usuario_nao_sensiveis_do_administrador AS
SELECT testdb.Usuario.nome, testdb.Usuario.n_telefone, testdb.Usuario.email, testdb.Usuario.nascimento
FROM testdb.Usuario
WHERE testdb.Usuario.id IN (SELECT usuario_id FROM testdb.Administrador);

#--------------------------
# TRIGGER
#--------------------------
DELIMITER $$

CREATE TRIGGER soma_de_nota_final BEFORE UPDATE ON testdb.Nota FOR EACH ROW
BEGIN
    SET @nota_final_ = TRUNCATE((NEW.trabalho * 0.6) + (NEW.prova * 0.4), 1);

    IF new.nota_final <> @nota_final_ OR NEW.nota_final IS NULL THEN
        SET NEW.nota_final = @nota_final_;
    END IF; 
END $$

DELIMITER ;

#--------------------------
# Inserting new records
#--------------------------

# -- Cadastrador's ID -- 
SET @id_do_cadastrador = 1;

# -- INSERT Disciplina --
INSERT INTO testdb.Disciplina 
 (disciplina)
VALUES
 ('Língua Portuguesa'), ('Matemática'), ('História'), ('Geografia'),
 ('Ciências'), ('Artes'), ('Educação Física'), ('Inglês');


# -- INSERT Turma --
INSERT INTO testdb.Turma
 (nome, disciplina_id)
VALUES 
    ('9º ano Português',disciplina_nome_pegar_id('Língua Portuguesa')),
    ('9º ano Matemática',disciplina_nome_pegar_id('Matemática')),
    ('9º ano História',disciplina_nome_pegar_id('História')),
    ('9º ano Geografia',disciplina_nome_pegar_id('Geografia')),
    ('9º ano Ciências', disciplina_nome_pegar_id('Ciências')),
    ('9º ano Artes', disciplina_nome_pegar_id('Artes')),
    ('9º ano Educação Física', disciplina_nome_pegar_id('Educação Física')),
    ('9º ano Inglês', disciplina_nome_pegar_id('Inglês')),

    ('8º ano Português',disciplina_nome_pegar_id('Língua Portuguesa')),
    ('8º ano Matemática',disciplina_nome_pegar_id('Matemática')),
    ('8º ano História',disciplina_nome_pegar_id('História')),
    ('8º ano Geografia',disciplina_nome_pegar_id('Geografia')),
    ('8º ano Ciências', disciplina_nome_pegar_id('Ciências')),
    ('8º ano Artes', disciplina_nome_pegar_id('Artes')),
    ('8º ano Educação Física', disciplina_nome_pegar_id('Educação Física')),
    ('8º ano Inglês', disciplina_nome_pegar_id('Inglês')),

    ('7º ano Português',disciplina_nome_pegar_id('Língua Portuguesa')),
    ('7º ano Matemática',disciplina_nome_pegar_id('Matemática')),
    ('7º ano História',disciplina_nome_pegar_id('História')),
    ('7º ano Geografia',disciplina_nome_pegar_id('Geografia')),
    ('7º ano Ciências', disciplina_nome_pegar_id('Ciências')),
    ('7º ano Artes', disciplina_nome_pegar_id('Artes')),
    ('7º ano Educação Física', disciplina_nome_pegar_id('Educação Física')),
    ('7º ano Inglês', disciplina_nome_pegar_id('Inglês'));

# -- INSERT Material --
INSERT INTO testdb.Material
 (titulo, turma_id)
VALUES
 ('Exercícios de interpretação', (SELECT id FROM testdb.Turma WHERE nome='9º ano Português')),
 ('Ciclo da água e tratamento da água', (SELECT id FROM testdb.Turma WHERE nome='9º ano Ciências')),
 ('Papel dos microrganismos na produção de alimentos', (SELECT id FROM testdb.Turma WHERE nome='9º ano Ciências'));


# -- INSERT Administrador --
CALL testdb.adicionar_administrador (
 'Fernanda Araujo Souza', '49.296.479-8', '645.170.901-83', 
 '(11) 99681-2557', 'FernandaAraujoSouza@gmail.com', 
 'FernandaSouza', '1996-01-31', 'eeFee6ohl');


# -- INSERT Professor --
CALL testdb.adicionar_professor (
 'Júlio Costa Souza', '47.166.673-3', '404.836.087-69', 
 '(11) 97527-7296', 'JulioCostaSouza@gmail.com', 
 'JúlioCosta', '1991-04-28', 'oov7fu8I', 'Matemática');

CALL testdb.adicionar_professor (
 'Eduarda Pereira Oliveira', '54.820.520-4', '328.620.228-29', 
 '(11) 93283-3603', 'EduardaPereiraOliveira@gmail.com', 
 'EduardaPOliveira', '1998-03-30', 'Quoor5OoGh2', 'Língua Portuguesa');
 
# -- INSERT Responsavel --
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
 

# -- INSERT Aluno --
CALL testdb.adicionar_aluno (
 'Luana Rocha Sousa', '45.560.970-9', '551.296.556-56', 
 '(11) 96845-6020', 'LuanaRochaSousa@gmail.com', 
 'LuanaRocha', '2008-06-12', 'ahShoop7ath', '2009201003009-8', @id_do_cadastrador);

CALL testdb.adicionar_aluno (
 'Melissa Ferreira Barbosa', '53.459.957-9', '162.146.465-27', 
 '(11) 97058-6574', 'MelissaFerreiraBarbosa@gmail.com', 
 'MFerreira', '2008-09-13', 'Piej8eeYi', '2529701099009-4', @id_do_cadastrador);
 
CALL testdb.adicionar_aluno (
 'Luis Silva Pinto', '52.606.404-2', '283.707.729-19', 
 '(11) 92215-2205', 'LuisSilvaPinto@gmail.com', 
 'LuizSPinto', '2008-10-22', 'cah9tah2Ei', '5821201033009-6', @id_do_cadastrador);

CALL testdb.adicionar_aluno (
 'Carla Correia Rocha', '55.422.483-9', '998.224.670-44', 
 '(11) 98255-7689', 'CarlaCorreiaRocha@gmail.com', 
 'CCrocha', '2008-08-29', 'ahsheiG4oogh', '9425501033029-5', @id_do_cadastrador);


# -- INSERT Aluno & Responsavel --
CALL adicionar_relacao_aluno_responsavel (
    usuario_pegar_aluno_id('LuanaRocha'),
    usuario_pegar_responsavel_id('Breno_Fernandes'));

CALL adicionar_relacao_aluno_responsavel (
    usuario_pegar_aluno_id('MFerreira'),
    usuario_pegar_responsavel_id('DanielAraujo_Carvalho'));

CALL adicionar_relacao_aluno_responsavel (
    usuario_pegar_aluno_id('LuizSPinto'),
    usuario_pegar_responsavel_id('Mariana.S.Rocha'));

 CALL adicionar_relacao_aluno_responsavel (       
    usuario_pegar_aluno_id('CCrocha'),
    usuario_pegar_responsavel_id('Mariana.S.Rocha'));


# -- INSERT Aluno INTO Turma --
CALL adicionar_aluno_turma(
    usuario_pegar_aluno_id('LuanaRocha'), 
    turma_nome_pegar_turma_id('9º ano Português'));

CALL adicionar_aluno_turma(
    usuario_pegar_aluno_id('LuanaRocha'), 
    turma_nome_pegar_turma_id('9º ano Ciências'));

CALL adicionar_aluno_turma(
    usuario_pegar_aluno_id('MFerreira'), 
    turma_nome_pegar_turma_id('9º ano Português'));

CALL adicionar_aluno_turma(
    usuario_pegar_aluno_id('MFerreira'), 
    turma_nome_pegar_turma_id('9º ano Ciências'));

CALL adicionar_aluno_turma(
    usuario_pegar_aluno_id('LuizSPinto'), 
    turma_nome_pegar_turma_id('9º ano Português'));

CALL adicionar_aluno_turma(
    usuario_pegar_aluno_id('LuizSPinto'), 
    turma_nome_pegar_turma_id('9º ano Ciências'));

CALL adicionar_aluno_turma(
    usuario_pegar_aluno_id('CCrocha'), 
    turma_nome_pegar_turma_id('9º ano Português'));

CALL adicionar_aluno_turma(
    usuario_pegar_aluno_id('CCrocha'), 
    turma_nome_pegar_turma_id('9º ano Ciências'));

# -- UPDATE Nota --
UPDATE testdb.Nota set trabalho = 7, prova = 4
WHERE aluno_id = usuario_pegar_aluno_id('LuanaRocha')
AND   turma_id = turma_nome_pegar_turma_id('9º ano Português'); 

UPDATE testdb.Nota set trabalho = 3, prova = 9
WHERE aluno_id = usuario_pegar_aluno_id('LuanaRocha')
AND   turma_id = turma_nome_pegar_turma_id('9º ano Ciências'); 

UPDATE testdb.Nota set trabalho = 4, prova = 2
WHERE aluno_id = usuario_pegar_aluno_id('MFerreira')
AND   turma_id = turma_nome_pegar_turma_id('9º ano Português'); 

UPDATE testdb.Nota set prova = 5
WHERE aluno_id = usuario_pegar_aluno_id('MFerreira')
AND   turma_id = turma_nome_pegar_turma_id('9º ano Ciências'); 

UPDATE testdb.Nota set trabalho = 4, prova = 2
WHERE aluno_id = usuario_pegar_aluno_id('LuizSPinto')
AND   turma_id = turma_nome_pegar_turma_id('9º ano Português'); 

UPDATE testdb.Nota set trabalho = 3, prova = 5
WHERE aluno_id = usuario_pegar_aluno_id('LuizSPinto')
AND   turma_id = turma_nome_pegar_turma_id('9º ano Ciências'); 

UPDATE testdb.Nota set trabalho = 7
WHERE aluno_id = usuario_pegar_aluno_id('CCrocha')
AND   turma_id = turma_nome_pegar_turma_id('9º ano Português'); 

UPDATE testdb.Nota set trabalho = 6, prova = 7
WHERE aluno_id = usuario_pegar_aluno_id('CCrocha')
AND   turma_id = turma_nome_pegar_turma_id('9º ano Ciências'); 


# -- INSERT Tarefa --
INSERT INTO testdb.Tarefa (titulo, prazo, turma_id) VALUES
    ('Leia "No Meio do Caminho" e responda às questões do caderno.', 
     '2022-12-10 23:59:59', 
     turma_nome_pegar_turma_id('9º ano Português')),
     
    ('Leia "Poema de Sete Faces" e responda às questões do caderno.', 
     '2022-12-16 13:00:00', 
     turma_nome_pegar_turma_id('9º ano Português')),
     
    ('Leia "Módulo - Microrganismos" para ser discutido em sala.', 
     '2022-12-09 10:00:00', 
     turma_nome_pegar_turma_id('9º ano Ciências')),
     
    ('Leia "Quadrilha" e responda às questões do caderno.', 
     '2022-12-13 14:00:00', 
     turma_nome_pegar_turma_id('9º ano Português')),
     
    ('Leia "Ciclo da água" para ser discutido em sala.', 
     '2022-12-12 15:30:00', 
     turma_nome_pegar_turma_id('9º ano Ciências'));


# -- INSERT FAQ --
INSERT INTO testdb.FAQ (autor_usuario_id, conteudo, turma_id) VALUES
 (usuario_pegar_aluno_id('LuanaRocha'), 'Como a vida começou?', turma_nome_pegar_turma_id('9º ano Ciências')),
 (usuario_pegar_aluno_id('MFerreira'), 'Quais são as dez classes gramaticais?', turma_nome_pegar_turma_id('9º ano Português')),
 (usuario_pegar_aluno_id('LuizSPinto'), 'O que é a consciência?', turma_nome_pegar_turma_id('9º ano Ciências')),
 (usuario_pegar_aluno_id('CCrocha'), 'Como separar sílabas?', turma_nome_pegar_turma_id('9º ano Português')),
 (usuario_pegar_aluno_id('CCrocha'), 'Por que sonhamos', turma_nome_pegar_turma_id('9º ano Ciências'));


# -- INSERT Feedback --
INSERT INTO testdb.Feedback (titulo, turma_id) VALUES
 ('Por favor! Prestem mais atenção na aula.', turma_nome_pegar_turma_id('9º ano Ciências')),
 ('Legal turma! Absorveram bem os conceitos!', turma_nome_pegar_turma_id('9º ano Português'));


# -- INSERT Calendário --
INSERT INTO testdb.Calendario (titulo, link, administrador_id) VALUES
 ('Calendário 2022 - Aulas e Atividade Extras', 'https://projetoeducacao.com.br/calendario', 1);


# -- INSERT Notificação --
INSERT INTO testdb.Notificacao (aluno_id, conteudo, turma_id) VALUES
 (usuario_pegar_aluno_id('MFerreira'), 'Por favor, comparecer a secretaria!', turma_nome_pegar_turma_id('9º ano Português' )),
 (usuario_pegar_aluno_id('LuizSPinto'), 'Atenção, sua prova de recuperação é amanhã!', turma_nome_pegar_turma_id('9º ano Ciências'));


# -- UPDATE Professor -- 
UPDATE testdb.Professor
SET disciplina_id = disciplina_nome_pegar_id('Ciências')
WHERE usuario_id = usuario_pegar_usuario_id('JúlioCosta');


# -- DELETE Administrador -- 
CALL testdb.adicionar_administrador (
 'Nicole Santos Castro', '54.004.755-5', '955.915.067-71',
 '(11) 96512-7796', 'NicoleSantosCastro@gmail.com',
 'NicoleCastro', '1957-07-08', 'No4nee6zaigh');

DELETE FROM testdb.Administrador WHERE usuario_id=  
 usuario_pegar_usuario_id('NicoleCastro');

DELETE FROM testdb.Usuario WHERE usuario='NicoleCastro';

#--------------------------
# Backup tables
#--------------------------
DELIMITER $$
CREATE PROCEDURE criar_backup()
BEGIN
    CREATE TABLE IF NOT EXISTS testdb.Usuario_Backup AS SELECT * FROM testdb.Usuario;

    CREATE TABLE IF NOT EXISTS testdb.Administrador_Backup AS SELECT * FROM testdb.Administrador;

    CREATE TABLE IF NOT EXISTS testdb.Professor_Backup AS SELECT * FROM testdb.Professor;

    CREATE TABLE IF NOT EXISTS testdb.Responsavel_Backup AS SELECT * FROM testdb.Responsavel;

    CREATE TABLE IF NOT EXISTS testdb.Aluno_Backup AS SELECT * FROM testdb.Aluno;

    CREATE TABLE IF NOT EXISTS testdb.Turma_Backup AS SELECT * FROM testdb.Turma;

    CREATE TABLE IF NOT EXISTS testdb.Nota_Backup AS SELECT * FROM testdb.Nota;

    CREATE TABLE IF NOT EXISTS testdb.FAQ_Backup AS SELECT * FROM testdb.FAQ;

    CREATE TABLE IF NOT EXISTS testdb.Tarefa_Backup AS SELECT * FROM testdb.Tarefa;

    CREATE TABLE IF NOT EXISTS testdb.Feedback_Backup AS SELECT * FROM testdb.Feedback;

    CREATE TABLE IF NOT EXISTS testdb.Calendario_Backup AS SELECT * FROM testdb.Calendario;

    CREATE TABLE IF NOT EXISTS testdb.Notificacao_Backup AS SELECT * FROM testdb.Notificacao;
    
    CREATE TABLE IF NOT EXISTS testdb.Material_Backup AS SELECT * FROM testdb.Material;

    CREATE TABLE IF NOT EXISTS testdb.Disciplina_Backup AS SELECT * FROM testdb.Disciplina;

    CREATE TABLE IF NOT EXISTS testdb.Aluno_Responsavel_Backup AS SELECT * FROM testdb.Aluno_Responsavel;
END $$
DELIMITER ;

CALL criar_backup;

#--------------------------
# SELECT ALL tables
#--------------------------
SELECT * FROM testdb.Usuario;
SELECT * FROM testdb.Administrador;
SELECT * FROM testdb.Professor;
SELECT * FROM testdb.Aluno;
SELECT * FROM testdb.Turma;
SELECT * FROM testdb.Nota;
SELECT * FROM testdb.FAQ;
SELECT * FROM testdb.Tarefa;
SELECT * FROM testdb.Feedback;
SELECT * FROM testdb.Calendario;
SELECT * FROM testdb.Notificacao;
SELECT * FROM testdb.Material;
SELECT * FROM testdb.Disciplina;
SELECT * FROM testdb.Aluno_Responsavel;

#--------------------------
# SELECT WITH FITER tables
#--------------------------

# -- SELECT Aluno_Usuario MULTIPLE ROWS -- 
SELECT id, nome, cpf, usuario, cadastro FROM testdb.Usuario WHERE id IN (SELECT usuario_id FROM testdb.Aluno);


# -- SELECT DISCIPLINA THAT HAS TEACHER --
SELECT disciplina FROM testdb.Disciplina WHERE id IN (SELECT disciplina_id FROM testdb.Professor);


# -- SELECT ALUNO THAT GOT FINAL GRADE BETWEEN 3 AND 5 (recuperation) --
SELECT nome FROM testdb.Usuario WHERE id IN 
 (SELECT usuario_id FROM testdb.Aluno WHERE id IN 
  (SELECT aluno_id FROM testdb.Nota WHERE nota_final BETWEEN 3 AND 5)
);


# -- SELECT Aluno nome, email, matricula, nota final, nome da turma FROM FOUR TABLES --
SELECT testdb.Usuario.nome, testdb.Usuario.email, testdb.Aluno.matricula, testdb.Nota.nota_final, testdb.Turma.nome
FROM testdb.Usuario, testdb.Aluno, testdb.Nota, testdb.Turma
WHERE testdb.Usuario.id = testdb.Aluno.usuario_id
AND   testdb.Aluno.id = testdb.Nota.aluno_id
AND   testdb.Turma.id = testdb.Nota.turma_id
ORDER BY testdb.Usuario.nome;


# -- SELECT Disciplina.disciplina AND THE Turma.nome THAT HAS THIS SUBJECT --
SELECT testdb.Disciplina.disciplina, testdb.Turma.nome
FROM testdb.Disciplina
INNER JOIN testdb.Turma
ON testdb.Disciplina.id = testdb.Turma.disciplina_id;

#--------------------------
# SELECT WITH VIEW tables
#--------------------------
SELECT * FROM dados_de_usuario_nao_sensiveis;
SELECT * FROM dados_de_usuario_nao_sensiveis_do_administrador;
SELECT * FROM dados_de_usuario_nao_sensiveis_do_aluno;
SELECT * FROM dados_de_usuario_nao_sensiveis_do_professor;
SELECT * FROM dados_de_usuario_nao_sensiveis_do_responsavel;

#--------------------------
# TRANSACTION COMMIT & ROLLBACK
#--------------------------

# -- TYPO ERROR --
start transaction;

update testdb.Usuario set testdb.Usuario.n_telefone = '(11) 93248-7177' 
where id > usuario_pegar_usuario_id('JúlioCosta');

select * from testdb.Usuario;

rollback;

select * from testdb.Usuario;

update testdb.Usuario set testdb.Usuario.n_telefone = '(11) 93248-7177' 
where id = usuario_pegar_usuario_id('JúlioCosta');

select * from testdb.Usuario;

commit;

