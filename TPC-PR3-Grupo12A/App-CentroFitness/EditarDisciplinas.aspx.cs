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
            if (!Seguridad.esAdmin(Session))
            {
                Response.Redirect("AccesoDenegado.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                cargarDisciplinas();
            }
        }

        protected void dgvDisciplinas_SelectedIndexChanged(object sender, EventArgs e)
        {
            string id = dgvDisciplinas.SelectedDataKey.Value.ToString();
            Response.Redirect("FormularioDisciplina.aspx?id=" + id);
        }

        protected void ddlEstado_SelectedIndexChanged(object sender, EventArgs e)
        {
            int estado = int.Parse(ddlEstado.SelectedValue);
            cargarDisciplinas(estado);
        }

        private void cargarDisciplinas(int estado = 0)
        {
            DisciplinaNegocio negocio = new DisciplinaNegocio();
            List<Disciplina> lista = negocio.listar();
            Session["listaDisciplinas"] = lista;

            if (estado == 1)
            {
                lista = lista.FindAll(x => x.Activa);
            }
            else if (estado == 2)
            {
                lista = lista.FindAll(x => !x.Activa);
            }

            dgvDisciplinas.DataSource = lista;
            dgvDisciplinas.DataBind();
        }

        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }
    }
}