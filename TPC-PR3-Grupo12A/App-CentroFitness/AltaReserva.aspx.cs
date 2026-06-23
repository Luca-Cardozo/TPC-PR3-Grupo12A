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
    public partial class AltaReserva : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //if (Session["usuario"] == null)
                //{
                //    Response.Redirect("Login.aspx", false);
                //    return;
                //}

                //Usuario usuario = (Usuario)Session["usuario"];

                cargarDisciplinas();
                cargarInstructores();
                cargarAlumnos();
                cargarClases();

                pnlSeleccionClase.Visible = true;
                pnlDatosReserva.Visible = false;
            }
        }

        private void cargarDisciplinas()
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

        private void cargarInstructores()
        {
            InstructorNegocio negocio = new InstructorNegocio();
            List<Instructor> lista = negocio.listar();
            lista = lista.FindAll(x => x.Activo);

            ddlInstructorFiltro.DataSource = lista;
            ddlInstructorFiltro.DataTextField = "NombreCompleto";
            ddlInstructorFiltro.DataValueField = "IdUsuario";
            ddlInstructorFiltro.DataBind();

            ddlInstructorFiltro.Items.Insert(0, new ListItem("Todos los instructores", "0"));
        }

        private void cargarAlumnos()
        {
            AlumnoNegocio negocio = new AlumnoNegocio();
            List<Alumno> lista = negocio.listar();
            lista = lista.FindAll(x => x.Activo);

            ddlAlumno.DataSource = lista;
            ddlAlumno.DataTextField = "NombreCompleto";
            ddlAlumno.DataValueField = "IdUsuario";
            ddlAlumno.DataBind();

            ddlAlumno.Items.Insert(0, new ListItem("Seleccione un alumno", "0"));
        }

        private void cargarClases()
        {
            ClaseNegocio negocio = new ClaseNegocio();
            ReservaNegocio reservaNegocio = new ReservaNegocio();

            List<Clase> lista = negocio.listar();
            List<Clase> disponibles = new List<Clase>();

            DateTime ahora = DateTime.Now;

            foreach (Clase clase in lista)
            {
                DateTime fechaHoraClase = clase.Fecha.Date.AddHours(clase.HoraInicio);
                if (clase.Estado == EstadoClase.Vigente && fechaHoraClase > ahora)
                {
                    clase.CantidadReservas = reservaNegocio.contarReservasVigentes(clase.IdClase);
                    clase.CuposDisponibles = clase.CupoMaximo - clase.CantidadReservas;
                    disponibles.Add(clase);
                }
            }

            Session["listaClases"] = disponibles;
            repClases.DataSource = disponibles;
            repClases.DataBind();
            lblSinClases.Visible = disponibles.Count == 0;
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            List<Clase> lista = (List<Clase>)Session["listaClases"];
            int idDisciplina = int.Parse(ddlDisciplinaFiltro.SelectedValue);
            int idInstructor = int.Parse(ddlInstructorFiltro.SelectedValue);

            if (idDisciplina != 0)
            {
                lista = lista.FindAll(x => x.Disciplina.IdDisciplina == idDisciplina);
            }

            if (idInstructor != 0)
            {
                lista = lista.FindAll(x => x.Instructor.IdUsuario == idInstructor);
            }

            if (!string.IsNullOrWhiteSpace(txtFechaDesde.Text))
            {
                DateTime desde = DateTime.Parse(txtFechaDesde.Text);
                lista = lista.FindAll(x => x.Fecha.Date >= desde.Date);
            }

            if (!string.IsNullOrWhiteSpace(txtFechaHasta.Text))
            {
                DateTime hasta = DateTime.Parse(txtFechaHasta.Text);
                lista = lista.FindAll(x => x.Fecha.Date <= hasta.Date);
            }

            repClases.DataSource = lista;
            repClases.DataBind();

            lblSinClases.Visible = lista.Count == 0;
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            ddlDisciplinaFiltro.SelectedIndex = 0;
            ddlInstructorFiltro.SelectedIndex = 0;
            txtFechaDesde.Text = "";
            txtFechaHasta.Text = "";
            cargarClases();
        }

        protected void btnSeleccionar_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int idClase = int.Parse(btn.CommandArgument);
            Session["idClaseSeleccionada"] = idClase;
            List<Clase> clases = (List<Clase>)Session["listaClases"];
            Clase seleccionada = clases.Find(x => x.IdClase == idClase);
            txtClaseSeleccionada.Text = seleccionada.Disciplina.Nombre + " - " + seleccionada.Fecha.ToString("dd/MM/yyyy") + " - " + seleccionada.HoraInicio + ":00 hs";

            pnlSeleccionClase.Visible = false;
            pnlDatosReserva.Visible = true;
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {

            if (!Page.IsValid)
                return;

            try
            {
                if (ddlAlumno.SelectedValue == "0")
                    throw new Exception("Seleccione un alumno.");

                if (Session["idClaseSeleccionada"] == null)
                    throw new Exception("Seleccione una clase.");

                Reserva nueva = new Reserva();
                nueva.Alumno = new Alumno();
                nueva.Alumno.IdUsuario = int.Parse(ddlAlumno.SelectedValue);
                nueva.Clase = new Clase();
                nueva.Clase.IdClase = (int)Session["idClaseSeleccionada"];
                nueva.Observaciones = txtObservaciones.Text.Trim();

                ReservaNegocio negocio = new ReservaNegocio();
                negocio.agregar(nueva);

                Response.Write("<script>alert('Reserva registrada correctamente');" +
                               "window.location='EditarReservas.aspx';</script>");
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }

        protected void btnVolver_Click(object sender, EventArgs e)
        {
            Response.Redirect("EditarReservas.aspx", false);
        }

        protected void btnCambiarClase_Click(object sender, EventArgs e)
        {
            Session["idClaseSeleccionada"] = null;
            txtClaseSeleccionada.Text = "";

            pnlSeleccionClase.Visible = true;
            pnlDatosReserva.Visible = false;
        }

        protected void ddlAlumno_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblClasesDisponiblesAlumno.Visible = false;

            if (ddlAlumno.SelectedValue == "0")
                return;

            try
            {
                int idAlumno = int.Parse(ddlAlumno.SelectedValue);

                SuscripcionNegocio negocio = new SuscripcionNegocio();
                Suscripcion suscripcion = negocio.obtenerSuscripcionActualUsuario(idAlumno);

                if (suscripcion == null || !suscripcion.EstaVigente(DateTime.Now))
                {
                    lblClasesDisponiblesAlumno.Text = "El alumno no posee una suscripción vigente.";
                    lblClasesDisponiblesAlumno.CssClass = "d-block mt-2 fw-bold text-danger";
                    lblClasesDisponiblesAlumno.Visible = true;
                    return;
                }

                if (!suscripcion.Plan.CantidadClases.HasValue)
                {
                    lblClasesDisponiblesAlumno.Text = "Clases disponibles: pase libre";
                    lblClasesDisponiblesAlumno.CssClass = "d-block mt-2 fw-bold text-success";
                    lblClasesDisponiblesAlumno.Visible = true;
                    return;
                }

                int disponibles = suscripcion.Plan.CantidadClases.Value - suscripcion.ClasesConsumidas;

                lblClasesDisponiblesAlumno.Text = "Clases disponibles: " + disponibles + " de " + suscripcion.Plan.CantidadClases.Value;

                lblClasesDisponiblesAlumno.CssClass = disponibles > 0 ? "d-block mt-2 fw-bold text-success" : "d-block mt-2 fw-bold text-danger";
                lblClasesDisponiblesAlumno.Visible = true;
            }
            catch (Exception ex)
            {
                lblClasesDisponiblesAlumno.Text = ex.Message;
                lblClasesDisponiblesAlumno.CssClass = "d-block mt-2 fw-bold text-danger";
                lblClasesDisponiblesAlumno.Visible = true;
            }
        }
    }
}