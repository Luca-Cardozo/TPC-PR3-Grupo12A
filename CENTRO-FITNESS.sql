
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
('Pack 4 clases',   4,    30,  8000.00),   -- IdPlan 1
('Pack 8 clases',   8,    30, 14000.00),   -- IdPlan 2
('Pack 12 clases',  12,   30, 20000.00),   -- IdPlan 3
('Pase Libre',      NULL, 30, 30000.00);   -- IdPlan 4

GO

-- =============================================
-- Mapa de IDs (basado en el script de creación)
-- =============================================
-- INSTRUCTORES (IdUsuario 2-16)
--   2  = Ana García        → Pilates (1)
--   3  = Carlos Rodríguez  → Spinning (5)
--   4  = Valentina Pérez   → Pilates (1)
--   5  = Diego Fernández   → Funcional (3)
--   6  = Sebastián Díaz    → Stretching (4)
--   7  = Nicolás Romero    → Yoga (2)
--   8  = Agustín Morales   → Pilates (1)
--   9  = Tomás Castro      → Funcional (3)
--  10  = Martín López      → Funcional (3) + Spinning (5)
--  11  = Sofía Martínez    → Yoga (2) + Stretching (4)
--  12  = Camila Sánchez    → Pilates (1) + Stretching (4)
--  13  = Florencia Torres  → Spinning (5) + Funcional (3)
--  14  = Micaela Herrera   → Yoga (2) + Pilates (1)
--  15  = Julieta Vargas    → Zumba (6) + Salsa (8)
--  16  = Lucía González    → Zumba (6) + Bachata (7) + Salsa (8)
--
-- ALUMNOS (IdUsuario 17-41)
--   17 = Luciana Fernández
--   18 = Mateo García         (lesión rodilla)
--   19 = Camila López
--   20 = Facundo Martínez     (asmático)
--   21 = Valentina Rodríguez
--   22 = Ignacio Pérez        (operado espalda)
--   23 = Florencia González
--   24 = Tobías Sánchez
--   25 = Martina Romero       (hipertensión)
--   26 = Bruno Torres
--   27 = Agustina Díaz        (tendinitis hombro)
--   28 = Santiago Morales
--   29 = Julieta Herrera      (diabetes)
--   30 = Nicolás Castro
--   31 = Antonella Vargas
--   32 = Emiliano Ruiz        (fractura tobillo)
--   33 = Sofía Medina
--   34 = Lautaro Jiménez
--   35 = Rocío Suárez         (escoliosis)
--   36 = Tomás Álvarez
--   37 = Milagros Ramos
--   38 = Ezequiel Molina      (operado menisco)
--   39 = Pilar Ortega
--   40 = Maximiliano Silva    (alérgico penicilina)
--   41 = Catalina Reyes
--
-- DISCIPLINAS
--   1=Pilates  2=Yoga  3=Funcional  4=Stretching
--   5=Spinning 6=Zumba 7=Bachata   8=Salsa
--
-- PLANES
--   1=Pack 4   2=Pack 8   3=Pack 12   4=Pase Libre
-- =============================================


-- =============================================
-- CLASES (29/06/2026 → 10/08/2026)
-- Restricción: un solo salón → único Fecha+HoraInicio
-- Cupos entre 5 y 8
-- Estado DEFAULT 1 (Vigente)
-- =============================================

INSERT INTO Clases (IdDisciplina, IdInstructor, Fecha, HoraInicio, CupoMaximo)
VALUES
-- ── Lunes 29/06 ──────────────────────────────────────────────────────
(1,  2,  '2026-06-29',  8, 6),  -- Pilates       - Ana García
(2,  7,  '2026-06-29', 10, 5),  -- Yoga          - Nicolás Romero
(3,  5,  '2026-06-29', 17, 8),  -- Funcional     - Diego Fernández
(6, 15,  '2026-06-29', 19, 7),  -- Zumba         - Julieta Vargas

-- ── Martes 30/06 ─────────────────────────────────────────────────────
(5,  3,  '2026-06-30',  9, 6),  -- Spinning      - Carlos Rodríguez
(4,  6,  '2026-06-30', 11, 5),  -- Stretching    - Sebastián Díaz
(1,  4,  '2026-06-30', 18, 7),  -- Pilates       - Valentina Pérez
(2, 11,  '2026-06-30', 20, 6),  -- Yoga          - Sofía Martínez

-- ── Miércoles 01/07 ──────────────────────────────────────────────────
(3,  9,  '2026-07-01',  8, 8),  -- Funcional     - Tomás Castro
(1,  8,  '2026-07-01', 10, 6),  -- Pilates       - Agustín Morales
(2, 14,  '2026-07-01', 17, 5),  -- Yoga          - Micaela Herrera
(7, 16,  '2026-07-01', 19, 7),  -- Bachata       - Lucía González

-- ── Jueves 02/07 ─────────────────────────────────────────────────────
(4, 11,  '2026-07-02',  9, 5),  -- Stretching    - Sofía Martínez
(5, 10,  '2026-07-02', 11, 6),  -- Spinning      - Martín López
(3, 13,  '2026-07-02', 18, 8),  -- Funcional     - Florencia Torres
(8, 16,  '2026-07-02', 20, 7),  -- Salsa         - Lucía González

-- ── Viernes 03/07 ────────────────────────────────────────────────────
(1, 12,  '2026-07-03',  8, 6),  -- Pilates       - Camila Sánchez
(3,  5,  '2026-07-03', 10, 8),  -- Funcional     - Diego Fernández
(4,  6,  '2026-07-03', 17, 5),  -- Stretching    - Sebastián Díaz
(6, 16,  '2026-07-03', 19, 7),  -- Zumba         - Lucía González

-- ── Sábado 04/07 ─────────────────────────────────────────────────────
(2,  7,  '2026-07-04',  9, 6),  -- Yoga          - Nicolás Romero
(8, 15,  '2026-07-04', 11, 7),  -- Salsa         - Julieta Vargas

-- ── Lunes 07/07 ──────────────────────────────────────────────────────
(1,  2,  '2026-07-07',  8, 6),  -- Pilates       - Ana García
(3,  9,  '2026-07-07', 10, 8),  -- Funcional     - Tomás Castro
(2,  7,  '2026-07-07', 17, 5),  -- Yoga          - Nicolás Romero
(6, 15,  '2026-07-07', 19, 7),  -- Zumba         - Julieta Vargas

-- ── Martes 08/07 ─────────────────────────────────────────────────────
(5, 13,  '2026-07-08',  9, 6),  -- Spinning      - Florencia Torres
(1,  4,  '2026-07-08', 11, 5),  -- Pilates       - Valentina Pérez
(4, 12,  '2026-07-08', 18, 6),  -- Stretching    - Camila Sánchez
(7, 16,  '2026-07-08', 20, 7),  -- Bachata       - Lucía González

-- ── Miércoles 09/07 ──────────────────────────────────────────────────
(2, 14,  '2026-07-09',  8, 5),  -- Yoga          - Micaela Herrera
(3, 10,  '2026-07-09', 10, 8),  -- Funcional     - Martín López
(1,  8,  '2026-07-09', 17, 6),  -- Pilates       - Agustín Morales
(8, 16,  '2026-07-09', 19, 7),  -- Salsa         - Lucía González

-- ── Jueves 10/07 ─────────────────────────────────────────────────────
(4, 11,  '2026-07-10',  9, 5),  -- Stretching    - Sofía Martínez
(5,  3,  '2026-07-10', 11, 6),  -- Spinning      - Carlos Rodríguez
(3,  5,  '2026-07-10', 18, 8),  -- Funcional     - Diego Fernández
(6, 16,  '2026-07-10', 20, 7),  -- Zumba         - Lucía González

-- ── Viernes 11/07 ────────────────────────────────────────────────────
(1,  2,  '2026-07-11',  8, 6),  -- Pilates       - Ana García
(2, 11,  '2026-07-11', 10, 5),  -- Yoga          - Sofía Martínez
(3, 13,  '2026-07-11', 17, 8),  -- Funcional     - Florencia Torres

-- ── Sábado 12/07 ─────────────────────────────────────────────────────
(1,  4,  '2026-07-12',  9, 6),  -- Pilates       - Valentina Pérez
(7, 16,  '2026-07-12', 11, 7),  -- Bachata       - Lucía González

-- ── Lunes 14/07 ──────────────────────────────────────────────────────
(3,  9,  '2026-07-14',  8, 8),  -- Funcional     - Tomás Castro
(1, 12,  '2026-07-14', 10, 6),  -- Pilates       - Camila Sánchez
(2,  7,  '2026-07-14', 17, 5),  -- Yoga          - Nicolás Romero
(6, 15,  '2026-07-14', 19, 7),  -- Zumba         - Julieta Vargas

-- ── Martes 15/07 ─────────────────────────────────────────────────────
(5, 10,  '2026-07-15',  9, 6),  -- Spinning      - Martín López
(4,  6,  '2026-07-15', 11, 5),  -- Stretching    - Sebastián Díaz
(1, 14,  '2026-07-15', 18, 6),  -- Pilates       - Micaela Herrera

-- ── Miércoles 16/07 ──────────────────────────────────────────────────
(2, 11,  '2026-07-16',  8, 5),  -- Yoga          - Sofía Martínez
(3,  5,  '2026-07-16', 10, 8),  -- Funcional     - Diego Fernández
(8, 16,  '2026-07-16', 17, 7),  -- Salsa         - Lucía González

-- ── Jueves 17/07 ─────────────────────────────────────────────────────
(1,  8,  '2026-07-17',  9, 6),  -- Pilates       - Agustín Morales
(5, 13,  '2026-07-17', 11, 6),  -- Spinning      - Florencia Torres
(4, 12,  '2026-07-17', 18, 5),  -- Stretching    - Camila Sánchez

-- ── Viernes 18/07 ────────────────────────────────────────────────────
(3,  9,  '2026-07-18',  8, 8),  -- Funcional     - Tomás Castro
(1,  2,  '2026-07-18', 10, 6),  -- Pilates       - Ana García
(6, 15,  '2026-07-18', 17, 7),  -- Zumba         - Julieta Vargas

-- ── Sábado 19/07 ─────────────────────────────────────────────────────
(2, 14,  '2026-07-19',  9, 5),  -- Yoga          - Micaela Herrera
(7, 16,  '2026-07-19', 11, 6),  -- Bachata       - Lucía González

-- ── Lunes 21/07 ──────────────────────────────────────────────────────
(1,  4,  '2026-07-21',  8, 6),  -- Pilates       - Valentina Pérez
(3, 10,  '2026-07-21', 10, 8),  -- Funcional     - Martín López
(2,  7,  '2026-07-21', 17, 5),  -- Yoga          - Nicolás Romero
(8, 16,  '2026-07-21', 19, 7),  -- Salsa         - Lucía González

-- ── Martes 22/07 ─────────────────────────────────────────────────────
(4, 11,  '2026-07-22',  9, 5),  -- Stretching    - Sofía Martínez
(5,  3,  '2026-07-22', 11, 6),  -- Spinning      - Carlos Rodríguez
(1,  8,  '2026-07-22', 18, 6),  -- Pilates       - Agustín Morales

-- ── Miércoles 23/07 ──────────────────────────────────────────────────
(3,  5,  '2026-07-23',  8, 8),  -- Funcional     - Diego Fernández
(2, 14,  '2026-07-23', 10, 5),  -- Yoga          - Micaela Herrera
(6, 15,  '2026-07-23', 17, 7),  -- Zumba         - Julieta Vargas

-- ── Jueves 24/07 ─────────────────────────────────────────────────────
(1, 12,  '2026-07-24',  9, 6),  -- Pilates       - Camila Sánchez
(3, 13,  '2026-07-24', 11, 8),  -- Funcional     - Florencia Torres
(4,  6,  '2026-07-24', 18, 5),  -- Stretching    - Sebastián Díaz

-- ── Viernes 25/07 ────────────────────────────────────────────────────
(1,  2,  '2026-07-25',  8, 6),  -- Pilates       - Ana García
(5, 10,  '2026-07-25', 10, 6),  -- Spinning      - Martín López
(2, 11,  '2026-07-25', 17, 5),  -- Yoga          - Sofía Martínez

-- ── Sábado 26/07 ─────────────────────────────────────────────────────
(3,  9,  '2026-07-26',  9, 8),  -- Funcional     - Tomás Castro
(7, 16,  '2026-07-26', 11, 6),  -- Bachata       - Lucía González

-- ── Lunes 28/07 ──────────────────────────────────────────────────────
(1,  4,  '2026-07-28',  8, 6),  -- Pilates       - Valentina Pérez
(2,  7,  '2026-07-28', 10, 5),  -- Yoga          - Nicolás Romero
(3,  5,  '2026-07-28', 17, 8),  -- Funcional     - Diego Fernández
(6, 16,  '2026-07-28', 19, 7),  -- Zumba         - Lucía González

-- ── Martes 29/07 ─────────────────────────────────────────────────────
(4, 12,  '2026-07-29',  9, 5),  -- Stretching    - Camila Sánchez
(5, 13,  '2026-07-29', 11, 6),  -- Spinning      - Florencia Torres
(1,  8,  '2026-07-29', 18, 6),  -- Pilates       - Agustín Morales

-- ── Miércoles 30/07 ──────────────────────────────────────────────────
(3, 10,  '2026-07-30',  8, 8),  -- Funcional     - Martín López
(1, 14,  '2026-07-30', 10, 6),  -- Pilates       - Micaela Herrera
(8, 15,  '2026-07-30', 17, 7),  -- Salsa         - Julieta Vargas

-- ── Jueves 31/07 ─────────────────────────────────────────────────────
(2, 11,  '2026-07-31',  9, 5),  -- Yoga          - Sofía Martínez
(4,  6,  '2026-07-31', 11, 5),  -- Stretching    - Sebastián Díaz
(3,  9,  '2026-07-31', 18, 8),  -- Funcional     - Tomás Castro

-- ── Sábado 01/08 ─────────────────────────────────────────────────────
(1,  2,  '2026-08-01',  9, 6),  -- Pilates       - Ana García
(6, 16,  '2026-08-01', 11, 7),  -- Zumba         - Lucía González

-- ── Lunes 03/08 ──────────────────────────────────────────────────────
(2, 14,  '2026-08-03',  8, 5),  -- Yoga          - Micaela Herrera
(3,  5,  '2026-08-03', 10, 8),  -- Funcional     - Diego Fernández
(1, 12,  '2026-08-03', 17, 6),  -- Pilates       - Camila Sánchez
(7, 16,  '2026-08-03', 19, 6),  -- Bachata       - Lucía González

-- ── Martes 04/08 ─────────────────────────────────────────────────────
(5,  3,  '2026-08-04',  9, 6),  -- Spinning      - Carlos Rodríguez
(1,  4,  '2026-08-04', 11, 6),  -- Pilates       - Valentina Pérez
(4, 11,  '2026-08-04', 18, 5),  -- Stretching    - Sofía Martínez

-- ── Miércoles 05/08 ──────────────────────────────────────────────────
(3, 13,  '2026-08-05',  8, 8),  -- Funcional     - Florencia Torres
(2,  7,  '2026-08-05', 10, 5),  -- Yoga          - Nicolás Romero
(1,  8,  '2026-08-05', 17, 6),  -- Pilates       - Agustín Morales

-- ── Jueves 06/08 ─────────────────────────────────────────────────────
(4,  6,  '2026-08-06',  9, 5),  -- Stretching    - Sebastián Díaz
(5, 10,  '2026-08-06', 11, 6),  -- Spinning      - Martín López
(3,  9,  '2026-08-06', 18, 8),  -- Funcional     - Tomás Castro

-- ── Viernes 07/08 ────────────────────────────────────────────────────
(1,  2,  '2026-08-07',  8, 6),  -- Pilates       - Ana García
(2, 14,  '2026-08-07', 10, 5),  -- Yoga          - Micaela Herrera
(6, 15,  '2026-08-07', 17, 7),  -- Zumba         - Julieta Vargas

-- ── Sábado 08/08 ─────────────────────────────────────────────────────
(3,  5,  '2026-08-08',  9, 8),  -- Funcional     - Diego Fernández
(8, 16,  '2026-08-08', 11, 7),  -- Salsa         - Lucía González

-- ── Lunes 10/08 ──────────────────────────────────────────────────────
(1,  4,  '2026-08-10',  8, 6),  -- Pilates       - Valentina Pérez
(3, 10,  '2026-08-10', 10, 8),  -- Funcional     - Martín López
(2, 11,  '2026-08-10', 17, 5),  -- Yoga          - Sofía Martínez
(6, 16,  '2026-08-10', 19, 7);  -- Zumba         - Lucía González

GO


-- =============================================
-- SUSCRIPCIONES
-- Alumnos 17-34 → suscripción JUNIO (vigente)
-- Alumnos 35-41 → suscripción MAYO  (vencida, no renovaron)
-- FechaUltimaActualizacion = primer día del mes del plan
-- =============================================

INSERT INTO Suscripciones (IdUsuario, IdPlan, FechaInicio, FechaFin, ClasesConsumidas, FechaUltimaActualizacion)
VALUES
-- ── Junio (01/06 – 30/06) ─────────────────────────────────────────────
(17, 2, '2026-06-01', '2026-06-30',  6, '2026-06-01'),  -- Luciana Fdez    Pack 8
(18, 1, '2026-06-01', '2026-06-30',  3, '2026-06-01'),  -- Mateo García    Pack 4
(19, 3, '2026-06-01', '2026-06-30',  8, '2026-06-01'),  -- Camila López    Pack 12
(20, 4, '2026-06-01', '2026-06-30', 11, '2026-06-01'),  -- Facundo Mart    Pase Libre
(21, 2, '2026-06-01', '2026-06-30',  5, '2026-06-01'),  -- Valentina Rod   Pack 8
(22, 1, '2026-06-01', '2026-06-30',  2, '2026-06-01'),  -- Ignacio Pérez   Pack 4
(23, 3, '2026-06-01', '2026-06-30',  9, '2026-06-01'),  -- Florencia Gon   Pack 12
(24, 4, '2026-06-01', '2026-06-30', 10, '2026-06-01'),  -- Tobías Sánch    Pase Libre
(25, 2, '2026-06-01', '2026-06-30',  4, '2026-06-01'),  -- Martina Rome    Pack 8
(26, 1, '2026-06-01', '2026-06-30',  4, '2026-06-01'),  -- Bruno Torres    Pack 4 (agotado)
(27, 3, '2026-06-01', '2026-06-30',  7, '2026-06-01'),  -- Agustina Díaz   Pack 12
(28, 2, '2026-06-01', '2026-06-30',  3, '2026-06-01'),  -- Santiago Mor    Pack 8
(29, 4, '2026-06-01', '2026-06-30', 13, '2026-06-01'),  -- Julieta Herr    Pase Libre
(30, 1, '2026-06-01', '2026-06-30',  1, '2026-06-01'),  -- Nicolás Cast    Pack 4
(31, 3, '2026-06-01', '2026-06-30',  6, '2026-06-01'),  -- Antonella Var   Pack 12
(32, 2, '2026-06-01', '2026-06-30',  5, '2026-06-01'),  -- Emiliano Ruiz   Pack 8
(33, 1, '2026-06-01', '2026-06-30',  3, '2026-06-01'),  -- Sofía Medina    Pack 4
(34, 3, '2026-06-01', '2026-06-30', 10, '2026-06-01'),  -- Lautaro Jimén   Pack 12

-- ── Mayo (01/05 – 31/05), vencidas ────────────────────────────────────
(35, 1, '2026-05-01', '2026-05-31',  4, '2026-05-01'),  -- Rocío Suárez    Pack 4  (usó las 4)
(36, 2, '2026-05-01', '2026-05-31',  7, '2026-05-01'),  -- Tomás Álvarez   Pack 8
(37, 1, '2026-05-01', '2026-05-31',  3, '2026-05-01'),  -- Milagros Ramos  Pack 4
(38, 3, '2026-05-01', '2026-05-31',  9, '2026-05-01'),  -- Ezequiel Mol    Pack 12
(39, 4, '2026-05-01', '2026-05-31', 12, '2026-05-01'),  -- Pilar Ortega    Pase Libre
(40, 2, '2026-05-01', '2026-05-31',  6, '2026-05-01'),  -- Maximiliano S   Pack 8
(41, 1, '2026-05-01', '2026-05-31',  4, '2026-05-01');  -- Catalina Reyes  Pack 4  (usó las 4)

GO


-- =============================================
-- HISTORIAL SUSCRIPCIONES
-- TipoMovimiento: 1 = ALTA, 2 = ACTUALIZACIÓN
-- Alumnos 17, 18, 19, 20, 21, 22, 25, 27
--   → tuvieron suscripción en MAYO y renovaron en JUNIO
-- Alumnos 23, 24, 26, 28, 29, 30, 31, 32, 33, 34
--   → se dieron de alta directamente en JUNIO
-- Alumnos 35-41 → solo MAYO
-- =============================================

INSERT INTO HistorialSuscripciones (IdUsuario, IdPlan, FechaInicio, FechaFin, FechaRegistro, TipoMovimiento)
VALUES
-- ── Alumnos con Mayo + Junio ──────────────────────────────────────────
(17, 2, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Luciana    ALTA mayo
(17, 2, '2026-06-01', '2026-06-30', '2026-06-01', 2),  -- Luciana    ACTUALIZACIÓN junio

(18, 1, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Mateo      ALTA mayo
(18, 1, '2026-06-01', '2026-06-30', '2026-06-01', 2),  -- Mateo      ACTUALIZACIÓN junio

(19, 3, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Camila     ALTA mayo
(19, 3, '2026-06-01', '2026-06-30', '2026-06-01', 2),  -- Camila     ACTUALIZACIÓN junio

(20, 4, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Facundo    ALTA mayo
(20, 4, '2026-06-01', '2026-06-30', '2026-06-01', 2),  -- Facundo    ACTUALIZACIÓN junio

(21, 2, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Valentina  ALTA mayo
(21, 2, '2026-06-01', '2026-06-30', '2026-06-01', 2),  -- Valentina  ACTUALIZACIÓN junio

(22, 1, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Ignacio    ALTA mayo
(22, 1, '2026-06-01', '2026-06-30', '2026-06-01', 2),  -- Ignacio    ACTUALIZACIÓN junio

(25, 2, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Martina    ALTA mayo
(25, 2, '2026-06-01', '2026-06-30', '2026-06-01', 2),  -- Martina    ACTUALIZACIÓN junio

(27, 3, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Agustina   ALTA mayo
(27, 3, '2026-06-01', '2026-06-30', '2026-06-01', 2),  -- Agustina   ACTUALIZACIÓN junio

-- ── Alumnos solo Junio ────────────────────────────────────────────────
(23, 3, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Florencia  ALTA junio
(24, 4, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Tobías     ALTA junio
(26, 1, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Bruno      ALTA junio
(28, 2, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Santiago   ALTA junio
(29, 4, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Julieta    ALTA junio
(30, 1, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Nicolás    ALTA junio
(31, 3, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Antonella  ALTA junio
(32, 2, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Emiliano   ALTA junio
(33, 1, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Sofía      ALTA junio
(34, 3, '2026-06-01', '2026-06-30', '2026-06-01', 1),  -- Lautaro    ALTA junio

-- ── Alumnos solo Mayo (vencidos) ──────────────────────────────────────
(35, 1, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Rocío      ALTA mayo
(36, 2, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Tomás      ALTA mayo
(37, 1, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Milagros   ALTA mayo
(38, 3, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Ezequiel   ALTA mayo
(39, 4, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Pilar      ALTA mayo
(40, 2, '2026-05-01', '2026-05-31', '2026-05-01', 1),  -- Maximiliano ALTA mayo
(41, 1, '2026-05-01', '2026-05-31', '2026-05-01', 1);  -- Catalina   ALTA mayo

GO


-- =============================================
-- RESERVAS
-- Solo alumnos con suscripción vigente (17-34)
-- Estado 1 = Vigente
-- Asistencia NULL (todas las clases son futuras)
-- Se referencian clases por Fecha+HoraInicio
--   (combinación única por restricción de salón)
-- Algunos registros incluyen observaciones
--   para alumnos con condiciones físicas
-- =============================================

-- ── Lunes 29/06 – Pilates 08h ─────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 17, 1, NULL, NULL                                              FROM Clases WHERE Fecha='2026-06-29' AND HoraInicio=8;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 18, 1, NULL, 'Lesión en rodilla derecha, trabajar con modificaciones'  FROM Clases WHERE Fecha='2026-06-29' AND HoraInicio=8;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 19, 1, NULL, NULL                                              FROM Clases WHERE Fecha='2026-06-29' AND HoraInicio=8;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 21, 1, NULL, NULL                                              FROM Clases WHERE Fecha='2026-06-29' AND HoraInicio=8;

-- ── Lunes 29/06 – Yoga 10h ────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 20, 1, NULL, 'Asmático, lleva inhalador'                       FROM Clases WHERE Fecha='2026-06-29' AND HoraInicio=10;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 23, 1, NULL, NULL                                              FROM Clases WHERE Fecha='2026-06-29' AND HoraInicio=10;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 25, 1, NULL, 'Hipertensión controlada, monitorear esfuerzo'    FROM Clases WHERE Fecha='2026-06-29' AND HoraInicio=10;

-- ── Lunes 29/06 – Funcional 17h ───────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 24, 1, NULL, NULL                                              FROM Clases WHERE Fecha='2026-06-29' AND HoraInicio=17;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 26, 1, NULL, NULL                                              FROM Clases WHERE Fecha='2026-06-29' AND HoraInicio=17;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 28, 1, NULL, NULL                                              FROM Clases WHERE Fecha='2026-06-29' AND HoraInicio=17;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 30, 1, NULL, NULL                                              FROM Clases WHERE Fecha='2026-06-29' AND HoraInicio=17;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 32, 1, NULL, 'Fractura de tobillo en recuperación, sin saltos' FROM Clases WHERE Fecha='2026-06-29' AND HoraInicio=17;

-- ── Lunes 29/06 – Zumba 19h ───────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 22, 1, NULL, 'Operado de espalda, evitar impacto'              FROM Clases WHERE Fecha='2026-06-29' AND HoraInicio=19;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 27, 1, NULL, 'Tendinitis en hombro izquierdo'                  FROM Clases WHERE Fecha='2026-06-29' AND HoraInicio=19;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 29, 1, NULL, 'Diabetes tipo 2, tiene glucómetro'               FROM Clases WHERE Fecha='2026-06-29' AND HoraInicio=19;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 31, 1, NULL, NULL                                              FROM Clases WHERE Fecha='2026-06-29' AND HoraInicio=19;

-- ── Martes 30/06 – Spinning 9h ────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 17, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-06-30' AND HoraInicio=9;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 19, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-06-30' AND HoraInicio=9;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 33, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-06-30' AND HoraInicio=9;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 34, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-06-30' AND HoraInicio=9;

-- ── Martes 30/06 – Stretching 11h ─────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 21, 1, NULL, NULL                                              FROM Clases WHERE Fecha='2026-06-30' AND HoraInicio=11;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 25, 1, NULL, NULL                                              FROM Clases WHERE Fecha='2026-06-30' AND HoraInicio=11;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 28, 1, NULL, NULL                                              FROM Clases WHERE Fecha='2026-06-30' AND HoraInicio=11;

-- ── Martes 30/06 – Pilates 18h ────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 20, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-06-30' AND HoraInicio=18;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 23, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-06-30' AND HoraInicio=18;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 26, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-06-30' AND HoraInicio=18;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 30, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-06-30' AND HoraInicio=18;

-- ── Miércoles 01/07 – Funcional 8h ────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 18, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-01' AND HoraInicio=8;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 22, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-01' AND HoraInicio=8;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 27, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-01' AND HoraInicio=8;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 31, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-01' AND HoraInicio=8;

-- ── Miércoles 01/07 – Pilates 10h ─────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 17, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-01' AND HoraInicio=10;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 24, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-01' AND HoraInicio=10;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 29, 1, NULL, 'Diabetes tipo 2, tiene glucómetro' FROM Clases WHERE Fecha='2026-07-01' AND HoraInicio=10;

-- ── Miércoles 01/07 – Yoga 17h ────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 19, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-01' AND HoraInicio=17;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 32, 1, NULL, 'En recuperación de fractura de tobillo' FROM Clases WHERE Fecha='2026-07-01' AND HoraInicio=17;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 33, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-01' AND HoraInicio=17;

-- ── Jueves 02/07 – Stretching 9h ──────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 17, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-02' AND HoraInicio=9;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 20, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-02' AND HoraInicio=9;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 34, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-02' AND HoraInicio=9;

-- ── Jueves 02/07 – Funcional 18h ──────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 21, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-02' AND HoraInicio=18;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 23, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-02' AND HoraInicio=18;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 25, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-02' AND HoraInicio=18;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 28, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-02' AND HoraInicio=18;

-- ── Viernes 03/07 – Pilates 8h ────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 19, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-03' AND HoraInicio=8;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 22, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-03' AND HoraInicio=8;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 26, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-03' AND HoraInicio=8;

-- ── Sábado 04/07 – Yoga 9h ────────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 18, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-04' AND HoraInicio=9;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 24, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-04' AND HoraInicio=9;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 27, 1, NULL, 'Tendinitis hombro izq., solo elongación suave' FROM Clases WHERE Fecha='2026-07-04' AND HoraInicio=9;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 30, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-04' AND HoraInicio=9;

-- ── Lunes 07/07 – Pilates 8h ──────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 17, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-07' AND HoraInicio=8;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 29, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-07' AND HoraInicio=8;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 31, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-07' AND HoraInicio=8;

-- ── Lunes 07/07 – Funcional 10h ───────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 20, 1, NULL, 'Asmático, lleva inhalador' FROM Clases WHERE Fecha='2026-07-07' AND HoraInicio=10;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 23, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-07' AND HoraInicio=10;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 33, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-07' AND HoraInicio=10;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 34, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-07' AND HoraInicio=10;

-- ── Martes 08/07 – Pilates 11h ────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 21, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-08' AND HoraInicio=11;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 25, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-08' AND HoraInicio=11;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 32, 1, NULL, 'Fractura tobillo, evitar impacto' FROM Clases WHERE Fecha='2026-07-08' AND HoraInicio=11;

-- ── Miércoles 09/07 – Yoga 8h ─────────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 19, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-09' AND HoraInicio=8;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 22, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-09' AND HoraInicio=8;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 26, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-09' AND HoraInicio=8;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 28, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-09' AND HoraInicio=8;

-- ── Jueves 10/07 – Stretching 9h ──────────────────────────────────────
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 17, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-10' AND HoraInicio=9;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 24, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-10' AND HoraInicio=9;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 29, 1, NULL, 'Diabetes tipo 2, tiene glucómetro' FROM Clases WHERE Fecha='2026-07-10' AND HoraInicio=9;
INSERT INTO Reservas (IdClase, IdAlumno, Estado, Asistencia, Observaciones)
SELECT IdClase, 30, 1, NULL, NULL  FROM Clases WHERE Fecha='2026-07-10' AND HoraInicio=9;

GO
