using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App_CentroFitness
{
    public partial class EditarReservas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    cargarReservas();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error al listar reservas: " + ex.Message + "');</script>");
                }
            }
        }

        private void cargarReservas()
        {
            ReservaNegocio negocio = new ReservaNegocio();


            dgvReservas.DataSource = negocio.listar();
            dgvReservas.DataBind();
        }
        protected void dgvReservas_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                int id = Convert.ToInt32(dgvReservas.SelectedDataKey.Value);

                ReservaNegocio negocio = new ReservaNegocio();
                negocio.eliminar(id);


                cargarReservas();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error al cancelar la reserva: " + ex.Message + "');</script>");
            }
        }
        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }
    }
}