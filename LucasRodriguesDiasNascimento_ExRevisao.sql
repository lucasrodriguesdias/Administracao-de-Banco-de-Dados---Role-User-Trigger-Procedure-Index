-- Exercicios em Sala de Aula 
-- Lucas Rodrigues Dias Nascimento - 12118365

-- Exercício (ExRevisao)

/*
A EMPRESA NEWTON LOC LOCAÇÃO DE VEICULOS TE CONTRATOU PARA SER 
O NOVO DBA DA EMPRESA. AO ANALISAR A PARTE DE GERENCIAMENTO DOS
DADOS MUITAS ALTERAÇÕES E ATÉ MELHORIAS PRECISAM SER FEITAS.
ABAIXO AS MELHORIAS SUGERIDAS:
#################################################################################
1 - CRIAÇÃO DE NOVOS USUARIOS: MARIA(ADM),ROBERTO(COMUM),ANDERSON(COMUM) E PAULA(ANALISTA).(TODOS LOCAIS)
	TODOS DEVEM TER SENHA E AS MESMAS DEVEM OBDECER AS SEGUINTES REGRAS:
		TODAS DEVEM EXPIRAR EM 180 DIAS
        TODAS DEVEM TER O número Máximo de falhas de login = 5 
        E O tempo de bloqueio em dias = 1
*/
CREATE USER 'Maria'@'localhost' IDENTIFIED BY '123456' 
PASSWORD EXPIRE INTERVAL 180 DAY
FAILED_LOGIN_ATTEMPTS 5 PASSWORD_LOCK_TIME 1;

CREATE USER 'Roberto'@'localhost' IDENTIFIED BY '123456' 
PASSWORD EXPIRE INTERVAL 180 DAY
FAILED_LOGIN_ATTEMPTS 5 PASSWORD_LOCK_TIME 1;

CREATE USER 'Anderson'@'localhost' IDENTIFIED BY '123456' 
PASSWORD EXPIRE INTERVAL 180 DAY
FAILED_LOGIN_ATTEMPTS 5 PASSWORD_LOCK_TIME 1;

CREATE USER 'Paula'@'localhost' IDENTIFIED BY '123456' 
PASSWORD EXPIRE INTERVAL 180 DAY
FAILED_LOGIN_ATTEMPTS 5 PASSWORD_LOCK_TIME 1;


/*
##################################################################################
2 - CRIAÇÃO DE NOVOS ROLES
	3 ROLES: ADM, ANALISTA,COMUM.
			ADM : ACESSA TODO SCHEMA NEWTON LOC .
            ANALISTA : ACESSA NEWTON, LOC MAS PARA APENAS INSERT,UPDATE E DELETE
            COMUM : SOMENTE PESQUISA NAS TABELAS DO NEWTON LOC
            APLIQUE AS PERMISSÕES AOS USUARIOS
*/
CREATE ROLE 'ADM'@'localhost';
GRANT ALL ON newtonloc.* TO 'ADM'@'localhost';
SHOW GRANTS FOR 'ADM'@'localhost';

CREATE ROLE 'ANALISTA'@'localhost';
GRANT INSERT, UPDATE, DELETE ON newtonloc.* TO 'ANALISTA'@'localhost';
SHOW GRANTS FOR 'ANALISTA'@'localhost';

CREATE ROLE 'COMUM'@'localhost';
GRANT SELECT ON newtonloc.* TO 'COMUM'@'localhost';
SHOW GRANTS FOR 'COMUM'@'localhost';

GRANT 'ADM'@'localhost' TO 'Maria'@'localhost';
GRANT 'ANALISTA'@'localhost' TO 'Paula'@'localhost';
GRANT 'COMUM'@'localhost' TO 'Roberto'@'localhost';
GRANT 'COMUM'@'localhost' TO 'Anderson'@'localhost';

/*
##################################################################################
3 - CRIAÇÃO DE STORED PROCEDURED
		CRIE UMA PROCEDURED CHAMADA SP1 PARA calcular a soma 
        de pontos de um cliente.
        use o nome do cliente.
*/
DELIMITER $$
CREATE PROCEDURE sp1(IN nomeInserido VARCHAR(45), OUT pontosCliente INT)
BEGIN

SELECT SUM(C.pontuacao) INTO pontosCliente
FROM clientes C 
WHERE C.nome = nomeInserido;

END $$

DELIMITER ;
CALL sp1('Carlos CPU', @pontosCliente);
SELECT @pontosCliente;

/*
#####################################################################################
4 - CRIAÇÃO DE TRIGGER
			CRIE UMA TRIGGUER PARA APLICAR A PONTUAÇÃO 
			QUE O CLIENTE VAI GANHAR
            AO ALUGAR UM CARRO, FORMULA:
            CLIENTE BASICO =  500 
            CLIENTE INTERMEDIARIO = 1500
            CLIENTE PREMIUM =  2500
*/
DELIMITER $$
CREATE TRIGGER aplicaPontuacao
AFTER INSERT ON locacao 
FOR EACH ROW
BEGIN 

DECLARE tipoCliente VARCHAR(50);

SELECT C.tipo INTO tipoCliente
FROM clientes C 
WHERE C.idCliente = NEW.fk_idCliente;

IF(tipoCliente = 'Basico') THEN 
UPDATE clientes 
SET pontuacao = pontuacao + 500
WHERE idCliente = NEW.fk_idCliente;

ELSE IF(tipoCliente = 'Intermediario') THEN 
UPDATE clientes 
SET pontuacao = pontuacao + 1500
WHERE idCliente = NEW.fk_idCliente;

ELSE 
UPDATE clientes 
SET pontuacao = pontuacao + 2500
WHERE idCliente = NEW.fk_idCliente;

END IF;
END IF;

END  $$
DELIMITER ;

-- Testar a trigger
USE newtonloc;
SELECT * FROM clientes;
INSERT INTO locacao(dataLocacao, valorDiaria, fk_idCliente, fk_idCarro) VALUES('2024-11-26', 150.00, 2, 3);
INSERT INTO locacao(dataLocacao, valorDiaria, fk_idCliente, fk_idCarro) VALUES('2024-11-26', 140.00, 4, 3);
INSERT INTO locacao(dataLocacao, valorDiaria, fk_idCliente, fk_idCarro) VALUES('2024-11-26', 200.00, 6, 3);
SELECT * FROM clientes; -- mudança de pontos nos clientes 2, 4, 6.



/*
#####################################################################################
5 - CRIAÇÃO DE INDICES
         OS INDICES QUE DEVEM SER CRIADOS:
			CLIENTES : NOME,EMAIL,PONTUACAO,TIPO
            CARROS : FABRICANTE,MODELO,COR,ANOFABRICACAO,POTENCIAMOTOR,CATEGORIA,QUILOMETRAGEM
			LOCACAO : DATALOCACAO,VALORDIARIA
            DIMENSOES : ALTURA,LARGURA,COMPRIMENTO,PESO,TANQUE,PORTAMALAS
*/

CREATE INDEX idx_clientes_nome ON clientes (nome);
CREATE INDEX idx_clientes_email ON clientes (email);
CREATE INDEX idx_clientes_pontuacao ON clientes (pontuacao);
CREATE INDEX idx_clientes_tipo ON clientes (tipo);

CREATE INDEX idx_carros_fabricante ON carros (fabricante);
CREATE INDEX idx_carros_modelo ON carros (modelo);
CREATE INDEX idx_carros_cor ON carros (cor);
CREATE INDEX idx_carros_anoFabricacao ON carros (anoFabricacao);
CREATE INDEX idx_carros_potenciaMotor ON carros (potenciaMotor);
CREATE INDEX idx_carros_categoria ON carros (categoria);
CREATE INDEX idx_carros_quilometragem ON carros (quilometragem);


CREATE INDEX idx_locacao_dataLocacao ON locacao (dataLocacao);
CREATE INDEX idx_locacao_valorDiaria ON locacao (valorDiaria);
CREATE INDEX idx_dimensoes_altura ON dimensoes (altura_mm);
CREATE INDEX idx_dimensoes_largura ON dimensoes (largura_mm);
CREATE INDEX idx_dimensoes_comprimento ON dimensoes (comprimento_mm);
CREATE INDEX idx_dimensoes_peso ON dimensoes (peso_kg);
CREATE INDEX idx_dimensoes_tanque ON dimensoes (tanque_L);
CREATE INDEX idx_dimensoes_portaMala ON dimensoes (porta_mala_L);


