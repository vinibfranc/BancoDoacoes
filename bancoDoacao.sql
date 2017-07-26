
/* Banco de doação de sangue e plaquetas desenvolvido como trabalho final da disciplina de Banco de Dados
   GRUPO: Edilson Junior, Marcos Vinícius Pivetta e Vinícius Franceschi */

create database bancoDoacao;
use bancoDoacao;
 
/* Especificações para doação
Impedimentos temporários
 
* Gripe: aguardar 7 dias.
* Gravidez: 90 dias após parto normal e 180 dias após cesariana.
* Amamentação (se o parto ocorreu há menos de 12 meses).
* Ingestão de bebida alcoólica nas 4 horas que antecedem a doação.
* Tatuagem nos últimos 12 meses.
* Situações nas quais há maior risco de adquirir doenças sexualmente transmissíveis, como não usar preservativo com parceiros ocasionais ou desconhecidos: aguardar 12 meses.
 
Impedimentos definitivos
 
* Hepatite após os 10 anos de idade.
* Evidência clínica ou laboratorial das seguintes doenças infecciosas transmissíveis pelo sangue: Hepatites B e C, Aids (vírus HIV), doenças associadas aos vírus HTLV I e II e Doença de Chagas.
* Uso de drogas ilícitas injetáveis.
* Malária.
*/

/* CRIAÇÃO DAS TABELAS */
CREATE TABLE Endereco(
		IdEndereco INT NOT NULL AUTO_INCREMENT,
		Estado CHAR(2) NOT NULL, /* Sigla do Estado */
		Cep VARCHAR(9) NOT NULL, /* Com traços são 9 caracteres, sem traço são 8 */
		Cidade VARCHAR(25) NOT NULL,
		Logradouro VARCHAR(50) NOT NULL,
		NumeroComplements VARCHAR(10),
    PRIMARY KEY(IdEndereco)
);
 
CREATE TABLE Contatos(
		IdContatos INT NOT NULL AUTO_INCREMENT, 
		TelefonePrincipal VARCHAR(14) NOT NULL, /* Possível colocar código de operadora, DDD e número */
		TelefoneSecundario VARCHAR(14),
		Email VARCHAR(50) NOT NULL,
	PRIMARY KEY (IdContatos)
);
 
CREATE TABLE Doador(
		IdDoador INT NOT NULL AUTO_INCREMENT,
		Rg INT(10) NOT NULL,
		Nome VARCHAR(40) NOT NULL,
		Sexo CHAR(1) NOT NULL, /* M ou F */
		DataNascimento DATE NOT NULL,
		ClassificaoABO CHAR(2) NOT NULL, /* A, B, AB ou O */
		FatorRh CHAR(1) NOT NULL,  /* + ou - */
		TipoColeta CHAR(2) NOT NULL,/* S é sangue, P é plaqueta e SP é ambos */
		ImpedimentoDefinitivo BOOLEAN NOT NULL, /* TRUE ou FALSE, baseado nos critérios acima */
		ImpedimentoTemporario BOOLEAN NOT NULL, /* TRUE ou FALSE, baseado nos critérios acima */
        IdEndereco INT,
        IdContatos INT,
    PRIMARY KEY(IdDoador),
        FOREIGN KEY(IdEndereco) REFERENCES Endereco(IdEndereco),
        FOREIGN KEY(IdContatos) REFERENCES Contatos(idContatos),
       
        /* ckecks com restrições que precisam ser verificadas para validade da doação */
        CONSTRAINT IDADE_MINIMA CHECK(DataNascimento BETWEEN '1948-01-01' AND '2001-01-01'), /* idade entre 16 e 69 anos */
        CONSTRAINT CLASS_ABO_CORRETA CHECK(ClassificacaoABO IN('A','B','AB','O')),
        CONSTRAINT RH_CORRETO CHECK(Rh = '+' OR Rh = '-'), /* verifica se informação de tipo e fator RH foram inseridos corretamente */
        /* quem pode doar pra quem considerando ABO e RH */
        CONSTRAINT IMPED_DEF CHECK(ImpedimentoDefinitivo = FALSE),
        CONSTRAINT IMPED_TEMP CHECK(ImpedimentoTemporario = FALSE) /* verifica se há impedimentos relatados que impedem a realização da doação */

);
 
 
CREATE TABLE PostoDeColeta(
		IdPostoDeColeta INT NOT NULL AUTO_INCREMENT,
		Nome VARCHAR(30) NOT NULL,
		TelefoneContato VARCHAR(14) NOT NULL,
		IdEndereco INT,
	PRIMARY KEY(IdPostoDeColeta),
	FOREIGN KEY(IdEndereco) REFERENCES Endereco(IdEndereco)
);
 
CREATE TABLE Coletador(
		Coren  INT NOT NULL,
		Nome VARCHAR(40) NOT NULL,
	PRIMARY KEY (Coren)
);
 
CREATE TABLE Doacao(
		DataDoacao DATE NOT NULL,
		TipoColeta CHAR(2) NOT NULL,
		LocalDestino VARCHAR(30) NOT NULL,
		QtdLitrosDoados FLOAT NOT NULL, 
		IdDoador INT,
		IdPostoColeta INT,
		Coren INT,
	PRIMARY KEY(DataDoacao),
    FOREIGN KEY(IdDoador) REFERENCES Doador(IdDoador),
    FOREIGN KEY(IdPostoColeta) REFERENCES PostoDeColeta(IdPostoDeColeta),
    FOREIGN KEY(Coren) REFERENCES Coletador(Coren)
);
/* FIM DA CRIAÇÃO DAS TABELAS */
 
/* INSERÇÃO DOS DOADORES */
INSERT INTO CONTATOS (TelefonePrincipal,TelefoneSecundario,Email) VALUES ("985064152", "35241186", "joao@provedor.com");
INSERT INTO ENDERECO (Estado, Cep, Cidade, Logradouro, NumeroComplements) VALUES ("RS", "92024-780", "Porto Alegre", "Rua das Olivas", "45 Casa"); 
INSERT INTO DOADOR (Rg,Nome,Sexo,DataNascimento,ClassificaoABO,FatorRh,TipoColeta, ImpedimentoDefinitivo,ImpedimentoTemporario,IdEndereco,IdContatos) 
	VALUES (286159636, "João Macedo", "M", "1950-07-02", "O", "-", "SP", false, false, 1, 1);
 
INSERT INTO CONTATOS (TelefonePrincipal,TelefoneSecundario,Email) VALUES ("985485151", "35345577", "joesley@provedor.com");
INSERT INTO ENDERECO (Estado, Cep, Cidade, Logradouro, NumeroComplements) VALUES ("SP", "92324-333", "Santos", "Rua das Margaridas", "13 casa"); 
INSERT INTO DOADOR (Rg,Nome,Sexo,DataNascimento,ClassificaoABO,FatorRh,TipoColeta, ImpedimentoDefinitivo,ImpedimentoTemporario,IdEndereco,IdContatos) 
	VALUES (461382283, "Joesley Baptista", "M", "1960-06-06", "B", "+", "S", false, false, 3, 2);
 
INSERT INTO CONTATOS (TelefonePrincipal,TelefoneSecundario,Email) VALUES ("984265123", "34589962", "inacia@provedor.com");
INSERT INTO ENDERECO (Estado, Cep, Cidade, Logradouro, NumeroComplements) VALUES ("SP", "91523-999", "São Paulo", "Rua das Pompeias", "73 casa"); 
INSERT INTO DOADOR (Rg,Nome,Sexo,DataNascimento,ClassificaoABO,FatorRh,TipoColeta, ImpedimentoDefinitivo,ImpedimentoTemporario,IdEndereco,IdContatos) 
	VALUES (350779235, "Inácia Silva", "F", "2000-08-06", "O", "-", "P", false, false, 4, 3);
/* FIM DA INSERÇÃO DOS DOADORES*/
 
 
/* INSERÇÃO DOS COLETADORES */
INSERT INTO COLETADOR (COREN, NOME) VALUES (123456789, "Fernanda Lírio"); 
INSERT INTO COLETADOR (COREN, NOME) VALUES (789456123, "Francisco Taborda"); 
/* FIM DA INSERÇÃO DOS COLETADORES */
 
/* INSERÇÃO DOS POSTOS DE COLETA */
INSERT INTO ENDERECO (Estado, Cep, Cidade, Logradouro, NumeroComplements) VALUES ("RS", "92789-780", "Canoas", "Rua das Maldivas", "13"); 
INSERT INTO POSTODECOLETA (Nome,TelefoneContato,IdEndereco) values ("Postinho do sangue", "984512254", 2);
 
INSERT INTO ENDERECO (Estado, Cep, Cidade, Logradouro, NumeroComplements) VALUES ("RJ", "59845-555", "Niterói", "Rua das Rosas", "96"); 
INSERT INTO POSTODECOLETA (Nome,TelefoneContato,IdEndereco) values ("SangueCorp", "984562145", 5);
/* FIM DA INSERÇÃO DOS POSTOS DE COLETA */
 
/* INSERÇÃO DAS DOAÇÕES */
INSERT INTO DOACAO (DataDoacao,TipoColeta,LocalDestino,QtdLitrosDoados,IdDoador,IdPostoColeta,Coren)
VALUES ('2017-07-02', 'S', "Hospital Santa Fé", 0.5, 1, 1, 123456789);
 
INSERT INTO DOACAO (DataDoacao,TipoColeta,LocalDestino,QtdLitrosDoados,IdDoador,IdPostoColeta,Coren)
VALUES ('2016-04-04', 'P', "Hospital Santa Clara", 0.45, 2, 2, 789456123);
 
INSERT INTO DOACAO (DataDoacao,TipoColeta,LocalDestino,QtdLitrosDoados,IdDoador,IdPostoColeta,Coren)
VALUES ('2017-02-02', 'S', "Hospital São Paulo", 0.5, 3, 2, 789456123);
/* FIM DA INSERÇÃO DAS DOAÇÕES */
 
 
/*CONSULTAS*/
 
/*RETORNA O NOME E CONTATO DE UM DOADOR DE SANGUE DO ESTADO DE SÃO PAULO QUE TENHA SANGUE B+*/
SELECT doador.nome, contatos.telefoneprincipal 
FROM DOADOR 
	INNER JOIN CONTATOS 
		ON DOADOR.IDCONTATOS = CONTATOS.IDCONTATOS 
	INNER JOIN ENDERECO 
		ON DOADOR.IDENDERECO = ENDERECO.IDENDERECO
WHERE (endereco.estado = 'SP') AND (doador.TipoColeta = 'SP' OR doador.tipocoleta = 'S') AND (doador.ClassificaoABO = 'B' AND doador.FatorRh = '+');
 
 
/*RETORNA A QUANTIDADE TOTAL DE SANGUE DOADO POR POSTO DE COLETA, CASO HAJA SANGUE DOADO NO LOCAL */
SELECT P.Nome, sum(D.QtdLitrosDoados) AS TOTAL_SANGUE
FROM Doacao D
	INNER JOIN PostoDeColeta P
		ON D.IdPostoColeta = P.IdPostoDeColeta
WHERE D.TipoColeta = 'S'
GROUP BY P.Nome
HAVING TOTAL_SANGUE > 0;
 
/*RETORNA TODOS OS DOADORES DE SANGUE, COM SEUS RESPECTIVAS LOCALIZAÇÕES E TIPOS SANGUÍNEOS */
SELECT D.Nome, D.ClassificaoABO, D.FatorRh, E.Estado, C.TelefonePrincipal
FROM Doador D
	INNER JOIN Endereco E
		ON E.IdEndereco = D.IdEndereco
	INNER JOIN Contatos C
		ON C.IdContatos = D.IdContatos
/*FIM CONSULTAS*/



