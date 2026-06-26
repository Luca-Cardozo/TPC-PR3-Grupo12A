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
    public partial class FormularioReserva : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (!Seguridad.esAdmin(Session) && !Seguridad.esRecepcionista(Session))
            {
                Response.Redirect("AccesoDenegado.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                cargarReserva();
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                Reserva reserva = new Reserva();
                reserva.IdReserva = int.Parse(Request.QueryString["id"]);
                reserva.Estado = (Estado)int.Parse(ddlEstado.SelectedValue);
                if (string.IsNullOrEmpty(ddlAsistencia.SelectedValue))
                    reserva.Asistencia = null;
                else
                    reserva.Asistencia = (EstadoAsistencia)int.Parse(ddlAsistencia.SelectedValue);
                reserva.Observaciones = string.IsNullOrWhiteSpace(txtObservaciones.Text) ? null : txtObservaciones.Text.Trim();
                ReservaNegocio negocio = new ReservaNegocio();
                if (reserva.Estado == Estado.Cancelada)
                {
                    negocio.cancelar(
                        reserva.IdReserva,
                        false,
                        TipoCancelacion.Alumno);
                }
                else
                {
                    negocio.modificar(reserva);
                }
                Response.Write("<script>alert('Reserva actualizada correctamente.');" +
                               "window.location='EditarReservas.aspx';</script>");
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error al guardar cambios: " + ex.Message + "');</script>");
            }
        }

        protected void btnVolver_Click(object sender, EventArgs e)
        {
            Response.Redirect("EditarReservas.aspx", false);
        }

        private void cargarReserva()
        {
            try
            {
                if (Request.QueryString["id"] == null)
                {
                    Response.Redirect("EditarReservas.aspx", false);
                    return;
                }

                int id = int.Parse(Request.QueryString["id"]);

                ReservaNegocio negocio = new ReservaNegocio();
                Reserva reserva = negocio.listar().Find(x => x.IdReserva == id);

                if (reserva == null)
                {
                    Response.Redirect("EditarReservas.aspx", false);
                    return;
                }

                txtIdReserva.Text = reserva.IdReserva.ToString();
                txtAlumno.Text = reserva.Alumno.Nombre + " " + reserva.Alumno.Apellido;
                txtClase.Text = reserva.Clase.Disciplina.Nombre.ToString() + " - " + reserva.Clase.Instructor.Nombre.ToString() + " " + reserva.Clase.Instructor.Apellido.ToString();
                txtFechaClase.Text = reserva.Clase.Fecha.ToString("dd/MM/yyyy");
                txtHorario.Text = reserva.Clase.HoraInicio.ToString() + ":00 - " + reserva.Clase.HoraFin.ToString() + ":00";
                ddlEstado.SelectedValue = ((int)reserva.Estado).ToString();
                if (reserva.Asistencia == null)
                    ddlAsistencia.SelectedValue = "";
                else
                    ddlAsistencia.SelectedValue = ((int)reserva.Asistencia.Value).ToString();
                txtObservaciones.Text = reserva.Observaciones;


                if (reserva.Estado == Estado.Vigente)
                {
                    lblTitulo.Text = "Editar Reserva";
                }
                else
                {
                    lblTitulo.Text = "Consulta de Reserva";

                    ddlEstado.Enabled = false;
                    ddlAsistencia.Enabled = false;
                    txtObservaciones.Enabled = false;

                    btnGuardar.Visible = false;
                }



            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error al cargar reserva: " + ex.Message + "');</script>");
            }
        }

    }
}