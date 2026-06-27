using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static Negocio.ReservaNegocio;

namespace App_CentroFitness
{
    public partial class MisReservas : System.Web.UI.Page
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
                cargarDisciplinasFiltro();
                cargarReservas();
            }
        }

        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            List<Reserva> lista = (List<Reserva>)Session["listaReservas"];
            int idDisciplina = int.Parse(ddlDisciplinaFiltro.SelectedValue);
            int estado = int.Parse(ddlEstadoFiltro.SelectedValue);

            if (idDisciplina != 0)
            {
                lista = lista.FindAll(x => x.Clase.Disciplina.IdDisciplina == idDisciplina);
            }

            if (!string.IsNullOrWhiteSpace(txtDesde.Text))
            {
                DateTime desde = DateTime.Parse(txtDesde.Text);
                lista = lista.FindAll(x => x.Clase.Fecha.Date >= desde.Date);
            }

            if (!string.IsNullOrWhiteSpace(txtHasta.Text))
            {
                DateTime hasta = DateTime.Parse(txtHasta.Text);
                lista = lista.FindAll(x => x.Clase.Fecha.Date <= hasta.Date);
            }

            if (estado != 0)
            {
                lista = lista.FindAll(x => (int)x.Estado == estado);
            }

            rptReservas.DataSource = lista;
            rptReservas.DataBind();
        }

        protected void btnRecargar_Click(object sender, EventArgs e)
        {
            txtDesde.Text = "";
            txtHasta.Text = "";
            ddlDisciplinaFiltro.SelectedIndex = 0;
            ddlEstadoFiltro.SelectedIndex = 0;

            cargarReservas();
        }

        private void cargarReservas()
        {
            Usuario usuario = (Usuario)Session["usuario"];
            ReservaNegocio negocio = new ReservaNegocio();
            List<Reserva> lista = negocio.listarPorAlumno(usuario.IdUsuario);
            Session["listaReservas"] = lista;
            rptReservas.DataSource = lista;
            rptReservas.DataBind();
        }

        private void cargarDisciplinasFiltro()
        {
            DisciplinaNegocio negocio = new DisciplinaNegocio();
            List<Disciplina> lista = negocio.listar();
            lista = lista.FindAll(x => x.Activa);
            ddlDisciplinaFiltro.DataSource = lista;
            ddlDisciplinaFiltro.DataTextField = "Nombre";
            ddlDisciplinaFiltro.DataValueField = "IdDisciplina";
            ddlDisciplinaFiltro.DataBind();
            ddlDisciplinaFiltro.Items.Insert(0, new ListItem("Todas las disciplinas", "0"));
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            try
            {
                Button btn = (Button)sender;
                int idReserva = int.Parse(btn.CommandArgument);

                ReservaNegocio negocio = new ReservaNegocio();
                Reserva reserva = negocio.listar().Find(x => x.IdReserva == idReserva);
                negocio.cancelar(idReserva, true, TipoCancelacion.Alumno);

                EmailService email = new EmailService();

                string cuerpo = @"<h2>Reserva cancelada</h2>

                <p>Su reserva fue cancelada correctamente.</p>

                <p><strong>Detalle de la reserva cancelada</strong></p>

                <ul>
                <li><strong>Disciplina:</strong> " + reserva.Clase.Disciplina.Nombre + @"</li>
                <li><strong>Fecha:</strong> " + reserva.Clase.Fecha.ToString("dd/MM/yyyy") + @"</li>
                <li><strong>Horario:</strong> " + reserva.Clase.HoraInicio + @":00 hs</li>
                </ul>

                <p>El cupo correspondiente fue reintegrado automáticamente a su plan.</p>

                <br/>

                <p>Centro Fitness</p>";

                email.armarCorreo(
                    reserva.Alumno.Email,
                    "Cancelación de reserva - Centro Fitness",
                    cuerpo
                );

                email.enviarEmail();

                cargarReservas();

                Response.Write("<script>alert('Reserva cancelada correctamente');</script>");
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error al cancelar: " + ex.Message + "');</script>");
            }
        }

        public string obtenerClaseBadgeEstado(object estadoObj)
        {
            Estado estado = (Estado)estadoObj;

            switch (estado)
            {
                case Estado.Vigente:
                    return "badge bg-success px-3 py-2";

                case Estado.Cancelada:
                    return "badge bg-danger px-3 py-2";

                case Estado.Finalizada:
                    return "badge bg-secondary px-3 py-2";

                case Estado.Reprogramada:
                    return "badge bg-warning text-dark px-3 py-2";

                default:
                    return "badge bg-light text-dark px-3 py-2";
            }
        }

        public string obtenerTextoEstado(object estadoObj)
        {
            Estado estado = (Estado)estadoObj;

            switch (estado)
            {
                case Estado.Vigente:
                    return "Vigente";

                case Estado.Cancelada:
                    return "Cancelada";

                case Estado.Finalizada:
                    return "Finalizada";

                case Estado.Reprogramada:
                    return "Reprogramada";

                default:
                    return "Sin estado";
            }
        }
    }
}