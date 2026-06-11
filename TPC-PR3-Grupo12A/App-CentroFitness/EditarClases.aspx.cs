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
            if (!IsPostBack)
            {
                try
                {
                    cargarClases();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error al listar clases: " + ex.Message + "');</script>");
                }
            }
        }

        private void cargarClases()
        {
            ClaseNegocio negocio = new ClaseNegocio();
            List<Clase> lista = negocio.listar();
            Session["listaClases"] = lista;
            repClases.DataSource = lista;
            repClases.DataBind();
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

        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }

    }
}