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
    public partial class ListadoInstructores : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            InstructorNegocio negocio = new InstructorNegocio();
            if (!IsPostBack)
            {
                List<Instructor> lista = negocio.listar();
                repInstructores.DataSource = lista.FindAll(x => x.Activo == true);
                repInstructores.DataBind();
            }
        }

        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }
    }
}