using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App_CentroFitness
{
    public partial class FormularioInstructor : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                cargarDisciplinas();
                if (Request.QueryString["id"] != null)
                {
                    int idSeleccionado = int.Parse(Request.QueryString["id"]);

                    btnEliminar.Visible = true;

                    try
                    {

                        List<Instructor> lista;
                        if (Session["listaInstructores"] != null)
                        {
                            lista = (List<Instructor>)Session["listaInstructores"];
                        }
                        else
                        {
                            InstructorNegocio negocio = new InstructorNegocio();
                            lista = negocio.listar();
                        }

                        Instructor seleccionado = lista.Find(x => x.IdUsuario == idSeleccionado);

                        if (seleccionado != null)
                        {
                            InstructorNegocio negocio = new InstructorNegocio();

                            txtIdUsuario.Text = seleccionado.IdUsuario.ToString();
                            txtNombre.Text = seleccionado.Nombre;
                            txtApellido.Text = seleccionado.Apellido;
                            txtDni.Text = seleccionado.DNI;
                            txtEmail.Text = seleccionado.Email;
                            txtTelefono.Text = seleccionado.Telefono;
                            txtFechaNacimiento.Text = seleccionado.FechaNacimiento.ToString("yyyy-MM-dd");

                            seleccionado.Disciplinas = negocio.listarDisciplinasPorInstructor(seleccionado.IdUsuario);

                            foreach (ListItem item in cblDisciplinas.Items)
                            {
                                item.Selected = seleccionado.Disciplinas.Any(x => x.IdDisciplina == int.Parse(item.Value));
                            }

                            if (seleccionado.Activo)
                            {
                                btnEliminar.Text = "Eliminar";
                                btnEliminar.CssClass = "btn btn-danger";
                                btnEliminar.OnClientClick = "return confirm('¿Está seguro de eliminar este instructor?');";
                            }
                            else
                            {
                                btnEliminar.Text = "Reactivar";
                                btnEliminar.CssClass = "btn btn-success";
                                btnEliminar.OnClientClick = "return confirm('¿Está seguro de reactivar este instructor?');";
                            }
                        }
                    }
                    catch (Exception ex)
                    {

                        Response.Write("<script>alert('Error al cargar el instructor: " + ex.Message + "');</script>");
                    }
                }
                else
                {
                    InstructorNegocio negocio = new InstructorNegocio();
                    txtIdUsuario.Text = negocio.obtenerProximoId().ToString();
                }
            }

        }

        private void cargarDisciplinas()
        {
            DisciplinaNegocio negocio = new DisciplinaNegocio();
            cblDisciplinas.DataSource = negocio.listar();
            cblDisciplinas.DataTextField = "Nombre";
            cblDisciplinas.DataValueField = "IdDisciplina";
            cblDisciplinas.DataBind();
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            Page.Validate();

            if (!Page.IsValid)
                return;

            try
            {
                Instructor nuevo = new Instructor();
                InstructorNegocio negocio = new InstructorNegocio();

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

                // Validar la selección de al menos una disciplina
                bool selecciono = cblDisciplinas.Items.Cast<ListItem>().Any(x => x.Selected);

                if (!selecciono)
                {
                    lblError.Text = "Debe seleccionar al menos una disciplina.";
                    lblError.Visible = true;
                    return;
                }

                int? idInstructor = null;

                if (Request.QueryString["id"] != null)
                {
                    idInstructor = int.Parse(Request.QueryString["id"]);
                }

                if (negocio.existeInstructor(dni, email, idInstructor))
                {
                    lblError.Text = "Ya existe un instructor con ese DNI o email.";
                    lblError.Visible = true;
                    return;
                }

                nuevo.Nombre = txtNombre.Text;
                nuevo.Apellido = txtApellido.Text;
                nuevo.Email = txtEmail.Text;
                nuevo.DNI = txtDni.Text;
                nuevo.Telefono = txtTelefono.Text;
                nuevo.FechaNacimiento = DateTime.Parse(txtFechaNacimiento.Text);

                if (Request.QueryString["id"] != null)
                {
                    nuevo.IdUsuario = int.Parse(Request.QueryString["id"]);
                    negocio.modificar(nuevo);
                    negocio.eliminarDisciplinasInstructor(nuevo.IdUsuario);
                }
                else
                {
                    negocio.agregar(nuevo);
                }

                foreach (ListItem item in cblDisciplinas.Items)
                {
                    if (item.Selected)
                    {
                        negocio.agregarDisciplinaInstructor(nuevo.IdUsuario, int.Parse(item.Value));
                    }
                }

                Response.Redirect("Instructores.aspx", false);
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
                InstructorNegocio negocio = new InstructorNegocio();

                int idInstructor = int.Parse(Request.QueryString["id"]);

                Instructor instructor = negocio.listar().Find(x => x.IdUsuario == idInstructor);

                if (instructor.Activo)
                {
                    negocio.eliminar(idInstructor);
                }
                else
                {
                    negocio.reactivar(idInstructor);
                }

                Response.Redirect("Instructores.aspx", false);
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
                lblError.Visible = true;
            }
        }
    }
}