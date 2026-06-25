using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Instrumentation;
using System.Web;
using System.Web.DynamicData;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App_CentroFitness
{
    public partial class FormularioClase : System.Web.UI.Page
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
                cargarInstructores();

                if (Request.QueryString["id"] != null)
                {
                    int idClase = int.Parse(Request.QueryString["id"]);
                    cargarClase(idClase);
                }
                else
                {
                    ClaseNegocio negocio = new ClaseNegocio();
                    txtIdClase.Text = negocio.obtenerProximoId().ToString();
                    btnEliminar.Visible = false;
                }
            }
        }


        protected void ddlInstructor_SelectedIndexChanged(object sender, EventArgs e)
        {
            int idInstructor = int.Parse(ddlInstructor.SelectedValue);
            cargarDisciplinasInstructor(idInstructor);
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            Page.Validate();
            if (!Page.IsValid)
                return;

            try
            {
                ClaseNegocio negocio = new ClaseNegocio();
                Clase nueva = new Clase();

                if (ddlInstructor.SelectedValue == "0")
                {
                    lblError.Text = "Debe seleccionar un instructor.";
                    lblError.Visible = true;
                    return;
                }

                if (ddlDisciplina.SelectedValue == "0")
                {
                    lblError.Text = "Debe seleccionar una disciplina.";
                    lblError.Visible = true;
                    return;
                }

                if (string.IsNullOrWhiteSpace(txtFecha.Text))
                {
                    lblError.Text = "Debe seleccionar una fecha.";
                    lblError.Visible = true;
                    return;
                }

                if (ddlHora.SelectedValue == "0")
                {
                    lblError.Text = "Debe seleccionar un horario.";
                    lblError.Visible = true;
                    return;
                }

                if (string.IsNullOrWhiteSpace(txtCupoMaximo.Text))
                {
                    lblError.Text = "Debe ingresar un cupo.";
                    lblError.Visible = true;
                    return;
                }

                int cupo;

                if (!int.TryParse(txtCupoMaximo.Text, out cupo))
                {
                    lblError.Text = "El cupo debe ser numérico.";
                    lblError.Visible = true;
                    return;
                }

                if (cupo < 1 || cupo > 15)
                {
                    lblError.Text = "El cupo debe estar entre 1 y 15.";
                    lblError.Visible = true;
                    return;
                }

                DateTime fechaHoraClase = DateTime.Parse(txtFecha.Text).AddHours(int.Parse(ddlHora.SelectedValue));

                if (fechaHoraClase < DateTime.Now)
                {
                    lblError.Text = "No puede cargar una clase en una fecha u horario pasado.";
                    lblError.Visible = true;
                    return;
                }

                int? idExcluir = null;

                if (Request.QueryString["id"] != null)
                {
                    idExcluir = int.Parse(txtIdClase.Text);
                }

                bool existe = negocio.existeClase(DateTime.Parse(txtFecha.Text), int.Parse(ddlHora.SelectedValue), idExcluir);

                if (existe)
                {
                    lblError.Text = "Ya existe una clase vigente programada para ese día y horario.";
                    lblError.Visible = true;
                    return;
                }

                nueva.Instructor = new Instructor();
                nueva.Instructor.IdUsuario = int.Parse(ddlInstructor.SelectedValue);

                nueva.Disciplina = new Disciplina();
                nueva.Disciplina.IdDisciplina = int.Parse(ddlDisciplina.SelectedValue);

                nueva.Fecha = DateTime.Parse(txtFecha.Text);

                nueva.HoraInicio = int.Parse(ddlHora.SelectedValue);

                nueva.CupoMaximo = int.Parse(txtCupoMaximo.Text);

                if (Request.QueryString["id"] != null)
                {
                    nueva.IdClase = int.Parse(txtIdClase.Text);

                    // Para que se conserve el estado que ya tenía antes cuando se hace una modificación
                    Clase claseActual = ((List<Clase>)Session["listaClases"]).Find(x => x.IdClase == nueva.IdClase);
                    nueva.Estado = claseActual.Estado;

                    negocio.modificar(nueva);
                }
                else
                {
                    negocio.agregar(nueva);
                }

                Response.Redirect("EditarClases.aspx", false);
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
                int idClase = int.Parse(txtIdClase.Text);

                ClaseNegocio negocio = new ClaseNegocio();

                List<Clase> lista = (List<Clase>)Session["listaClases"];

                Clase seleccionada = lista.Find(x => x.IdClase == idClase);

                if (seleccionada.Estado == EstadoClase.Vigente)
                {
                    ReservaNegocio reservaNegocio = new ReservaNegocio();
                    reservaNegocio.cancelarClasePorCentroFitness(idClase);
                }
                else if (seleccionada.Estado == EstadoClase.Cancelada)
                {
                    negocio.reactivar(idClase);
                }

                Response.Redirect("EditarClases.aspx", false);
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
                lblError.Visible = true;
            }
        }

        private void cargarInstructores()
        {
            InstructorNegocio negocio = new InstructorNegocio();
            ddlInstructor.DataSource = negocio.listar().FindAll(x => x.Activo == true);
            ddlInstructor.DataTextField = "NombreCompleto";
            ddlInstructor.DataValueField = "IdUsuario";
            ddlInstructor.DataBind();
            ddlInstructor.Items.Insert(0, new ListItem("Seleccione un instructor", "0"));
        }

        private void cargarDisciplinasInstructor(int idInstructor)
        {
            InstructorNegocio negocio = new InstructorNegocio();
            ddlDisciplina.DataSource = negocio.listarDisciplinasPorInstructor(idInstructor);
            ddlDisciplina.DataTextField = "Nombre";
            ddlDisciplina.DataValueField = "IdDisciplina";
            ddlDisciplina.DataBind();
            ddlDisciplina.Items.Insert(0, new ListItem("Seleccione una disciplina", "0"));
        }

        private void cargarClase(int idClase)
        {
            try
            {
                List<Clase> lista;

                if (Session["listaClases"] != null)
                {
                    lista = (List<Clase>)Session["listaClases"];
                }
                else
                {
                    ClaseNegocio negocio = new ClaseNegocio();
                    lista = negocio.listar();
                }

                Clase seleccionada = lista.Find(x => x.IdClase == idClase);

                if (seleccionada != null)
                {
                    txtIdClase.Text = seleccionada.IdClase.ToString();

                    txtFecha.Text = seleccionada.Fecha.ToString("yyyy-MM-dd");

                    txtCupoMaximo.Text = seleccionada.CupoMaximo.ToString();

                    ddlHora.SelectedValue = seleccionada.HoraInicio.ToString();

                    ddlInstructor.SelectedValue = seleccionada.Instructor.IdUsuario.ToString();

                    cargarDisciplinasInstructor(seleccionada.Instructor.IdUsuario);

                    ddlDisciplina.SelectedValue = seleccionada.Disciplina.IdDisciplina.ToString();


                    if (seleccionada.Estado == EstadoClase.Vigente)
                    {
                        lblTitulo.Text = "Editar Clase";
                        btnAceptar.Visible = true;
                        btnEliminar.Visible = true;

                        btnEliminar.Text = "Eliminar";
                        btnEliminar.CssClass = "btn btn-danger";
                        btnEliminar.OnClientClick = "return confirm('¿Está seguro de cancelar esta clase?');";
                    }
                    else
                    {
                        lblTitulo.Text = "Consulta de Clase";
                        ddlInstructor.Enabled = false;
                        ddlDisciplina.Enabled = false;
                        txtFecha.Enabled = false;
                        ddlHora.Enabled = false;
                        txtCupoMaximo.Enabled = false;

                        btnAceptar.Visible = false;
                        btnEliminar.Visible = false;
                    }

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