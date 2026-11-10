-- =====================================================================
-- AutoNex — estrutura criada na aula 4 (4 tabelas)
-- Para o MySQL de onecompiler.com/mysql: cole tudo no editor e clique Run.
-- Cada Run começa com o banco vazio: deixe estes comandos no topo do
-- editor e escreva os seus (INSERT, SELECT...) logo abaixo.
-- =====================================================================

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
