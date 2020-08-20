/* REQUISITOS DO PROJETO */

/* O cliente LOG, solicitou a modelagem de um banco de dados para controle dos veículos que são utilizados pelos departamentos da empresa.
/* O cliente informa que deseja somente consultar somente as informações abaixo:

Nome do Funcionario e o tipo de veiculo que ele esta utilizando.
Departamento de o Nome do Responsável
Quantidade de veículos sendo separada por tipo.
Quais responsáveis por departamento possuem veículos e quais as suas respectivas placas.*/ 
 
 /* COMANDO PARA CRIAÇÃO DO BANCO DE DADOS */
 CREATE DATABASE IF NOT EXISTS logistica ;
 
 /* SELECIONAR DATABASE */
 USE logistica;
 
 /* CRIAÇÃO DE TABELAS*/ 
 
 /* INSERINDO A TABELA FUNCIONARIOS */
 CREATE TABLE IF NOT EXISTS funcionarios 
 (
	id int unsigned not null auto_increment, 
	nome varchar(45) not null,
	salario double not null default '0',
	departamento varchar(45) not null, 
 PRIMARY KEY (id)
 );
 
 /* INSERINDO A TABELA VEÍCULOS */
 
 CREATE TABLE  IF NOT EXISTS veiculos
 (
	id int unsigned not null auto_increment,
    funcionario_id int unsigned default null, 
    veiculo varchar (45) not null default '',
    placa varchar(10) not null default '',
	tipo varchar(5),
    PRIMARY KEY (id),
    CONSTRAINT fk_veiculos_funcionarios FOREIGN KEY (funcionario_id) REFERENCES funcionarios (id)
 )
 ;
 
 /* INSERINDO A TABELA DEPARTAMENTO */
 
 CREATE TABLE IF NOT EXISTS departamentos
 (
	id int unsigned not null auto_increment,
	nome varchar (30) not null,
	responsavel_id int unsigned default null,
	PRIMARY KEY (id),
	CONSTRAINT fk_departamento_funcionarios FOREIGN KEY (responsavel_id) REFERENCES funcionarios (id)

 );
 
 /* CRIAÇÃO DE INDICES PARA MELHOR DESEMPENHO EM CONSULTAS DO BANCO DE DADOS */
 
 CREATE INDEX departamentos ON funcionarios (departamento);
 CREATE INDEX nomes ON funcionarios (nome(6));
 
 
 /* COMANDO DE INSERÇÃO DE DADOS NAS TABELAS */
 /*INSERINDO DADOS NA TABELA FUNCIONARIOS */
 INSERT INTO funcionarios (nome, salario, departamento) VALUES ('Rodrigo Freitas',6800.50,'Tecnologia');
 INSERT INTO funcionarios (nome, salario, departamento) VALUES ('Aline Negreiros',5500.00,'Recursos Humanos');
 INSERT INTO funcionarios (nome, salario, departamento) VALUES ('Caroline Santos',1500.00,'Administração');
 INSERT INTO funcionarios (nome, salario, departamento) VALUES ('Marcela Farias',2200.00,'Recursos Humanos');
 INSERT INTO funcionarios (nome, salario, departamento) VALUES ('Julia Costa',2800.00,'Marketing');
 INSERT INTO funcionarios (nome, salario, departamento) VALUES ('Juliana Vieira',4500.00,'Administração');
 INSERT INTO funcionarios (nome, salario, departamento) VALUES ('Marcos Junior',2100.00,'Tecnologia');
 INSERT INTO funcionarios (nome, salario, departamento) VALUES ('Carlos Coelho',1700.00,'Tecnologia');
 
 
 /*INSERINDO DADOS NA TABELA VEICULOS */
 INSERT INTO VEICULOS (funcionario_id, veiculo, placa, tipo) VALUES (1,'FORD FUSION', 'KRR-5804','Carro');
 INSERT INTO VEICULOS (funcionario_id, veiculo, placa, tipo) VALUES (2,'RENAULT FLUENCE', 'NVK-5357','Carro');
 INSERT INTO VEICULOS (funcionario_id, veiculo, placa, tipo) VALUES (1,'DUCATI DIAVEL 1260S', 'RPG-3308', 'Moto');
 INSERT INTO VEICULOS (funcionario_id, veiculo, placa, tipo) VALUES (4,'FIAT ARGO', 'KPG-7201', 'Carro');
 INSERT INTO VEICULOS (funcionario_id, veiculo, placa, tipo) VALUES (6,'FIAT ARGO', 'SDK-2504', 'Carro');
 INSERT INTO VEICULOS (funcionario_id, veiculo, placa, tipo) VALUES (7,'HONDA CB300R', 'FKG-3128', 'Moto');
 INSERT INTO VEICULOS (funcionario_id, veiculo, placa, tipo) VALUES (8,'HONDA CB300R', 'DDL-5051', 'Moto');
 
 /*INSERINDO DADOS NA TABELA DEPARTAMENTOS */
 
 INSERT INTO DEPARTAMENTOS (nome, responsavel_id) VALUES ('Tecnologia',1);
 INSERT INTO DEPARTAMENTOS (nome, responsavel_id) VALUES ('Recursos Humanos',2);
 INSERT INTO DEPARTAMENTOS (nome, responsavel_id) VALUES ('Marketing',5);
 INSERT INTO DEPARTAMENTOS (nome, responsavel_id) VALUES ('Administração',6);
 
 
 /* COMANDO PARA CONSULTAS DE INFORMAÇÕES */
 
 /* CONSULTA PARA SABER QUAl O TIPO DE VEÍCULO DE CADA FUNCIONARIO (CARRO OU MOTO)*/
 SELECT f.nome AS 'NOME DO FUNCIONARIOS', v.tipo AS 'TIPO DE VEÍCULO' 
	FROM veiculos v 
		INNER JOIN funcionarios f 
	ON v.funcionario_id = f.id
;
 
 /* SELECT PARA DESCOBRIR O RESPONSÁVEL DE CADA DEPARTAMENTO */
 SELECT d.nome AS 'DEPARTAMENTO', f.nome AS 'NOME DO RESPONSÁVEL'  
	FROM departamentos d
		INNER JOIN funcionarios f
	ON d.responsavel_id = f.id
;
	
/* SELECT PARA DESCOBRIR QUANTOS FUNCIONARIOS UTILIZAM MOTOS OU CARROS */
SELECT tipo AS 'TIPO DE VEÍCULO', COUNT(*) AS 'QUANTIDADE' 
	FROM veiculos
GROUP BY tipo
;
	
/* SELECT PARA CONSULTA DE QUAIS RESPONSÁVEIS POSSUEM ALGUM TIPO DE VEÍCULO E SUAS RESPECTIVAS PLACAS  */
SELECT f.nome AS 'NOME DO RESPONSÁVEL', d.nome AS 'DEPARTAMENTO', v.tipo AS 'TIPO DE VEÍCULO', v.veiculo AS 'NOME DO VEÍCULO', v.placa AS 'PLACA'  
	FROM veiculos v 
		INNER JOIN funcionarios f
	ON v.funcionario_id = f.id
		INNER JOIN departamentos d
	ON d.responsavel_id = f.id
;
