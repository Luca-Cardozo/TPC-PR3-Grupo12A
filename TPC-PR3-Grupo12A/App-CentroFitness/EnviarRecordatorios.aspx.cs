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
    public partial class EnviarRecordatorios : System.Web.UI.Page
    {

        // Clase auxiliar para manejar la información desplegada en la pantalla
        private class ClaseRecordatorio
        {
            public int IdClase { get; set; }
            public Disciplina Disciplina { get; set; }
            public Instructor Instructor { get; set; }
            public DateTime Fecha { get; set; }
            public int HoraInicio { get; set; }
            public int HoraFin { get; set; }
            public int CantidadReservas { get; set; }
            public bool RecordatorioEnviado { get; set; }
            public string RecordatorioTexto { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Seguridad.esAdmin(Session) && !Seguridad.esRecepcionista(Session))
            {
                Response.Redirect("AccesoDenegado.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                cargarClases();
            }
        }

        private void cargarClases()
        {
            DateTime fechaDiaSiguiente = DateTime.Today.AddDays(1);

            ClaseNegocio claseNegocio = new ClaseNegocio();
            ReservaNegocio reservaNegocio = new ReservaNegocio();

            List<Clase> clases = claseNegocio.listarVigentesPorFecha(fechaDiaSiguiente);
            List<ClaseRecordatorio> recordatorios = new List<ClaseRecordatorio>();

            foreach (Clase clase in clases)
            {
                List<Reserva> reservas = reservaNegocio.listarVigentesPorClase(clase.IdClase);

                bool enviado = claseNegocio.tieneRecordatorioEnviado(clase.IdClase);
                DateTime? fechaEnvio = claseNegocio.obtenerFechaUltimoRecordatorio(clase.IdClase);

                ClaseRecordatorio aux = new ClaseRecordatorio();

                aux.IdClase = clase.IdClase;
                aux.Disciplina = clase.Disciplina;
                aux.Instructor = clase.Instructor;
                aux.Fecha = clase.Fecha;
                aux.HoraInicio = clase.HoraInicio;
                aux.HoraFin = clase.HoraFin;
                aux.CantidadReservas = reservas.Count;
                aux.RecordatorioEnviado = enviado;

                if (enviado && fechaEnvio.HasValue)
                    aux.RecordatorioTexto = "Enviado el " + fechaEnvio.Value.ToString("dd/MM/yyyy HH:mm");
                else
                    aux.RecordatorioTexto = "Pendiente";

                recordatorios.Add(aux);
            }

            dgvClases.DataSource = recordatorios;
            dgvClases.DataBind();

            lblSinClases.Visible = recordatorios.Count == 0;
        }

        protected void dgvClases_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "EnviarRecordatorio")
                return;

            try
            {
                int idClase = Convert.ToInt32(e.CommandArgument);

                ClaseNegocio claseNegocio = new ClaseNegocio();
                ReservaNegocio reservaNegocio = new ReservaNegocio();
                AlumnoNegocio alumnoNegocio = new AlumnoNegocio();

                Clase clase = claseNegocio.obtenerPorId(idClase);

                if (clase == null)
                    throw new Exception("No se encontró la clase seleccionada.");

                List<Reserva> reservas = reservaNegocio.listarVigentesPorClase(idClase);

                if (reservas.Count == 0)
                    throw new Exception("La clase seleccionada no tiene alumnos con reservas vigentes.");

                int enviados = 0;

                foreach (Reserva reserva in reservas)
                {
                    alumnoNegocio.enviarMailRecordatorioClase(reserva.Alumno.Email, reserva.Alumno.Nombre, clase);

                    enviados++;
                }

                claseNegocio.registrarRecordatorio(idClase, enviados);

                lblMensaje.Text = "Recordatorios enviados correctamente. Total enviados: " + enviados;
                lblMensaje.CssClass = "alert alert-success d-block text-center";
                lblMensaje.Visible = true;

                cargarClases();
            }
            catch (Exception ex)
            {
                lblMensaje.Text = "Error al enviar recordatorios: " + ex.Message;
                lblMensaje.CssClass = "alert alert-danger d-block text-center";
                lblMensaje.Visible = true;
            }
        }

        protected void btnVolver_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }
    }
}