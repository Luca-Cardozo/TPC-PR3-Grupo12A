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

-- =============================================
-- INSERT: 25 Alumnos (Rol = 4)
-- =============================================

INSERT INTO Usuarios (Nombre, Apellido, Email, Password, DNI, Telefono, FechaNacimiento, Imagen, Rol, Observaciones, Activo)
VALUES
('Luciana',      'Fernández',  'luciana.fernandez@gmail.com',   '1234', '41200101', '1151000101', '1998-03-12', 'default-user', 4, NULL,                                          1),
('Mateo',        'García',     'mateo.garcia@gmail.com',        '1234', '38200102', '1151000102', '1994-07-25', 'default-user', 4, 'Lesión en la rodilla derecha',                1),
('Camila',       'López',      'camila.lopez@gmail.com',        '1234', '43200103', '1151000103', '2000-11-08', 'default-user', 4, NULL,                                          1),
('Facundo',      'Martínez',   'facundo.martinez@gmail.com',    '1234', '36200104', '1151000104', '1991-05-30', 'default-user', 4, 'Asmático, utiliza inhalador',                 1),
('Valentina',    'Rodríguez',  'valentina.rodriguez@gmail.com', '1234', '40200105', '1151000105', '1997-09-14', 'default-user', 4, NULL,                                          1),
('Ignacio',      'Pérez',      'ignacio.perez@gmail.com',       '1234', '35200106', '1151000106', '1989-02-28', 'default-user', 4, 'Operado de la espalda, evitar impacto',       1),
('Florencia',    'González',   'florencia.gonzalez@gmail.com',  '1234', '42200107', '1151000107', '1999-06-17', 'default-user', 4, NULL,                                          1),
('Tobías',       'Sánchez',    'tobias.sanchez@gmail.com',      '1234', '44200108', '1151000108', '2001-04-03', 'default-user', 4, NULL,                                          1),
('Martina',      'Romero',     'martina.romero@gmail.com',      '1234', '37200109', '1151000109', '1992-12-22', 'default-user', 4, 'Hipertensión controlada con medicación',      1),
('Bruno',        'Torres',     'bruno.torres@gmail.com',        '1234', '39200110', '1151000110', '1995-08-11', 'default-user', 4, NULL,                                          1),
('Agustina',     'Díaz',       'agustina.diaz@gmail.com',       '1234', '45200111', '1151000111', '2002-01-19', 'default-user', 4, 'Tendinitis en el hombro izquierdo',           1),
('Santiago',     'Morales',    'santiago.morales@gmail.com',    '1234', '34200112', '1151000112', '1988-10-05', 'default-user', 4, NULL,                                          1),
('Julieta',      'Herrera',    'julieta.herrera@gmail.com',     '1234', '41200113', '1151000113', '1998-07-31', 'default-user', 4, 'Diabetes tipo 2, monitorea glucosa',          1),
('Nicolás',      'Castro',     'nicolas.castro@gmail.com',      '1234', '38200114', '1151000114', '1993-03-16', 'default-user', 4, NULL,                                          1),
('Antonella',    'Vargas',     'antonella.vargas@gmail.com',    '1234', '43200115', '1151000115', '2000-05-27', 'default-user', 4, NULL,                                          1),
('Emiliano',     'Ruiz',       'emiliano.ruiz@gmail.com',       '1234', '36200116', '1151000116', '1990-11-09', 'default-user', 4, 'Fractura de tobillo en recuperación',         1),
('Sofía',        'Medina',     'sofia.medina@gmail.com',        '1234', '40200117', '1151000117', '1996-02-14', 'default-user', 4, NULL,                                          1),
('Lautaro',      'Jiménez',    'lautaro.jimenez@gmail.com',     '1234', '44200118', '1151000118', '2001-08-23', 'default-user', 4, NULL,                                          1),
('Rocío',        'Suárez',     'rocio.suarez@gmail.com',        '1234', '37200119', '1151000119', '1992-06-07', 'default-user', 4, 'Escoliosis leve, evitar torsiones bruscas',   1),
('Tomás',        'Álvarez',    'tomas.alvarez@gmail.com',       '1234', '42200120', '1151000120', '1999-04-18', 'default-user', 4, NULL,                                          1),
('Milagros',     'Ramos',      'milagros.ramos@gmail.com',      '1234', '35200121', '1151000121', '1989-09-02', 'default-user', 4, NULL,                                          1),
('Ezequiel',     'Molina',     'ezequiel.molina@gmail.com',     '1234', '39200122', '1151000122', '1994-12-29', 'default-user', 4, 'Operado de menisco, sin saltos ni impacto',   1),
('Pilar',        'Ortega',     'pilar.ortega@gmail.com',        '1234', '46200123', '1151000123', '2003-07-11', 'default-user', 4, NULL,                                          1),
('Maximiliano',  'Silva',      'maximiliano.silva@gmail.com',   '1234', '33200124', '1151000124', '1987-01-24', 'default-user', 4, 'Alérgico a la penicilina',                    1),
('Catalina',     'Reyes',      'catalina.reyes@gmail.com',      '1234', '41200125', '1151000125', '1997-10-15', 'default-user', 4, NULL,                                          1);

GO

-- =============================================
-- INSERT: 3 Recepcionistas (Rol = 2)
-- =============================================

INSERT INTO Usuarios (Nombre, Apellido, Email, Password, DNI, Telefono, FechaNacimiento, Imagen, Rol, Observaciones, Activo)
VALUES
('Romina',   'Acosta',   'romina.acosta@centrofitness.com',   '1234', '32500201', '1161000201', '1990-04-18', 'default-user', 2, NULL, 1),
('Leandro',  'Burgos',   'leandro.burgos@centrofitness.com',  '1234', '29500202', '1161000202', '1986-09-07', 'default-user', 2, NULL, 1),
('Mariela',  'Campos',   'mariela.campos@centrofitness.com',  '1234', '35500203', '1161000203', '1993-12-23', 'default-user', 2, NULL, 1);

GO

-- =============================================
-- Tabla: Reservas 
-- =============================================
CREATE TABLE Reservas (
    IdReserva     INT IDENTITY(1,1) NOT NULL,
    IdClase       INT NOT NULL,
    IdAlumno      INT NOT NULL, 
    FechaReserva  DATETIME NOT NULL DEFAULT GETDATE(),
    Estado        INT NOT NULL DEFAULT 1, -- 1=Vigente, 2=Cancelada, 3=Finalizada, 4=Reprogramada
    Asistio       BIT NULL, -- NULL (no pasó la clase), 1 (Asistió), 0 (Faltó)
    Observaciones VARCHAR(500) NULL,

    CONSTRAINT PK_Reservas PRIMARY KEY (IdReserva),
    CONSTRAINT FK_Reservas_Clases FOREIGN KEY (IdClase) REFERENCES Clases(IdClase),
    CONSTRAINT FK_Reservas_Usuarios FOREIGN KEY (IdAlumno) REFERENCES Usuarios(IdUsuario),
    CONSTRAINT UQ_Alumno_Clase UNIQUE (IdAlumno, IdClase),
    CONSTRAINT CK_Reservas_Estado CHECK (Estado IN (1, 2, 3, 4)) 
);
GO

-- ====================================================================
-- INSERT: Reservas de Prueba 
-- ====================================================================


INSERT INTO Reservas (IdClase, IdAlumno, Estado, Observaciones)
SELECT 1, IdUsuario, 1, 'Inscripción web regular.' 
FROM Usuarios WHERE Email = 'luciana.fernandez@gmail.com';

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Observaciones)
SELECT 2, IdUsuario, 1, 'Recordar: el alumno tiene lesión en rodilla derecha.' 
FROM Usuarios WHERE Email = 'mateo.garcia@gmail.com';

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Observaciones)
SELECT 3, IdUsuario, 1, 'Primera vez en esta disciplina.' 
FROM Usuarios WHERE Email = 'camila.lopez@gmail.com';


-- =============================================
-- INSERT: Clases de Julio 2026
-- =============================================
 
INSERT INTO Clases (IdDisciplina, IdInstructor, Fecha, HoraInicio, CupoMaximo)
VALUES
-- Martes 01/07
(1,  2,  '2026-07-01',  8,  10),   -- 08hs Pilates       - Ana García
(2,  7,  '2026-07-01',  9,  12),   -- 09hs Yoga          - Nicolás Romero
(3,  5,  '2026-07-01', 10,  15),   -- 10hs Funcional     - Diego Fernández
(5,  3,  '2026-07-01', 17,  10),   -- 17hs Spinning      - Carlos Rodríguez
(6, 15,  '2026-07-01', 18,  20),   -- 18hs Zumba         - Julieta Vargas
(7, 16,  '2026-07-01', 19,  20),   -- 19hs Bachata       - Lucía González
 
-- Miércoles 02/07
(1,  4,  '2026-07-02',  8,  10),   -- 08hs Pilates       - Valentina Pérez
(4, 11,  '2026-07-02',  9,  12),   -- 09hs Stretching    - Sofía Martínez
(3,  9,  '2026-07-02', 10,  15),   -- 10hs Funcional     - Tomás Castro
(8, 15,  '2026-07-02', 17,  20),   -- 17hs Salsa         - Julieta Vargas
(6, 16,  '2026-07-02', 18,  20),   -- 18hs Zumba         - Lucía González
 
-- Jueves 03/07
(2, 14,  '2026-07-03',  8,  12),   -- 08hs Yoga          - Micaela Herrera
(1,  8,  '2026-07-03',  9,  10),   -- 09hs Pilates       - Agustín Morales
(5, 10,  '2026-07-03', 10,  10),   -- 10hs Spinning      - Martín López
(4,  6,  '2026-07-03', 17,  12),   -- 17hs Stretching    - Sebastián Díaz
(8, 16,  '2026-07-03', 18,  20),   -- 18hs Salsa         - Lucía González
 
-- Lunes 07/07
(1, 12,  '2026-07-07',  8,  10),   -- 08hs Pilates       - Camila Sánchez
(2,  7,  '2026-07-07',  9,  12),   -- 09hs Yoga          - Nicolás Romero
(3, 13,  '2026-07-07', 10,  15),   -- 10hs Funcional     - Florencia Torres
(7, 16,  '2026-07-07', 18,  20),   -- 18hs Bachata       - Lucía González
 
-- Martes 08/07
(4, 11,  '2026-07-08',  8,  12),   -- 08hs Stretching    - Sofía Martínez
(5, 13,  '2026-07-08',  9,  10),   -- 09hs Spinning      - Florencia Torres
(1,  2,  '2026-07-08', 10,  10),   -- 10hs Pilates       - Ana García
(6, 15,  '2026-07-08', 17,  20),   -- 17hs Zumba         - Julieta Vargas
(8, 16,  '2026-07-08', 18,  20),   -- 18hs Salsa         - Lucía González
 
-- Miércoles 09/07
(1, 14,  '2026-07-09',  8,  10),   -- 08hs Pilates       - Micaela Herrera
(2, 11,  '2026-07-09',  9,  12),   -- 09hs Yoga          - Sofía Martínez
(3,  5,  '2026-07-09', 10,  15),   -- 10hs Funcional     - Diego Fernández
 
-- Jueves 10/07
(5,  3,  '2026-07-10',  8,  10),   -- 08hs Spinning      - Carlos Rodríguez
(4,  6,  '2026-07-10',  9,  12),   -- 09hs Stretching    - Sebastián Díaz
(1,  4,  '2026-07-10', 10,  10),   -- 10hs Pilates       - Valentina Pérez
(7, 16,  '2026-07-10', 17,  20),   -- 17hs Bachata       - Lucía González
(6, 15,  '2026-07-10', 18,  20);   -- 18hs Zumba         - Julieta Vargas
 
GO
 
-- =============================================
-- INSERT: Reservas
-- =============================================
 
-- ── 01/07 ── Pilates 08hs (Ana García) ──────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 19, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 8;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 20, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 8;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 21, GETDATE(), 1, NULL, 'Alumno con lesión en rodilla, avisó que trae rodillera' FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 8;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 22, GETDATE(), 3, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 8; -- Cancelada
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 23, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 8;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 24, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 8;
 
-- ── 01/07 ── Yoga 09hs (Nicolás Romero) ─────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 25, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 9;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 26, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 9;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 27, GETDATE(), 2, NULL, 'Reprogramó desde el 28/06' FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 9; -- Reprogramada
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 28, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 9;
 
-- ── 01/07 ── Funcional 10hs (Diego Fernández) ────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 29, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 10;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 30, GETDATE(), 1, NULL, 'Asmático, trae inhalador' FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 10;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 31, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 10;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 32, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 10;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 33, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 10;
 
-- ── 01/07 ── Zumba 18hs (Julieta Vargas) ────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 34, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 18;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 35, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 18;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 36, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 18;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 37, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 18;
 
-- ── 01/07 ── Bachata 19hs (Lucía González) ──────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 38, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 19;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 39, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 19;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 40, GETDATE(), 3, NULL, 'Canceló por enfermedad' FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 19; -- Cancelada
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 41, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 19;
 
-- ── 02/07 ── Pilates 08hs (Valentina Pérez) ─────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 19, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 8;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 22, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 8; -- La misma que canceló el 01/07 reprogramó acá
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 23, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 8;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 42, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 8;
 
-- ── 02/07 ── Stretching 09hs (Sofía Martínez) ───────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 25, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 9;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 26, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 9;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 43, GETDATE(), 1, NULL, 'Operado de espalda, solo elongación suave' FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 9;
 
-- ── 02/07 ── Zumba 18hs (Lucía González) ────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 34, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 18;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 35, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 18;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 36, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 18;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 37, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 18;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 38, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 18;
 
-- ── 03/07 ── Yoga 08hs (Micaela Herrera) ────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 20, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 8;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 28, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 8;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 29, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 8;
 
-- ── 03/07 ── Pilates 09hs (Agustín Morales) ─────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 30, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 9;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 31, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 9;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 32, GETDATE(), 2, NULL, 'Reprogramó desde el 01/07' FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 9;
 
-- ── 03/07 ── Salsa 18hs (Lucía González) ────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 39, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 18;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 40, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 18;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 41, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 18;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 42, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 18;
 
-- ── 07/07 ── Pilates 08hs (Camila Sánchez) ──────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 19, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-07' AND HoraInicio = 8;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 21, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-07' AND HoraInicio = 8;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 24, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-07' AND HoraInicio = 8;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 43, GETDATE(), 3, NULL, 'Canceló con poca anticipación' FROM Clases WHERE Fecha = '2026-07-07' AND HoraInicio = 8;
 
-- ── 07/07 ── Yoga 09hs (Nicolás Romero) ─────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 20, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-07' AND HoraInicio = 9;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 25, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-07' AND HoraInicio = 9;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 33, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-07' AND HoraInicio = 9;
 
-- ── 08/07 ── Spinning 09hs (Florencia Torres) ───────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 26, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-08' AND HoraInicio = 9;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 27, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-08' AND HoraInicio = 9;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 28, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-08' AND HoraInicio = 9;
 
-- ── 08/07 ── Zumba 17hs (Julieta Vargas) ────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 34, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-08' AND HoraInicio = 17;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 35, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-08' AND HoraInicio = 17;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 36, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-08' AND HoraInicio = 17;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 37, GETDATE(), 4, NULL, 'En lista de espera' FROM Clases WHERE Fecha = '2026-07-08' AND HoraInicio = 17; -- Lista de espera
 
-- ── 09/07 ── Pilates 08hs (Micaela Herrera) ─────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 19, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-09' AND HoraInicio = 8;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 21, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-09' AND HoraInicio = 8;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 23, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-09' AND HoraInicio = 8;
 
-- ── 10/07 ── Bachata 17hs (Lucía González) ──────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 38, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-10' AND HoraInicio = 17;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 39, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-10' AND HoraInicio = 17;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 40, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-10' AND HoraInicio = 17;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 41, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-10' AND HoraInicio = 17;
 
-- ── 10/07 ── Zumba 18hs (Julieta Vargas) ────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 34, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-10' AND HoraInicio = 18;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 35, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-10' AND HoraInicio = 18;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 42, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-10' AND HoraInicio = 18;
INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones)
SELECT IdClase, 43, GETDATE(), 1, NULL, NULL FROM Clases WHERE Fecha = '2026-07-10' AND HoraInicio = 18;