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
    public partial class EditarInstructores : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Seguridad.esAdmin(Session))
            {
                Response.Redirect("AccesoDenegado.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                try
                {
                    cargarInstructores();
                    cargarDisciplinasFiltro();
                }
                catch (Exception ex)
                {

                    Response.Write("<script>alert('Error al listar instructores: " + ex.Message + "');</script>");
                }
            }
        }

        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }

        protected void dgvInstructores_SelectedIndexChanged(object sender, EventArgs e)
        {
            string id = dgvInstructores.SelectedDataKey.Value.ToString();
            Response.Redirect("FormularioInstructor.aspx?id=" + id);
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            List<Instructor> lista = (List<Instructor>)Session["listaInstructores"];

            string nombre = txtNombreFiltro.Text.Trim().ToLower();
            string apellido = txtApellidoFiltro.Text.Trim().ToLower();
            string dni = txtDniFiltro.Text.Trim();
            int estado = int.Parse(ddlEstadoFiltro.SelectedValue);
            int idDisciplina = int.Parse(ddlDisciplinaFiltro.SelectedValue);

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

            if (idDisciplina != 0)
            {
                InstructorNegocio negocio = new InstructorNegocio();
                // Devuelve a los instructores que tienen en su lista de disciplinas que dictan a la disciplina filtrada
                lista = lista.FindAll(instructor => negocio.listarDisciplinasPorInstructor(instructor.IdUsuario).Any(disciplina => disciplina.IdDisciplina == idDisciplina));
            }

            dgvInstructores.DataSource = lista;
            dgvInstructores.DataBind();
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtNombreFiltro.Text = "";
            txtApellidoFiltro.Text = "";
            txtDniFiltro.Text = "";
            ddlEstadoFiltro.SelectedIndex = 0;
            ddlDisciplinaFiltro.SelectedIndex = 0;
            cargarInstructores();
        }

        private void cargarInstructores()
        {
            InstructorNegocio negocio = new InstructorNegocio();
            Session.Add("listaInstructores", negocio.listar());
            dgvInstructores.DataSource = Session["listaInstructores"];
            dgvInstructores.DataBind();
        }

        private void cargarDisciplinasFiltro()
        {
            DisciplinaNegocio negocio = new DisciplinaNegocio();

            ddlDisciplinaFiltro.DataSource = negocio.listar().FindAll(x => x.Activa);
            ddlDisciplinaFiltro.DataTextField = "Nombre";
            ddlDisciplinaFiltro.DataValueField = "IdDisciplina";
            ddlDisciplinaFiltro.DataBind();
            ddlDisciplinaFiltro.Items.Insert(0, new ListItem("Todas", "0"));
        }
    }
}