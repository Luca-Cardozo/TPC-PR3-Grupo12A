using Acceso_Datos;
using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class RecepcionistaNegocio
    {
        public List<Recepcionista> listar()
        {
            List<Recepcionista> lista = new List<Recepcionista>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "SELECT IdUsuario, Nombre, Apellido, Email, Password, DNI, Telefono, " +
                    "FechaNacimiento, Imagen, Rol, Activo " +
                    "FROM Usuarios WHERE Rol = 2");

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Recepcionista recepcionista = new Recepcionista();

                    recepcionista.IdUsuario = (int)datos.Lector["IdUsuario"];
                    recepcionista.Nombre = (string)datos.Lector["Nombre"];
                    recepcionista.Apellido = (string)datos.Lector["Apellido"];
                    recepcionista.Email = (string)datos.Lector["Email"];
                    recepcionista.Password = (string)datos.Lector["Password"];
                    recepcionista.DNI = (string)datos.Lector["DNI"];
                    recepcionista.Telefono = (string)datos.Lector["Telefono"];
                    recepcionista.FechaNacimiento = (DateTime)datos.Lector["FechaNacimiento"];
                    recepcionista.Imagen = datos.Lector["Imagen"] == DBNull.Value ? "default-user" : (string)datos.Lector["Imagen"];
                    recepcionista.Activo = (bool)datos.Lector["Activo"];

                    lista.Add(recepcionista);
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

        public void agregar(Recepcionista recepcionistaNuevo)
        {
            if (existeRecepcionista(recepcionistaNuevo.DNI, recepcionistaNuevo.Email))
                throw new Exception("Ya existe ese recepcionista.");

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("INSERT INTO Usuarios (Nombre, Apellido, Email, Password, DNI, " +
                    "Telefono, FechaNacimiento, Imagen, Rol) OUTPUT INSERTED.IdUsuario " +
                     "VALUES (@Nombre, @Apellido, @Email, '1234', @DNI, @Telefono, " +
                     "@FechaNacimiento, 'default-user', 2)");

                datos.setearParametro("@Nombre", recepcionistaNuevo.Nombre);
                datos.setearParametro("@Apellido", recepcionistaNuevo.Apellido);
                datos.setearParametro("@Email", recepcionistaNuevo.Email);
                datos.setearParametro("@DNI", recepcionistaNuevo.DNI);
                datos.setearParametro("@Telefono", recepcionistaNuevo.Telefono);
                datos.setearParametro("@FechaNacimiento", recepcionistaNuevo.FechaNacimiento);
                datos.setearParametro("@Imagen", string.IsNullOrWhiteSpace(recepcionistaNuevo.Imagen) ? "default-user" : recepcionistaNuevo.Imagen);

                int idrecepcionista = datos.ejecutarAccionScalar();
                recepcionistaNuevo.IdUsuario = idrecepcionista;
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

        public void modificar(Recepcionista recepcionistaModificado)
        {
            if (existeRecepcionista(recepcionistaModificado.DNI, recepcionistaModificado.Email, recepcionistaModificado.IdUsuario))
                throw new Exception("Ya existe Recepcionista con ese DNI o Mail ingresado.");

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Usuarios SET Nombre = @Nombre, Apellido = @Apellido, " +
"Email = @Email, DNI = @DNI, Telefono = @Telefono, " +
"FechaNacimiento = @FechaNacimiento, Imagen = @Imagen " +
"WHERE IdUsuario = @IdUsuario AND Rol = 2");

                datos.setearParametro("@Nombre", recepcionistaModificado.Nombre);
                datos.setearParametro("@Apellido", recepcionistaModificado.Apellido);
                datos.setearParametro("@Email", recepcionistaModificado.Email);
                datos.setearParametro("@DNI", recepcionistaModificado.DNI);
                datos.setearParametro("@Telefono", recepcionistaModificado.Telefono);
                datos.setearParametro("@FechaNacimiento", recepcionistaModificado.FechaNacimiento);
                datos.setearParametro("@IdUsuario", recepcionistaModificado.IdUsuario);
                datos.setearParametro("@Imagen", string.IsNullOrWhiteSpace(recepcionistaModificado.Imagen) ? "default-user" : recepcionistaModificado.Imagen);

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


        public void eliminar(int idRecepcionista)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Usuarios SET Activo = 0 WHERE IdUsuario = @IdUsuario AND Rol = 2");

                datos.setearParametro("@IdUsuario", idRecepcionista);

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

        public void reactivar(int idRecepcionista)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Usuarios SET Activo = 1 WHERE IdUsuario = @IdUsuario AND Rol = 2");

                datos.setearParametro("@IdUsuario", idRecepcionista);

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


        public bool existeRecepcionista(string dni, string email, int? idExcluir = null)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                string consulta = "SELECT 1 FROM Usuarios WHERE (DNI = @DNI OR Email = @Email) AND Rol = 2";

                //
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


    }
}

