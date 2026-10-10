-- =====================================================================
-- AutoNex — banco de exemplo do curso (UC4 Banco de Dados)
-- Mesmo cenário do livro (indústria automotiva), com os dados de aula.
-- Alvo: MariaDB 10.4 (XAMPP) via phpMyAdmin. Aba "SQL" > colar > Executar.
-- Rodar este script inteiro RECRIA o banco do zero (apaga o que existir).
-- =====================================================================

DROP DATABASE IF EXISTS AutoNex;
CREATE DATABASE AutoNex CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE AutoNex;

-- ---------- Estrutura (DDL) ----------

CREATE TABLE Clientes (
    ClienteID INT AUTO_INCREMENT PRIMARY KEY,
    Nome      VARCHAR(100) NOT NULL,
    CNPJ      CHAR(14)     NOT NULL UNIQUE,
    Endereco  VARCHAR(255),
    Cidade    VARCHAR(100),
    Estado    CHAR(2),
    CEP       CHAR(8),
    Telefone  VARCHAR(20),
    Email     VARCHAR(100)
);

CREATE TABLE Funcionarios (
    FuncionarioID   INT AUTO_INCREMENT PRIMARY KEY,
    Nome            VARCHAR(100)  NOT NULL,
    Cargo           VARCHAR(50)   NOT NULL,
    Salario         DECIMAL(10,2) NOT NULL,
    DataContratacao DATE          NOT NULL,
    Telefone        VARCHAR(20),
    Email           VARCHAR(100)
);

CREATE TABLE Produtos (
    ProdutoID INT AUTO_INCREMENT PRIMARY KEY,
    Nome      VARCHAR(100)  NOT NULL,
    Descricao TEXT,
    Preco     DECIMAL(10,2) NOT NULL,
    Estoque   INT           NOT NULL DEFAULT 0
);

CREATE TABLE Vendas (
    VendaID       INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID     INT           NOT NULL,
    FuncionarioID INT           NULL,       -- NULL = venda feita pelo site
    DataVenda     DATE          NOT NULL,
    TotalVenda    DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_vendas_cliente
        FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID),
    CONSTRAINT fk_vendas_funcionario
        FOREIGN KEY (FuncionarioID) REFERENCES Funcionarios(FuncionarioID)
);

CREATE TABLE ItensVenda (
    ItemVendaID   INT AUTO_INCREMENT PRIMARY KEY,
    VendaID       INT           NOT NULL,
    ProdutoID     INT           NOT NULL,
    Quantidade    INT           NOT NULL,
    PrecoUnitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_itens_venda
        FOREIGN KEY (VendaID) REFERENCES Vendas(VendaID),
    CONSTRAINT fk_itens_produto
        FOREIGN KEY (ProdutoID) REFERENCES Produtos(ProdutoID)
);

-- ---------- Dados (DML) ----------

INSERT INTO Clientes (Nome, CNPJ, Endereco, Cidade, Estado, CEP, Telefone, Email) VALUES
('BS Serviços Automotivos ME',  '48996633000128', 'Rua Doze, 196',           'Bauru',     'SP', '17035640', '1435192270',  'contato@bsmec.com.br'),
('Auto Peças Curitiba Ltda',    '11222000133',    'Av. das Torres, 1500',    'Curitiba',  'PR', '80666070', '4133221100',  'vendas@apcuritiba.com.br'),
('Mecânica do Ademar',          '22333000144',    'Rua XV de Novembro, 45',  'Curitiba',  'PR', '80777080', '41991112233', 'ademar@mecanica.com.br'),
('Oficina Fernanda & Filhos',   '33444000155',    'Rua das Flores, 820',     'Londrina',  'PR', '86010000', '43992224455', NULL),
('Retífica Carmen',             '44555000166',    'Av. Brasil, 3010',        'Maringá',   'PR', '87013000', NULL,          'carmen@retifica.com.br'),
('Centro Automotivo Joinville', '55666000177',    'Rua do Príncipe, 12',     'Joinville', 'SC', '89201000', '4734556677',  'contato@cajoinville.com.br');

INSERT INTO Funcionarios (Nome, Cargo, Salario, DataContratacao, Telefone, Email) VALUES
('Agata Silva',       'Vendedora',         3200.00, '2020-01-15', '41988880001', 'agata@autonex.com.br'),
('Joaquim Silveira',  'Vendedor',          2900.00, '2021-06-01', '41988880002', 'joaquim@autonex.com.br'),
('Ruan Carlos Costa', 'Gerente de Vendas', 6500.00, '2018-03-12', '41988880003', 'ruan@autonex.com.br'),
('Carmen Moura',      'Vendedora',         3100.00, '2022-09-05', '41988880004', 'carmen@autonex.com.br'),
('Fernanda Lemes',    'Estagiária',        1400.00, '2024-02-19', NULL,          'fernanda@autonex.com.br');

INSERT INTO Produtos (Nome, Descricao, Preco, Estoque) VALUES
('Correia de distribuição',      'Correia dentada que sincroniza o motor',   512.05, 200),
('Pneu X 205/55 R16',            'Pneu de alta performance',                 350.00, 100),
('Filtro de óleo',               'Filtro para motores 1.0 a 2.0',             38.90, 500),
('Pastilha de freio dianteira',  'Jogo com 4 pastilhas',                     189.90, 150),
('Bateria 60Ah',                 'Bateria selada, 18 meses de garantia',     620.00,  40),
('Amortecedor traseiro',         'Amortecedor a gás',                        430.00,  12),
('Vela de ignição',              'Vela de níquel',                            24.50, 800),
('Palheta limpador',             'Palheta de silicone 20 polegadas',          59.90,   0);

INSERT INTO Vendas (ClienteID, FuncionarioID, DataVenda, TotalVenda) VALUES
(1, 1,    '2024-03-04', 1477.80),
(2, 2,    '2024-03-11', 6100.50),
(3, 1,    '2024-04-02',  379.80),
(2, 3,    '2024-04-18', 5440.00),
(4, 4,    '2024-05-09',  781.00),
(1, NULL, '2024-05-21',  700.00),
(5, 2,    '2024-06-03', 1783.70),
(3, 1,    '2024-06-17',  620.00);

INSERT INTO ItensVenda (VendaID, ProdutoID, Quantidade, PrecoUnitario) VALUES
(1, 2,  4, 350.00),
(1, 3,  2,  38.90),
(2, 1, 10, 512.05),
(2, 7, 40,  24.50),
(3, 4,  2, 189.90),
(4, 5,  6, 620.00),
(4, 6,  4, 430.00),
(5, 3, 10,  38.90),
(5, 7, 16,  24.50),
(6, 2,  2, 350.00),
(7, 1,  2, 512.05),
(7, 4,  4, 189.90),
(8, 5,  1, 620.00);
