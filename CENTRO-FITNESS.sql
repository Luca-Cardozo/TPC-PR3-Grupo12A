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


-- =============================================
-- Tabla: Usuarios
-- Incluye: Administrador (1), Recepcionista (2), Instructor (3), Alumno (4)
-- =============================================
 
CREATE TABLE Usuarios (
    IdUsuario       INT             NOT NULL IDENTITY(1,1),
    Nombre          VARCHAR(100)    NOT NULL,
    Apellido        VARCHAR(100)    NOT NULL,
    Email           VARCHAR(150)    NOT NULL,
    Password        VARCHAR(300)    NOT NULL,
    DNI             VARCHAR(15)     NOT NULL,
    Telefono        VARCHAR(25)     NOT NULL,
    FechaNacimiento DATE            NOT NULL,
    Imagen          VARCHAR(300)    NULL,
    Rol             INT             NOT NULL,   -- Enum: 1=Administrador, 2=Recepcionista, 3=Instructor, 4=Alumno
    Observaciones   VARCHAR(500)    NULL,       -- Solo Alumnos
    Activo          BIT             NOT NULL    DEFAULT 1,
 
    CONSTRAINT PK_Usuarios      PRIMARY KEY (IdUsuario),
    CONSTRAINT UQ_Usuarios_Email UNIQUE      (Email),
    CONSTRAINT UQ_Usuarios_DNI   UNIQUE      (DNI),
    CONSTRAINT CK_Usuarios_Rol   CHECK       (Rol IN (1, 2, 3, 4))
);
 
-- =============================================
-- Datos iniciales: usuario Administrador
-- =============================================
INSERT INTO Usuarios (Nombre, Apellido, Email, Password, DNI, Telefono, FechaNacimiento, Rol)
VALUES ('Admin', 'Sistema', 'admin@centrofitness.com', '1234', '00000000', '00000000', '2000-01-01', 1);
 
GO

-- =============================================
-- INSERT: 15 Instructores
-- Nota: los INSERTs de DisciplinasXInstructores
-- usan subconsultas por DNI para no depender
-- de valores de IDENTITY hardcodeados
-- =============================================
 
INSERT INTO Usuarios (Nombre, Apellido, Email, Password, DNI, Telefono, FechaNacimiento, Imagen, Rol)
VALUES
-- 1 disciplina
('Ana',        'García',    'ana.garcia@centrofitness.com',       '1234', '28111001', '1141000001', '1990-03-15', 'instructor-2',  3),
('Carlos',     'Rodríguez', 'carlos.rodriguez@centrofitness.com', '1234', '27111002', '1141000002', '1985-07-22', 'instructor-3',  3),
('Valentina',  'Pérez',     'valentina.perez@centrofitness.com',  '1234', '30111003', '1141000003', '1994-11-08', 'instructor-4',  3),
('Diego',      'Fernández', 'diego.fernandez@centrofitness.com',  '1234', '29111004', '1141000004', '1988-01-30', 'instructor-5',  3),
('Sebastián',  'Díaz',      'sebastian.diaz@centrofitness.com',   '1234', '31111005', '1141000005', '1992-06-17', 'instructor-6',  3),
('Nicolás',    'Romero',    'nicolas.romero@centrofitness.com',   '1234', '26111006', '1141000006', '1983-09-04', 'instructor-7',  3),
('Agustín',    'Morales',   'agustin.morales@centrofitness.com',  '1234', '32111007', '1141000007', '1996-04-25', 'instructor-8',  3),
('Tomás',      'Castro',    'tomas.castro@centrofitness.com',     '1234', '25111008', '1141000008', '1980-12-11', 'instructor-9',  3),
-- 2 disciplinas
('Martín',     'López',     'martin.lopez@centrofitness.com',     '1234', '28111009', '1141000009', '1991-05-03', 'instructor-10',  3),
('Sofía',      'Martínez',  'sofia.martinez@centrofitness.com',   '1234', '33111010', '1141000010', '1997-08-19', 'instructor-11', 3),
('Camila',     'Sánchez',   'camila.sanchez@centrofitness.com',   '1234', '30111011', '1141000011', '1993-02-28', 'instructor-12', 3),
('Florencia',  'Torres',    'florencia.torres@centrofitness.com', '1234', '27111012', '1141000012', '1986-10-07', 'instructor-13', 3),
('Micaela',    'Herrera',   'micaela.herrera@centrofitness.com',  '1234', '31111013', '1141000013', '1995-07-14', 'instructor-14', 3),
('Julieta',    'Vargas',    'julieta.vargas@centrofitness.com',   '1234', '29111014', '1141000014', '1989-03-22', 'instructor-15', 3),
-- 3 disciplinas (Zumba + Bachata + Salsa)
('Lucía',      'González',  'lucia.gonzalez@centrofitness.com',   '1234', '26111015', '1141000015', '1984-11-30', 'instructor-16', 3);
 
GO


-- =============================================
-- Tabla: DisciplinasXInstructores
-- =============================================
 
CREATE TABLE DisciplinasXInstructores (
	IdInstructor    INT     NOT NULL,
    IdDisciplina    INT     NOT NULL,
 
    CONSTRAINT PK_DisciplinasXInstructores  PRIMARY KEY (IdInstructor, IdDisciplina),
    CONSTRAINT FK_DXI_Instructor            FOREIGN KEY (IdInstructor) REFERENCES Usuarios(IdUsuario),
    CONSTRAINT FK_DXI_Disciplina            FOREIGN KEY (IdDisciplina) REFERENCES Disciplinas(IdDisciplina)
);


-- =============================================
-- INSERT: DisciplinasXInstructores
-- =============================================
 
-- Ana García → Pilates (1)
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 1 FROM Usuarios WHERE DNI = '28111001';
 
-- Carlos Rodríguez → Spinning (5)
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 5 FROM Usuarios WHERE DNI = '27111002';
 
-- Valentina Pérez → Pilates (1)
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 1 FROM Usuarios WHERE DNI = '30111003';
 
-- Diego Fernández → Funcional (3)
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 3 FROM Usuarios WHERE DNI = '29111004';
 
-- Sebastián Díaz → Stretching (4)
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 4 FROM Usuarios WHERE DNI = '31111005';
 
-- Nicolás Romero → Yoga (2)
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 2 FROM Usuarios WHERE DNI = '26111006';
 
-- Agustín Morales → Pilates (1)
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 1 FROM Usuarios WHERE DNI = '32111007';
 
-- Tomás Castro → Funcional (3)
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 3 FROM Usuarios WHERE DNI = '25111008';
 
-- Martín López → Funcional (3) + Spinning (5)
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 3 FROM Usuarios WHERE DNI = '28111009';
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 5 FROM Usuarios WHERE DNI = '28111009';
 
-- Sofía Martínez → Yoga (2) + Stretching (4)
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 2 FROM Usuarios WHERE DNI = '33111010';
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 4 FROM Usuarios WHERE DNI = '33111010';
 
-- Camila Sánchez → Pilates (1) + Stretching (4)
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 1 FROM Usuarios WHERE DNI = '30111011';
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 4 FROM Usuarios WHERE DNI = '30111011';
 
-- Florencia Torres → Spinning (5) + Funcional (3)
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 5 FROM Usuarios WHERE DNI = '27111012';
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 3 FROM Usuarios WHERE DNI = '27111012';
 
-- Micaela Herrera → Yoga (2) + Pilates (1)
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 2 FROM Usuarios WHERE DNI = '31111013';
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 1 FROM Usuarios WHERE DNI = '31111013';
 
-- Julieta Vargas → Zumba (6) + Salsa (8)
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 6 FROM Usuarios WHERE DNI = '29111014';
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 8 FROM Usuarios WHERE DNI = '29111014';
 
-- Lucía González → Zumba (6) + Bachata (7) + Salsa (8)
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 6 FROM Usuarios WHERE DNI = '26111015';
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 7 FROM Usuarios WHERE DNI = '26111015';
INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina)
SELECT IdUsuario, 8 FROM Usuarios WHERE DNI = '26111015';


SELECT IdDisciplina, Nombre, Imagen, Activa FROM Disciplinas
SELECT * FROM Usuarios
SELECT * FROM DisciplinasXInstructores

USE CENTRO_FITNESS;
GO
-- =============================================
-- Tabla: Clases
-- =============================================

CREATE TABLE Clases(
    IdClase INT IDENTITY(1,1) NOT NULL,
    IdDisciplina INT NOT NULL,
    IdInstructor INT NOT NULL,
    Fecha DATE NOT NULL,
    HoraInicio INT NOT NULL,
    CupoMaximo INT NOT NULL,
    Estado INT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Clases PRIMARY KEY(IdClase),

    CONSTRAINT FK_Clases_Disciplina
        FOREIGN KEY(IdDisciplina)
        REFERENCES Disciplinas(IdDisciplina),

    CONSTRAINT FK_Clases_Instructor
        FOREIGN KEY(IdInstructor)
        REFERENCES Usuarios(IdUsuario),

    CONSTRAINT CK_Clases_Hora
        CHECK(HoraInicio BETWEEN 0 AND 22),

    CONSTRAINT CK_Clases_Cupo
        CHECK(CupoMaximo > 0)
);
GO
-- =============================================
-- Insert Manuales, de prueba
-- =============================================
INSERT INTO Clases
(IdDisciplina, IdInstructor, Fecha, HoraInicio, CupoMaximo)
VALUES
(1,2,'2026-06-15',18,10), 
(1,3,'2026-06-16',19,12), 
(2,4,'2026-06-17',17,15); 

GO
SELECT * FROM Clases;
-- =============================================
-- Consulta para ver las clases disponibles
-- =============================================
SELECT 
    C.IdClase,
    D.Nombre AS Disciplina,
    U.Nombre + ' ' + U.Apellido AS Instructor,
    C.Fecha,
    C.HoraInicio,
    C.HoraInicio + 1 AS HoraFin,
    C.CupoMaximo,
    C.Estado
FROM Clases C
INNER JOIN Disciplinas D ON D.IdDisciplina = C.IdDisciplina
INNER JOIN Usuarios U ON U.IdUsuario = C.IdInstructor;