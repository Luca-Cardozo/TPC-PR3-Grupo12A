using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App_CentroFitness
{
    public partial class EditarEstados : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }

        //protected void dgvEstados_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    string id = dgvEstados.SelectedDataKey.Value.ToString();
        //    Response.Redirect("FormularioEstado.aspx?id=" + id);
        //}

    }
}