CREATE DATABASE CENTRO_FITNESS

USE CENTRO_FITNESS
CREATE TABLE Disciplinas (
    IdDisciplina INT IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL,
    Activa BIT NOT NULL DEFAULT 1
	CONSTRAINT PK_Disciplinas PRIMARY KEY (IdDisciplina)
);

INSERT INTO Disciplinas (Nombre)
VALUES 
('Pilates'),
('Yoga'),
('Funcional'),
('Stretching'),
('Spinning'),
('Zumba'),
('Bachata'),
('Salsa');

SELECT IdDisciplina, Nombre, Activa FROM Disciplinas