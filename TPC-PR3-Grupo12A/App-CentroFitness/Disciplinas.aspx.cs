using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App_CentroFitness
{
    public partial class Disciplinas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DisciplinaNegocio negocio = new DisciplinaNegocio();
            if (!IsPostBack)
            {


                repDisciplinas.DataSource = negocio.listar();
                repDisciplinas.DataBind();
            }

        }

        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }

        protected void btnVerClases_Click(object sender, EventArgs e)
        {
            Response.Redirect("Clases.aspx", false);
        }
    }
}