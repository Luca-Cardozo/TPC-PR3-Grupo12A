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
                    "SELECT R.IdReserva, R.FechaReserva, R.Estado, R.Asistio, R.Observaciones, " +
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


                    res.Asistio = datos.Lector["Asistio"] == DBNull.Value ? (bool?)null : (bool)datos.Lector["Asistio"];
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
                    "R.Asistio, R.Observaciones, C.IdClase, C.Fecha, C.HoraInicio, C.CupoMaximo, " +
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
                    res.Asistio = datos.Lector["Asistio"] == DBNull.Value ? (bool?)null : (bool)datos.Lector["Asistio"];
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

        public void agregar(Reserva reservaNueva)
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
                }

                datos.cerrarConexion();

                validarCupoDisponible(reservaNueva.Clase.IdClase);

                datos = new AccesoDatos();
                datos.setearConsulta("INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones) " +
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
                    "UPDATE Reservas SET Estado = @Estado, Asistio = @Asistio, Observaciones = @Observaciones " +
                    "WHERE IdReserva = @IdReserva");

                datos.setearParametro("@Estado", (int)reservaModificada.Estado);


                datos.setearParametro("@Asistio", (object)reservaModificada.Asistio ?? DBNull.Value);
                datos.setearParametro("@Observaciones", string.IsNullOrWhiteSpace(reservaModificada.Observaciones) ? (object)DBNull.Value : reservaModificada.Observaciones.Trim());
                datos.setearParametro("@IdReserva", reservaModificada.IdReserva);

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
        }

        public void cancelar(int idReserva)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT IdAlumno FROM Reservas WHERE IdReserva = @IdReserva");
                datos.setearParametro("@IdReserva", idReserva);
                datos.ejecutarLectura();
                if (!datos.Lector.Read())
                    throw new Exception("Reserva no encontrada.");
                int idAlumno = (int)datos.Lector["IdAlumno"];
                datos.cerrarConexion();

                datos = new AccesoDatos();
                datos.setearConsulta("UPDATE Reservas SET Estado = 2 WHERE IdReserva = @IdReserva");
                datos.setearParametro("@IdReserva", idReserva);
                datos.ejecutarAccion();

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
                    "SELECT R.IdReserva, R.FechaReserva, R.Estado, R.Asistio, R.Observaciones, " +
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
                    res.Asistio = datos.Lector["Asistio"] == DBNull.Value ? (bool?)null : (bool)datos.Lector["Asistio"];
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

        public void actualizarAsistencia(int idReserva, bool asistio, string observaciones)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "UPDATE Reservas SET Asistio = @Asistio, Observaciones = @Observaciones, Estado = 3 " +
                    "WHERE IdReserva = @IdReserva");

                datos.setearParametro("@Asistio", asistio);
                datos.setearParametro("@Observaciones", observaciones ?? "");
                datos.setearParametro("@IdReserva", idReserva);

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
        }

        public int contarReservasVigentes(int idClase)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT COUNT(*) FROM Reservas " +
                    "WHERE IdClase = @IdClase AND Estado IN (1, 4)");
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



        public void reprogramar(int idReserva, int idClaseNueva)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                Reserva reserva = listar().Find(x => x.IdReserva == idReserva);

                if (reserva == null)
                    throw new Exception("No se encontró la reserva.");

                if (existeReserva(reserva.Alumno.IdUsuario, idClaseNueva))
                    throw new Exception("El alumno ya tiene una reserva vigente para esa clase.");

                validarCupoDisponible(idClaseNueva);

                datos.setearConsulta(
                    "UPDATE Reservas SET IdClase = @IdClaseNueva, Estado = 4, Asistio = NULL " +
                    "WHERE IdReserva = @IdReserva");

                datos.setearParametro("@IdClaseNueva", idClaseNueva);
                datos.setearParametro("@IdReserva", idReserva);

                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }


        public List<Reserva> listarPorClase(int idClase)
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
                    "AND R.Estado IN (1,4)");

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
            List<Reserva> reservas = listarPorClase(idClase);
            ClaseNegocio claseNegocio = new ClaseNegocio();
            Clase clase = claseNegocio.obtenerPorId(idClase);

            foreach (Reserva reserva in reservas)
            {
                cancelar(reserva.IdReserva);

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

            claseNegocio.eliminar(idClase);
        }



        public void trasladarReservas(int idClaseOriginal, int idClaseNueva)
        {
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
        }
    }

}



