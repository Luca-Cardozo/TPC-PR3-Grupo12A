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
    public partial class MisClases : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["usuario"] == null)
                {
                    Response.Redirect("Login.aspx", false);
                    return;
                }

                Usuario usuario = (Usuario)Session["usuario"];

                if (usuario.Rol != Rol.Instructor)
                {
                    Response.Write("<script>alert('Debe ser instructor para acceder a esta sección.');window.location='Home.aspx';</script>");
                    return;
                }

                lblTitulo.Text = "Bienvenido/a " + usuario.Nombre;

                cargarClasesInstructor(usuario.IdUsuario);

                dgvAsistencia.Visible = false;
                btnGuardarAsistencia.Visible = false;
                lblInfoClase.Visible = false;
            }
        }

        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }



        private void cargarClasesInstructor(int idInstructor)
        {
            ReservaNegocio negocio = new ReservaNegocio();
            List<Reserva> reservas = negocio.listarVigentesPorInstructor(idInstructor);

            var clases = reservas
                .GroupBy(r => r.Clase.IdClase)
                .Select(g => new
                {
                    IdClase = g.First().Clase.IdClase,
                    Descripcion = g.First().Clase.Disciplina.Nombre + " - " +
                                  g.First().Clase.Fecha.ToString("dd/MM/yyyy") + " - " +
                                  g.First().Clase.HoraInicio + ":00"
                })
                .ToList();

            ddlClases.DataSource = clases;
            ddlClases.DataTextField = "Descripcion";
            ddlClases.DataValueField = "IdClase";
            ddlClases.DataBind();

            ddlClases.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Seleccione una clase", "0"));
        }
        private void cargarAsistencia()
        {
            Usuario usuario = (Usuario)Session["usuario"];
            int idClase = int.Parse(ddlClases.SelectedValue);

            ReservaNegocio negocio = new ReservaNegocio();
            List<Reserva> reservas = negocio.listarVigentesPorInstructor(usuario.IdUsuario);

            List<Reserva> reservasClase = reservas.FindAll(x => x.Clase.IdClase == idClase);

            dgvAsistencia.DataSource = reservasClase;
            dgvAsistencia.DataBind();

            if (reservasClase.Count > 0)
            {
                Reserva primera = reservasClase[0];

                lblInfoClase.Text =
                    primera.Clase.Disciplina.Nombre + " - " +
                    primera.Clase.Fecha.ToString("dd/MM/yyyy") + " - " +
                    primera.Clase.HoraInicio + ":00 a " +
                    primera.Clase.HoraFin + ":00 | Reservados: " +
                    reservasClase.Count + "/" + primera.Clase.CupoMaximo;

                lblInfoClase.Visible = true;
            }

            dgvAsistencia.Visible = true;
            btnGuardarAsistencia.Visible = true;
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            ddlClases.SelectedIndex = 0;
            dgvAsistencia.Visible = false;
            btnGuardarAsistencia.Visible = false;
            lblInfoClase.Visible = false;
        }
        protected void btnBuscarClase_Click(object sender, EventArgs e)
        {
            if (ddlClases.SelectedValue == "0")
                return;

            cargarAsistencia();
        }
        protected void btnGuardarAsistencia_Click(object sender, EventArgs e)
        {
            try
            {
                ReservaNegocio negocio = new ReservaNegocio();

                foreach (GridViewRow fila in dgvAsistencia.Rows)
                {
                    int idReserva = (int)dgvAsistencia.DataKeys[fila.RowIndex].Value;

                    CheckBox chkAsistio = (CheckBox)fila.FindControl("chkAsistio");
                    TextBox txtObservaciones = (TextBox)fila.FindControl("txtObservaciones");

                    negocio.actualizarAsistencia(
                        idReserva,
                        chkAsistio.Checked,
                        txtObservaciones.Text.Trim()
                    );
                }
                
                int idClase = int.Parse(ddlClases.SelectedValue);

                if (dgvAsistencia.Rows.Count > 0)
                {
                    ClaseNegocio claseNegocio = new ClaseNegocio();
                    claseNegocio.finalizarClase(idClase);
                }

                Response.Write("<script>alert('Asistencia registrada correctamente.');" +
                               "window.location='MisClases.aspx';</script>");

            }
            catch (Exception ex)
            {
                lblInfoClase.Text = "Error al guardar asistencia: " + ex.Message;
                lblInfoClase.CssClass = "alert alert-danger d-block text-center";
                lblInfoClase.Visible = true;
            }
        }
    }
}