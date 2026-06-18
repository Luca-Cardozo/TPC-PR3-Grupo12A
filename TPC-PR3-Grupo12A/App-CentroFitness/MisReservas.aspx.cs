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
    public partial class MisReservas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null)
            {
                Response.Write("<script>alert('Debe iniciar sesión para acceder a esta página.');" +
                                "window.location='Login.aspx';</script>");
                return;
            }

            Usuario usuario = (Usuario)Session["usuario"];

            if (usuario.Rol != Rol.Alumno)
            {
                Response.Write("<script>alert('Debe ser alumno para acceder a esta sección.');" +
                                "window.location='Home.aspx';</script>");
                return;
            }

            if (!IsPostBack)
            {
                cargarDisciplinasFiltro();
                cargarReservas();
            }
        }

        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            List<Reserva> lista = (List<Reserva>)Session["listaReservas"];
            int idDisciplina = int.Parse(ddlDisciplinaFiltro.SelectedValue);
            int estado = int.Parse(ddlEstadoFiltro.SelectedValue);

            if (idDisciplina != 0)
            {
                lista = lista.FindAll(x => x.Clase.Disciplina.IdDisciplina == idDisciplina);
            }

            if (!string.IsNullOrWhiteSpace(txtDesde.Text))
            {
                DateTime desde = DateTime.Parse(txtDesde.Text);
                lista = lista.FindAll(x => x.Clase.Fecha.Date >= desde.Date);
            }

            if (!string.IsNullOrWhiteSpace(txtHasta.Text))
            {
                DateTime hasta = DateTime.Parse(txtHasta.Text);
                lista = lista.FindAll(x => x.Clase.Fecha.Date <= hasta.Date);
            }

            if (estado != 0)
            {
                lista = lista.FindAll(x => (int)x.Estado == estado);
            }

            rptReservas.DataSource = lista;
            rptReservas.DataBind();
        }

        protected void btnRecargar_Click(object sender, EventArgs e)
        {
            txtDesde.Text = "";
            txtHasta.Text = "";
            ddlDisciplinaFiltro.SelectedIndex = 0;
            ddlEstadoFiltro.SelectedIndex = 0;

            cargarReservas();
        }

        private void cargarReservas()
        {
            Usuario usuario = (Usuario)Session["usuario"];
            ReservaNegocio negocio = new ReservaNegocio();
            List<Reserva> lista = negocio.listarPorAlumno(usuario.IdUsuario);
            Session["listaReservas"] = lista;
            rptReservas.DataSource = lista;
            rptReservas.DataBind();
        }

        private void cargarDisciplinasFiltro()
        {
            DisciplinaNegocio negocio = new DisciplinaNegocio();
            List<Disciplina> lista = negocio.listar();
            lista = lista.FindAll(x => x.Activa);
            ddlDisciplinaFiltro.DataSource = lista;
            ddlDisciplinaFiltro.DataTextField = "Nombre";
            ddlDisciplinaFiltro.DataValueField = "IdDisciplina";
            ddlDisciplinaFiltro.DataBind();
            ddlDisciplinaFiltro.Items.Insert(0, new ListItem("Todas las disciplinas", "0"));
        }
    }
}