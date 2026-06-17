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
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            Usuario usuario = (Usuario)Session["usuario"];
            if (usuario.Rol != Rol.Alumno)
            {
                Response.Write("<script>alert('Debe ser alumno para acceder a esta página.');window.location='Default.aspx';</script>");
                return;
            }

            if (!IsPostBack)
            {
                ClaseNegocio negocio = new ClaseNegocio();

                int id = int.Parse(Request.QueryString["id"]);
                List<Clase> lista = negocio.listarVigentesPorDisciplina(id);
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

        protected void btnSeleccionar_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int idClase = int.Parse(btn.CommandArgument);
            Response.Redirect("ConfirmarReserva.aspx?id=" + idClase, false);
        }
    }
}