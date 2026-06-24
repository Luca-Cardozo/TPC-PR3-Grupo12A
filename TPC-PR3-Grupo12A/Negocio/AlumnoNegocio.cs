using Acceso_Datos;
using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class AlumnoNegocio
    {
        public List<Alumno> listar()
        {
            List<Alumno> lista = new List<Alumno>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "SELECT IdUsuario, Nombre, Apellido, Email, Password, DNI, Telefono, " +
                    "FechaNacimiento, Imagen, Rol, Observaciones, Activo " +
                    "FROM Usuarios WHERE Rol = 4");

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Alumno alumno = new Alumno();

                    alumno.IdUsuario = (int)datos.Lector["IdUsuario"];
                    alumno.Nombre = (string)datos.Lector["Nombre"];
                    alumno.Apellido = (string)datos.Lector["Apellido"];
                    alumno.Email = (string)datos.Lector["Email"];
                    alumno.Password = (string)datos.Lector["Password"];
                    alumno.DNI = (string)datos.Lector["DNI"];
                    alumno.Telefono = (string)datos.Lector["Telefono"];
                    alumno.FechaNacimiento = (DateTime)datos.Lector["FechaNacimiento"];
                    alumno.Imagen = datos.Lector["Imagen"] == DBNull.Value ? "" : (string)datos.Lector["Imagen"];
                    alumno.Observaciones = datos.Lector["Observaciones"] == DBNull.Value ? "" : (string)datos.Lector["Observaciones"];
                    alumno.Activo = (bool)datos.Lector["Activo"];

                    lista.Add(alumno);
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

        public void agregar(Alumno alumnoNuevo)
        {
            if (existeAlumno(alumnoNuevo.DNI, alumnoNuevo.Email))
                throw new Exception("Ya existe un alumno con ese DNI o email.");

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "INSERT INTO Usuarios (Nombre, Apellido, Email, Password, DNI, Telefono, " +
                    "FechaNacimiento, Imagen, Rol, Observaciones) " +
                    "OUTPUT INSERTED.IdUsuario " +
                    "VALUES (@Nombre, @Apellido, @Email, '1234', @DNI, @Telefono, " +
                    "@FechaNacimiento, 'default-user', 4, @Observaciones)");

                datos.setearParametro("@Nombre", alumnoNuevo.Nombre);
                datos.setearParametro("@Apellido", alumnoNuevo.Apellido);
                datos.setearParametro("@Email", alumnoNuevo.Email);
                datos.setearParametro("@DNI", alumnoNuevo.DNI);
                datos.setearParametro("@Telefono", alumnoNuevo.Telefono);
                datos.setearParametro("@FechaNacimiento", alumnoNuevo.FechaNacimiento);
                datos.setearParametro("@Observaciones", alumnoNuevo.Observaciones ?? "");

                int idAlumno = datos.ejecutarAccionScalar();
                alumnoNuevo.IdUsuario = idAlumno;
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

        public void modificar(Alumno alumnoModificado)
        {
            if (existeAlumno(alumnoModificado.DNI, alumnoModificado.Email, alumnoModificado.IdUsuario))
                throw new Exception("Ya existe un alumno con ese DNI o email.");

            UsuarioNegocio usuarioNegocio = new UsuarioNegocio();
            string emailAnterior = usuarioNegocio.obtenerEmailActual(alumnoModificado.IdUsuario);

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "UPDATE Usuarios SET Nombre = @Nombre, Apellido = @Apellido, " +
                    "Email = @Email, DNI = @DNI, Telefono = @Telefono, " +
                    "FechaNacimiento = @FechaNacimiento, Observaciones = @Observaciones " +
                    "WHERE IdUsuario = @IdUsuario AND Rol = 4");

                datos.setearParametro("@Nombre", alumnoModificado.Nombre);
                datos.setearParametro("@Apellido", alumnoModificado.Apellido);
                datos.setearParametro("@Email", alumnoModificado.Email);
                datos.setearParametro("@DNI", alumnoModificado.DNI);
                datos.setearParametro("@Telefono", alumnoModificado.Telefono);
                datos.setearParametro("@FechaNacimiento", alumnoModificado.FechaNacimiento);
                datos.setearParametro("@Observaciones", alumnoModificado.Observaciones ?? "");
                datos.setearParametro("@IdUsuario", alumnoModificado.IdUsuario);

                datos.ejecutarAccion();

                if (!string.Equals(emailAnterior, alumnoModificado.Email, StringComparison.OrdinalIgnoreCase))
                {
                    usuarioNegocio.enviarMailCambioEmail(alumnoModificado.Email);
                }
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

        public void eliminar(int idAlumno)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Usuarios SET Activo = 0 WHERE IdUsuario = @IdUsuario AND Rol = 4");
                datos.setearParametro("@IdUsuario", idAlumno);
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

        public void reactivar(int idAlumno)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Usuarios SET Activo = 1 WHERE IdUsuario = @IdUsuario AND Rol = 4");
                datos.setearParametro("@IdUsuario", idAlumno);
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

        public bool existeAlumno(string dni, string email, int? idExcluir = null)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                string consulta = "SELECT 1 FROM Usuarios WHERE (DNI = @DNI OR Email = @Email) AND Rol = 4";

                if (idExcluir.HasValue)
                    consulta += " AND IdUsuario <> @IdUsuario";

                datos.setearConsulta(consulta);
                datos.setearParametro("@DNI", dni);
                datos.setearParametro("@Email", email);

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

        public void enviarMailSuscripcionActualizada(string email, Suscripcion suscripcion)
        {
            EmailService service = new EmailService();

            string cantidadClases;

            if (suscripcion.Plan.CantidadClases.HasValue)
                cantidadClases = suscripcion.Plan.CantidadClases.Value + " clases";
            else
                cantidadClases = "Pase Libre";

            string cuerpo = @"
            <h2>Suscripción actualizada correctamente ✅</h2>

            <p>
            Te informamos que tu suscripción de Centro Fitness fue registrada correctamente en nuestro sistema.
            </p>

            <p>
            A continuación podés consultar el detalle de tu plan:
            </p>

            <ul>
                <li><b>Plan:</b> " + suscripcion.Plan.Descripcion + @"</li>
                <li><b>Cantidad de clases:</b> " + cantidadClases + @"</li>
                <li><b>Vigencia desde:</b> " + suscripcion.FechaInicio.ToString("dd/MM/yyyy") + @"</li>
                <li><b>Vigencia hasta:</b> " + suscripcion.FechaFin.ToString("dd/MM/yyyy") + @"</li>
            </ul>

            <p>
            Recordá que podés consultar tu suscripción vigente en cualquier momento desde la sección <b>Mi Perfil</b> de la aplicación.
            </p>

            <p>
            Si tu plan posee una cantidad limitada de clases, el sistema irá descontándolas automáticamente a medida que realices reservas.
            </p>

            <p>
            Podés acceder a la aplicación desde:
            <br />
            <a href='https://www.centro-fitness.com'>www.centro-fitness.com</a>
            </p>

            <p>
            ¡Gracias por elegir Centro Fitness! 💪
            </p>

            <hr />

            <small>
            Este es un mensaje automático generado por Centro Fitness. Por favor, no responder a este correo.
            </small>";

            service.armarCorreo(email, "Suscripción actualizada - Centro Fitness", cuerpo);
            service.enviarEmail();
        }
    }
}

