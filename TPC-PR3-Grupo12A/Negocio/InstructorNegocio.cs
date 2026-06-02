using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dominio;
using Acceso_Datos;
using System.Diagnostics.Tracing;

namespace Negocio
{
    public class InstructorNegocio
    {
        public List<Instructor> listar()
        {
            List<Instructor> lista = new List<Instructor>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT U.IdUsuario, U.Nombre AS NombreInstructor, " +
                    "U.Apellido, U.Email, U.Password, U.DNI, U.Telefono, U.FechaNacimiento, " +
                    "U.Imagen AS ImagenInstructor, U.Rol, U.Activo, D.IdDisciplina, " +
                    "D.Nombre AS NombreDisciplina, D.Imagen AS ImagenDisciplina, " +
                    "D.Activa FROM Usuarios U " +
                    "INNER JOIN DisciplinasXInstructores DI ON DI.IdInstructor = U.IdUsuario " +
                    "INNER JOIN Disciplinas D ON D.IdDisciplina = DI.IdDisciplina " +
                    "WHERE Rol = 3");
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    int idInstructor = (int)datos.Lector["IdUsuario"];
                    // Buscar si el instructor ya está cargado para no cargarlo tantas veces como disciplinas dicte
                    Instructor instructor = lista.Find(x => x.IdUsuario == idInstructor);

                    if (instructor == null)
                    {
                        instructor = new Instructor();
                        instructor.IdUsuario = (int)datos.Lector["IdUsuario"];
                        instructor.Nombre = (string)datos.Lector["NombreInstructor"];
                        instructor.Apellido = (string)datos.Lector["Apellido"];
                        instructor.Email = (string)datos.Lector["Email"];
                        instructor.Password = (string)datos.Lector["Password"];
                        instructor.DNI = (string)datos.Lector["DNI"];
                        instructor.Telefono = (string)datos.Lector["Telefono"];
                        instructor.FechaNacimiento = (DateTime)datos.Lector["FechaNacimiento"];
                        instructor.Imagen = (string)datos.Lector["ImagenInstructor"];
                        instructor.Activo = (bool)datos.Lector["Activo"];
                        lista.Add(instructor);
                    }

                    Disciplina disciplina = new Disciplina();
                    disciplina.IdDisciplina = (int)datos.Lector["IdDisciplina"];
                    disciplina.Nombre = (string)datos.Lector["NombreDisciplina"];
                    disciplina.Imagen = (string)datos.Lector["ImagenDisciplina"];
                    disciplina.Activa = (bool)datos.Lector["Activa"];
                    instructor.Disciplinas.Add(disciplina);
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
    }
}
