using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App_CentroFitness
{
    public partial class FormularioSuscripcion : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] == null)
                {
                    Response.Redirect("EditarAlumnos.aspx", false);
                    return;
                }

                cargarAlumno();
                cargarPlanes();
                cargarMeses();
                cargarAnios();
                cargarSuscripcionActual();
                actualizarNuevaVigencia();
            }
        }

        protected void btnAlta_Click(object sender, EventArgs e)
        {
            Page.Validate("Suscripcion");

            if (!Page.IsValid)
                return;

            try
            {
                int idAlumno = obtenerIdAlumno();
                int idPlan = int.Parse(ddlPlanes.SelectedValue);
                int mes = int.Parse(ddlMes.SelectedValue);
                int anio = int.Parse(ddlAnio.SelectedValue);

                SuscripcionNegocio negocio = new SuscripcionNegocio();
                negocio.altaSuscripcion(idAlumno, idPlan, mes, anio);

                lblMensaje.Text = "Suscripción dada de alta correctamente. Redirigiendo...";
                lblMensaje.CssClass = "text-success fw-bold";
                lblMensaje.Visible = true;

                ScriptManager.RegisterStartupScript(this, GetType(), "redirect", "setTimeout(function(){ window.location='EditarAlumnos.aspx'; }, 3000);", true);
            }
            catch (Exception ex)
            {
                lblMensaje.Text = ex.Message;
                lblMensaje.CssClass = "text-danger fw-bold";
                lblMensaje.Visible = true;
            }
        }

        protected void btnActualizar_Click(object sender, EventArgs e)
        {
            Page.Validate("Suscripcion");

            if (!Page.IsValid)
                return;

            try
            {
                int idAlumno = obtenerIdAlumno();
                int idPlan = int.Parse(ddlPlanes.SelectedValue);
                int mes = int.Parse(ddlMes.SelectedValue);
                int anio = int.Parse(ddlAnio.SelectedValue);

                SuscripcionNegocio negocio = new SuscripcionNegocio();
                negocio.actualizarSuscripcion(idAlumno, idPlan, mes, anio);

                lblMensaje.Text = "Suscripción actualizada correctamente. Redirigiendo...";
                lblMensaje.CssClass = "text-success fw-bold";
                lblMensaje.Visible = true;

                ScriptManager.RegisterStartupScript(this, GetType(), "redirect", "setTimeout(function(){ window.location='EditarAlumnos.aspx'; }, 3000);", true);
            }
            catch (Exception ex)
            {
                lblMensaje.Text = ex.Message;
                lblMensaje.CssClass = "text-danger fw-bold";
                lblMensaje.Visible = true;
            }
        }

        protected void btnVolver_Click(object sender, EventArgs e)
        {
            Response.Redirect("EditarAlumnos.aspx", false);
        }

        private int obtenerIdAlumno()
        {
            return int.Parse(Request.QueryString["id"]);
        }

        private void cargarAlumno()
        {
            int idAlumno = obtenerIdAlumno();

            AlumnoNegocio negocio = new AlumnoNegocio();
            List<Alumno> lista = negocio.listar();

            Alumno alumno = lista.Find(x => x.IdUsuario == idAlumno);

            if (alumno == null)
                throw new Exception("No se encontró el alumno seleccionado.");

            txtIdAlumno.Text = alumno.IdUsuario.ToString();
            txtNombre.Text = alumno.Nombre;
            txtApellido.Text = alumno.Apellido;
            txtDni.Text = alumno.DNI;
            txtEmail.Text = alumno.Email;
        }

        private void cargarPlanes()
        {
            PlanNegocio negocio = new PlanNegocio();
            List<Plan> lista = negocio.listar();

            lista = lista.FindAll(x => x.Activo);

            ddlPlanes.DataSource = lista;
            ddlPlanes.DataTextField = "Descripcion";
            ddlPlanes.DataValueField = "IdPlan";
            ddlPlanes.DataBind();

            ddlPlanes.Items.Insert(0, new ListItem("Seleccione un plan", "0"));
        }

        private void cargarMeses()
        {
            ddlMes.Items.Clear();

            ddlMes.Items.Add(new ListItem("Seleccione mes", "0"));

            for (int i = 1; i <= 12; i++)
            {
                string nombreMes = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(i);
                nombreMes = char.ToUpper(nombreMes[0]) + nombreMes.Substring(1);

                ddlMes.Items.Add(new ListItem(nombreMes, i.ToString()));
            }

            ddlMes.SelectedValue = DateTime.Today.Month.ToString();
        }

        private void cargarAnios()
        {
            ddlAnio.Items.Clear();

            ddlAnio.Items.Add(new ListItem("Seleccione año", "0"));

            int anioActual = DateTime.Today.Year;

            ddlAnio.Items.Add(new ListItem(anioActual.ToString(), anioActual.ToString()));
            ddlAnio.Items.Add(new ListItem((anioActual + 1).ToString(), (anioActual + 1).ToString()));
            ddlAnio.Items.Add(new ListItem((anioActual + 2).ToString(), (anioActual + 2).ToString()));

            ddlAnio.SelectedValue = anioActual.ToString();
        }

        private void cargarSuscripcionActual()
        {
            int idAlumno = obtenerIdAlumno();

            SuscripcionNegocio negocio = new SuscripcionNegocio();
            Suscripcion suscripcion = negocio.obtenerSuscripcionActualUsuario(idAlumno);

            if (suscripcion == null)
            {
                pnlSuscripcionActual.Visible = false;
                pnlSinSuscripcion.Visible = true;

                btnAlta.Visible = true;
                btnActualizar.Visible = false;

                return;
            }

            pnlSuscripcionActual.Visible = true;
            pnlSinSuscripcion.Visible = false;

            btnAlta.Visible = false;
            btnActualizar.Visible = true;

            txtPlanActual.Text = suscripcion.Plan.Descripcion;
            txtFechaInicio.Text = suscripcion.FechaInicio.ToString("dd/MM/yyyy");
            txtFechaFin.Text = suscripcion.FechaFin.ToString("dd/MM/yyyy");

            if (suscripcion.Plan.CantidadClases.HasValue)
            {
                txtClasesConsumidas.Text =
                    suscripcion.ClasesConsumidas + " / " + suscripcion.Plan.CantidadClases.Value;
            }
            else
            {
                txtClasesConsumidas.Text = "Pase libre";
            }

            if (suscripcion.EnGracia(DateTime.Now))
            {
                txtEstadoSuscripcion.Text = "En período de gracia";
            }
            else if (suscripcion.EstaVigente(DateTime.Now))
            {
                txtEstadoSuscripcion.Text = "Vigente";
            }
            else
            {
                txtEstadoSuscripcion.Text = "Vencida";
            }
        }

        private void actualizarNuevaVigencia()
        {
            txtNuevaVigencia.Text = "";

            if (ddlPlanes.SelectedValue == "0" || ddlMes.SelectedValue == "0" || ddlAnio.SelectedValue == "0")
            {
                return;
            }

            int idPlan = int.Parse(ddlPlanes.SelectedValue);
            int mes = int.Parse(ddlMes.SelectedValue);
            int anio = int.Parse(ddlAnio.SelectedValue);

            PlanNegocio planNegocio = new PlanNegocio();
            Plan plan = planNegocio.listar().Find(x => x.IdPlan == idPlan);

            if (plan == null)
                return;

            DateTime inicio = new DateTime(anio, mes, 1);
            DateTime fin = inicio.AddMonths(plan.DuracionMeses).AddDays(-1);

            txtNuevaVigencia.Text = inicio.ToString("dd/MM/yyyy") + " al " + fin.ToString("dd/MM/yyyy");
        }

        protected void datosVigencia_SelectedIndexChanged(object sender, EventArgs e)
        {
            actualizarNuevaVigencia();
        }

    }
}