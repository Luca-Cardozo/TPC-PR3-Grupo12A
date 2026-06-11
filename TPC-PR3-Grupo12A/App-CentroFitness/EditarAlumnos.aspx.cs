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
                    AlumnoNegocio negocio = new AlumnoNegocio();

                    Session["listaAlumnos"] = negocio.listar();


                    dgvAlumnos.DataSource = Session["listaAlumnos"];
                    dgvAlumnos.DataBind();
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

        ///ver filtro a futuro


        /*protected void txtFiltro_TextChanged(object sender, EventArgs e)
        {
            List<Alumno> lista = (List<Alumno>)Session["listaAlumnos"];

            string filtro = txtFiltro.Text.Trim().ToUpper();

            if (string.IsNullOrWhiteSpace(filtro))
            {
                dgvAlumnos.DataSource = lista;
            }
            else
            {
                List<Alumno> listaFiltrada = lista.FindAll(x =>
                    x.Nombre.ToUpper().Contains(filtro) ||
                    x.Apellido.ToUpper().Contains(filtro) ||
                    x.DNI.ToUpper().Contains(filtro) ||
                    x.Email.ToUpper().Contains(filtro)
                );

                dgvAlumnos.DataSource = listaFiltrada;
            }

            dgvAlumnos.DataBind();
        }*/
    }
}