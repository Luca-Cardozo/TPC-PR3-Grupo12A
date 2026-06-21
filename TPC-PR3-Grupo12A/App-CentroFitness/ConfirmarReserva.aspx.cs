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
    public partial class ConfirmarReserva : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            Usuario usuario = (Usuario)Session["usuario"];

            if (usuario.Rol != Rol.Alumno)
            {
                Response.Write("<script>alert('Solo alumnos pueden reservar clases.');" +
                               "window.location='Default.aspx';</script>");
                return;
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["id"] == null)
                {
                    Response.Redirect("Clases.aspx", false);
                    return;
                }

                int idClase = int.Parse(Request.QueryString["id"]);

                ClaseNegocio negocio = new ClaseNegocio();
                Clase clase = negocio.obtenerPorId(idClase);

                if (clase == null)
                {
                    Response.Write("<script>alert('Clase no encontrada');" +
                                   "window.location='Clases.aspx';</script>");
                    return;
                }

                Session["idClaseSeleccionada"] = idClase;

                lblDisciplina.Text = clase.Disciplina.Nombre;
                lblInstructor.Text = clase.Instructor.Nombre + " " + clase.Instructor.Apellido;
                lblFecha.Text = clase.Fecha.ToString("dd/MM/yyyy");
                lblHorario.Text = clase.HoraInicio + ":00 - " + clase.HoraFin + ":00 hs";
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Response.Redirect("Clases.aspx", false);
        }

        protected void btnConfirmar_Click(object sender, EventArgs e)
        {
            try
            {
                Usuario usuario = (Usuario)Session["usuario"];
                int idClase = int.Parse(Request.QueryString["id"]);

                ClaseNegocio claseNegocio = new ClaseNegocio();
                Clase clase = claseNegocio.obtenerPorId(idClase);

                if (clase == null)
                    throw new Exception("La clase no existe.");

                DateTime fechaHora = clase.Fecha.Date.AddHours(clase.HoraInicio);

                if (clase.Estado != EstadoClase.Vigente || fechaHora <= DateTime.Now)
                    throw new Exception("La clase ya no está disponible.");

                
                ReservaNegocio reservaNegocio = new ReservaNegocio();

                int reservas = reservaNegocio.contarReservasVigentes(idClase);

                if (reservas >= clase.CupoMaximo)
                    throw new Exception("No hay cupos disponibles.");

                if (reservaNegocio.existeReserva(usuario.IdUsuario, idClase))
                    throw new Exception("Ya estás inscripto en esta clase.");

                Reserva reserva = new Reserva();
                reserva.Alumno = new Alumno();
                reserva.Alumno.IdUsuario = usuario.IdUsuario;

                reserva.Clase = new Clase();
                reserva.Clase.IdClase = idClase;

                reservaNegocio.agregar(reserva);

                lblMensaje.CssClass = "text-success text-center d-block mt-3";
                lblMensaje.Text = "Reserva realizada con éxito ✔. Serás redirigido en 3 segundos...";

                btnConfirmar.Enabled = false;

                Response.AddHeader("REFRESH", "3;URL=MisReservas.aspx");
            }
            catch (Exception ex)
            {
                lblMensaje.CssClass = "text-danger text-center d-block mt-3";
                lblMensaje.Text = ex.Message;
            }
        }
    }
}