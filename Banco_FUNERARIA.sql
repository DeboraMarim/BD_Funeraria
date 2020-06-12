
create database FUNERARIA_a;
use funeraria_a;

				CREATE TABLE TB_CONVENIADO   (CONV_CODIGO INTEGER NOT NULL PRIMARY KEY,
                CONV_NOME VARCHAR(50) NOT NULL,
                DESC_AGREGADOS VARCHAR(200) NOT NULL,
                VALOR_MENSALIDADE DECIMAL(10,00) NOT NULL 
                );
                
         
				CREATE TABLE TB_FALECIDO  (COD_CONV_FALECIDO INTEGER NOT NULL REFERENCES TB_CONVENIADO(CONV_CODIGO),
                NOME_FALECIDO VARCHAR(50) NOT NULL, 
                PESO_FALECIDO DECIMAL(10,2) NOT NULL,
                IDADE_FALECIDO INTEGER NOT NULL,
                COD_FALECIDO INTEGER NOT NULL PRIMARY KEY
                );

				CREATE TABLE TB_URNA (COD_URNA INTEGER NOT NULL PRIMARY KEY,
				DESC_URNA VARCHAR(100) NOT NULL,
                VALOR_URNA DECIMAL(20,2)
                );

				CREATE TABLE TB_TRATAMENTO( COD_TRATAMENTO INT NOT NULL PRIMARY KEY,
                DESC_TRATAMENTO VARCHAR(200) NOT NULL,
                VALOR_TRATAMENTO DECIMAL(20,2) NOT NULL
                );
		
				CREATE TABLE TB_PACOTE (COD_PACOTE INTEGER NOT NULL PRIMARY KEY,
                COD_CONV_PACOTE INTEGER NOT NULL REFERENCES TB_CONVENIADO(CONV_CODIGO),
                COD_FALECIDO_PACOTE INTEGER NOT NULL REFERENCES TB_FALECIDO(COD_FALECIDO),
                COD_URNA_PACOTE INTEGER NOT NULL REFERENCES TB_URNA(COD_URNA),
                COD_TRATAMENTO_PACOTE INTEGER NOT NULL REFERENCES TB_TRATAMENTO(COD_TRATAMENTO)
                );
                
insert into tb_conveniado(conv_codigo, conv_nome, desc_agregados, valor_mensalidade) 
values (001, 'Antonio Oliveira', 'Maria de Souza Oliveira Roberto Oliveira Jessica Oliveira', 70);                
                
insert into tb_conveniado(conv_codigo, conv_nome, desc_agregados, valor_mensalidade) 
values (002, 'Marcelo Lobato', 'Rafaela Lobato Raquel Lobato', 60 );                
                
insert into tb_conveniado(conv_codigo, conv_nome, desc_agregados, valor_mensalidade) 
values (003, 'Tiago Farias', 'Rute Farias Claudio Farias Lucas Farias sergio Farias Claudia Farias', 90 );                

insert into tb_falecido(COD_CONV_FALECIDO,  NOME_FALECIDO, peso_falecido, idade_falecido, cod_falecido ) 
values (001, 'Maria de Souza Oliveira', 70.50, 45, 001);

insert into tb_falecido(COD_CONV_FALECIDO,  NOME_FALECIDO, peso_falecido, idade_falecido, cod_falecido ) 
values (002, 'Rafaela Lobato', 45, 55, 002);

insert into tb_falecido(COD_CONV_FALECIDO,  NOME_FALECIDO, peso_falecido, idade_falecido, cod_falecido ) 
values (003, 'sergio Farias', 80, 60, 003);

insert into tb_urna (cod_urna, desc_urna, valor_urna)
values (0001, 'marron, com vidro, tam b', 800);

insert into tb_urna (cod_urna, desc_urna, valor_urna)
values (0002, 'marron, sem  vidro, tam a', 600);

insert into tb_urna (cod_urna, desc_urna, valor_urna)
values (0003, 'marron, com vidro, bordas de ouro, almofadada, todos os tamanhos', 8500);

insert into tb_tratamento(cod_tratamento, desc_tratamento, valor_tratamento)
values (01, 'banho, maquiagem, roupas', 200);
 
insert into tb_tratamento(cod_tratamento, desc_tratamento, valor_tratamento)
values (02, 'banho, maquiagem, roupas, costura, quebra de ossos', 900);

insert into tb_tratamento(cod_tratamento, desc_tratamento, valor_tratamento)
values (03, 'banho, maquiagem', 150);
 
insert into tb_pacote(cod_pacote, cod_conv_pacote, cod_falecido_pacote, cod_urna_pacote, cod_tratamento_pacote)
values (0101, 001, 001, 0001, 01);

insert into tb_pacote(cod_pacote, cod_conv_pacote, cod_falecido_pacote, cod_urna_pacote, cod_tratamento_pacote)
values (0102, 002, 002, 0002, 02);

insert into tb_pacote(cod_pacote, cod_conv_pacote, cod_falecido_pacote, cod_urna_pacote, cod_tratamento_pacote)
values (0103, 003, 003, 0003, 03);

delimiter //
CREATE PROCEDURE deleta_cliente (in cod int)
	BEGIN
		
		delete from tb_conveniado where tb_conveniado.CONV_CODIGO = cod;
END; //


delimiter //
CREATE PROCEDURE atualizar_agregados (in descricao varchar(300))
	BEGIN
		
		update  tb_conveniado set DESC_AGREGADOS = descricao ;
END; //


delimiter //
CREATE PROCEDURE atualizar_mensalidade (in valor decimal(10,00))
	BEGIN
		
		update  tb_conveniado set VALOR_MENSALIDADE = valor ;
END; //


delimiter //
CREATE PROCEDURE gerar_falecido (in codconveniado int, in codfalecido int, nome varchar(100), in peso decimal (10,2), in idade int)
	BEGIN
		
		insert into tb_falecido (cod_conv_falecido, cod_falecido, nome_falecido, peso_falecido, idade_falecido)
        values (codconveniado, codfalecido, nome, peso, idade);
END; //

delimiter //
CREATE PROCEDURE gerar_conveniado (in conv_codigo int, in conv_nome varchar (100), 
									in desc_agregados varchar(200), in valor_mensalidade decimal (10,00))
	BEGIN
		
		insert into tb_conveniado (conv_codigo, conv_nome, desc_agregados, valor_mensalidade)
        values (conv_codigo, conv_nome, desc_agregados, valor_mensalidade);
END; //


DELIMITER //
CREATE FUNCTION inserir_urna (cod int, descricao varchar (100), valor decimal (20,2))
RETURNS varchar (30)
	BEGIN
		
			insert into tb_urna (cod_urna, desc_urna, valor_urna)
            values (cod, descricao, valor);
        
        RETURN 'URNA ADCIONADA COM SUCESSO !';
	END;
//


CREATE OR REPLACE VIEW sobre_urna AS 
	SELECT desc_urna, valor_urna FROM tb_urna; 
        

DELIMITER //
CREATE FUNCTION deletar_urna (cod int)
RETURNS varchar (30)
	BEGIN
		
        delete from tb_urna where tb_urna.cod_urna = cod;
        
        RETURN 'URNA DELETADA COM SUCESSO !';
	END;
//

CREATE OR REPLACE VIEW Valor_total AS 
	SELECT nome_falecido, valor_urna, valor_tratamento
	FROM tb_falecido inner join TB_urna INNER JOIN TB_TRATAMENTO ON COD_FALECIDO = COD_CONV_FALECIDO;
//

CREATE TABLE TB_HISTORICO_PACOTES(
	USUARIO VARCHAR(250),
	OPERACAO VARCHAR(100),
	DATAHORA DATETIME,
	Cod_historico_pacote INT
		);

delimiter //
	CREATE TRIGGER historico_pacotes
	AFTER INSERT ON TB_HISTORICO_PACOTES
	FOR EACH ROW
		BEGIN
			INSERT INTO TB_PACOTES VALUES (USER(), 'INSERT',
			NOW());

		END; //
delimiter ;

create table all_clientes(
	cliente_titular varchar (50) not null,
    cliente_agregado varchar (200)  not null
)

DELIMITER //
	CREATE EVENT CRIAR_
	ON SCHEDULE EVERY 1 MONTH STARTS '2018-06-15 02:00:00'
		DO
			BEGIN
				INSERT INTO all_clientes
				(cliente_titular, cliente_agregado)
				SELECT nome_conv, desc_conv FROM TB_conveniado;
			END;
//