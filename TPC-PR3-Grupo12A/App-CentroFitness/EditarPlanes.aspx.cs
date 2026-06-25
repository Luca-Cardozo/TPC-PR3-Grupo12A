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
    public partial class EditarPlanes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Seguridad.esAdmin(Session))
            {
                Response.Redirect("AccesoDenegado.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                try
                {
                    cargarPlanes();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error al listar planes: " + ex.Message + "');</script>");
                }
            }
        }

        private void cargarPlanes()
        {
            PlanNegocio negocio = new PlanNegocio();
            List<Plan> lista = negocio.listar();
            Session["listaPlanes"] = lista;
            dgvPlanes.DataSource = lista;
            dgvPlanes.DataBind();
        }

        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }

        protected void btnEditarPlan_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string id = btn.CommandArgument;
            Response.Redirect("FormularioPlan.aspx?id=" + id, false);
        }

        protected void ddlEstadoFiltro_SelectedIndexChanged(object sender, EventArgs e)
        {
            int estado = int.Parse(ddlEstadoFiltro.SelectedValue);
            if (estado == 0)
            {
                cargarPlanes();
                return;
            }
            List<Plan> lista = (List<Plan>)Session["listaPlanes"];
            lista = estado == 1 ? lista.FindAll(x => x.Activo) : lista.FindAll(x => !x.Activo);
            dgvPlanes.DataSource = lista;
            dgvPlanes.DataBind();
        }

    }
}