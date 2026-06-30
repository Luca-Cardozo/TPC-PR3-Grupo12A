using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

namespace App_CentroFitness
{
    public partial class FormularioAlumno : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Seguridad.esAdmin(Session) && !Seguridad.esRecepcionista(Session))
            {
                Response.Redirect("AccesoDenegado.aspx", false);
                return;
            }

            if (!IsPostBack)
            {

                btnEliminar.Visible = false;

                if (Request.QueryString["id"] != null)
                {
                    lblTitulo.Text = "Editar Alumno";

                    int idSeleccionado = int.Parse(Request.QueryString["id"]);

                    btnEliminar.Visible = true;

                    try
                    {

                        AlumnoNegocio negocio = new AlumnoNegocio();
                        List<Alumno> lista = negocio.listar();

                        Alumno seleccionado = lista.Find(x => x.IdUsuario == idSeleccionado);

                        if (seleccionado != null)
                        {
                            txtIdUsuario.Text = seleccionado.IdUsuario.ToString();
                            txtEstado.Text = seleccionado.Activo ? "Activo" : "Inactivo";
                            txtNombre.Text = seleccionado.Nombre;
                            txtApellido.Text = seleccionado.Apellido;
                            txtDni.Text = seleccionado.DNI;
                            txtEmail.Text = seleccionado.Email;
                            txtTelefono.Text = seleccionado.Telefono;
                            txtFechaNacimiento.Text = seleccionado.FechaNacimiento.ToString("yyyy-MM-dd");
                            txtObservaciones.Text = seleccionado.Observaciones;

                            AlumnoNegocio alumnoNegocio = new AlumnoNegocio();
                            int inasistencias = alumnoNegocio.contarInasistenciasMes(seleccionado.IdUsuario);

                            txtInasistenciasMes.Text = inasistencias.ToString();

                            if (seleccionado.Activo)
                            {
                                btnEliminar.Text = "Eliminar";
                                btnEliminar.CssClass = "btn btn-outline-danger";
                                btnEliminar.OnClientClick = "return confirm('¿Está seguro de eliminar este alumno?');";
                            }
                            else
                            {
                                btnEliminar.Text = "Reactivar";
                                btnEliminar.CssClass = "btn btn-success";
                                btnEliminar.OnClientClick = "return confirm('¿Está seguro de reactivar este alumno?');";
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        Response.Write("<script>alert('Error al cargar el alumno: " + ex.Message + "');</script>");
                    }
                }
                else
                {
                    lblTitulo.Text = "Nuevo Alumno";
                    txtEstado.Text = "Activo";
                    AlumnoNegocio negocio = new AlumnoNegocio();
                    txtIdUsuario.Text = negocio.obtenerProximoId().ToString();
                }
            }
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            Page.Validate();

            if (!Page.IsValid)
                return;

            try
            {
                Alumno nuevo = new Alumno();
                AlumnoNegocio negocio = new AlumnoNegocio();

                string nombre = txtNombre.Text.Trim();

                if (string.IsNullOrWhiteSpace(nombre))
                {
                    lblError.Text = "El nombre es obligatorio.";
                    lblError.Visible = true;
                    return;
                }

                string apellido = txtApellido.Text.Trim();

                if (string.IsNullOrWhiteSpace(apellido))
                {
                    lblError.Text = "El apellido es obligatorio.";
                    lblError.Visible = true;
                    return;
                }

                string dni = txtDni.Text.Trim();

                if (string.IsNullOrWhiteSpace(dni))
                {
                    lblError.Text = "El DNI es obligatorio.";
                    lblError.Visible = true;
                    return;
                }

                string email = txtEmail.Text.Trim();

                if (string.IsNullOrWhiteSpace(email))
                {
                    lblError.Text = "El email es obligatorio.";
                    lblError.Visible = true;
                    return;
                }

                string tel = txtTelefono.Text.Trim();

                if (string.IsNullOrWhiteSpace(tel))
                {
                    lblError.Text = "El teléfono es obligatorio.";
                    lblError.Visible = true;
                    return;
                }

                string fecNac = txtFechaNacimiento.Text;

                if (string.IsNullOrWhiteSpace(fecNac))
                {
                    lblError.Text = "La fecha de nacimiento es obligatoria.";
                    lblError.Visible = true;
                    return;
                }

                DateTime fechaNacimiento = DateTime.Parse(fecNac);

                if (fechaNacimiento.Date > DateTime.Today)
                {
                    lblError.Text = "La fecha de nacimiento no puede ser posterior a la fecha actual.";
                    lblError.Visible = true;
                    return;
                }

                int? idAlumno = null;

                if (Request.QueryString["id"] != null)
                {
                    idAlumno = int.Parse(Request.QueryString["id"]);
                }

                UsuarioNegocio usuarioNegocio = new UsuarioNegocio();

                if (usuarioNegocio.existeUsuario(dni, email, idAlumno))
                {
                    lblError.Text = "Ya existe un usuario con ese DNI o email.";
                    lblError.Visible = true;
                    return;
                }

                nuevo.Nombre = nombre;
                nuevo.Apellido = apellido;
                nuevo.Email = email;
                nuevo.DNI = dni;
                nuevo.Telefono = tel;
                nuevo.FechaNacimiento = fechaNacimiento;
                nuevo.Observaciones = txtObservaciones.Text.Trim();
                nuevo.Imagen = "default-user";

                if (Request.QueryString["id"] != null)
                {
                    nuevo.IdUsuario = int.Parse(Request.QueryString["id"]);
                    negocio.modificar(nuevo);
                    Response.Write("<script>alert('Alumno modificado correctamente');window.location='EditarAlumnos.aspx';</script>");
                }
                else
                {
                    EmailService service = new EmailService();

                    string cuerpo = @"
                    <h2>¡Bienvenido a Centro Fitness! 🏋️‍♂️</h2>
                    <p>Tu cuenta fue creada correctamente y ya podés acceder a nuestra aplicación web.</p>
                    <p>
                    <b>Usuario:</b> " + nuevo.Email + @"<br/>
                    <b>Contraseña inicial:</b> 1234
                    </p>
                    <p>
                    Por razones de seguridad, te recomendamos iniciar sesión y cambiar tu contraseña lo antes posible.
                    </p>
                    <p>
                    Desde la sección <b>Mi Perfil</b> podrás:
                    </p>
                    <ul>
                        <li>Modificar tu contraseña.</li>
                        <li>Actualizar tu número de teléfono.</li>
                        <li>Agregar o cambiar tu foto de perfil.</li>
                        <li>Consultar tu información personal.</li>
                        <li> Visualizar la información de tu suscripción vigente.</li>
                    </ul>
                    <p>
                    Además, encontrarás las siguientes funcionalidades:
                    </p>
                    <ul>
                        <li>
                            <b> Disciplinas:</ b > podrás consultar todas las actividades disponibles e inscribirte en las clases que desees realizar.
                        </li>
                        <li>
                            <b> Mis Reservas:</ b > podrás visualizar las reservas realizadas, consultar su información y gestionar cancelaciones cuando corresponda.
                        </li>
                    </ul>
                    <p>
                    Podés acceder a la aplicación desde:
                    <br/>
                    <a href='https://www.centro-fitness.com'>www.centro-fitness.com</a>
                    </p>
                    <p>
                    ¡Gracias por confiar en nosotros y te deseamos muchos éxitos en tu entrenamiento! 💪
                    </p>
                    <hr/>
                    <small>
                    Este es un mensaje automático. Por favor, no responder a este correo.
                    </small>";

                    service.armarCorreo(nuevo.Email, "Bienvenido a Centro Fitness", cuerpo);
                    service.enviarEmail();

                    negocio.agregar(nuevo);
                    Response.Write("<script>alert('Alumno agregado correctamente');window.location='EditarAlumnos.aspx';</script>");
                }
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
                lblError.Visible = true;
            }
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            try
            {
                AlumnoNegocio negocio = new AlumnoNegocio();

                int idAlumno = int.Parse(Request.QueryString["id"]);

                Alumno alumno = negocio.listar().Find(x => x.IdUsuario == idAlumno);

                UsuarioNegocio usuarioNegocio = new UsuarioNegocio();

                if (alumno.Activo)
                {
                    negocio.eliminar(idAlumno);
                    usuarioNegocio.enviarMailCambioEstadoCuenta(alumno.Email, false);
                    Response.Write("<script>alert('Alumno eliminado correctamente');window.location='EditarAlumnos.aspx';</script>");
                }
                else
                {
                    negocio.reactivar(idAlumno);
                    usuarioNegocio.enviarMailCambioEstadoCuenta(alumno.Email, true);
                    Response.Write("<script>alert('Alumno reactivado correctamente');window.location='EditarAlumnos.aspx';</script>");
                }
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
                lblError.Visible = true;
            }
        }

    }
}
