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
        public List<Clase> listarPorDisciplina(int idDisciplina)
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
                    "WHERE C.IdDisciplina = " + idDisciplina);

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
    }
}
