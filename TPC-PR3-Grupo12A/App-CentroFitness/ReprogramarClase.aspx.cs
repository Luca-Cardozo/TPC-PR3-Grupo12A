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
    public partial class ReprogramaClase : System.Web.UI.Page
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
                if (Request.QueryString["id"] != null)
                {
                    int idClase = int.Parse(Request.QueryString["id"]);

                    ClaseNegocio negocio = new ClaseNegocio();
                    Clase clase = negocio.obtenerPorId(idClase);

                    txtIdClase.Text = clase.IdClase.ToString();
                    txtDisciplina.Text = clase.Disciplina.Nombre;
                    txtInstructor.Text = clase.Instructor.Nombre + " " + clase.Instructor.Apellido;
                    txtFechaActual.Text = clase.Fecha.ToString("dd/MM/yyyy");
                    txtHoraActual.Text = clase.HoraInicio + ":00";

                    ReservaNegocio reservaNegocio = new ReservaNegocio();
                    int reservasVigentes = reservaNegocio.contarReservasVigentes(clase.IdClase);

                    txtReservasVigentes.Text = reservasVigentes + " / " + clase.CupoMaximo;
                }
                else
                {
                    Response.Redirect("EditarClases.aspx", false);
                    return;
                }
            }

        }

        protected void btnReprogramar_Click(object sender, EventArgs e)
        {
            try
            {
                int idClaseOriginal = int.Parse(txtIdClase.Text);

                ClaseNegocio claseNegocio = new ClaseNegocio();
                ReservaNegocio reservaNegocio = new ReservaNegocio();
                SuscripcionNegocio suscripcionNegocio = new SuscripcionNegocio();

                Clase claseOriginal = claseNegocio.obtenerPorId(idClaseOriginal);

                if (claseOriginal == null)
                    throw new Exception("No se encontró la clase original.");

                if (string.IsNullOrWhiteSpace(txtNuevaFecha.Text))
                    throw new Exception("Debe ingresar una nueva fecha.");

                if (ddlNuevaHora.SelectedValue == "0")
                    throw new Exception("Debe seleccionar una nueva hora.");

                DateTime nuevaFecha = DateTime.Parse(txtNuevaFecha.Text);
                int nuevaHora = int.Parse(ddlNuevaHora.SelectedValue);

                DateTime nuevaFechaHora = nuevaFecha.Date.AddHours(nuevaHora);
                DateTime fechaHoraOriginal = claseOriginal.Fecha.Date.AddHours(claseOriginal.HoraInicio);

                if (nuevaFechaHora <= DateTime.Now)
                    throw new Exception("La nueva fecha y hora no pueden ser anteriores al momento actual.");

                if (nuevaFechaHora <= fechaHoraOriginal)
                    throw new Exception("La nueva fecha y hora debe ser posterior a la programación original.");

                if (claseNegocio.existeClase(nuevaFecha, nuevaHora))
                    throw new Exception("Ya existe una clase programada en ese horario.");


                Clase nuevaClase = new Clase();

                nuevaClase.Disciplina = claseOriginal.Disciplina;
                nuevaClase.Instructor = claseOriginal.Instructor;
                nuevaClase.CupoMaximo = claseOriginal.CupoMaximo;

                nuevaClase.Fecha = nuevaFecha;
                nuevaClase.HoraInicio = nuevaHora;

                nuevaClase.Estado = EstadoClase.Vigente;

                List<Reserva> reservas = reservaNegocio.listarVigentesPorClase(claseOriginal.IdClase);

                foreach (Reserva reserva in reservas)
                {
                    suscripcionNegocio.validarClaseDentroDeSuscripcion(reserva.Alumno.IdUsuario, nuevaClase);
                }

                claseNegocio.agregar(nuevaClase);

                reservaNegocio.trasladarReservas(claseOriginal.IdClase, nuevaClase.IdClase);

                claseNegocio.cambiarEstadoClase(claseOriginal.IdClase, EstadoClase.Reprogramada);

                Response.Write("<script>alert('Clase reprogramada correctamente');window.location='EditarClases.aspx';</script>");
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
                lblError.Visible = true;
            }

        }


    }


}