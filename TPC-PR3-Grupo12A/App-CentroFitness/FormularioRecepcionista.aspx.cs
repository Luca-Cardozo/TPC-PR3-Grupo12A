using Dominio;
using Microsoft.SqlServer.Server;
using Microsoft.Win32;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

namespace App_CentroFitness
{
    public partial class FormularioRecepcionista : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Seguridad.esAdmin(Session))
            {
                Response.Redirect("AccesoDenegado.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                btnEliminar.Visible = false;

                if (Request.QueryString["id"] != null)
                {
                    lblTitulo.Text = "Editar Recepcionista";

                    int idSeleccionado = int.Parse(Request.QueryString["id"]);
                    btnEliminar.Visible = true;

                    try
                    {
                        RecepcionistaNegocio negocio = new RecepcionistaNegocio();
                        List<Recepcionista> lista = negocio.listar();

                        Recepcionista seleccionado = lista.Find(x => x.IdUsuario == idSeleccionado);

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

                            if (seleccionado.Activo)
                            {
                                btnEliminar.Text = "Eliminar";
                                btnEliminar.CssClass = "btn btn-outline-danger";
                                btnEliminar.OnClientClick = "return confirm('¿Está seguro de eliminar este recepcionista?');";
                            }
                            else
                            {
                                btnEliminar.Text = "Reactivar";
                                btnEliminar.CssClass = "btn btn-success";
                                btnEliminar.OnClientClick = "return confirm('¿Está seguro de reactivar este recepcionista?');";
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        Response.Write("<script>alert('Error al cargar el recepcionista: " + ex.Message + "');</script>");
                    }
                }
                else
                {
                    lblTitulo.Text = "Nuevo Recepcionista";
                    txtEstado.Text = "Activo";

                    RecepcionistaNegocio negocio = new RecepcionistaNegocio();
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
                Recepcionista nuevo = new Recepcionista();
                RecepcionistaNegocio negocio = new RecepcionistaNegocio();

                string nombre = txtNombre.Text.Trim();
                string apellido = txtApellido.Text.Trim();
                string dni = txtDni.Text.Trim();
                string email = txtEmail.Text.Trim();
                string tel = txtTelefono.Text.Trim();
                string fecNac = txtFechaNacimiento.Text;

                if (string.IsNullOrWhiteSpace(nombre))
                {
                    lblError.Text = "El nombre es obligatorio.";
                    lblError.Visible = true;
                    return;
                }

                if (string.IsNullOrWhiteSpace(apellido))
                {
                    lblError.Text = "El apellido es obligatorio.";
                    lblError.Visible = true;
                    return;
                }

                if (string.IsNullOrWhiteSpace(dni))
                {
                    lblError.Text = "El DNI es obligatorio.";
                    lblError.Visible = true;
                    return;
                }

                if (string.IsNullOrWhiteSpace(email))
                {
                    lblError.Text = "El email es obligatorio.";
                    lblError.Visible = true;
                    return;
                }

                if (string.IsNullOrWhiteSpace(tel))
                {
                    lblError.Text = "El teléfono es obligatorio.";
                    lblError.Visible = true;
                    return;
                }

                if (string.IsNullOrWhiteSpace(fecNac))
                {
                    lblError.Text = "La fecha de nacimiento es obligatoria.";
                    lblError.Visible = true;
                    return;
                }

                int? idRecepcionista = null;

                if (Request.QueryString["id"] != null)
                    idRecepcionista = int.Parse(Request.QueryString["id"]);

                if (negocio.existeRecepcionista(dni, email, idRecepcionista))
                {
                    lblError.Text = "Ya existe un recepcionista con ese DNI o email.";
                    lblError.Visible = true;
                    return;
                }

                nuevo.Nombre = nombre;
                nuevo.Apellido = apellido;
                nuevo.Email = email;
                nuevo.DNI = dni;
                nuevo.Telefono = tel;
                nuevo.FechaNacimiento = DateTime.Parse(fecNac);
                nuevo.Imagen = "default-user";

                if (Request.QueryString["id"] != null)
                {
                    nuevo.IdUsuario = int.Parse(Request.QueryString["id"]);
                    negocio.modificar(nuevo);
                }
                else
                {
                    EmailService service = new EmailService();

                    string cuerpo = @"
                    <h2>¡Bienvenido a Centro Fitness! 🏋️‍♂️</h2>
                    <p>Tu cuenta de recepcionista fue creada correctamente y ya podés acceder a nuestra aplicación web.</p>
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
                    </ul>
                    <p>
                    Como recepcionista, tendrás acceso al <b>Panel de Administración</b>, desde donde podrás:
                    </p>
                    <ul>
                        <li> Dar de alta, modificar, eliminar y reactivar alumnos.</li>
                        <li> Gestionar las suscripciones y planes de los alumnos.</li>
                        <li> Dar de alta, modificar, eliminar y reactivar clases.</li>
                        <li> Registrar reservas para los alumnos.</li>
                        <li> Consultar y administrar las reservas existentes.</li>
                    </ul>
                    Podés acceder a la aplicación desde:
                    <br/>
                    <a href='https://www.centro-fitness.com'>www.centro-fitness.com</a>
                    </p>
                    <p>
                    ¡Gracias por formar parte del equipo de Centro Fitness! 💪
                    </p>
                    <hr/>
                    <small>
                    Este es un mensaje automático. Por favor, no responder a este correo.
                    </small>";

                    service.armarCorreo(nuevo.Email, "Bienvenido a Centro Fitness", cuerpo);
                    service.enviarEmail();

                    negocio.agregar(nuevo);
                }

                Response.Redirect("EditarRecepcionistas.aspx", false);
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
                RecepcionistaNegocio negocio = new RecepcionistaNegocio();

                int idRecepcionista = int.Parse(Request.QueryString["id"]);

                Recepcionista recepcionista = negocio.listar().Find(x => x.IdUsuario == idRecepcionista);

                UsuarioNegocio usuarioNegocio = new UsuarioNegocio();

                if (recepcionista.Activo)
                {
                    negocio.eliminar(idRecepcionista);
                    usuarioNegocio.enviarMailCambioEstadoCuenta(recepcionista.Email, false);
                }
                else
                {
                    negocio.reactivar(idRecepcionista);
                    usuarioNegocio.enviarMailCambioEstadoCuenta(recepcionista.Email, true);
                }

                Response.Redirect("EditarRecepcionistas.aspx", false);
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
                lblError.Visible = true;
            }
        }
    }
}
