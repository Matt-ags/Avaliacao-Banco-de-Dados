-- MATEUS ABNER
-- 1 CRIANDO BANCO DE DADOS
CREATE DATABASE restauranteBD

--Sobre o banco de dados "restauranteBD"
--Pensei na temática de "Restaurante" que tem as tabelas de clientes, cozinheiros e menu.

--No inicio, ele foi organizado da seguinte forma:

-- Vai ter clientes, id, nome, Se é vegano ou não, e preferencias
-- Vai ter cozinheiro, id, especialidade e nome 
-- Vai ter menu, id, nome, e cozinheiro especial

--Contudo, com o decorrer da execução, atualizei para ser mais "robusto", ficando da seguinte forma:

-- CLIENTES: (ID_CLIENTE, NOME, NASCIMENTO, PREFERENCIA);
-- COZINHEIROS: (ID_COZINHEIRO, NOME, ESPECIALIDADE)
-- MENU: (ID_PRODUTO, PRECO, NOME, ID_COZINHEIRO)

-- A tabela de MENU foi a mais interessante, trouxe essa relação entre cozinheiro especialista em qual prato, o que gostei bastante.

-- Certo, mas, quais foram os "códigos" usados?

--1) COLOCANDO UMA VIEW: Pensei em criar uma "view", para que mostre uma "tabela" que tenha o cozinheiro e seu prato
--2) COLOCANDO TRIGGER: Um "gatilho" para "confirmar" se o ultimo cliente foi adicionado, mostrando o nome dele.
--3) COLOCANDO UMA SUBQUERY: Pensei em colocar uma forma de pesquisa, para verificar/organizar COZINHEIROS em relação as MASSAS (ou seja, realizei uma pesquisa dentro de uma pesquisa, em relação da tabela menu, não de cozinheiros).
--4) ADICIONANDO FUNÇÃO: Função para calcular idade, simples. 
--5) ADICIONANDO CTE: Pensei em mostrar uma tabela temporaria que tenha o nome do cozinheiro, e seu prato "chave"

-- Uma coisa que percebi é as semelhanças entre "VIEW" e "CTE", algo que achei bem legal.
-- A principal diferença é que com a CTE, consigo "Separar" quais colunas vão aparecer, como o própria definição diz, uma tabela temporária.

-- Faltou "LOOPS", "PROCEDURES" e "WINDOWS FUNCTIONS.
-- LOOPS pois não tive idéia em onde colocar, e os outros por falta de domínio.

USE restauranteBD

CREATE TABLE CLIENTES (
	ID_CLIENTE INT PRIMARY KEY,
	NOME varchar(100),
	PREFERENCIA varchar(100)
)

CREATE TABLE COZINHEIROS (
	ID_COZINHEIRO INT PRIMARY KEY,
	NOME varchar(100),
	ESPECIALIDADE varchar(100) 
)

CREATE TABLE MENU (
	ID_PRODUTO INT PRIMARY KEY,
	NOME varchar(100),
	ID_COZINHEIRO INT,
	--Importante, lemnbre que para declarar chaves extrangeiras ou não, lembra de declarar elas antes:
	FOREIGN KEY (ID_COZINHEIRO) REFERENCES COZINHEIROS(ID_COZINHEIRO)
)

--clientes:
INSERT INTO CLIENTES (ID_CLIENTE, NOME, PREFERENCIA) VALUES
	(1 , 'Lucas', 'Vegano'),
	(2 , 'Marcos', 'NENHUMA'),
	(3 , 'Joana', 'NENHUMA'),
	(4 , 'Vitor', 'Vegano')
	
--cozinheiros:
INSERT INTO COZINHEIROS(ID_COZINHEIRO, NOME, ESPECIALIDADE) VALUES
	(1 , 'Mateus', 'Vegetais'),
	(2 , 'Carlos', 'Massas'),
	(3 , 'Julia', 'Massas'),
	(4 , 'Bianca', 'Carnes')

--menu:

INSERT INTO MENU(ID_PRODUTO, NOME, ID_COZINHEIRO) VALUES
	(1 , 'Filé a milaneza', 4),
	(2 , 'Lasanha', 3),
	(3 , 'Macarronada', 2),
	(4 , 'Salada de Beringela', 1)


--Show, caso vem surgu=indo mais idéias, vou voltando e corrigindo

--1) COLOCANDO UMA VIEW:
--Pensei em criar uma "view", para que mostre uma "tabela" que tenha o cozinheiro e seu prato

CREATE VIEW CozinheirosEMenu
AS
SELECT
A.ESPECIALIDADE,
B.NOME,
B.ID_COZINHEIRO
FROM COZINHEIROS A
JOIN MENU B
ON A.ID_COZINHEIRO = B.ID_COZINHEIRO

-- O view acima é interessante para ver o nome, especialidade e id do cozinheiro, para caracterizar em "grupos" sobre cada um deles.

--2) COLOCANDO TRIGGER:
--Um gatilho para "confirmar" se o ultimo cliente foi adicionado, mostrando o nome dele.

CREATE TRIGGER InseriuCliente
ON CLIENTES
AFTER INSERT
AS
BEGIN
	DECLARE @nome VARCHAR(100) 
	SELECT @nome = NOME FROM CLIENTES ORDER BY ID_CLIENTE ASC;

	PRINT @nome + ' adicionado com sucesso'
END


--testando:

INSERT INTO CLIENTES (ID_CLIENTE, NOME, PREFERENCIA) VALUES
	(5 , 'Helena', 'Vegano')

--SUCESSO! Apareceu uma mensagem: "Helena foi adicionada com sucesso"

-- 3) COLOCANDO UMA SUBQUERY:
-- Pensei em colocar uma forma de pesquisa, para verificar/organizar COZINHEIROS em relação as MASSAS.

SELECT NOME AS 'Cozinheiros que fazem pratos de massas'
FROM COZINHEIROS
WHERE ID_COZINHEIRO IN (
	SELECT ID_COZINHEIRO
	FROM MENU
	WHERE NOME = 'Lasanha' OR NOME = 'Macarronada'
)

--Funcionou, acima, ele separa os cozinheiros em relação do prato no menu, trazendo aqueles que fazem pratos de massas.

-- ATUALIZANDO:

--Acho que para criar mais situações problemas, vou dar uma atualizada:

CREATE TABLE MENU (
	ID_PRODUTO INT PRIMARY KEY,
	PRECO DECIMAL(10, 2),
	NOME varchar(100),
	ID_COZINHEIRO INT,
	--Importante, lemnbre que para declarar chaves extrangeiras ou não, lembra de declarar elas antes:
	FOREIGN KEY (ID_COZINHEIRO) REFERENCES COZINHEIROS(ID_COZINHEIRO)
)

INSERT INTO MENU(ID_PRODUTO, PRECO, NOME, ID_COZINHEIRO) VALUES
	(1 , 35.00, 'Filé a milaneza', 4),
	(2 , 30.00, 'Lasanha', 3),
	(3 , 29.99, 'Macarronada', 2),
	(4 , 25.00, 'Salada de Beringela', 1)

--Show, adicionei a parte de preços, o que poderia ter feito antes...

--Tambem, vou adicionar a data de nascimento na tabela de clientes:

CREATE TABLE CLIENTES (
	ID_CLIENTE INT PRIMARY KEY,
	NOME varchar(100),
	NASCIMENTO DATE,
	PREFERENCIA varchar(100)
)

INSERT INTO CLIENTES (ID_CLIENTE, NOME, NASCIMENTO, PREFERENCIA) VALUES
	(1 , 'Lucas', '2000-02-12', 'Vegano'),
	(2 , 'Marcos', '1999-01-19', 'NENHUMA'),
	(3 , 'Joana', '1999-01-20', 'NENHUMA'),
	(4 , 'Vitor', '1989-04-21', 'Vegano'),
	(5 , 'Helena', '1999-01-23', 'Vegano')

--4) ADICIONANDO FUNÇÃO:
--Função para calcular idade, simples. 

CREATE FUNCTION idades (@data DATE)
RETURNS INT
AS 
BEGIN
	RETURN DATEDIFF(YEAR, @data, GETDATE())
END;

SELECT NOME, dbo.idades(NASCIMENTO) as IDADE
FROM CLIENTES

--DEU CERTO, da até pra mudar e colocar na de cozinheiros, por exemplo.

--5) ADICIONANDO CTE:
-- Pensei em mostrar uma tabela temporaria que tenha o nome do cozinheiro, e seu prato "chave"

WITH cprato
AS(
SELECT
	A.NOME,
	A.ID_COZINHEIRO,
	A.ESPECIALIDADE,
	B.NOME AS 'PRATO CHEFE'
FROM COZINHEIROS A
JOIN MENU B
ON A.ID_COZINHEIRO = B.ID_COZINHEIRO
)

SELECT *
FROM cprato

--Lembre de executar tudo junto.
--O daora disso, é que podemos selecionar quais colunas queremos que aparecemos, diferente do view, deixando mais "simples"

