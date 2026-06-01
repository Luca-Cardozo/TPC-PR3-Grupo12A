using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dominio;
using Negocio;

namespace App_CentroFitness
{
    public partial class EditarDisciplinas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DisciplinaNegocio negocio = new DisciplinaNegocio();
                Session.Add("listaDisciplinas", negocio.listar());
                dgvDisciplinas.DataSource = Session["listaDisciplinas"];
                dgvDisciplinas.DataBind();
            }
        }
    }
}