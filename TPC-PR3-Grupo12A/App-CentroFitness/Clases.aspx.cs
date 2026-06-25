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
            if (!Seguridad.esAlumno(Session))
            {
                Response.Redirect("AccesoDenegado.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                ClaseNegocio negocio = new ClaseNegocio();

                int id;
                if (!int.TryParse(Request.QueryString["id"], out id))
                {
                    Response.Redirect("Disciplinas.aspx", false);
                    return;
                }

                List<Clase> lista = negocio.listarVigentesPorDisciplina(id);

                ReservaNegocio reservaNegocio = new ReservaNegocio();

                foreach (Clase clase in lista)
                {
                    clase.CantidadReservas = reservaNegocio.contarReservasVigentes(clase.IdClase);
                    clase.CuposDisponibles = clase.CupoMaximo - clase.CantidadReservas;
                }

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