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
    public partial class EditarReservas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    cargarDisciplinasFiltro();
                    cargarReservas();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error al listar reservas: " + ex.Message + "');</script>");
                }
            }
        }

        private void cargarReservas()
        {
            ReservaNegocio negocio = new ReservaNegocio();
            List<Reserva> lista = negocio.listar();
            Session["listaReservas"] = lista;
            dgvReservas.DataSource = lista;
            dgvReservas.DataBind();
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

        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            List<Reserva> lista = (List<Reserva>)Session["listaReservas"];
            int idDisciplina = int.Parse(ddlDisciplinaFiltro.SelectedValue);
            int estado = int.Parse(ddlEstadoFiltro.SelectedValue);
            string nombre = txtNombreFiltro.Text.Trim().ToLower();
            string apellido = txtApellidoFiltro.Text.Trim().ToLower();
            string dni = txtDniFiltro.Text.Trim();

            if (!string.IsNullOrWhiteSpace(nombre))
            {
                lista = lista.FindAll(x => x.Alumno.Nombre.ToLower().Contains(nombre));
            }

            if (!string.IsNullOrWhiteSpace(apellido))
            {
                lista = lista.FindAll(x => x.Alumno.Apellido.ToLower().Contains(apellido));
            }

            if (!string.IsNullOrWhiteSpace(dni))
            {
                lista = lista.FindAll(x => x.Alumno.DNI.Contains(dni));
            }

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

            dgvReservas.DataSource = lista;
            dgvReservas.DataBind();
        }

        protected void btnRecargar_Click(object sender, EventArgs e)
        {
            txtNombreFiltro.Text = "";
            txtApellidoFiltro.Text = "";
            txtDniFiltro.Text = "";
            txtDesde.Text = "";
            txtHasta.Text = "";
            ddlDisciplinaFiltro.SelectedIndex = 0;
            ddlEstadoFiltro.SelectedIndex = 0;

            cargarReservas();
        }

        protected void btnEditar_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int id = int.Parse(btn.CommandArgument);
            Response.Redirect("FormularioReserva.aspx?id=" + id, false);
        }

        protected void btnNuevaReserva_Click(object sender, EventArgs e)
        {
            Response.Redirect("AltaReserva.aspx", false);
        }


        protected void btnReprogramar_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int id = int.Parse(btn.CommandArgument);

            Response.Redirect("ReprogramarReserva.aspx?id=" + id, false);
        }

    }
}