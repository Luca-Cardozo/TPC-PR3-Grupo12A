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

        public void modificarPerfil(Usuario usuario)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                string consulta = "UPDATE Usuarios SET Telefono = @Telefono, Password = @Password, " +
                    "Imagen = @Imagen ";
                if (usuario is Alumno)
                {
                    consulta += ", Observaciones = " + "@Observaciones ";
                }
                consulta += "WHERE IdUsuario = @IdUsuario";

                datos.setearConsulta(consulta);

                datos.setearParametro("@Telefono", usuario.Telefono);

                datos.setearParametro("@Password", usuario.Password);

                datos.setearParametro("@Imagen", usuario.Imagen);

                datos.setearParametro("@IdUsuario", usuario.IdUsuario);

                if (usuario is Alumno)
                {
                    Alumno alumno = (Alumno)usuario;
                    datos.setearParametro("@Observaciones", alumno.Observaciones);
                }

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

        public string obtenerEmailActual(int idUsuario)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT Email FROM Usuarios WHERE IdUsuario = @IdUsuario");
                datos.setearParametro("@IdUsuario", idUsuario);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                    return datos.Lector["Email"].ToString();

                return "";
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void enviarMailCambioEmail(string nuevoEmail)
        {
            EmailService service = new EmailService();

            string cuerpo = @"
            <h2>Actualización de correo electrónico</h2>

            <p>El correo electrónico asociado a tu cuenta de Centro Fitness fue actualizado correctamente.</p>

            <p>
            A partir de este momento deberás utilizar tu nueva dirección de correo para iniciar sesión:
            </p>

            <p><b>Nuevo usuario:</b> " + nuevoEmail + @"</p>

            <p>Tu contraseña actual no fue modificada y continúa siendo la misma.</p>

            <p>
            Si no realizaste este cambio o creés que se trata de un error, por favor comunicate con la recepción del gimnasio.
            </p>

            <p>
            Podés acceder a la aplicación desde:<br/>
            <a href='https://www.centro-fitness.com'>www.centro-fitness.com</a>
            </p>

            <hr/>

            <small>Este es un mensaje automático generado por Centro Fitness. Por favor, no responder a este correo.</small>";

            service.armarCorreo(nuevoEmail, "Actualización de correo electrónico - Centro Fitness", cuerpo);
            service.enviarEmail();
        }
        
    }
}
