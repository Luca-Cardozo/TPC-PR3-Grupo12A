using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App_CentroFitness
{
    public partial class FormularioAlumno : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
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

                            // imgAlumno.ImageUrl = "~/Images/" + seleccionado.Imagen + ".jpg";

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

                int? idAlumno = null;

                if (Request.QueryString["id"] != null)
                {
                    idAlumno = int.Parse(Request.QueryString["id"]);
                }

                if (negocio.existeAlumno(dni, email, idAlumno))
                {
                    lblError.Text = "Ya existe un alumno con ese DNI o email.";
                    lblError.Visible = true;
                    return;
                }

                nuevo.Nombre = nombre;
                nuevo.Apellido = apellido;
                nuevo.Email = email;
                nuevo.DNI = dni;
                nuevo.Telefono = tel;
                nuevo.FechaNacimiento = DateTime.Parse(fecNac);
                nuevo.Observaciones = txtObservaciones.Text.Trim();

                if (Request.QueryString["id"] != null)
                {
                    nuevo.IdUsuario = int.Parse(Request.QueryString["id"]);
                    negocio.modificar(nuevo);
                }
                else
                {
                    negocio.agregar(nuevo);
                }

                Response.Redirect("EditarAlumnos.aspx", false);
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

                if (alumno.Activo)
                {
                    negocio.eliminar(idAlumno);
                }
                else
                {
                    negocio.reactivar(idAlumno);
                }

                Response.Redirect("EditarAlumnos.aspx", false);
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
                lblError.Visible = true;
            }
        }
    }
}
