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
    public partial class EditarRecepcionistas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    cargarRecepcionistas();
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

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            List<Recepcionista> lista = (List<Recepcionista>)Session["listaRecepcionistas"];

            string nombre = txtNombreFiltro.Text.Trim().ToLower();
            string apellido = txtApellidoFiltro.Text.Trim().ToLower();
            string dni = txtDniFiltro.Text.Trim();
            int estado = int.Parse(ddlEstadoFiltro.SelectedValue);

            if (!string.IsNullOrWhiteSpace(nombre))
                lista = lista.FindAll(x => x.Nombre.ToLower().Contains(nombre));

            if (!string.IsNullOrWhiteSpace(apellido))
                lista = lista.FindAll(x => x.Apellido.ToLower().Contains(apellido));

            if (!string.IsNullOrWhiteSpace(dni))
                lista = lista.FindAll(x => x.DNI.Contains(dni));

            if (estado == 1)
                lista = lista.FindAll(x => x.Activo);
            else if (estado == 2)
                lista = lista.FindAll(x => !x.Activo);

            dgvRecepcionistas.DataSource = lista;
            dgvRecepcionistas.DataBind();
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtNombreFiltro.Text = "";
            txtApellidoFiltro.Text = "";
            txtDniFiltro.Text = "";
            ddlEstadoFiltro.SelectedIndex = 0;

            cargarRecepcionistas();
        }

        private void cargarRecepcionistas()
        {
            RecepcionistaNegocio negocio = new RecepcionistaNegocio();

            Session["listaRecepcionistas"] = negocio.listar();

            dgvRecepcionistas.DataSource = Session["listaRecepcionistas"];
            dgvRecepcionistas.DataBind();
        }
    }


}
