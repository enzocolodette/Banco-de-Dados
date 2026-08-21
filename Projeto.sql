
-- Criação das tabelas 

CREATE TABLE comunidade(
    cod_comunidade INT,
    nome VARCHAR(100) NOT NULL,
    regiao VARCHAR(50) NOT NULL,
    primary key(cod_comunidade)
);

CREATE TABLE residencia(
    cod_residencia INT,
    num_moradores INT NOT NULL,
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL,
    demanda_estimada FLOAT,
    cod_comunidade INT NOT NULL,
    primary key(cod_residencia),
    foreign key(cod_comunidade) references comunidade(cod_comunidade)
);

CREATE TABLE ponto_monitoramento(
    cod_ponto INT,
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL,
    descricao VARCHAR(100),
    cod_comunidade INT NOT NULL,
    primary key(cod_ponto),
    foreign key(cod_comunidade) references comunidade(cod_comunidade)
);

CREATE TABLE recurso_renovavel(
    cod_recurso INT,
    tipo VARCHAR(50),
    unidade_medida VARCHAR(20),
    primary key(cod_recurso)
);

CREATE TABLE avalia(
    cod_ponto INT,
    cod_recurso INT,
    primary key(cod_ponto, cod_recurso),
    foreign key(cod_ponto) references ponto_monitoramento(cod_ponto),
    foreign key(cod_recurso) references recurso_renovavel(cod_recurso)
);

CREATE TABLE tecnico(
    cod_tecnico INT,
    nome VARCHAR(100) NOT NULL,
    reg_profissional VARCHAR(50) NOT NULL,
    especialidade VARCHAR(50),
    primary key(cod_tecnico)
);

CREATE TABLE equipamento(
    num_serie INT,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    data_calibracao DATE,
    data_ultima_medicao DATE,
    primary key(num_serie)
);

CREATE TABLE diagnostico(
    cod_diagnostico INT,
    data_analise DATE NOT NULL,
    recomendacao VARCHAR(200),
    primary key(cod_diagnostico)
);

CREATE TABLE medicao(
    cod_medicao INT,
    data_leitura DATE NOT NULL,
    valor_medido FLOAT NOT NULL,
    cod_recurso INT NOT NULL,
    cod_diagnostico INT NOT NULL,
    num_serie INT NOT NULL,
    cod_tecnico INT NOT NULL,
    primary key(cod_medicao),
    foreign key(cod_recurso) references recurso_renovavel(cod_recurso),
    foreign key(cod_diagnostico) references diagnostico(cod_diagnostico),
    foreign key(num_serie) references equipamento(num_serie),
    foreign key(cod_tecnico) references tecnico(cod_tecnico)
);

CREATE TABLE analise(
    cod_diagnostico INT,
    cod_residencia INT,
    data_analise DATE NOT NULL,
    primary key(cod_diagnostico, cod_residencia),
    foreign key(cod_diagnostico) references diagnostico(cod_diagnostico),
    foreign key(cod_residencia) references residencia(cod_residencia)
);

CREATE TABLE atende(
    cod_tecnico INT,
    cod_residencia INT,
    data_atendimento DATE NOT NULL,
    primary key(cod_tecnico, cod_residencia, data_atendimento),
    foreign key(cod_tecnico) references tecnico(cod_tecnico),
    foreign key(cod_residencia) references residencia(cod_residencia)
);

-- Carga de Dados

INSERT INTO comunidade VALUES (1, 'Vila Nova Esperança', 'Região Serrana');
INSERT INTO comunidade VALUES (2, 'Comunidade do Barro Branco', 'Norte Fluminense');
INSERT INTO comunidade VALUES (3, 'Sítio São João', 'Baixadas Litorâneas');
INSERT INTO comunidade VALUES (4, 'Córrego Fundo', 'Costa Verde');
INSERT INTO comunidade VALUES (5, 'Comunidade do Taquaral', 'Noroeste Fluminense');

INSERT INTO residencia VALUES (1, 4, -22.1234, -43.5678, 3.5, 1);
INSERT INTO residencia VALUES (2, 7, -21.8765, -41.2345, 5.0, 2);
INSERT INTO residencia VALUES (3, 3, -22.9012, -42.1234, 2.5, 3);
INSERT INTO residencia VALUES (4, 5, -23.1111, -44.3456, 4.0, 4);
INSERT INTO residencia VALUES (5, 2, -21.3456, -41.9876, 1.5, 5);

INSERT INTO recurso_renovavel VALUES (1, 'Solar', 'kWh/m²');
INSERT INTO recurso_renovavel VALUES (2, 'Eólico', 'm/s');
INSERT INTO recurso_renovavel VALUES (3, 'Biomassa', 'kg/dia');
INSERT INTO recurso_renovavel VALUES (4, 'Hídrico', 'm³/s');
INSERT INTO recurso_renovavel VALUES (5, 'Biogás', 'm³/dia');

INSERT INTO ponto_monitoramento VALUES (1, -22.1300, -43.5700, 'Topo do morro próximo à vila', 1);
INSERT INTO ponto_monitoramento VALUES (2, -21.8800, -41.2400, 'Campo aberto ao norte', 2);
INSERT INTO ponto_monitoramento VALUES (3, -22.9100, -42.1300, 'Área próxima ao rio', 3);
INSERT INTO ponto_monitoramento VALUES (4, -23.1200, -44.3500, 'Terreno plano na entrada', 4);
INSERT INTO ponto_monitoramento VALUES (5, -21.3500, -41.9900, 'Roça abandonada no centro', 5);

INSERT INTO avalia VALUES (1, 1);
INSERT INTO avalia VALUES (1, 2);
INSERT INTO avalia VALUES (2, 2);
INSERT INTO avalia VALUES (3, 4);
INSERT INTO avalia VALUES (4, 3);
INSERT INTO avalia VALUES (5, 1);

INSERT INTO tecnico VALUES (1, 'Carlos Andrade', 'CREA-12345', 'Energia Solar');
INSERT INTO tecnico VALUES (2, 'Fernanda Lima', 'CREA-67890', 'Energia Eólica');
INSERT INTO tecnico VALUES (3, 'Marcos Souza', 'CREA-11223', 'Recursos Hídricos');
INSERT INTO tecnico VALUES (4, 'Juliana Costa', 'CREA-44556', 'Biomassa');
INSERT INTO tecnico VALUES (5, 'Rafael Nunes', 'CREA-77889', 'Energia Solar');

INSERT INTO equipamento VALUES (1001, 'SunMeter', 'Medidor Solar MS-200', '15-JAN-24', '10-JUN-24');
INSERT INTO equipamento VALUES (1002, 'WindTech', 'Anemômetro WT-50', '20-NOV-23', '08-JUN-24');
INSERT INTO equipamento VALUES (1003, 'AquaSense', 'Medidor de Vazão AQ-10', '10-FEV-24', '30-MAI-24');
INSERT INTO equipamento VALUES (1004, 'BioCheck', 'Analisador de Biomassa BC-3', '05-SET-23', '01-JUN-24');
INSERT INTO equipamento VALUES (1005, 'SunMeter', 'Medidor Solar MS-100', '22-MAR-24', '12-JUN-24');
 
INSERT INTO diagnostico VALUES (1, '10-JUN-24', 'Instalar painel solar para atender a demanda básica da residência');
INSERT INTO diagnostico VALUES (2, '08-JUN-24', 'Local tem bom vento, indicado instalar um aerogerador pequeno');
INSERT INTO diagnostico VALUES (3, '30-MAI-24', 'Rio próximo tem vazão suficiente para uma roda dagua simples');
INSERT INTO diagnostico VALUES (4, '01-JUN-24', 'Resíduos orgânicos da criação de animais permitem uso de biodigestor');
INSERT INTO diagnostico VALUES (5, '12-JUN-24', 'Painel solar de pequeno porte já atenderia a demanda do local');
 
INSERT INTO medicao VALUES (1, '10-JUN-24', 5.80, 1, 1, 1001, 1);
INSERT INTO medicao VALUES (2, '08-JUN-24', 7.20, 2, 2, 1002, 2);
INSERT INTO medicao VALUES (3, '30-MAI-24', 0.45, 4, 3, 1003, 3);
INSERT INTO medicao VALUES (4, '01-JUN-24', 120.00, 3, 4, 1004, 4);
INSERT INTO medicao VALUES (5, '12-JUN-24', 6.10, 1, 5, 1005, 5);
 
INSERT INTO analise VALUES (1, 1, '10-JUN-24');
INSERT INTO analise VALUES (2, 2, '08-JUN-24');
INSERT INTO analise VALUES (3, 3, '30-MAI-24');
INSERT INTO analise VALUES (4, 4, '01-JUN-24');
INSERT INTO analise VALUES (5, 5, '12-JUN-24');
 
INSERT INTO atende VALUES (1, 1, '05-JUN-24');
INSERT INTO atende VALUES (2, 2, '03-JUN-24');
INSERT INTO atende VALUES (3, 3, '25-MAI-24');
INSERT INTO atende VALUES (4, 4, '28-MAI-24');
INSERT INTO atende VALUES (5, 5, '07-JUN-24');

-- Consultas  


-- 8a) SELECT de todos os dados de todas as tabelas

SELECT * FROM comunidade;
SELECT * FROM residencia;
SELECT * FROM recurso_renovavel;
SELECT * FROM ponto_monitoramento;
SELECT * FROM avalia;
SELECT * FROM tecnico;

SELECT * FROM equipamento;
SELECT * FROM diagnostico;
SELECT * FROM medicao;
SELECT * FROM analise;
SELECT * FROM atende;

-- 8b) Consulta sem GROUP BY envolvendo DUAS tabelas
-- Residências com demanda acima da média, exibindo o nome da comunidade

SELECT r.cod_residencia,
       c.nome AS comunidade,
       c.regiao,
       r.num_moradores,
       r.demanda_estimada
FROM residencia r
JOIN comunidade c ON r.cod_comunidade = c.cod_comunidade
WHERE r.demanda_estimada > (SELECT AVG(demanda_estimada) FROM residencia)
ORDER BY r.demanda_estimada DESC;


-- 8c) Consulta com GROUP BY envolvendo DUAS tabelas
-- Total de residências e demanda média por comunidade

SELECT c.nome AS comunidade,
       c.regiao,
       COUNT(r.cod_residencia) AS total_residencias,
       ROUND(AVG(r.demanda_estimada), 2) AS demanda_media_kwh,
       SUM(r.num_moradores) AS total_moradores,
       MAX(r.demanda_estimada) AS maior_demanda
FROM comunidade c
JOIN residencia r ON c.cod_comunidade = r.cod_comunidade
GROUP BY c.nome, c.regiao
HAVING COUNT(r.cod_residencia) >= 1
ORDER BY demanda_media_kwh DESC;


-- 8d) Consulta envolvendo TRÊS ou mais tabelas
-- Histórico de medições com técnico responsável, recurso avaliado e diagnóstico gerado

SELECT m.cod_medicao,
       m.data_leitura,
       m.valor_medido,
       rr.tipo AS recurso,
       rr.unidade_medida,
       t.nome AS tecnico,
       t.especialidade,
       d.recomendacao,
       d.data_analise
FROM medicao m
JOIN recurso_renovavel rr ON m.cod_recurso = rr.cod_recurso
JOIN tecnico t ON m.cod_tecnico = t.cod_tecnico
JOIN diagnostico d ON m.cod_diagnostico = d.cod_diagnostico
WHERE m.valor_medido > (SELECT AVG(valor_medido) FROM medicao)
ORDER BY m.data_leitura DESC;

DELETE FROM atende;
DELETE FROM analise;
DELETE FROM medicao;
DELETE FROM diagnostico;
DELETE FROM equipamento;
DELETE FROM tecnico;
DELETE FROM avalia;
DELETE FROM ponto_monitoramento;
DELETE FROM recurso_renovavel;
DELETE FROM residencia;
DELETE FROM comunidade;