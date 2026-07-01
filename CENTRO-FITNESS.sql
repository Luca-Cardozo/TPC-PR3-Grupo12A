
-- =============================================
-- Creación de DB y Tablas con sus correspondientes relaciones
-- =============================================

CREATE DATABASE CENTRO_FITNESS
GO
USE CENTRO_FITNESS
GO


CREATE TABLE Disciplinas (
    IdDisciplina INT IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL,
	Imagen VARCHAR(300) NOT NULL,
    Activa BIT NOT NULL DEFAULT 1,
	CONSTRAINT PK_Disciplinas PRIMARY KEY (IdDisciplina)
);
GO

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
GO

CREATE TABLE DisciplinasXInstructores (
	IdInstructor    INT     NOT NULL,
    IdDisciplina    INT     NOT NULL,
 
    CONSTRAINT PK_DisciplinasXInstructores  PRIMARY KEY (IdInstructor, IdDisciplina),
    CONSTRAINT FK_DXI_Instructor            FOREIGN KEY (IdInstructor) REFERENCES Usuarios(IdUsuario),
    CONSTRAINT FK_DXI_Disciplina            FOREIGN KEY (IdDisciplina) REFERENCES Disciplinas(IdDisciplina)
);
GO

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

CREATE TABLE Reservas (
    IdReserva     INT IDENTITY(1,1) NOT NULL,
    IdClase       INT NOT NULL,
    IdAlumno      INT NOT NULL, 
    FechaReserva  DATETIME NOT NULL DEFAULT GETDATE(),
    Estado        INT NOT NULL DEFAULT 1, -- 1=Vigente, 2=Cancelada, 3=Finalizada, 4=Reprogramada
    Asistencia    INT NULL, -- NULL (no pasó la clase), 1 (Asistió), 0 (Faltó)
    Observaciones VARCHAR(500) NULL,

    CONSTRAINT PK_Reservas PRIMARY KEY (IdReserva),
    CONSTRAINT FK_Reservas_Clases FOREIGN KEY (IdClase) REFERENCES Clases(IdClase),
    CONSTRAINT FK_Reservas_Usuarios FOREIGN KEY (IdAlumno) REFERENCES Usuarios(IdUsuario),
    CONSTRAINT UQ_Alumno_Clase UNIQUE (IdAlumno, IdClase),
    CONSTRAINT CK_Reservas_Estado CHECK (Estado IN (1, 2, 3, 4)) 
);

ALTER TABLE Reservas
ADD CONSTRAINT CK_Reservas_Asistencia
CHECK (Asistencia IS NULL OR Asistencia IN (1, 2));

GO

CREATE TABLE Planes (
    IdPlan INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(100) NOT NULL,
    CantidadClases INT NULL, -- NULL = ilimitado
    DuracionMeses INT NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

ALTER TABLE Planes
ADD CONSTRAINT CHK_Planes_DuracionMeses
CHECK (DuracionMeses >= 1);

ALTER TABLE Planes
ADD CONSTRAINT DF_Planes_DuracionMeses
DEFAULT 1 FOR DuracionMeses;
GO

CREATE TABLE Suscripciones (
    IdSuscripcion INT IDENTITY(1,1) PRIMARY KEY,

    IdUsuario INT NOT NULL UNIQUE, -- 1 sola suscripción activa por usuario
    IdPlan INT NOT NULL,

    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,

    ClasesConsumidas INT NOT NULL DEFAULT 0,

    FechaUltimaActualizacion DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Suscripciones_Usuarios
        FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario),

    CONSTRAINT FK_Suscripciones_Planes
        FOREIGN KEY (IdPlan) REFERENCES Planes(IdPlan)
);
GO

CREATE TABLE RecordatoriosClases (
    IdRecordatorio INT IDENTITY(1,1) PRIMARY KEY,
    IdClase INT NOT NULL,
    FechaEnvio DATETIME NOT NULL DEFAULT GETDATE(),
    CantidadEnviada INT NOT NULL,
    CONSTRAINT FK_RecordatoriosClases_Clases
	FOREIGN KEY (IdClase) REFERENCES Clases(IdClase)
);
GO

CREATE TABLE HistorialCancelaciones
(
    IdHistorial INT IDENTITY(1,1) PRIMARY KEY,
    IdReserva INT NOT NULL,
    IdAlumno INT NOT NULL,
    FechaClase DATE NOT NULL,
    FechaCancelacion DATETIME NOT NULL DEFAULT GETDATE(),
    TipoCancelacion INT NOT NULL, -- 1 = Alumno -- 2 = Centro Fitness
    Motivo VARCHAR(200) NULL
);
GO

CREATE TABLE HistorialInasistencias (
    IdInasistencia INT IDENTITY(1,1) PRIMARY KEY,
    IdAlumno INT NOT NULL,
    IdReserva INT NOT NULL,
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_HistorialInasistencias_Alumno
        FOREIGN KEY (IdAlumno) REFERENCES Usuarios(IdUsuario),

    CONSTRAINT FK_HistorialInasistencias_Reserva
        FOREIGN KEY (IdReserva) REFERENCES Reservas(IdReserva)
);

ALTER TABLE HistorialInasistencias
ADD CONSTRAINT UQ_HistorialInasistencias_Reserva UNIQUE (IdReserva);
GO

CREATE TABLE HistorialSuscripciones (
    IdHistorial INT IDENTITY(1,1) PRIMARY KEY,

    IdUsuario INT NOT NULL,
    IdPlan INT NOT NULL,

    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,

    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),

    TipoMovimiento INT NOT NULL
    -- EJ: 1-'ALTA', 2-'ACTUALIZACIÓN'
);
GO

-- =============================================
-- Datos iniciales: Disciplinas
-- =============================================

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
-- Datos iniciales: usuario Administrador
-- =============================================
INSERT INTO Usuarios (Nombre, Apellido, Email, Password, DNI, Telefono, FechaNacimiento, Imagen, Rol)
VALUES ('Admin', 'Sistema', 'admin@centrofitness.com', '1234', '00000000', '00000000', '2000-01-01', 'default-user', 1); 
GO

-- =============================================
-- Datos iniciales: 15 Instructores
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

-- =============================================
-- Datos iniciales: 25 Alumnos (Rol = 4)
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
-- Datos iniciales: 3 Recepcionistas (Rol = 2)
-- =============================================

INSERT INTO Usuarios (Nombre, Apellido, Email, Password, DNI, Telefono, FechaNacimiento, Imagen, Rol, Observaciones, Activo)
VALUES
('Romina',   'Acosta',   'romina.acosta@centrofitness.com',   '1234', '32500201', '1161000201', '1990-04-18', 'default-user', 2, NULL, 1),
('Leandro',  'Burgos',   'leandro.burgos@centrofitness.com',  '1234', '29500202', '1161000202', '1986-09-07', 'default-user', 2, NULL, 1),
('Mariela',  'Campos',   'mariela.campos@centrofitness.com',  '1234', '35500203', '1161000203', '1993-12-23', 'default-user', 2, NULL, 1);
GO

-- =============================================
-- Datos iniciales: Planes
-- =============================================
INSERT INTO Planes (Descripcion, CantidadClases, DuracionMeses, Precio)
VALUES
('Pack 4 clases',   4,    1,  8000.00),   -- IdPlan 1
('Pack 8 clases',   8,    1, 14000.00),   -- IdPlan 2
('Pack 12 clases',  12,   1, 20000.00),   -- IdPlan 3
('Pase Libre',      NULL, 1, 30000.00);   -- IdPlan 4

GO

USE CENTRO_FITNESS
GO

-- ============================================================
-- MAPA DE IDs
-- ============================================================
-- INSTRUCTORES (IdUsuario 2–16)
--   2  Ana García        → Pilates
--   3  Carlos Rodríguez  → Spinning
--   4  Valentina Pérez   → Pilates
--   5  Diego Fernández   → Funcional
--   6  Sebastián Díaz    → Stretching
--   7  Nicolás Romero    → Yoga
--   8  Agustín Morales   → Pilates
--   9  Tomás Castro      → Funcional
--  10  Martín López      → Funcional + Spinning
--  11  Sofía Martínez    → Yoga + Stretching
--  12  Camila Sánchez    → Pilates + Stretching
--  13  Florencia Torres  → Spinning + Funcional
--  14  Micaela Herrera   → Yoga + Pilates
--  15  Julieta Vargas    → Zumba + Salsa
--  16  Lucía González    → Zumba + Bachata + Salsa
--
-- ALUMNOS (IdUsuario 17–41)
--   17 Luciana Fernández
--   18 Mateo García         (lesión rodilla)
--   19 Camila López
--   20 Facundo Martínez     (asmático)
--   21 Valentina Rodríguez
--   22 Ignacio Pérez        (operado espalda)
--   23 Florencia González
--   24 Tobías Sánchez
--   25 Martina Romero       (hipertensión)
--   26 Bruno Torres
--   27 Agustina Díaz        (tendinitis hombro)
--   28 Santiago Morales
--   29 Julieta Herrera      (diabetes)
--   30 Nicolás Castro
--   31 Antonella Vargas
--   32 Emiliano Ruiz        (fractura tobillo)
--   33 Sofía Medina
--   34 Lautaro Jiménez
--   35 Rocío Suárez         (escoliosis)
--   36 Tomás Álvarez
--   37 Milagros Ramos
--   38 Ezequiel Molina      (operado menisco)
--   39 Pilar Ortega
--   40 Maximiliano Silva    (alérgico penicilina)
--   41 Catalina Reyes
--
-- GRUPOS DE SUSCRIPCIÓN
--   MAYO  vencida  (sin reservas):  alumnos 37–41
--   JUNIO vigente  (reservas 29/06 hasta 04/07): alumnos 17–26
--   JULIO vigente  (reservas 01/07 hasta 04/08): alumnos 27–36
--
-- DISCIPLINAS: 1=Pilates 2=Yoga 3=Funcional 4=Stretching
--              5=Spinning 6=Zumba 7=Bachata 8=Salsa
-- PLANES:      1=Pack4  2=Pack8  3=Pack12  4=Pase Libre
-- ============================================================


-- ============================================================
-- 1. CLASES  (29/06/2026 → 10/08/2026)
--    Restricción: un solo salón → Fecha+HoraInicio único
--    Cupos entre 5 y 8  |  Estado DEFAULT 1 (Vigente)
-- ============================================================

INSERT INTO Clases (IdDisciplina, IdInstructor, Fecha, HoraInicio, CupoMaximo)
VALUES
-- ── Lun 29/06 ────────────────────────────────────────────────────────
(1,  2,  '2026-06-29',  8, 6),   -- Pilates      Ana García
(2,  7,  '2026-06-29', 10, 5),   -- Yoga         Nicolás Romero
(3,  5,  '2026-06-29', 17, 8),   -- Funcional    Diego Fernández
(6, 15,  '2026-06-29', 19, 7),   -- Zumba        Julieta Vargas
-- ── Mar 30/06 ────────────────────────────────────────────────────────
(5,  3,  '2026-06-30',  9, 6),   -- Spinning     Carlos Rodríguez
(4,  6,  '2026-06-30', 11, 5),   -- Stretching   Sebastián Díaz
(1,  4,  '2026-06-30', 18, 7),   -- Pilates      Valentina Pérez
(2, 11,  '2026-06-30', 20, 6),   -- Yoga         Sofía Martínez
-- ── Mié 01/07 ────────────────────────────────────────────────────────
(3,  9,  '2026-07-01',  8, 8),   -- Funcional    Tomás Castro
(1,  8,  '2026-07-01', 10, 6),   -- Pilates      Agustín Morales
(2, 14,  '2026-07-01', 17, 5),   -- Yoga         Micaela Herrera
(7, 16,  '2026-07-01', 19, 7),   -- Bachata      Lucía González
-- ── Jue 02/07 ────────────────────────────────────────────────────────
(4, 11,  '2026-07-02',  9, 5),   -- Stretching   Sofía Martínez
(5, 10,  '2026-07-02', 11, 6),   -- Spinning     Martín López
(3, 13,  '2026-07-02', 18, 8),   -- Funcional    Florencia Torres
(8, 16,  '2026-07-02', 20, 7),   -- Salsa        Lucía González
-- ── Vie 03/07 ────────────────────────────────────────────────────────
(1, 12,  '2026-07-03',  8, 6),   -- Pilates      Camila Sánchez
(3,  5,  '2026-07-03', 10, 8),   -- Funcional    Diego Fernández
(4,  6,  '2026-07-03', 17, 5),   -- Stretching   Sebastián Díaz
(6, 16,  '2026-07-03', 19, 7),   -- Zumba        Lucía González
-- ── Sáb 04/07 ────────────────────────────────────────────────────────
(2,  7,  '2026-07-04',  9, 6),   -- Yoga         Nicolás Romero
(8, 15,  '2026-07-04', 11, 7),   -- Salsa        Julieta Vargas
-- ── Lun 07/07 ────────────────────────────────────────────────────────
(1,  2,  '2026-07-07',  8, 6),   -- Pilates      Ana García
(3,  9,  '2026-07-07', 10, 8),   -- Funcional    Tomás Castro
(2,  7,  '2026-07-07', 17, 5),   -- Yoga         Nicolás Romero
(6, 15,  '2026-07-07', 19, 7),   -- Zumba        Julieta Vargas
-- ── Mar 08/07 ────────────────────────────────────────────────────────
(5, 13,  '2026-07-08',  9, 6),   -- Spinning     Florencia Torres
(1,  4,  '2026-07-08', 11, 5),   -- Pilates      Valentina Pérez
(4, 12,  '2026-07-08', 18, 6),   -- Stretching   Camila Sánchez
(7, 16,  '2026-07-08', 20, 7),   -- Bachata      Lucía González
-- ── Mié 09/07 ────────────────────────────────────────────────────────
(2, 14,  '2026-07-09',  8, 5),   -- Yoga         Micaela Herrera
(3, 10,  '2026-07-09', 10, 8),   -- Funcional    Martín López
(1,  8,  '2026-07-09', 17, 6),   -- Pilates      Agustín Morales
(8, 16,  '2026-07-09', 19, 7),   -- Salsa        Lucía González
-- ── Jue 10/07 ────────────────────────────────────────────────────────
(4, 11,  '2026-07-10',  9, 5),   -- Stretching   Sofía Martínez
(5,  3,  '2026-07-10', 11, 6),   -- Spinning     Carlos Rodríguez
(3,  5,  '2026-07-10', 18, 8),   -- Funcional    Diego Fernández
(6, 16,  '2026-07-10', 20, 7),   -- Zumba        Lucía González
-- ── Vie 11/07 ────────────────────────────────────────────────────────
(1,  2,  '2026-07-11',  8, 6),   -- Pilates      Ana García
(2, 11,  '2026-07-11', 10, 5),   -- Yoga         Sofía Martínez
(3, 13,  '2026-07-11', 17, 8),   -- Funcional    Florencia Torres
-- ── Sáb 12/07 ────────────────────────────────────────────────────────
(1,  4,  '2026-07-12',  9, 6),   -- Pilates      Valentina Pérez
(7, 16,  '2026-07-12', 11, 7),   -- Bachata      Lucía González
-- ── Lun 14/07 ────────────────────────────────────────────────────────
(3,  9,  '2026-07-14',  8, 8),   -- Funcional    Tomás Castro
(1, 12,  '2026-07-14', 10, 6),   -- Pilates      Camila Sánchez
(2,  7,  '2026-07-14', 17, 5),   -- Yoga         Nicolás Romero
(6, 15,  '2026-07-14', 19, 7),   -- Zumba        Julieta Vargas
-- ── Mar 15/07 ────────────────────────────────────────────────────────
(5, 10,  '2026-07-15',  9, 6),   -- Spinning     Martín López
(4,  6,  '2026-07-15', 11, 5),   -- Stretching   Sebastián Díaz
(1, 14,  '2026-07-15', 18, 6),   -- Pilates      Micaela Herrera
-- ── Mié 16/07 ────────────────────────────────────────────────────────
(2, 11,  '2026-07-16',  8, 5),   -- Yoga         Sofía Martínez
(3,  5,  '2026-07-16', 10, 8),   -- Funcional    Diego Fernández
(8, 16,  '2026-07-16', 17, 7),   -- Salsa        Lucía González
-- ── Jue 17/07 ────────────────────────────────────────────────────────
(1,  8,  '2026-07-17',  9, 6),   -- Pilates      Agustín Morales
(5, 13,  '2026-07-17', 11, 6),   -- Spinning     Florencia Torres
(4, 12,  '2026-07-17', 18, 5),   -- Stretching   Camila Sánchez
-- ── Vie 18/07 ────────────────────────────────────────────────────────
(3,  9,  '2026-07-18',  8, 8),   -- Funcional    Tomás Castro
(1,  2,  '2026-07-18', 10, 6),   -- Pilates      Ana García
(6, 15,  '2026-07-18', 17, 7),   -- Zumba        Julieta Vargas
-- ── Sáb 19/07 ────────────────────────────────────────────────────────
(2, 14,  '2026-07-19',  9, 5),   -- Yoga         Micaela Herrera
(7, 16,  '2026-07-19', 11, 6),   -- Bachata      Lucía González
-- ── Lun 21/07 ────────────────────────────────────────────────────────
(1,  4,  '2026-07-21',  8, 6),   -- Pilates      Valentina Pérez
(3, 10,  '2026-07-21', 10, 8),   -- Funcional    Martín López
(2,  7,  '2026-07-21', 17, 5),   -- Yoga         Nicolás Romero
(8, 16,  '2026-07-21', 19, 7),   -- Salsa        Lucía González
-- ── Mar 22/07 ────────────────────────────────────────────────────────
(4, 11,  '2026-07-22',  9, 5),   -- Stretching   Sofía Martínez
(5,  3,  '2026-07-22', 11, 6),   -- Spinning     Carlos Rodríguez
(1,  8,  '2026-07-22', 18, 6),   -- Pilates      Agustín Morales
-- ── Mié 23/07 ────────────────────────────────────────────────────────
(3,  5,  '2026-07-23',  8, 8),   -- Funcional    Diego Fernández
(2, 14,  '2026-07-23', 10, 5),   -- Yoga         Micaela Herrera
(6, 15,  '2026-07-23', 17, 7),   -- Zumba        Julieta Vargas
-- ── Jue 24/07 ────────────────────────────────────────────────────────
(1, 12,  '2026-07-24',  9, 6),   -- Pilates      Camila Sánchez
(3, 13,  '2026-07-24', 11, 8),   -- Funcional    Florencia Torres
(4,  6,  '2026-07-24', 18, 5),   -- Stretching   Sebastián Díaz
-- ── Vie 25/07 ────────────────────────────────────────────────────────
(1,  2,  '2026-07-25',  8, 6),   -- Pilates      Ana García
(5, 10,  '2026-07-25', 10, 6),   -- Spinning     Martín López
(2, 11,  '2026-07-25', 17, 5),   -- Yoga         Sofía Martínez
-- ── Sáb 26/07 ────────────────────────────────────────────────────────
(3,  9,  '2026-07-26',  9, 8),   -- Funcional    Tomás Castro
(7, 16,  '2026-07-26', 11, 6),   -- Bachata      Lucía González
-- ── Lun 28/07 ────────────────────────────────────────────────────────
(1,  4,  '2026-07-28',  8, 6),   -- Pilates      Valentina Pérez
(2,  7,  '2026-07-28', 10, 5),   -- Yoga         Nicolás Romero
(3,  5,  '2026-07-28', 17, 8),   -- Funcional    Diego Fernández
(6, 16,  '2026-07-28', 19, 7),   -- Zumba        Lucía González
-- ── Mar 29/07 ────────────────────────────────────────────────────────
(4, 12,  '2026-07-29',  9, 5),   -- Stretching   Camila Sánchez
(5, 13,  '2026-07-29', 11, 6),   -- Spinning     Florencia Torres
(1,  8,  '2026-07-29', 18, 6),   -- Pilates      Agustín Morales
-- ── Mié 30/07 ────────────────────────────────────────────────────────
(3, 10,  '2026-07-30',  8, 8),   -- Funcional    Martín López
(1, 14,  '2026-07-30', 10, 6),   -- Pilates      Micaela Herrera
(8, 15,  '2026-07-30', 17, 7),   -- Salsa        Julieta Vargas
-- ── Jue 31/07 ────────────────────────────────────────────────────────
(2, 11,  '2026-07-31',  9, 5),   -- Yoga         Sofía Martínez
(4,  6,  '2026-07-31', 11, 5),   -- Stretching   Sebastián Díaz
(3,  9,  '2026-07-31', 18, 8),   -- Funcional    Tomás Castro
-- ── Sáb 01/08 ────────────────────────────────────────────────────────
(1,  2,  '2026-08-01',  9, 6),   -- Pilates      Ana García
(6, 16,  '2026-08-01', 11, 7),   -- Zumba        Lucía González
-- ── Lun 03/08 ────────────────────────────────────────────────────────
(2, 14,  '2026-08-03',  8, 5),   -- Yoga         Micaela Herrera
(3,  5,  '2026-08-03', 10, 8),   -- Funcional    Diego Fernández
(1, 12,  '2026-08-03', 17, 6),   -- Pilates      Camila Sánchez
(7, 16,  '2026-08-03', 19, 6),   -- Bachata      Lucía González
-- ── Mar 04/08 ────────────────────────────────────────────────────────
(5,  3,  '2026-08-04',  9, 6),   -- Spinning     Carlos Rodríguez
(1,  4,  '2026-08-04', 11, 6),   -- Pilates      Valentina Pérez
(4, 11,  '2026-08-04', 18, 5),   -- Stretching   Sofía Martínez
-- ── Mié 05/08 ────────────────────────────────────────────────────────
(3, 13,  '2026-08-05',  8, 8),   -- Funcional    Florencia Torres
(2,  7,  '2026-08-05', 10, 5),   -- Yoga         Nicolás Romero
(1,  8,  '2026-08-05', 17, 6),   -- Pilates      Agustín Morales
-- ── Jue 06/08 ────────────────────────────────────────────────────────
(4,  6,  '2026-08-06',  9, 5),   -- Stretching   Sebastián Díaz
(5, 10,  '2026-08-06', 11, 6),   -- Spinning     Martín López
(3,  9,  '2026-08-06', 18, 8),   -- Funcional    Tomás Castro
-- ── Vie 07/08 ────────────────────────────────────────────────────────
(1,  2,  '2026-08-07',  8, 6),   -- Pilates      Ana García
(2, 14,  '2026-08-07', 10, 5),   -- Yoga         Micaela Herrera
(6, 15,  '2026-08-07', 17, 7),   -- Zumba        Julieta Vargas
-- ── Sáb 08/08 ────────────────────────────────────────────────────────
(3,  5,  '2026-08-08',  9, 8),   -- Funcional    Diego Fernández
(8, 16,  '2026-08-08', 11, 7),   -- Salsa        Lucía González
-- ── Lun 10/08 ────────────────────────────────────────────────────────
(1,  4,  '2026-08-10',  8, 6),   -- Pilates      Valentina Pérez
(3, 10,  '2026-08-10', 10, 8),   -- Funcional    Martín López
(2, 11,  '2026-08-10', 17, 5),   -- Yoga         Sofía Martínez
(6, 16,  '2026-08-10', 19, 7);   -- Zumba        Lucía González

GO


-- ============================================================
-- 2. SUSCRIPCIONES
--
--   MAYO  vencida  → alumnos 37–41  (FechaFin 31/05)
--   JUNIO vigente  → alumnos 17–26  (FechaFin 30/06)
--   JULIO vigente  → alumnos 27–36  (FechaFin 31/07)
--
-- ClasesConsumidas:
--   Mayo  → consumo acumulado al vencimiento
--   Junio → consumo parcial (estamos en el día 29)
--   Julio → 0 (mes aún no comenzó)
-- ============================================================

INSERT INTO Suscripciones
    (IdUsuario, IdPlan, FechaInicio, FechaFin, ClasesConsumidas, FechaUltimaActualizacion)
VALUES
-- ── JUNIO vigente (17–26) ─────────────────────────────────────────────
(17, 2, '2026-06-01', '2026-06-30',  5, '2026-06-01'),  -- Luciana      Pack 8
(18, 1, '2026-06-01', '2026-06-30',  3, '2026-06-01'),  -- Mateo        Pack 4
(19, 3, '2026-06-01', '2026-06-30',  7, '2026-06-01'),  -- Camila       Pack 12
(20, 4, '2026-06-01', '2026-06-30',  9, '2026-06-01'),  -- Facundo      Pase Libre
(21, 2, '2026-06-01', '2026-06-30',  4, '2026-06-01'),  -- Valentina    Pack 8
(22, 1, '2026-06-01', '2026-06-30',  2, '2026-06-01'),  -- Ignacio      Pack 4
(23, 3, '2026-06-01', '2026-06-30',  8, '2026-06-01'),  -- Florencia    Pack 12
(24, 4, '2026-06-01', '2026-06-30', 10, '2026-06-01'),  -- Tobías       Pase Libre
(25, 2, '2026-06-01', '2026-06-30',  3, '2026-06-01'),  -- Martina      Pack 8
(26, 1, '2026-06-01', '2026-06-30',  4, '2026-06-01'),  -- Bruno        Pack 4 (agotado)
-- ── JULIO vigente (27–36) ─────────────────────────────────────────────
(27, 2, '2026-07-01', '2026-07-31',  0, '2026-07-01'),  -- Agustina     Pack 8
(28, 1, '2026-07-01', '2026-07-31',  0, '2026-07-01'),  -- Santiago     Pack 4
(29, 3, '2026-07-01', '2026-07-31',  0, '2026-07-01'),  -- Julieta      Pack 12
(30, 4, '2026-07-01', '2026-07-31',  0, '2026-07-01'),  -- Nicolás      Pase Libre
(31, 2, '2026-07-01', '2026-07-31',  0, '2026-07-01'),  -- Antonella    Pack 8
(32, 1, '2026-07-01', '2026-07-31',  0, '2026-07-01'),  -- Emiliano     Pack 4
(33, 3, '2026-07-01', '2026-07-31',  0, '2026-07-01'),  -- Sofía        Pack 12
(34, 4, '2026-07-01', '2026-07-31',  0, '2026-07-01'),  -- Lautaro      Pase Libre
(35, 2, '2026-07-01', '2026-07-31',  0, '2026-07-01'),  -- Rocío        Pack 8
(36, 1, '2026-07-01', '2026-07-31',  0, '2026-07-01'),  -- Tomás        Pack 4
-- ── MAYO vencida (37–41) ──────────────────────────────────────────────
(37, 1, '2026-05-01', '2026-05-31',  3, '2026-05-01'),  -- Milagros     Pack 4
(38, 2, '2026-05-01', '2026-05-31',  7, '2026-05-01'),  -- Ezequiel     Pack 8
(39, 3, '2026-05-01', '2026-05-31', 10, '2026-05-01'),  -- Pilar        Pack 12
(40, 4, '2026-05-01', '2026-05-31', 12, '2026-05-01'),  -- Maximiliano  Pase Libre
(41, 1, '2026-05-01', '2026-05-31',  4, '2026-05-01');  -- Catalina     Pack 4 (agotado)

GO


-- ============================================================
-- 3. HISTORIAL SUSCRIPCIONES
--    TipoMovimiento: 1=ALTA  2=ACTUALIZACIÓN
--
--    Alumnos 17–20: tuvieron Mayo → renovaron Junio
--    Alumnos 21–26: alta directa en Junio
--    Alumnos 27–30: tuvieron Junio → renovaron Julio
--    Alumnos 31–32: tuvieron Mayo → Junio → Julio
--    Alumnos 33–36: alta directa en Julio
--    Alumnos 37–41: solo Mayo (no renovaron)
-- ============================================================

INSERT INTO HistorialSuscripciones
    (IdUsuario, IdPlan, FechaInicio, FechaFin, FechaRegistro, TipoMovimiento)
VALUES
-- ── Alumnos con Mayo + Junio (17–20) ─────────────────────────────────
(17, 2, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Luciana   ALTA mayo   Pack 8
(17, 2, '2026-06-01', '2026-06-30', '2026-06-01', 2),  -- Luciana   ACT. junio  Pack 8
(18, 1, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Mateo     ALTA mayo   Pack 4
(18, 1, '2026-06-01', '2026-06-30', '2026-06-01', 2),  -- Mateo     ACT. junio  Pack 4
(19, 3, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Camila    ALTA mayo   Pack 12
(19, 3, '2026-06-01', '2026-06-30', '2026-06-01', 2),  -- Camila    ACT. junio  Pack 12
(20, 4, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Facundo   ALTA mayo   Pase Libre
(20, 4, '2026-06-01', '2026-06-30', '2026-06-01', 2),  -- Facundo   ACT. junio  Pase Libre
-- ── Alta directa en Junio (21–26) ────────────────────────────────────
(21, 2, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Valentina ALTA junio  Pack 8
(22, 1, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Ignacio   ALTA junio  Pack 4
(23, 3, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Florencia ALTA junio  Pack 12
(24, 4, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Tobías    ALTA junio  Pase Libre
(25, 2, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Martina   ALTA junio  Pack 8
(26, 1, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Bruno     ALTA junio  Pack 4
-- ── Alumnos con Junio + Julio (27–30) ────────────────────────────────
(27, 1, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Agustina  ALTA junio  Pack 4
(27, 2, '2026-07-01', '2026-07-31', '2026-07-01', 2),  -- Agustina  ACT. julio  Pack 8
(28, 1, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Santiago  ALTA junio  Pack 4
(28, 1, '2026-07-01', '2026-07-31', '2026-07-01', 2),  -- Santiago  ACT. julio  Pack 4
(29, 3, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Julieta   ALTA junio  Pack 12
(29, 3, '2026-07-01', '2026-07-31', '2026-07-01', 2),  -- Julieta   ACT. julio  Pack 12
(30, 4, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Nicolás   ALTA junio  Pase Libre
(30, 4, '2026-07-01', '2026-07-31', '2026-07-01', 2),  -- Nicolás   ACT. julio  Pase Libre
-- ── Alumnos con Mayo + Junio + Julio (31–32) ─────────────────────────
(31, 2, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Antonella ALTA mayo   Pack 8
(31, 2, '2026-06-01', '2026-06-30', '2026-06-01', 2),  -- Antonella ACT. junio  Pack 8
(31, 2, '2026-07-01', '2026-07-31', '2026-07-01', 2),  -- Antonella ACT. julio  Pack 8
(32, 1, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Emiliano  ALTA mayo   Pack 4
(32, 1, '2026-06-01', '2026-06-30', '2026-06-01', 2),  -- Emiliano  ACT. junio  Pack 4
(32, 1, '2026-07-01', '2026-07-31', '2026-07-01', 2),  -- Emiliano  ACT. julio  Pack 4
-- ── Alta directa en Julio (33–36) ────────────────────────────────────
(33, 3, '2026-07-01', '2026-07-31', '2026-07-01', 1),  -- Sofía     ALTA julio  Pack 12
(34, 4, '2026-07-01', '2026-07-31', '2026-07-01', 1),  -- Lautaro   ALTA julio  Pase Libre
(35, 2, '2026-07-01', '2026-07-31', '2026-07-01', 1),  -- Rocío     ALTA julio  Pack 8
(36, 1, '2026-07-01', '2026-07-31', '2026-07-01', 1),  -- Tomás     ALTA julio  Pack 4
-- ── Solo Mayo, no renovaron (37–41) ──────────────────────────────────
(37, 1, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Milagros  ALTA mayo   Pack 4
(38, 2, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Ezequiel  ALTA mayo   Pack 8
(39, 3, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Pilar     ALTA mayo   Pack 12
(40, 4, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Maximiliano ALTA mayo Pase Libre
(41, 1, '2026-05-01', '2026-05-31', '2026-05-01', 1);  -- Catalina  ALTA mayo   Pack 4

GO


-- ============================================================
-- 4. RESERVAS
--    Estado 1 = Vigente  |  Asistencia = NULL (clases futuras)
--
--    REGLA DE PERÍODOS:
--    ┌─────────────────────┬──────────────────────────────────┐
--    │ Suscripción         │ Fechas válidas para reservas     │
--    ├─────────────────────┼──────────────────────────────────┤
--    │ Mayo  vencida 37–41 │ Sin reservas                     │
--    │ Junio vigente 17–26 │ 29/06 hasta 04/07 inclusive      │
--    │ Julio vigente 27–36 │ 01/07 hasta 04/08 inclusive      │
--    └─────────────────────┴──────────────────────────────────┘
--
--    Las clases se referencian por Fecha+HoraInicio
--    (único por restricción de salón único)
-- ============================================================

-- ════════════════════════════════════════════════════════════
-- GRUPO JUNIO (alumnos 17–26): clases del 29/06 al 04/07
-- ════════════════════════════════════════════════════════════

-- ── 29/06 Pilates 8h ──────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 17, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-06-29' AND HoraInicio = 8;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 18, 1, NULL, 'Lesión en rodilla derecha, trabajar con modificaciones'
FROM Clases WHERE Fecha = '2026-06-29' AND HoraInicio = 8;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 21, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-06-29' AND HoraInicio = 8;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 23, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-06-29' AND HoraInicio = 8;

-- ── 29/06 Yoga 10h ────────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 19, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-06-29' AND HoraInicio = 10;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 20, 1, NULL, 'Asmático, lleva inhalador'
FROM Clases WHERE Fecha = '2026-06-29' AND HoraInicio = 10;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 25, 1, NULL, 'Hipertensión controlada, monitorear esfuerzo'
FROM Clases WHERE Fecha = '2026-06-29' AND HoraInicio = 10;

-- ── 29/06 Funcional 17h ───────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 22, 1, NULL, 'Operado de espalda, evitar impacto'
FROM Clases WHERE Fecha = '2026-06-29' AND HoraInicio = 17;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 24, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-06-29' AND HoraInicio = 17;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 26, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-06-29' AND HoraInicio = 17;

-- ── 29/06 Zumba 19h ───────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 17, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-06-29' AND HoraInicio = 19;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 23, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-06-29' AND HoraInicio = 19;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 26, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-06-29' AND HoraInicio = 19;

-- ── 30/06 Spinning 9h ─────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 18, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-06-30' AND HoraInicio = 9;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 20, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-06-30' AND HoraInicio = 9;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 24, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-06-30' AND HoraInicio = 9;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 25, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-06-30' AND HoraInicio = 9;

-- ── 30/06 Stretching 11h ──────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 19, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-06-30' AND HoraInicio = 11;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 21, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-06-30' AND HoraInicio = 11;

-- ── 30/06 Pilates 18h ─────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 22, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-06-30' AND HoraInicio = 18;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 23, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-06-30' AND HoraInicio = 18;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 26, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-06-30' AND HoraInicio = 18;

-- ── 01/07 Pilates 10h ─────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 17, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 10;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 19, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 10;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 21, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 10;

-- ── 01/07 Yoga 17h ────────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 20, 1, NULL, 'Asmático, lleva inhalador'
FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 17;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 25, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 17;

-- ── 02/07 Stretching 9h ───────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 18, 1, NULL, 'Lesión en rodilla derecha'
FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 9;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 24, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 9;

-- ── 02/07 Funcional 18h ───────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 22, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 18;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 23, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 18;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 26, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 18;

-- ── 03/07 Pilates 8h ──────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 17, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 8;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 19, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 8;

-- ── 03/07 Funcional 10h ───────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 20, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 10;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 21, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 10;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 25, 1, NULL, 'Hipertensión, clase de intensidad moderada'
FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 10;

-- ── 04/07 Yoga 9h (sábado, último día grupo junio) ───────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 22, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-04' AND HoraInicio = 9;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 24, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-04' AND HoraInicio = 9;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 26, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-04' AND HoraInicio = 9;

-- ── 04/07 Salsa 11h ───────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 23, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-04' AND HoraInicio = 11;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 25, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-04' AND HoraInicio = 11;


-- ════════════════════════════════════════════════════════════
-- GRUPO JULIO (alumnos 27–36): clases del 01/07 al 04/08
-- ════════════════════════════════════════════════════════════

-- ── 01/07 Funcional 8h ────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 27, 1, NULL, 'Tendinitis en hombro izquierdo, evitar carga'
FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 8;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 28, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 8;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 30, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 8;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 33, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 8;

-- ── 01/07 Bachata 19h ─────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 29, 1, NULL, 'Diabetes tipo 2, tiene glucómetro'
FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 19;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 34, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 19;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 35, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-01' AND HoraInicio = 19;

-- ── 02/07 Spinning 11h ────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 27, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 11;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 31, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 11;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 36, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 11;

-- ── 02/07 Salsa 20h ───────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 28, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 20;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 29, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 20;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 35, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-02' AND HoraInicio = 20;

-- ── 03/07 Stretching 17h ──────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 30, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 17;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 32, 1, NULL, 'Fractura de tobillo en recuperación, sin saltos'
FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 17;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 33, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 17;

-- ── 03/07 Zumba 19h ───────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 31, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 19;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 34, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 19;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 36, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-03' AND HoraInicio = 19;

-- ── 07/07 Pilates 8h ──────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 27, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-07' AND HoraInicio = 8;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 29, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-07' AND HoraInicio = 8;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 33, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-07' AND HoraInicio = 8;

-- ── 07/07 Funcional 10h ───────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 28, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-07' AND HoraInicio = 10;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 31, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-07' AND HoraInicio = 10;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 35, 1, NULL, 'Escoliosis leve, evitar torsiones bruscas'
FROM Clases WHERE Fecha = '2026-07-07' AND HoraInicio = 10;

-- ── 08/07 Pilates 11h ─────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 30, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-08' AND HoraInicio = 11;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 32, 1, NULL, 'Fractura tobillo, solo ejercicios de piso'
FROM Clases WHERE Fecha = '2026-07-08' AND HoraInicio = 11;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 36, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-08' AND HoraInicio = 11;

-- ── 09/07 Yoga 8h ─────────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 27, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-09' AND HoraInicio = 8;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 34, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-09' AND HoraInicio = 8;

-- ── 10/07 Funcional 18h ───────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 28, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-10' AND HoraInicio = 18;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 29, 1, NULL, 'Diabetes tipo 2, tiene glucómetro'
FROM Clases WHERE Fecha = '2026-07-10' AND HoraInicio = 18;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 33, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-10' AND HoraInicio = 18;

-- ── 14/07 Yoga 17h ────────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 30, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-14' AND HoraInicio = 17;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 31, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-14' AND HoraInicio = 17;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 35, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-14' AND HoraInicio = 17;

-- ── 16/07 Funcional 10h ───────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 27, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-16' AND HoraInicio = 10;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 32, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-16' AND HoraInicio = 10;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 36, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-16' AND HoraInicio = 10;

-- ── 21/07 Pilates 8h ──────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 28, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-21' AND HoraInicio = 8;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 33, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-21' AND HoraInicio = 8;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 34, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-21' AND HoraInicio = 8;

-- ── 23/07 Zumba 17h ───────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 29, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-23' AND HoraInicio = 17;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 31, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-23' AND HoraInicio = 17;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 35, 1, NULL, 'Escoliosis leve, movimientos controlados'
FROM Clases WHERE Fecha = '2026-07-23' AND HoraInicio = 17;

-- ── 28/07 Yoga 10h ────────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 30, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-28' AND HoraInicio = 10;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 36, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-28' AND HoraInicio = 10;

-- ── 30/07 Pilates 10h ─────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 27, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-30' AND HoraInicio = 10;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 32, 1, NULL, 'Fractura tobillo, sin saltos ni impacto'
FROM Clases WHERE Fecha = '2026-07-30' AND HoraInicio = 10;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 34, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-07-30' AND HoraInicio = 10;

-- ── 01/08 Pilates 9h ──────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 28, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-08-01' AND HoraInicio = 9;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 31, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-08-01' AND HoraInicio = 9;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 33, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-08-01' AND HoraInicio = 9;

-- ── 03/08 Yoga 8h ─────────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 29, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-08-03' AND HoraInicio = 8;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 35, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-08-03' AND HoraInicio = 8;

-- ── 04/08 Spinning 9h (último día grupo julio) ────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 30, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-08-04' AND HoraInicio = 9;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 36, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-08-04' AND HoraInicio = 9;

-- ── 04/08 Pilates 11h ─────────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 27, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-08-04' AND HoraInicio = 11;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 32, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-08-04' AND HoraInicio = 11;

INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 34, 1, NULL, NULL
FROM Clases WHERE Fecha = '2026-08-04' AND HoraInicio = 11;

GO
