using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App_CentroFitness
{
    public partial class EditarInstructores : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {

                    InstructorNegocio negocio = new InstructorNegocio();

                    Session.Add("listaInstructores", negocio.listar());


                    dgvInstructores.DataSource = Session["listaInstructores"];
                    dgvInstructores.DataBind();
                }
                catch (Exception ex)
                {

                    Response.Write("<script>alert('Error al listar instructores: " + ex.Message + "');</script>");
                }
            }
        }

        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }

        protected void dgvInstructores_SelectedIndexChanged(object sender, EventArgs e)
        {
            string id = dgvInstructores.SelectedDataKey.Value.ToString();
            Response.Redirect("FormularioInstructor.aspx?id=" + id);
        }
    }
}