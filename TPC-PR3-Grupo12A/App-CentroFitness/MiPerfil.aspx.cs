using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App_CentroFitness
{
    public partial class MiPerfil : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["usuario"] == null)
                {
                    Response.Redirect("Login.aspx", false);
                    return;
                }
                cargarPerfil();
            }
        }

        private void cargarPerfil()
        {
            Usuario usuario = (Usuario)Session["usuario"];

            txtRol.Text = usuario.Rol.ToString();
            txtNombre.Text = usuario.Nombre;
            txtApellido.Text = usuario.Apellido;
            txtDni.Text = usuario.DNI;
            txtTelefono.Text = usuario.Telefono;
            txtFechaNacimiento.Text = usuario.FechaNacimiento.ToString("dd/MM/yyyy");
            imgPerfil.ImageUrl = "~/Images/" + usuario.Imagen + ".jpg";

            if (usuario.Rol == Rol.Alumno)
            {
                pnlObservaciones.Visible = true;
                Alumno alumno = (Alumno)usuario;
                txtObservaciones.Text = alumno.Observaciones;
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                Usuario usuario = (Usuario)Session["usuario"];

                UsuarioNegocio negocio = new UsuarioNegocio();

                usuario.Telefono = txtTelefono.Text.Trim();

                if (usuario.Rol == Rol.Alumno)
                {
                    Alumno alumno = (Alumno)usuario;
                    alumno.Observaciones = txtObservaciones.Text.Trim();
                }

                if (txtImagen.PostedFile.FileName != "")
                {
                    string ruta = Server.MapPath("~/Images/");
                    string nombreArchivo;
                    if (usuario.Rol == Rol.Alumno)
                        nombreArchivo = "alumno-" + usuario.IdUsuario;
                    else if (usuario.Rol == Rol.Instructor)
                        nombreArchivo = "instructor-" + usuario.IdUsuario;
                    else if (usuario.Rol == Rol.Recepcionista)
                        nombreArchivo = "recepcionista-" + usuario.IdUsuario;
                    else
                        nombreArchivo = "admin-" + usuario.IdUsuario;
                    txtImagen.PostedFile.SaveAs(Path.Combine(ruta, nombreArchivo + ".jpg"));
                    usuario.Imagen = nombreArchivo;
                }

                bool cambiaPassword = !string.IsNullOrWhiteSpace(txtNuevaPassword.Text);

                if (cambiaPassword)
                {
                    if (txtPasswordActual.Text != usuario.Password)
                    {
                        throw new Exception("La contraseña actual no es correcta.");
                    }

                    if (txtNuevaPassword.Text != txtConfirmarPassword.Text)
                    {
                        throw new Exception("Las contraseñas no coinciden.");
                    }

                    usuario.Password = txtNuevaPassword.Text;
                }

                negocio.modificarPerfil(usuario);

                Session["usuario"] = usuario;

                lblError.Text = "Perfil actualizado correctamente. Redirigiendo al HOME...";

                lblError.CssClass = "text-success fw-bold";

                lblError.Visible = true;

                Response.AddHeader("REFRESH", "3;URL=Home.aspx");
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
                lblError.CssClass = "text-danger fw-bold";
                lblError.Visible = true;
            }
        }
    }
}