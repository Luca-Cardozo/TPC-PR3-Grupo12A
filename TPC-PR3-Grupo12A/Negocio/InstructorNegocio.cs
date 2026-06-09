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

        public List<Disciplina> listarDisciplinasPorInstructor(int idInstructor)
        {
            List<Disciplina> lista = new List<Disciplina>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT D.IdDisciplina, D.Nombre FROM Disciplinas D " +
                    "INNER JOIN DisciplinasXInstructores DXI ON D.IdDisciplina = DXI.IdDisciplina " +
                    "WHERE DXI.IdInstructor = @IdInstructor");
                datos.setearParametro("@IdInstructor", idInstructor);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Disciplina disciplina = new Disciplina();
                    disciplina.IdDisciplina = (int)datos.Lector["IdDisciplina"];
                    disciplina.Nombre = (string)datos.Lector["Nombre"];
                    lista.Add(disciplina);
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

        public void agregar(Instructor instructorNuevo)
        {
            if (existeInstructor(instructorNuevo.DNI, instructorNuevo.Email))
                throw new Exception("Ya existe ese instructor.");

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("INSERT INTO Usuarios (Nombre, Apellido, Email, Password, DNI, " +
                    "Telefono, FechaNacimiento, Imagen, Rol) OUTPUT INSERTED.IdUsuario " +
                     "VALUES (@Nombre, @Apellido, @Email, '1234', @DNI, @Telefono, " +
                     "@FechaNacimiento, 'default-user', 3)");

                datos.setearParametro("@Nombre", instructorNuevo.Nombre);
                datos.setearParametro("@Apellido", instructorNuevo.Apellido);
                datos.setearParametro("@Email", instructorNuevo.Email);
                datos.setearParametro("@DNI", instructorNuevo.DNI);
                datos.setearParametro("@Telefono", instructorNuevo.Telefono);
                datos.setearParametro("@FechaNacimiento", instructorNuevo.FechaNacimiento);

                int idInstructor = datos.ejecutarAccionScalar();
                instructorNuevo.IdUsuario = idInstructor;
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

        public void modificar(Instructor instructorModificado)
        {
            if (existeInstructor(instructorModificado.DNI, instructorModificado.Email, instructorModificado.IdUsuario))
                throw new Exception("Ya existe ese instructor.");

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Usuarios SET Nombre = @Nombre, Apellido = @Apellido, " +
                    "Email = @Email, DNI = @DNI, Telefono = @Telefono, FechaNacimiento = @FechaNacimiento " +
                    "WHERE IdUsuario = @IdUsuario");

                datos.setearParametro("@Nombre", instructorModificado.Nombre);
                datos.setearParametro("@Apellido", instructorModificado.Apellido);
                datos.setearParametro("@Email", instructorModificado.Email);
                datos.setearParametro("@DNI", instructorModificado.DNI);
                datos.setearParametro("@Telefono", instructorModificado.Telefono);
                datos.setearParametro("@FechaNacimiento", instructorModificado.FechaNacimiento);
                datos.setearParametro("@IdUsuario", instructorModificado.IdUsuario);

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


        public void eliminar(int idInstructor)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Usuarios SET Activo = 0 " +
                    "WHERE IdUsuario = @IdUsuario");

                datos.setearParametro("@IdUsuario", idInstructor);

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

        public void reactivar(int idInstructor)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Usuarios SET Activo = 1 " +
                    "WHERE IdUsuario = @IdUsuario");

                datos.setearParametro("@IdUsuario", idInstructor);

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


        public void agregarDisciplinaInstructor(int idInstructor, int idDisciplina)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("INSERT INTO DisciplinasXInstructores (IdInstructor, IdDisciplina) " +
                    "VALUES (@IdInstructor, @IdDisciplina)");

                datos.setearParametro("@IdInstructor", idInstructor);
                datos.setearParametro("@IdDisciplina", idDisciplina);

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
                datos.setearConsulta("SELECT ISNULL(MAX(IdUsuario), 0) + 1 FROM Usuarios");
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


        public bool existeInstructor(string dni, string email, int? idExcluir = null)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                string consulta = "SELECT 1 FROM Usuarios WHERE (DNI = @DNI OR Email = @Email) AND Rol = 3";

                // En el caso de modificar el instructor, se excluye el id del mismo
                if (idExcluir.HasValue)
                    consulta += " AND IdUsuario <> @IdUsuario";

                datos.setearConsulta(consulta);
                datos.setearParametro("@DNI", dni);
                datos.setearParametro("@Email", email);

                // En caso de modificación
                if (idExcluir.HasValue)
                    datos.setearParametro("@IdUsuario", idExcluir.Value);

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

        public void eliminarDisciplinasInstructor(int idInstructor)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("DELETE FROM DisciplinasXInstructores WHERE IdInstructor = @IdInstructor");

                datos.setearParametro("@IdInstructor", idInstructor);

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
