using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App_CentroFitness
{
    public partial class EditarRecepcionistas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    RecepcionistaNegocio negocio = new RecepcionistaNegocio();

                    Session["listaRecepcionistas"] = negocio.listar();

                    dgvRecepcionistas.DataSource = Session["listaRecepcionistas"];
                    dgvRecepcionistas.DataBind();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error al listar recepcionistas: " + ex.Message + "');</script>");
                }
            }

        }

        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }

        protected void dgvRecepcionistas_SelectedIndexChanged(object sender, EventArgs e)
        {
            string id = dgvRecepcionistas.SelectedDataKey.Value.ToString();
            Response.Redirect("FormularioRecepcionista.aspx?id=" + id);
        }


    }
}