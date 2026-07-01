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
            if (!Seguridad.esInstructor(Session))
            {
                Response.Redirect("AccesoDenegado.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                Usuario usuario = Seguridad.usuarioActual(Session);

                lblTitulo.Text = "Bienvenido/a " + usuario.Nombre;

                cargarClasesInstructor(usuario.IdUsuario);
                cargarProximasClases(usuario.IdUsuario);

                pnlAsistencia.Visible = false;
                lblInfoClase.Visible = false;
            }
        }

        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }



        private void cargarClasesInstructor(int idInstructor)
        {
            ClaseNegocio negocio = new ClaseNegocio();
            List<Clase> clases = negocio.listarVigentesPorInstructor(idInstructor);

            var mostrarClases = clases
                 .Select(c => new
                 {
                     IdClase = c.IdClase,
                     Descripcion = c.Disciplina.Nombre + " - " +
                          c.Fecha.ToString("dd/MM/yyyy") + " - " +
                          c.HoraInicio + ":00"
                 })
        .ToList();

            ddlClases.DataSource = mostrarClases;
            ddlClases.DataTextField = "Descripcion";
            ddlClases.DataValueField = "IdClase";
            ddlClases.DataBind();

            ddlClases.Items.Insert(0, new ListItem("Seleccione una clase", "0"));
        }

        private void cargarAsistencia()
        {
            Usuario usuario = (Usuario)Session["usuario"];
            int idClase = int.Parse(ddlClases.SelectedValue);

            ClaseNegocio claseNegocio = new ClaseNegocio();
            Clase claseSeleccionada = claseNegocio.obtenerPorId(idClase);

            DateTime fechaHoraClase = claseSeleccionada.Fecha.Date.AddHours(claseSeleccionada.HoraInicio);

            if (fechaHoraClase > DateTime.Now)
            {
                lblInfoClase.Text = "La asistencia solo puede registrarse una vez que la clase haya comenzado.";
                lblInfoClase.CssClass = "alert alert-warning d-block text-center";
                lblInfoClase.Visible = true;

                dgvAsistencia.DataSource = null;
                dgvAsistencia.DataBind();

                pnlProximasClases.Visible = false;
                pnlAsistencia.Visible = false;

                return;
            }

            ReservaNegocio negocio = new ReservaNegocio();
            List<Reserva> reservas = negocio.listarVigentesPorInstructor(usuario.IdUsuario);

            List<Reserva> reservasClase = reservas.FindAll(x => x.Clase.IdClase == idClase);


            if (reservasClase.Count == 0)
            {
                lblInfoClase.Text = "La clase seleccionada aún no posee alumnos inscriptos.";
                lblInfoClase.CssClass = "alert alert-warning d-block text-center";
                lblInfoClase.Visible = true;

                dgvAsistencia.DataSource = null;
                dgvAsistencia.DataBind();

                pnlProximasClases.Visible = false;
                pnlAsistencia.Visible = false;

                return;
            }
            dgvAsistencia.DataSource = reservasClase;
            dgvAsistencia.DataBind();


            Reserva primera = reservasClase[0];

            lblInfoClase.Text =
                primera.Clase.Disciplina.Nombre + " - " +
                primera.Clase.Fecha.ToString("dd/MM/yyyy") + " - " +
                primera.Clase.HoraInicio + ":00 a " +
                primera.Clase.HoraFin + ":00 | Reservados: " +
                reservasClase.Count + "/" + primera.Clase.CupoMaximo;

            lblInfoClase.CssClass = "alert alert-info d-block text-center";
            lblInfoClase.Visible = true;

            pnlProximasClases.Visible = false;
            pnlAsistencia.Visible = true;
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            limpiarPantalla();
        }

        protected void btnGuardarAsistencia_Click(object sender, EventArgs e)
        {
            try
            {
                ReservaNegocio negocio = new ReservaNegocio();

                int idClase = int.Parse(ddlClases.SelectedValue);

                ClaseNegocio claseNegocio = new ClaseNegocio();
                Clase clase = claseNegocio.obtenerPorId(idClase);

                DateTime fechaHoraClase = clase.Fecha.Date.AddHours(clase.HoraInicio);

                if (fechaHoraClase > DateTime.Now)
                    throw new Exception("No se puede registrar asistencia de una clase que todavía no comenzó.");

                foreach (GridViewRow fila in dgvAsistencia.Rows)
                {
                    int idReserva = (int)dgvAsistencia.DataKeys[fila.RowIndex].Value;

                    CheckBox chkPresente = (CheckBox)fila.FindControl("chkPresente");
                    TextBox txtObservaciones = (TextBox)fila.FindControl("txtObservaciones");

                    EstadoAsistencia asistencia;

                    if (chkPresente.Checked)
                        asistencia = EstadoAsistencia.Presente;
                    else
                        asistencia = EstadoAsistencia.Ausente;

                    negocio.actualizarAsistencia(
                        idReserva,
                        asistencia,
                        txtObservaciones.Text.Trim()
                    );
                }

                if (dgvAsistencia.Rows.Count > 0)
                {
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

        protected void ddlClases_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlClases.SelectedValue == "0")
            {
                limpiarPantalla();
                return;
            }
            cargarAsistencia();
        }

        private void limpiarPantalla()
        {
            ddlClases.SelectedIndex = 0;
            pnlAsistencia.Visible = false;
            lblInfoClase.Visible = false;

            dgvAsistencia.DataSource = null;
            dgvAsistencia.DataBind();

            pnlProximasClases.Visible = true;
        }

        private void cargarProximasClases(int idInstructor)
        {
            ClaseNegocio claseNegocio = new ClaseNegocio();
            ReservaNegocio reservaNegocio = new ReservaNegocio();

            DateTime hoy = DateTime.Today;
            DateTime maniana = DateTime.Today.AddDays(1);

            List<Clase> clases = claseNegocio.listarVigentesPorInstructor(idInstructor);

            clases = clases.FindAll(x => x.Fecha.Date >= hoy && x.Fecha.Date <= maniana);

            foreach (Clase clase in clases)
            {
                clase.CantidadReservas = reservaNegocio.contarReservasVigentes(clase.IdClase);
            }

            rptProximasClases.DataSource = clases;
            rptProximasClases.DataBind();

            lblSinProximasClases.Visible = clases.Count == 0;
        }
    }
}