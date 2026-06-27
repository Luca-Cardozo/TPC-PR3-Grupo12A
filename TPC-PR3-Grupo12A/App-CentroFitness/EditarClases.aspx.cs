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
    public partial class EditarClases : System.Web.UI.Page
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
                try
                {
                    cargarClases();
                    cargarFiltros();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error al listar clases: " + ex.Message + "');</script>");
                }
            }
        }


        protected void btnNuevaClase_Click(object sender, EventArgs e)
        {
            Response.Redirect("FormularioClase.aspx", false);
        }

        protected void btnEditar_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int idClase = int.Parse(btn.CommandArgument);
            Response.Redirect("FormularioClase.aspx?id=" + idClase, false);
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            List<Clase> lista = (List<Clase>)Session["listaClases"];

            int idInstructor = int.Parse(ddlInstructorFiltro.SelectedValue);
            int idDisciplina = int.Parse(ddlDisciplinaFiltro.SelectedValue);
            int estado = int.Parse(ddlEstadoFiltro.SelectedValue);

            if (!string.IsNullOrWhiteSpace(txtFechaDesde.Text))
            {
                DateTime desde = DateTime.Parse(txtFechaDesde.Text);
                lista = lista.FindAll(x => x.Fecha.Date >= desde.Date);
            }

            if (!string.IsNullOrWhiteSpace(txtFechaHasta.Text))
            {
                DateTime hasta = DateTime.Parse(txtFechaHasta.Text);
                lista = lista.FindAll(x => x.Fecha.Date <= hasta.Date);
            }

            if (idInstructor != 0)
            {
                lista = lista.FindAll(x => x.Instructor.IdUsuario == idInstructor);
            }

            if (idDisciplina != 0)
            {
                lista = lista.FindAll(x => x.Disciplina.IdDisciplina == idDisciplina);
            }

            if (estado == 1)
            {
                lista = lista.FindAll(x => x.Estado == EstadoClase.Vigente);
            }
            else if (estado == 2)
            {
                lista = lista.FindAll(x => x.Estado == EstadoClase.Cancelada);
            }
            else if (estado == 3)
            {
                lista = lista.FindAll(x => x.Estado == EstadoClase.Finalizada);
            }
            else if (estado == 4)
            {
                lista = lista.FindAll(x => x.Estado == EstadoClase.Reprogramada);
            }

            repClases.DataSource = lista;
            repClases.DataBind();
        }

        protected void btnRecargar_Click(object sender, EventArgs e)
        {
            txtFechaDesde.Text = "";
            txtFechaHasta.Text = "";
            ddlInstructorFiltro.SelectedIndex = 0;
            ddlDisciplinaFiltro.SelectedIndex = 0;
            ddlEstadoFiltro.SelectedIndex = 0;
            cargarClases();
        }

        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }

        private void cargarClases()
        {
            ClaseNegocio negocio = new ClaseNegocio();
            List<Clase> lista = negocio.listar();
            //ordena en pantalla
            lista = lista
            .OrderBy(x => x.Estado == EstadoClase.Vigente ? 0 :
               x.Estado == EstadoClase.Reprogramada ? 1 :
               x.Estado == EstadoClase.Cancelada ? 2 : 3)
                .ThenBy(x => x.Fecha)
                .ThenBy(x => x.HoraInicio)
                .ToList();
            Session["listaClases"] = lista;
            repClases.DataSource = lista;
            repClases.DataBind();
        }
        private void cargarFiltros()
        {
            InstructorNegocio instructorNegocio = new InstructorNegocio();

            ddlInstructorFiltro.DataSource = instructorNegocio.listar().FindAll(x => x.Activo);
            ddlInstructorFiltro.DataTextField = "NombreCompleto";
            ddlInstructorFiltro.DataValueField = "IdUsuario";
            ddlInstructorFiltro.DataBind();
            ddlInstructorFiltro.Items.Insert(0, new ListItem("Todos", "0"));

            DisciplinaNegocio disciplinaNegocio = new DisciplinaNegocio();

            ddlDisciplinaFiltro.DataSource = disciplinaNegocio.listar().FindAll(x => x.Activa);
            ddlDisciplinaFiltro.DataTextField = "Nombre";
            ddlDisciplinaFiltro.DataValueField = "IdDisciplina";
            ddlDisciplinaFiltro.DataBind();
            ddlDisciplinaFiltro.Items.Insert(0, new ListItem("Todas", "0"));
        }


        protected void btnReprogramar_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int idClase = int.Parse(btn.CommandArgument);

            Response.Redirect("ReprogramarClase.aspx?id=" + idClase, false);
        }
        protected void btnVer_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int idClase = int.Parse(btn.CommandArgument);

            Response.Redirect("FormularioClase.aspx?id=" + idClase, false);
        }
    }
}