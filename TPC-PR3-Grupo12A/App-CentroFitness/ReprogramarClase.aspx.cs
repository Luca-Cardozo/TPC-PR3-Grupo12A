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
                }
            }

        }

        protected void btnReprogramar_Click(object sender, EventArgs e)
        {
            try
            {
                int idClaseOriginal = int.Parse(txtIdClase.Text);

                ClaseNegocio claseNegocio = new ClaseNegocio();

                Clase claseOriginal = claseNegocio.obtenerPorId(idClaseOriginal);

                DateTime nuevaFecha = DateTime.Parse(txtNuevaFecha.Text);

                if (nuevaFecha <= claseOriginal.Fecha)
                {
                    throw new Exception("La nueva fecha debe ser posterior a la fecha original.");
                }
                int nuevaHora = int.Parse(ddlNuevaHora.SelectedValue);

                if (claseNegocio.existeClase(nuevaFecha, nuevaHora))
                {
                    throw new Exception("Ya existe una clase programada en ese horario.");
                }

                Clase nuevaClase = new Clase();

                nuevaClase.Disciplina = claseOriginal.Disciplina;
                nuevaClase.Instructor = claseOriginal.Instructor;
                nuevaClase.CupoMaximo = claseOriginal.CupoMaximo;

                nuevaClase.Fecha = nuevaFecha;
                nuevaClase.HoraInicio = nuevaHora;

                nuevaClase.Estado = EstadoClase.Vigente;

                claseNegocio.agregar(nuevaClase);

                ReservaNegocio reservaNegocio = new ReservaNegocio();

                reservaNegocio.trasladarReservas(
                    claseOriginal.IdClase,
                    nuevaClase.IdClase);

                claseNegocio.cambiarEstadoClase(
                    claseOriginal.IdClase,
                    EstadoClase.Reprogramada);

                Response.Redirect("EditarClases.aspx", false);
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
                lblError.Visible = true;
            }

        }


    }


}