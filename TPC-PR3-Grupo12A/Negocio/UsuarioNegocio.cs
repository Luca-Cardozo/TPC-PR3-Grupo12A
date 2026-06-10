using Acceso_Datos;
using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class UsuarioNegocio
    {
        public Usuario login(string email, string password)
        {
            Usuario usuario = null;
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT IdUsuario, Nombre, Apellido, Email, Password, DNI, " +
                "Telefono, FechaNacimiento, Imagen, Rol, Observaciones, Activo FROM Usuarios " +
                "WHERE Email = @Email AND Password = @Password"
                );

                datos.setearParametro("@Email", email);

                datos.setearParametro("@Password", password);

                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    Rol rol = (Rol)(int)datos.Lector["Rol"];

                    if (rol == Rol.Alumno)
                    {
                        Alumno alumno = new Alumno();

                        alumno.Observaciones = datos.Lector["Observaciones"] != DBNull.Value ? datos.Lector["Observaciones"].ToString() : "";

                        usuario = alumno;
                    }
                    else
                    {
                        usuario = new Usuario();
                    }

                    usuario.IdUsuario = (int)datos.Lector["IdUsuario"];

                    usuario.Nombre = datos.Lector["Nombre"].ToString();

                    usuario.Apellido = datos.Lector["Apellido"].ToString();

                    usuario.Email = datos.Lector["Email"].ToString();

                    usuario.Password = datos.Lector["Password"].ToString();

                    usuario.DNI = datos.Lector["DNI"].ToString();

                    usuario.Telefono = datos.Lector["Telefono"].ToString();

                    usuario.FechaNacimiento = (DateTime)datos.Lector["FechaNacimiento"];

                    usuario.Imagen = datos.Lector["Imagen"].ToString();

                    usuario.Rol = rol;

                    usuario.Activo = (bool)datos.Lector["Activo"];
                }

                return usuario;
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
