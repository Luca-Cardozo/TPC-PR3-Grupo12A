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
                    "U.IdUsuario, U.Nombre AS NombreAlumno, U.Apellido AS ApellidoAlumno " +
                    "FROM Reservas R " +
                    "INNER JOIN Clases C ON R.IdClase = C.IdClase " +
                    "INNER JOIN Disciplinas D ON C.IdDisciplina = D.IdDisciplina " +
                    "INNER JOIN Usuarios U ON R.IdAlumno = U.IdUsuario");

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


        //comentado porque no se si se va a usar
        //public void agregar(Reserva reservaNueva)
        //{

        //    if (existeReserva(reservaNueva.Alumno.IdUsuario, reservaNueva.Clase.IdClase))
        //        throw new Exception("El alumno ya posee una reserva vigente para esta clase.");

        //    AccesoDatos datos = new AccesoDatos();

        //    try
        //    {

        //        datos.setearConsulta(
        //            "INSERT INTO Reservas (IdClase, IdAlumno, FechaReserva, Estado, Asistio, Observaciones) " +
        //            "OUTPUT INSERTED.IdReserva " +
        //            "VALUES (@IdClase, @IdAlumno, GETDATE(), 1, NULL, @Observaciones)");

        //        datos.setearParametro("@IdClase", reservaNueva.Clase.IdClase);
        //        datos.setearParametro("@IdAlumno", reservaNueva.Alumno.IdUsuario);
        //        datos.setearParametro("@Observaciones", reservaNueva.Observaciones ?? "");


        //        int idReserva = datos.ejecutarAccionScalar();
        //        reservaNueva.IdReserva = idReserva;
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    finally
        //    {
        //        datos.cerrarConexion();
        //    }
        //}

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
                datos.setearParametro("@Observaciones", reservaModificada.Observaciones ?? "");
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

        public void eliminar(int idReserva)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {


                datos.setearConsulta("UPDATE Reservas SET Estado = 2 WHERE IdReserva = @IdReserva");
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
    }
}


