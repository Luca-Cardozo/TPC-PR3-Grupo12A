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
    public partial class ReprogramarReserva : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                cargarDatosReserva();
            }
        }




        private void cargarDatosReserva()
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

                txtAlumno.Text = reserva.Alumno.Nombre + " " +
                                 reserva.Alumno.Apellido;

                txtClaseActual.Text = reserva.Clase.Disciplina.Nombre + " - " +
                                      reserva.Clase.Instructor.Nombre + " " +
                                      reserva.Clase.Instructor.Apellido;

                txtFechaActual.Text = reserva.Clase.Fecha.ToString("dd/MM/yyyy");

                txtHorarioActual.Text =
                    reserva.Clase.HoraInicio + ":00 - " +
                    reserva.Clase.HoraFin + ":00";

                cargarClasesDisponibles(
    reserva.Clase.Disciplina.IdDisciplina,
    reserva.Clase.IdClase,
    reserva.Alumno.IdUsuario);
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error al cargar reserva: " + ex.Message + "');</script>");
            }
        }
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                int idReserva = int.Parse(Request.QueryString["id"]);
                int idNuevaClase = int.Parse(ddlNuevaClase.SelectedValue);

                ReservaNegocio negocio = new ReservaNegocio();

                Reserva reserva = negocio.listar().Find(x => x.IdReserva == idReserva);
                negocio.reprogramar(idReserva, idNuevaClase);


                EmailService email = new EmailService();

                string cuerpo = @"<h2>Reserva reprogramada correctamente</h2>
                          <p>Tu clase fue reprogramada exitosamente.</p>
                          <p>Te esperamos en tu próxima actividad.</p>
                          <br/>
                          <p>Centro Fitness</p>";

                email.armarCorreo(
                    reserva.Alumno.Email,
                    "Reprogramación de reserva - Centro Fitness",
                    cuerpo);
                email.enviarEmail();

                Response.Write("<script>alert('Reserva reprogramada correctamente.'); window.location='EditarReservas.aspx';</script>");
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error al reprogramar reserva: " + ex.Message + "');</script>");
            }


        }




        protected void btnVolver_Click(object sender, EventArgs e)
        {
            Response.Redirect("EditarReservas.aspx", false);
        }

        private void cargarClasesDisponibles(int idDisciplina, int idClaseActual, int idAlumno)
        {
            ClaseNegocio claseNegocio = new ClaseNegocio();
            ReservaNegocio reservaNegocio = new ReservaNegocio();
            // Clases mismas disciplinas 
            List<Clase> lista = claseNegocio.listarVigentesPorDisciplina(idDisciplina);
            // no se muestra la misma clase, verifico cupos, reserva 2 veces la misma clase
            lista = lista.FindAll(x =>
                x.IdClase != idClaseActual &&
                reservaNegocio.contarReservasVigentes(x.IdClase) < x.CupoMaximo &&
                !reservaNegocio.existeReserva(idAlumno, x.IdClase)
            );
            // si en la lista no hay ninguna clase disponible..
            if (lista.Count == 0)
            {
                ddlNuevaClase.Items.Clear();
                ddlNuevaClase.Items.Add(new ListItem("No hay clases disponibles para reprogramar", "0"));
                btnGuardar.Enabled = false;
                return;
            }

            btnGuardar.Enabled = true;

            ddlNuevaClase.DataSource = lista;
            ddlNuevaClase.DataValueField = "IdClase";
            ddlNuevaClase.DataBind();

            foreach (ListItem item in ddlNuevaClase.Items)
            {
                Clase clase = lista.Find(x => x.IdClase.ToString() == item.Value);

                item.Text =
                    clase.Instructor.Nombre + " " +
                    clase.Instructor.Apellido + " - " +
                    clase.Fecha.ToString("dd/MM/yyyy") + " - " +
                    clase.HoraInicio + ":00";
            }
        }


    }
}