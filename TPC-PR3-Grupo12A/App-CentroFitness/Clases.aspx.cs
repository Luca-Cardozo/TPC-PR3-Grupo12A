using Dominio;
using Negocio;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App_CentroFitness
{
    public partial class Clases : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Seguridad.esAlumno(Session))
            {
                Response.Redirect("AccesoDenegado.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                cargarClases();
            }
        }

        protected void btnVolver_Click(object sender, EventArgs e)
        {
            Response.Redirect("Disciplinas.aspx", false);
        }

        protected void btnSeleccionar_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int idClase = int.Parse(btn.CommandArgument);
            Response.Redirect("ConfirmarReserva.aspx?id=" + idClase, false);
        }

        protected void btnFiltrar_Click(object sender, EventArgs e)
        {
            List<Clase> lista = Session["listaClasesDisciplina"] as List<Clase>;

            if (lista == null)
            {
                cargarClases();
                return;
            }

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

            if (ddlDisponibilidad.SelectedValue == "1")
            {
                lista = lista.FindAll(x => x.CuposDisponibles > 0);
            }

            mostrarClases(lista);
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtFechaDesde.Text = "";
            txtFechaHasta.Text = "";
            ddlDisponibilidad.SelectedIndex = 0;

            List<Clase> lista = Session["listaClasesDisciplina"] as List<Clase>;

            if (lista != null)
                mostrarClases(lista);
            else
                cargarClases();
        }

        private void cargarClases()
        {
            ClaseNegocio negocio = new ClaseNegocio();

            int id;
            if (!int.TryParse(Request.QueryString["id"], out id))
            {
                Response.Redirect("Disciplinas.aspx", false);
                return;
            }

            List<Clase> lista = negocio.listarVigentesPorDisciplina(id);

            ReservaNegocio reservaNegocio = new ReservaNegocio();

            foreach (Clase clase in lista)
            {
                clase.CantidadReservas = reservaNegocio.contarReservasVigentes(clase.IdClase);
                clase.CuposDisponibles = clase.CupoMaximo - clase.CantidadReservas;
            }

            Session["listaClasesDisciplina"] = lista;

            mostrarClases(lista);
        }

        private void mostrarClases(List<Clase> lista)
        {
            repClases.DataSource = lista;
            repClases.DataBind();

            lblSinClases.Visible = lista.Count == 0;
        }
    }
}