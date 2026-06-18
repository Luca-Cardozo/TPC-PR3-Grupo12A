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
    public partial class MisClases : System.Web.UI.Page
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

                Usuario usuario = (Usuario)Session["usuario"];
                lblTitulo.Text = "Bienvenida " + usuario.Nombre;

                cargarClasesInstructor(usuario.IdUsuario);

                dgvAsistencia.Visible = false;
                btnGuardarAsistencia.Visible = false;
                lblInfoClase.Visible = false;
            }
        }

        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }



        private void cargarClasesInstructor(int idInstructor)
        {
            ReservaNegocio negocio = new ReservaNegocio();
            List<Reserva> reservas = negocio.listarPorInstructor(idInstructor);

            var clases = reservas
                .GroupBy(r => r.Clase.IdClase)
                .Select(g => new
                {
                    IdClase = g.First().Clase.IdClase,
                    Descripcion = g.First().Clase.Disciplina.Nombre + " - " +
                                  g.First().Clase.Fecha.ToString("dd/MM/yyyy") + " - " +
                                  g.First().Clase.HoraInicio + ":00"
                })
                .ToList();

            ddlClases.DataSource = clases;
            ddlClases.DataTextField = "Descripcion";
            ddlClases.DataValueField = "IdClase";
            ddlClases.DataBind();

            ddlClases.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Seleccione una clase", "0"));
        }



    }
}