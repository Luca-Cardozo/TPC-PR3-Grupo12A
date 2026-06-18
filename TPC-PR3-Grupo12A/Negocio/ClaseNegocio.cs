using Acceso_Datos;
using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class ClaseNegocio
    {
        public List<Clase> listar()
        {
            List<Clase> lista = new List<Clase>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "SELECT C.IdClase, C.Fecha, C.HoraInicio, C.CupoMaximo, C.Estado, " +
                    "D.IdDisciplina, D.Nombre AS NombreDisciplina, " +
                    "U.IdUsuario, U.Nombre AS NombreInstructor, U.Apellido " +
                    "FROM Clases C " +
                    "INNER JOIN Disciplinas D ON D.IdDisciplina = C.IdDisciplina " +
                    "INNER JOIN Usuarios U ON U.IdUsuario = C.IdInstructor");

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Clase clase = new Clase();

                    clase.IdClase = (int)datos.Lector["IdClase"];
                    clase.Fecha = (DateTime)datos.Lector["Fecha"];
                    clase.HoraInicio = (int)datos.Lector["HoraInicio"];
                    clase.CupoMaximo = (int)datos.Lector["CupoMaximo"];
                    clase.Estado = (EstadoClase)(int)datos.Lector["Estado"];

                    clase.Disciplina = new Disciplina();
                    clase.Disciplina.IdDisciplina = (int)datos.Lector["IdDisciplina"];
                    clase.Disciplina.Nombre = (string)datos.Lector["NombreDisciplina"];

                    clase.Instructor = new Instructor();
                    clase.Instructor.IdUsuario = (int)datos.Lector["IdUsuario"];
                    clase.Instructor.Nombre = (string)datos.Lector["NombreInstructor"];
                    clase.Instructor.Apellido = (string)datos.Lector["Apellido"];

                    lista.Add(clase);
                }

                return lista;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        public List<Clase> listarVigentesPorDisciplina(int idDisciplina)
        {
            List<Clase> lista = new List<Clase>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "SELECT C.IdClase, C.Fecha, C.HoraInicio, C.CupoMaximo, C.Estado, " +
                    "D.IdDisciplina, D.Nombre AS NombreDisciplina, " +
                    "U.IdUsuario, U.Nombre AS NombreInstructor, U.Apellido " +
                    "FROM Clases C " +
                    "INNER JOIN Disciplinas D ON D.IdDisciplina = C.IdDisciplina " +
                    "INNER JOIN Usuarios U ON U.IdUsuario = C.IdInstructor " +
                    "WHERE C.IdDisciplina = @IdDisciplina " +
                    "AND C.Estado = 1 " +
                    "AND DATEADD(HOUR, C.HoraInicio, CAST(C.Fecha AS DATETIME)) > GETDATE() " +
                    "ORDER BY C.Fecha, C.HoraInicio");

                datos.setearParametro("@IdDisciplina", idDisciplina);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Clase clase = new Clase();

                    clase.IdClase = (int)datos.Lector["IdClase"];
                    clase.Fecha = (DateTime)datos.Lector["Fecha"];
                    clase.HoraInicio = (int)datos.Lector["HoraInicio"];
                    clase.CupoMaximo = (int)datos.Lector["CupoMaximo"];
                    clase.Estado = (EstadoClase)(int)datos.Lector["Estado"];

                    clase.Disciplina = new Disciplina();
                    clase.Disciplina.IdDisciplina = (int)datos.Lector["IdDisciplina"];
                    clase.Disciplina.Nombre = (string)datos.Lector["NombreDisciplina"];

                    clase.Instructor = new Instructor();
                    clase.Instructor.IdUsuario = (int)datos.Lector["IdUsuario"];
                    clase.Instructor.Nombre = (string)datos.Lector["NombreInstructor"];
                    clase.Instructor.Apellido = (string)datos.Lector["Apellido"];

                    lista.Add(clase);
                }

                return lista;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void agregar(Clase claseNueva)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("INSERT INTO Clases (IdDisciplina, IdInstructor, Fecha, " +
                    "HoraInicio, CupoMaximo, Estado) OUTPUT INSERTED.IdClase " +
                     "VALUES (@IdDisciplina, @IdInstructor, @Fecha, @HoraInicio, @CupoMaximo, " +
                     "@Estado)");

                datos.setearParametro("@IdDisciplina", claseNueva.Disciplina.IdDisciplina);
                datos.setearParametro("@IdInstructor", claseNueva.Instructor.IdUsuario);
                datos.setearParametro("@Fecha", claseNueva.Fecha);
                datos.setearParametro("@HoraInicio", claseNueva.HoraInicio);
                datos.setearParametro("@CupoMaximo", claseNueva.CupoMaximo);
                datos.setearParametro("@Estado", claseNueva.Estado);

                int idClase = datos.ejecutarAccionScalar();
                claseNueva.IdClase = idClase;
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

        public void modificar(Clase claseModificada)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Clases SET IdDisciplina = @IdDisciplina, " +
                    "IdInstructor = @IdInstructor, Fecha = @Fecha, HoraInicio = @HoraInicio, " +
                    "CupoMaximo = @CupoMaximo, Estado = @Estado WHERE IdClase = @IdClase");

                datos.setearParametro("@IdDisciplina", claseModificada.Disciplina.IdDisciplina);
                datos.setearParametro("@IdInstructor", claseModificada.Instructor.IdUsuario);
                datos.setearParametro("@Fecha", claseModificada.Fecha);
                datos.setearParametro("@HoraInicio", claseModificada.HoraInicio);
                datos.setearParametro("@CupoMaximo", claseModificada.CupoMaximo);
                datos.setearParametro("@Estado", claseModificada.Estado);
                datos.setearParametro("@IdClase", claseModificada.IdClase);

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

        public void eliminar(int idClase)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Clases SET Estado = 2 " +
                    "WHERE IdClase = @IdClase");

                datos.setearParametro("@IdClase", idClase);

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

        public void reactivar(int idClase)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Clases SET Estado = 1 " +
                    "WHERE IdClase = @IdClase");

                datos.setearParametro("@IdClase", idClase);

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

        public int obtenerProximoId()
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT ISNULL(MAX(IdClase), 0) + 1 FROM Clases");
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                    return (int)datos.Lector[0];

                return 1;
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

        public bool existeClase(DateTime fecha, int horaInicio, int? idExcluir = null)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                string consulta = "SELECT 1 FROM Clases WHERE Fecha = @Fecha " +
                    "AND HoraInicio = @HoraInicio ";

                if (idExcluir.HasValue)
                {
                    consulta += "AND IdClase <> @IdClase ";
                }

                consulta += "AND Estado = 1";

                datos.setearConsulta(consulta);

                datos.setearParametro("@Fecha", fecha.Date);

                datos.setearParametro("@HoraInicio", horaInicio);

                if (idExcluir.HasValue)
                {
                    datos.setearParametro("@IdClase", idExcluir.Value);
                }

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

        public void finalizarClase(int idClase)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Clases SET Estado = @Estado WHERE IdClase = @IdClase");
                datos.setearParametro("@Estado", (int)EstadoClase.Finalizada);
                datos.setearParametro("@IdClase", idClase);
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
