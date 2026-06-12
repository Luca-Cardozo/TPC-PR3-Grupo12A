using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dominio;
using Negocio;

namespace App_CentroFitness
{
    public partial class ListadoAlumnos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    cargarAlumnos();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error al listar alumnos: " + ex.Message + "');</script>");
                }

            }
        }
        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }

        protected void dgvDisciplinas_SelectedIndexChanged(object sender, EventArgs e)
        {
            string id = dgvAlumnos.SelectedDataKey.Value.ToString();
            Response.Redirect("FormularioAlumno.aspx?id=" + id);
        }

        protected void dgvAlumnos_SelectedIndexChanged(object sender, EventArgs e)
        {
            string id = dgvAlumnos.SelectedDataKey.Value.ToString();
            Response.Redirect("FormularioAlumno.aspx?id=" + id);
        }
        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            List<Alumno> lista = (List<Alumno>)Session["listaAlumnos"];

            string nombre = txtNombreFiltro.Text.Trim().ToLower();
            string apellido = txtApellidoFiltro.Text.Trim().ToLower();
            string dni = txtDniFiltro.Text.Trim();
            int estado = int.Parse(ddlEstadoFiltro.SelectedValue);

            if (!string.IsNullOrWhiteSpace(nombre))
                lista = lista.FindAll(x => x.Nombre.ToLower().Contains(nombre));

            if (!string.IsNullOrWhiteSpace(apellido))
                lista = lista.FindAll(x => x.Apellido.ToLower().Contains(apellido));

            if (!string.IsNullOrWhiteSpace(dni))
                lista = lista.FindAll(x => x.DNI.Contains(dni));

            if (estado == 1)
                lista = lista.FindAll(x => x.Activo);
            else if (estado == 2)
                lista = lista.FindAll(x => !x.Activo);

            dgvAlumnos.DataSource = lista;
            dgvAlumnos.DataBind();
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtNombreFiltro.Text = "";
            txtApellidoFiltro.Text = "";
            txtDniFiltro.Text = "";
            ddlEstadoFiltro.SelectedIndex = 0;

            cargarAlumnos();
        }

        private void cargarAlumnos()
        {
            AlumnoNegocio negocio = new AlumnoNegocio();

            Session["listaAlumnos"] = negocio.listar();

            dgvAlumnos.DataSource = Session["listaAlumnos"];
            dgvAlumnos.DataBind();
        }
    }
}