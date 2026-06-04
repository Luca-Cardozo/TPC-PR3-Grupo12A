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

            if (!IsPostBack)
            {
                ClaseNegocio negocio = new ClaseNegocio();

                int id = int.Parse(Request.QueryString["id"]);
                List<Clase> lista = negocio.listarPorDisciplina(id);
                if (lista.Count == 0)
                {
                    lblSinClases.Visible = true;
                }
                else
                {
                    repClases.DataSource = lista;
                    repClases.DataBind();
                }

            }
        }

        protected void btnVolver_Click(object sender, EventArgs e)
        {
            Response.Redirect("Disciplinas.aspx", false);
        }
    }
}