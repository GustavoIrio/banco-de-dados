-- =====================================================================
-- BiblioTech — banco das listas de exercícios (biblioteca escolar)
-- Estrutura da lista 4 (4 tabelas, só 1:N) + os dados da lista 5.
-- Ponto de partida da lista 6 em diante (e gabarito das listas 4 e 5).
-- Para o MySQL de onecompiler.com/mysql: cole tudo no editor e clique Run.
-- Cada Run recria tudo do zero: deixe este script no topo do editor e
-- escreva as suas consultas logo abaixo da última linha.
-- Cada livro tem um autor (Livros.AutorID). "Sistemas de Banco de Dados"
-- tem dois autores no mundo real; aqui fica só com Elmasri.
-- =====================================================================

CREATE TABLE Alunos (
    AlunoID   INT AUTO_INCREMENT PRIMARY KEY,
    Nome      VARCHAR(100) NOT NULL,
    Matricula CHAR(6)      NOT NULL UNIQUE,
    Turma     VARCHAR(10)  NOT NULL,
    Email     VARCHAR(100)
);
CREATE TABLE Autores (
    AutorID       INT AUTO_INCREMENT PRIMARY KEY,
    Nome          VARCHAR(100) NOT NULL,
    Nacionalidade VARCHAR(50)
);
CREATE TABLE Livros (
    LivroID       INT AUTO_INCREMENT PRIMARY KEY,
    AutorID       INT          NOT NULL,
    Titulo        VARCHAR(150) NOT NULL,
    ISBN          CHAR(13)     NOT NULL UNIQUE,
    AnoPublicacao INT,
    Exemplares    INT          NOT NULL DEFAULT 1,
    CONSTRAINT fk_livros_autor FOREIGN KEY (AutorID) REFERENCES Autores(AutorID)
);

CREATE TABLE Emprestimos (
    EmprestimoID   INT AUTO_INCREMENT PRIMARY KEY,
    AlunoID        INT  NOT NULL,
    LivroID        INT  NOT NULL,
    DataEmprestimo DATE NOT NULL,
    DataDevolucao  DATE NULL,
    CONSTRAINT fk_emp_aluno FOREIGN KEY (AlunoID) REFERENCES Alunos(AlunoID),
    CONSTRAINT fk_emp_livro FOREIGN KEY (LivroID) REFERENCES Livros(LivroID)
);

INSERT INTO Alunos (Nome, Matricula, Turma, Email) VALUES
('Bruno Almeida',   '240001', 'DS-1A', 'bruno@escola.com.br'),
('Camila Rocha',    '240002', 'DS-1A', 'camila@escola.com.br'),
('Diego Martins',   '240003', 'DS-1B', NULL),
('Elisa Nogueira',  '240004', 'DS-1B', 'elisa@escola.com.br'),
('Felipe Tanaka',   '240005', 'DS-2A', 'felipe@escola.com.br'),
('Gabriela Souza',  '240006', 'DS-2A', NULL);

INSERT INTO Autores (Nome, Nacionalidade) VALUES
('Ramez Elmasri',       'Egípcia'),
('Shamkant Navathe',    'Indiana'),
('Machado de Assis',    'Brasileira'),
('Clarice Lispector',   'Brasileira'),
('Robert C. Martin',    'Americana'),
('Carlos Alberto Heuser','Brasileira'),
('Graciliano Ramos',     'Brasileira');

INSERT INTO Livros (AutorID, Titulo, ISBN, AnoPublicacao, Exemplares) VALUES
(1, 'Sistemas de Banco de Dados', '9788579360855', 2011, 3),
(3, 'Dom Casmurro',               '9788535910663', 1899, 5),
(4, 'A Hora da Estrela',          '9788532508126', 1977, 2),
(5, 'Código Limpo',               '9788576082675', 2009, 1),
(6, 'Projeto de Banco de Dados',  '9788577803828', 2009, 2),
(3, 'Memórias Póstumas de Brás Cubas', '9788535911664', 1881, 4),
(7, 'Vidas Secas',                 '9788501114785', 1938, 3);

INSERT INTO Emprestimos (AlunoID, LivroID, DataEmprestimo, DataDevolucao) VALUES
(1, 1, '2024-03-05', '2024-03-19'),
(1, 4, '2024-03-20', NULL),
(2, 2, '2024-03-06', '2024-03-13'),
(2, 3, '2024-04-01', '2024-04-10'),
(3, 1, '2024-04-02', NULL),
(4, 5, '2024-04-15', '2024-04-29'),
(4, 2, '2024-05-02', NULL),
(2, 6, '2024-05-10', '2024-05-20'),
(5, 1, '2024-05-12', '2024-05-26');
