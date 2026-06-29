using Acceso_Datos;
using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class ReservaNegocio
    {
        public List<Reserva> listar()
        {
            List<Reserva> lista = new List<Reserva>();
            AccesoDatos datos = new AccesoDatos();

            try
            {

                datos.setearConsulta(
                    "SELECT R.IdReserva, R.FechaReserva, R.Estado, R.Asistencia, R.Observaciones, " +
                    "C.IdClase, C.Fecha, C.HoraInicio, C.CupoMaximo, " +
                    "D.IdDisciplina, D.Nombre AS NombreDisciplina, " +
                    "U.IdUsuario AS IdAlumno, U.Nombre AS NombreAlumno, U.Apellido AS ApellidoAlumno, U.DNI, U.Email AS EmailAlumno, " +
                    "U2.IdUsuario AS IdInstructor, U2.Nombre AS NombreInstructor, U2.Apellido AS ApellidoInstructor " +
                    "FROM Reservas R " +
                    "INNER JOIN Clases C ON R.IdClase = C.IdClase " +
                    "INNER JOIN Disciplinas D ON C.IdDisciplina = D.IdDisciplina " +
                    "INNER JOIN Usuarios U ON R.IdAlumno = U.IdUsuario " +
                    "INNER JOIN Usuarios U2 ON C.IdInstructor = U2.IdUsuario " +
                    "ORDER BY C.Fecha DESC, C.HoraInicio DESC");

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Reserva res = new Reserva();

                    res.IdReserva = (int)datos.Lector["IdReserva"];
                    res.FechaReserva = (DateTime)datos.Lector["FechaReserva"];


                    res.Estado = (Estado)(int)datos.Lector["Estado"];


                    res.Asistencia = datos.Lector["Asistencia"] == DBNull.Value ? (EstadoAsistencia?)null : (EstadoAsistencia)(int)datos.Lector["Asistencia"];
                    res.Observaciones = datos.Lector["Observaciones"] == DBNull.Value ? "" : (string)datos.Lector["Observaciones"];


                    res.Clase = new Clase();
                    res.Clase.IdClase = (int)datos.Lector["IdClase"];
                    res.Clase.Fecha = (DateTime)datos.Lector["Fecha"];
                    res.Clase.HoraInicio = (int)datos.Lector["HoraInicio"];
                    res.Clase.CupoMaximo = (int)datos.Lector["CupoMaximo"];
                    res.Clase.Instructor = new Instructor();
                    res.Clase.Instructor.IdUsuario = (int)datos.Lector["IdInstructor"];
                    res.Clase.Instructor.Nombre = (string)datos.Lector["NombreInstructor"];
                    res.Clase.Instructor.Apellido = (string)datos.Lector["ApellidoInstructor"];

                    res.Clase.Disciplina = new Disciplina();
                    res.Clase.Disciplina.IdDisciplina = (int)datos.Lector["IdDisciplina"];
                    res.Clase.Disciplina.Nombre = (string)datos.Lector["NombreDisciplina"];


                    res.Alumno = new Alumno();
                    res.Alumno.IdUsuario = (int)datos.Lector["IdAlumno"];
                    res.Alumno.Nombre = (string)datos.Lector["NombreAlumno"];
                    res.Alumno.Apellido = (string)datos.Lector["ApellidoAlumno"];
                    res.Alumno.DNI = (string)datos.Lector["DNI"];
                    res.Alumno.Email = (string)datos.Lector["EmailAlumno"];

                    lista.Add(res);
                }

                return lista;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public List<Reserva> listarPorAlumno(int idAlumno)
        {
            List<Reserva> lista = new List<Reserva>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT R.IdReserva, R.FechaReserva, R.Estado, " +
                    "R.Asistencia, R.Observaciones, C.IdClase, C.Fecha, C.HoraInicio, C.CupoMaximo, " +
                    "D.IdDisciplina, D.Nombre AS NombreDisciplina, U.IdUsuario, " +
                    "U.Nombre AS NombreAlumno, U.Apellido AS ApellidoAlumno " +
                    "FROM Reservas R " +
                    "INNER JOIN Clases C ON R.IdClase = C.IdClase " +
                    "INNER JOIN Disciplinas D ON C.IdDisciplina = D.IdDisciplina " +
                    "INNER JOIN Usuarios U ON R.IdAlumno = U.IdUsuario " +
                    "WHERE R.IdAlumno = @IdAlumno " +
                    "ORDER BY C.Fecha DESC, C.HoraInicio DESC"
                );

                datos.setearParametro("@IdAlumno", idAlumno);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Reserva res = new Reserva();

                    res.IdReserva = (int)datos.Lector["IdReserva"];
                    res.FechaReserva = (DateTime)datos.Lector["FechaReserva"];
                    res.Estado = (Estado)(int)datos.Lector["Estado"];
                    res.Asistencia = datos.Lector["Asistencia"] == DBNull.Value ? (EstadoAsistencia?)null : (EstadoAsistencia)(int)datos.Lector["Asistencia"];
                    res.Observaciones = datos.Lector["Observaciones"] == DBNull.Value ? "" : (string)datos.Lector["Observaciones"];

                    res.Clase = new Clase();
                    res.Clase.IdClase = (int)datos.Lector["IdClase"];
                    res.Clase.Fecha = (DateTime)datos.Lector["Fecha"];
                    res.Clase.HoraInicio = (int)datos.Lector["HoraInicio"];
                    res.Clase.CupoMaximo = (int)datos.Lector["CupoMaximo"];

                    res.Clase.Disciplina = new Disciplina();
                    res.Clase.Disciplina.IdDisciplina = (int)datos.Lector["IdDisciplina"];
                    res.Clase.Disciplina.Nombre = (string)datos.Lector["NombreDisciplina"];

                    res.Alumno = new Alumno();
                    res.Alumno.IdUsuario = (int)datos.Lector["IdUsuario"];
                    res.Alumno.Nombre = (string)datos.Lector["NombreAlumno"];
                    res.Alumno.Apellido = (string)datos.Lector["ApellidoAlumno"];

                    lista.Add(res);
                }

                return lista;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void agregar(Reserva reservaNueva, bool validarAnticipacion)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                SuscripcionNegocio suscripcionNegocio = new SuscripcionNegocio();
                Suscripcion suscripcion = suscripcionNegocio.obtenerSuscripcionActualUsuario(reservaNueva.Alumno.IdUsuario);

                if (suscripcion == null)
                    throw new Exception("El alumno no posee una suscripción activa. Debe dar de alta un plan en recepción.");

                if (!suscripcion.EstaVigente(DateTime.Now))
                    throw new Exception("La suscripción se encuentra vencida. Debe actualizar su plan en recepción.");

                ClaseNegocio claseNegocio = new ClaseNegocio();
                Clase clase = claseNegocio.obtenerPorId(reservaNueva.Clase.IdClase);

                if (clase == null)
                    throw new Exception("La clase seleccionada no existe.");

                DateTime fechaHoraClase = clase.Fecha.Date.AddHours(clase.HoraInicio);

                if (fechaHoraClase <= DateTime.Now)
                    throw new Exception("No se puede reservar una clase que ya comenzó.");

                if (validarAnticipacion && fechaHoraClase <= DateTime.Now.AddHours(1))
                    throw new Exception("La reserva debe realizarse con al menos 1 hora de anticipación.");

                DateTime fechaClase = clase.Fecha.Date;
                DateTime inicioSuscripcion = suscripcion.FechaInicio.Date;
                DateTime finSuscripcionConGracia = suscripcion.FechaFin.Date.AddDays(5);

                if (fechaClase < inicioSuscripcion || fechaClase > finSuscripcionConGracia)
                    throw new Exception("La clase seleccionada no corresponde al período de la suscripción vigente.");

                if (suscripcion.Plan.CantidadClases.HasValue)
                {
                    if (suscripcion.ClasesConsumidas >= suscripcion.Plan.CantidadClases.Value)
                        throw new Exception("Ya se consumieron todas las clases disponibles en su plan.");
                }

                datos.setearConsulta("SELECT Estado FROM Reservas WHERE IdAlumno = @IdAlumno AND IdClase = @IdClase");
                datos.setearParametro("@IdAlumno", reservaNueva.Alumno.IdUsuario);
                datos.setearParametro("@IdClase", reservaNueva.Clase.IdClase);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    int estado = (int)datos.Lector["Estado"];

                    if (estado == 1)
                        throw new Exception("Ya estás inscripto en esta clase.");

                    if (estado == 2)
                    {
                        validarCupoDisponible(reservaNueva.Clase.IdClase);
                        reactivar(reservaNueva.Alumno.IdUsuario, reservaNueva.Clase.IdClase);
                        return;
                    }

                    if (estado == 3)
                        throw new Exception("Ya participaste de esta clase.");

                    if (estado == 4)
                        throw new Exception("Ya tuviste una reserva reprogramada para esta clase. Elegí otra clase disponible.");

                    throw new Exception("Ya existe una reserva previa para esta clase.");
                }

                datos.cerrarConexion();

                validarCupoDisponible(reservaNueva.Clase.IdClase);

                datos = new AccesoDatos();
                datos.setearConsulta("INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistencia, Observaciones) " +
                                     "VALUES (@IdClase, @IdAlumno, GETDATE(), 1, NULL, @Observaciones)");

                datos.setearParametro("@IdClase", reservaNueva.Clase.IdClase);
                datos.setearParametro("@IdAlumno", reservaNueva.Alumno.IdUsuario);
                datos.setearParametro("@Observaciones", string.IsNullOrWhiteSpace(reservaNueva.Observaciones) ? (object)DBNull.Value : reservaNueva.Observaciones);
                datos.ejecutarAccion();

                suscripcionNegocio.incrementarClasesConsumidas(reservaNueva.Alumno.IdUsuario);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void modificar(Reserva reservaModificada)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {

                datos.setearConsulta(
                    "UPDATE Reservas SET Estado = @Estado, Asistencia = @Asistencia, Observaciones = @Observaciones " +
                    "WHERE IdReserva = @IdReserva");

                datos.setearParametro("@Estado", (int)reservaModificada.Estado);

                datos.setearParametro("@Asistencia", reservaModificada.Asistencia.HasValue ? (object)(int)reservaModificada.Asistencia.Value : DBNull.Value);
                datos.setearParametro("@Observaciones", string.IsNullOrWhiteSpace(reservaModificada.Observaciones) ? (object)DBNull.Value : reservaModificada.Observaciones.Trim());
                datos.setearParametro("@IdReserva", reservaModificada.IdReserva);

                datos.ejecutarAccion();

                sincronizarHistorialInasistencia(reservaModificada.IdReserva, reservaModificada.Asistencia);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        public void cancelar(int idReserva, bool validarAnticipacion, TipoCancelacion tipoCancelacion)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT R.IdAlumno, R.Estado, C.Fecha, C.HoraInicio FROM Reservas R " +
                    "INNER JOIN Clases C ON C.IdClase = R.IdClase WHERE R.IdReserva = @IdReserva");
                datos.setearParametro("@IdReserva", idReserva);
                datos.ejecutarLectura();

                if (!datos.Lector.Read())
                    throw new Exception("Reserva no encontrada.");

                int idAlumno = (int)datos.Lector["IdAlumno"];
                DateTime fechaClase = (DateTime)datos.Lector["Fecha"];
                int horaInicio = (int)datos.Lector["HoraInicio"];
                Estado estadoReserva = (Estado)(int)datos.Lector["Estado"];

                if (estadoReserva != Estado.Vigente)
                    throw new Exception("Solo se pueden cancelar reservas vigentes.");

                DateTime fechaHoraClase = fechaClase.Date.AddHours(horaInicio);

                if (validarAnticipacion && fechaHoraClase <= DateTime.Now.AddHours(24))
                    throw new Exception("La reserva solo puede cancelarse con al menos 24 horas de anticipación.");

                datos.cerrarConexion();

                datos = new AccesoDatos();
                datos.setearConsulta("UPDATE Reservas SET Estado = 2 WHERE IdReserva = @IdReserva");
                datos.setearParametro("@IdReserva", idReserva);
                datos.ejecutarAccion();

                sincronizarHistorialInasistencia(idReserva, null);

                registrarHistorialCancelacion(
                        idReserva,
                        idAlumno,
                        fechaClase,
                        (int)tipoCancelacion,
                                           "");
                SuscripcionNegocio suscripcionNegocio = new SuscripcionNegocio();
                suscripcionNegocio.disminuirClasesConsumidas(idAlumno);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        public void cancelar(int idReserva, bool validarAnticipacion)
        {
            cancelar(idReserva, validarAnticipacion, TipoCancelacion.CentroFitness);
        }

        public void reactivar(int idAlumno, int idClase)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Reservas SET Estado = 1, FechaReserva = GETDATE() " +
                    "WHERE IdAlumno = @IdAlumno AND IdClase = @IdClase"
                );

                datos.setearParametro("@IdAlumno", idAlumno);
                datos.setearParametro("@IdClase", idClase);

                datos.ejecutarAccion();

                SuscripcionNegocio suscripcionNegocio = new SuscripcionNegocio();
                suscripcionNegocio.incrementarClasesConsumidas(idAlumno);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public bool existeReserva(int idAlumno, int idClase)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {

                datos.setearConsulta("SELECT 1 FROM Reservas WHERE IdAlumno = @IdAlumno AND IdClase = @IdClase AND Estado = 1");
                datos.setearParametro("@IdAlumno", idAlumno);
                datos.setearParametro("@IdClase", idClase);

                datos.ejecutarLectura();

                return datos.Lector.Read();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public List<Reserva> listarVigentesPorInstructor(int idInstructor)
        {
            List<Reserva> lista = new List<Reserva>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "SELECT R.IdReserva, R.FechaReserva, R.Estado, R.Asistencia, R.Observaciones, " +
                    "C.IdClase, C.Fecha, C.HoraInicio, C.CupoMaximo, " +
                    "D.IdDisciplina, D.Nombre AS NombreDisciplina, " +
                    "A.IdUsuario AS IdAlumno, A.Nombre AS NombreAlumno, A.Apellido AS ApellidoAlumno " +
                    "FROM Reservas R " +
                    "INNER JOIN Clases C ON R.IdClase = C.IdClase " +
                    "INNER JOIN Disciplinas D ON C.IdDisciplina = D.IdDisciplina " +
                    "INNER JOIN Usuarios A ON R.IdAlumno = A.IdUsuario " +
                    "WHERE C.IdInstructor = @IdInstructor AND R.Estado = 1 AND C.Estado = 1 " +
                    "ORDER BY C.Fecha, C.HoraInicio, D.Nombre, A.Apellido");

                datos.setearParametro("@IdInstructor", idInstructor);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Reserva res = new Reserva();

                    res.IdReserva = (int)datos.Lector["IdReserva"];
                    res.FechaReserva = (DateTime)datos.Lector["FechaReserva"];
                    res.Estado = (Estado)(int)datos.Lector["Estado"];
                    res.Asistencia = datos.Lector["Asistencia"] == DBNull.Value ? (EstadoAsistencia?)null : (EstadoAsistencia)(int)datos.Lector["Asistencia"];
                    res.Observaciones = datos.Lector["Observaciones"] == DBNull.Value ? "" : (string)datos.Lector["Observaciones"];

                    res.Clase = new Clase();
                    res.Clase.IdClase = (int)datos.Lector["IdClase"];
                    res.Clase.Fecha = (DateTime)datos.Lector["Fecha"];
                    res.Clase.HoraInicio = (int)datos.Lector["HoraInicio"];
                    res.Clase.CupoMaximo = (int)datos.Lector["CupoMaximo"];

                    res.Clase.Disciplina = new Disciplina();
                    res.Clase.Disciplina.IdDisciplina = (int)datos.Lector["IdDisciplina"];
                    res.Clase.Disciplina.Nombre = (string)datos.Lector["NombreDisciplina"];

                    res.Alumno = new Alumno();
                    res.Alumno.IdUsuario = (int)datos.Lector["IdAlumno"];
                    res.Alumno.Nombre = (string)datos.Lector["NombreAlumno"];
                    res.Alumno.Apellido = (string)datos.Lector["ApellidoAlumno"];

                    lista.Add(res);
                }

                return lista;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void actualizarAsistencia(int idReserva, EstadoAsistencia asistencia, string observaciones)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "UPDATE Reservas SET Asistencia = @Asistencia, Observaciones = @Observaciones, " +
                    "Estado = @Estado WHERE IdReserva = @IdReserva");

                datos.setearParametro("@Asistencia", (int)asistencia);
                datos.setearParametro("@Observaciones", string.IsNullOrWhiteSpace(observaciones) ? (object)DBNull.Value : observaciones);
                datos.setearParametro("@Estado", (int)Estado.Finalizada);
                datos.setearParametro("@IdReserva", idReserva);

                datos.ejecutarAccion();

                sincronizarHistorialInasistencia(idReserva, asistencia);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public int contarReservasVigentes(int idClase)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT COUNT(*) FROM Reservas " +
                    "WHERE IdClase = @IdClase AND Estado = 1 ");
                datos.setearParametro("@IdClase", idClase);
                return datos.ejecutarAccionScalar();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        private void validarCupoDisponible(int idClase)
        {
            ClaseNegocio claseNegocio = new ClaseNegocio();
            Clase clase = claseNegocio.obtenerPorId(idClase);
            int reservasVigentes = contarReservasVigentes(idClase);
            if (reservasVigentes >= clase.CupoMaximo)
                throw new Exception("No hay cupos disponibles para esta clase.");
        }

        private void marcarReservaReprogramada(int idReserva)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "UPDATE Reservas " +
                    "SET Estado = @Estado, Asistencia = NULL " +
                    "WHERE IdReserva = @IdReserva");

                datos.setearParametro("@Estado", (int)Estado.Reprogramada);
                datos.setearParametro("@IdReserva", idReserva);

                datos.ejecutarAccion();

                sincronizarHistorialInasistencia(idReserva, null);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }


        public void reprogramar(int idReserva, int idClaseNueva)
        {
            Reserva reserva = listar().Find(x => x.IdReserva == idReserva);

            if (reserva == null)
                throw new Exception("No se encontró la reserva.");

            if (reserva.Estado != Estado.Vigente)
                throw new Exception("Solo se pueden reprogramar reservas vigentes.");

            if (existeReserva(reserva.Alumno.IdUsuario, idClaseNueva))
                throw new Exception("El alumno ya tiene una reserva vigente para esa clase.");
            DateTime fechaHoraClase = reserva.Clase.Fecha.AddHours(reserva.Clase.HoraInicio);

            if (DateTime.Now >= fechaHoraClase.AddHours(-24))
                throw new Exception("La reserva solo puede reprogramarse con al menos 24 horas de anticipación al inicio de la clase.");

            ClaseNegocio claseNegocio = new ClaseNegocio();
            Clase claseNueva = claseNegocio.obtenerPorId(idClaseNueva);

            if (claseNueva == null)
                throw new Exception("La clase nueva no existe.");

            if (claseNueva.Estado != EstadoClase.Vigente)
                throw new Exception("La clase nueva no se encuentra vigente.");

            validarCupoDisponible(idClaseNueva);

            SuscripcionNegocio suscripcionNegocio = new SuscripcionNegocio();
            suscripcionNegocio.validarClaseDentroDeSuscripcion(reserva.Alumno.IdUsuario, claseNueva);

            Reserva nueva = new Reserva();
            nueva.Alumno = reserva.Alumno;
            nueva.Clase = new Clase();
            nueva.Clase.IdClase = idClaseNueva;
            nueva.Observaciones = reserva.Observaciones;

            marcarReservaReprogramada(idReserva);
            suscripcionNegocio.disminuirClasesConsumidas(reserva.Alumno.IdUsuario);

            agregar(nueva, false);
        }


        public List<Reserva> listarVigentesPorClase(int idClase)
        {
            List<Reserva> lista = new List<Reserva>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "SELECT R.IdReserva, R.FechaReserva, R.Estado, " +
                    "U.IdUsuario AS IdAlumno, U.Nombre AS NombreAlumno, " +
                    "U.Apellido AS ApellidoAlumno, U.Email " +
                    "FROM Reservas R " +
                    "INNER JOIN Usuarios U ON R.IdAlumno = U.IdUsuario " +
                    "WHERE R.IdClase = @IdClase " +
                    "AND R.Estado = 1 ");

                datos.setearParametro("@IdClase", idClase);

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Reserva reserva = new Reserva();

                    reserva.IdReserva = (int)datos.Lector["IdReserva"];
                    reserva.FechaReserva = (DateTime)datos.Lector["FechaReserva"];
                    reserva.Estado = (Estado)(int)datos.Lector["Estado"];

                    reserva.Alumno = new Alumno();
                    reserva.Alumno.IdUsuario = (int)datos.Lector["IdAlumno"];
                    reserva.Alumno.Nombre = (string)datos.Lector["NombreAlumno"];
                    reserva.Alumno.Apellido = (string)datos.Lector["ApellidoAlumno"];
                    reserva.Alumno.Email = (string)datos.Lector["Email"];

                    lista.Add(reserva);
                }

                return lista;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void cancelarClasePorCentroFitness(int idClase)
        {
            List<Reserva> reservas = listarVigentesPorClase(idClase);
            ClaseNegocio claseNegocio = new ClaseNegocio();
            Clase clase = claseNegocio.obtenerPorId(idClase);

            foreach (Reserva reserva in reservas)
            {
                cancelar(reserva.IdReserva, false, TipoCancelacion.CentroFitness);

                EmailService email = new EmailService();


                string cuerpo = @"<h2>Clase cancelada</h2>
                <p>La siguiente clase fue cancelada por Centro Fitness:</p>

                <ul>
                <li><strong>Disciplina:</strong> " + clase.Disciplina.Nombre + @"</li>
                <li><strong>Fecha:</strong> " + clase.Fecha.ToString("dd/MM/yyyy") + @"</li>
                <li><strong>Horario:</strong> " + clase.HoraInicio + @":00 hs</li>
                </ul>

                <p>El cupo correspondiente fue reintegrado automáticamente a su plan.</p>

                <br/>
                <p>Centro Fitness</p>";

                email.armarCorreo(
                    reserva.Alumno.Email,
                    "Cancelación de clase - Centro Fitness",
                    cuerpo
                );

                email.enviarEmail();
            }

            enviarMailInstructorCancelacionClase(clase);

            claseNegocio.eliminar(idClase);
        }



        public void trasladarReservas(int idClaseOriginal, int idClaseNueva)
        {
            ClaseNegocio claseNegocio = new ClaseNegocio();
            SuscripcionNegocio suscripcionNegocio = new SuscripcionNegocio();

            Clase claseOriginal = claseNegocio.obtenerPorId(idClaseOriginal);
            Clase claseNueva = claseNegocio.obtenerPorId(idClaseNueva);

            if (claseOriginal == null)
                throw new Exception("No se encontró la clase original.");

            if (claseNueva == null)
                throw new Exception("No se encontró la clase nueva.");

            if (claseNueva.Estado != EstadoClase.Vigente)
                throw new Exception("La clase nueva no se encuentra vigente.");

            List<Reserva> reservas = listarVigentesPorClase(idClaseOriginal);

            if (reservas.Count > 0)
            {
                int reservasActualesClaseNueva = contarReservasVigentes(idClaseNueva);

                if (reservasActualesClaseNueva + reservas.Count > claseNueva.CupoMaximo)
                    throw new Exception("La clase nueva no tiene cupo suficiente para trasladar todas las reservas.");

                foreach (Reserva reserva in reservas)
                {
                    if (existeReserva(reserva.Alumno.IdUsuario, idClaseNueva))
                        throw new Exception("El alumno " + reserva.Alumno.Nombre + " " + reserva.Alumno.Apellido + " ya tiene una reserva vigente para la clase nueva.");

                    suscripcionNegocio.validarClaseDentroDeSuscripcion(reserva.Alumno.IdUsuario, claseNueva);
                }
            }

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "UPDATE Reservas " +
                    "SET IdClase = @IdClaseNueva " +
                    "WHERE IdClase = @IdClaseOriginal " +
                    "AND Estado = 1");

                datos.setearParametro("@IdClaseNueva", idClaseNueva);
                datos.setearParametro("@IdClaseOriginal", idClaseOriginal);

                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
            enviarMailsReprogramacionClase(reservas, claseOriginal, claseNueva);
        }


        public enum TipoCancelacion
        {
            Alumno = 1,
            CentroFitness = 2
        }

        private void registrarHistorialCancelacion(int idReserva, int idAlumno, DateTime fechaClase, int tipoCancelacion, string motivo)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "INSERT INTO HistorialCancelaciones (IdReserva, IdAlumno, FechaClase, TipoCancelacion, Motivo) " +
                    "VALUES (@IdReserva, @IdAlumno, @FechaClase, @TipoCancelacion, @Motivo)");

                datos.setearParametro("@IdReserva", idReserva);
                datos.setearParametro("@IdAlumno", idAlumno);
                datos.setearParametro("@FechaClase", fechaClase);
                datos.setearParametro("@TipoCancelacion", tipoCancelacion);
                datos.setearParametro("@Motivo", motivo);

                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        private void sincronizarHistorialInasistencia(int idReserva, EstadoAsistencia? asistencia)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                if (asistencia == EstadoAsistencia.Ausente)
                {
                    datos.setearConsulta("IF NOT EXISTS (SELECT 1 FROM HistorialInasistencias WHERE IdReserva = @IdReserva) " +
                        "BEGIN " +
                        "INSERT INTO HistorialInasistencias (IdAlumno, IdReserva) " +
                        "SELECT IdAlumno, IdReserva FROM Reservas WHERE IdReserva = @IdReserva " +
                        "END");

                    datos.setearParametro("@IdReserva", idReserva);
                }
                else
                {
                    datos.setearConsulta(
                        "DELETE FROM HistorialInasistencias WHERE IdReserva = @IdReserva");

                    datos.setearParametro("@IdReserva", idReserva);
                }

                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        private void enviarMailsReprogramacionClase(List<Reserva> reservas, Clase claseOriginal, Clase claseNueva)
        {
            foreach (Reserva reserva in reservas)
            {
                EmailService email = new EmailService();

                string cuerpo = @"
                <h2>Clase reprogramada</h2>

                <p>Te informamos que una clase en la que tenías reserva fue reprogramada.</p>

                <p><strong>Clase original:</strong></p>
                <ul>
                    <li><strong>Disciplina:</strong> " + claseOriginal.Disciplina.Nombre + @"</li>
                    <li><strong>Fecha:</strong> " + claseOriginal.Fecha.ToString("dd/MM/yyyy") + @"</li>
                    <li><strong>Horario:</strong> " + claseOriginal.HoraInicio + @":00 hs</li>
                </ul>

                <p><strong>Nueva clase:</strong></p>
                <ul>
                    <li><strong>Disciplina:</strong> " + claseNueva.Disciplina.Nombre + @"</li>
                    <li><strong>Fecha:</strong> " + claseNueva.Fecha.ToString("dd/MM/yyyy") + @"</li>
                    <li><strong>Horario:</strong> " + claseNueva.HoraInicio + @":00 hs</li>
                </ul>

                <p>Tu reserva fue trasladada automáticamente.</p>

                <br/>
                <p>Centro Fitness</p>";

                email.armarCorreo(
                    reserva.Alumno.Email,
                    "Reprogramación de clase - Centro Fitness",
                    cuerpo);

                email.enviarEmail();
            }

            enviarMailInstructorReprogramacion(claseOriginal, claseNueva);
        }

        private void enviarMailInstructorReprogramacion(Clase claseOriginal, Clase claseNueva)
        {
            if (claseNueva.Instructor == null || string.IsNullOrWhiteSpace(claseNueva.Instructor.Email))
                return;

            EmailService email = new EmailService();

            string cuerpo = @"
            <h2>Clase reprogramada</h2>

            <p>Te informamos que una de tus clases fue reprogramada.</p>

            <p><strong>Clase original:</strong></p>
            <ul>
                <li><strong>Disciplina:</strong> " + claseOriginal.Disciplina.Nombre + @"</li>
                <li><strong>Fecha:</strong> " + claseOriginal.Fecha.ToString("dd/MM/yyyy") + @"</li>
                <li><strong>Horario:</strong> " + claseOriginal.HoraInicio + @":00 hs</li>
            </ul>

            <p><strong>Nueva clase:</strong></p>
            <ul>
                <li><strong>Disciplina:</strong> " + claseNueva.Disciplina.Nombre + @"</li>
                <li><strong>Fecha:</strong> " + claseNueva.Fecha.ToString("dd/MM/yyyy") + @"</li>
                <li><strong>Horario:</strong> " + claseNueva.HoraInicio + @":00 hs</li>
            </ul>

            <p>Centro Fitness</p>";

            email.armarCorreo(
                claseNueva.Instructor.Email,
                "Reprogramación de clase asignada - Centro Fitness",
                cuerpo);

            email.enviarEmail();
        }

        private void enviarMailInstructorCancelacionClase(Clase clase)
        {
            if (clase.Instructor == null || string.IsNullOrWhiteSpace(clase.Instructor.Email))
                return;

            EmailService email = new EmailService();

            string cuerpo = @"
            <h2>Clase cancelada</h2>

            <p>Te informamos que la siguiente clase asignada fue cancelada:</p>

            <ul>
                <li><strong>Disciplina:</strong> " + clase.Disciplina.Nombre + @"</li>
                <li><strong>Fecha:</strong> " + clase.Fecha.ToString("dd/MM/yyyy") + @"</li>
                <li><strong>Horario:</strong> " + clase.HoraInicio + @":00 hs</li>
            </ul>

            <p>Los alumnos inscriptos fueron notificados automáticamente.</p>

            <br/>
            <p>Centro Fitness</p>";

            email.armarCorreo(
                clase.Instructor.Email,
                "Cancelación de clase asignada - Centro Fitness",
                cuerpo);

            email.enviarEmail();
        }

        public void enviarMailCancelacionReserva(Reserva reserva)
        {
            EmailService email = new EmailService();

            string cuerpo = @"<h2>Reserva cancelada</h2>

            <p>La siguiente reserva fue cancelada correctamente:</p>

            <ul>
            <li><strong>Disciplina:</strong> " + reserva.Clase.Disciplina.Nombre + @"</li>
            <li><strong>Fecha:</strong> " + reserva.Clase.Fecha.ToString("dd/MM/yyyy") + @"</li>
            <li><strong>Horario:</strong> " + reserva.Clase.HoraInicio + @":00 hs</li>
            </ul>

            <p>El cupo correspondiente fue reintegrado automáticamente a su plan.</p>

            <br/>

            <p>Centro Fitness</p>";

            email.armarCorreo(
                reserva.Alumno.Email,
                "Cancelación de reserva - Centro Fitness",
                cuerpo);

            email.enviarEmail();
        }

    }

}



