-- =====================================================================
-- BiblioTech — estrutura criada na lista 4 (4 tabelas)
-- Para o MySQL de onecompiler.com/mysql: cole tudo no editor e clique Run.
-- Cada Run começa com o banco vazio: deixe estes comandos no topo do
-- editor e escreva os seus logo abaixo.
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
