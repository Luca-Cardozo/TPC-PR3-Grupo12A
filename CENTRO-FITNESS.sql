CREATE DATABASE CENTRO_FITNESS

USE CENTRO_FITNESS


CREATE TABLE Disciplinas (
    IdDisciplina INT IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL,
	Imagen VARCHAR(300) NOT NULL,
    Activa BIT NOT NULL DEFAULT 1,
	CONSTRAINT PK_Disciplinas PRIMARY KEY (IdDisciplina)
);

INSERT INTO Disciplinas (Nombre, Imagen)
VALUES 
('Pilates', 'disciplina-1'),
('Yoga', 'disciplina-2'),
('Funcional', 'disciplina-3'),
('Stretching', 'disciplina-4'),
('Spinning', 'disciplina-5'),
('Zumba', 'disciplina-6'),
('Bachata', 'disciplina-7'),
('Salsa', 'disciplina-8');

SELECT IdDisciplina, Nombre, Imagen, Activa FROM Disciplinas