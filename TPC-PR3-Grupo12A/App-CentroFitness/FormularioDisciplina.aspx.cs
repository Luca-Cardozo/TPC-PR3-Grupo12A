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
    public partial class FormularioDisciplina : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {

                if (Request.QueryString["id"] != null)
                {
                    int idSeleccionado = int.Parse(Request.QueryString["id"]);

                    try
                    {

                        List<Disciplina> lista;
                        if (Session["listaDisciplinas"] != null)
                        {
                            lista = (List<Disciplina>)Session["listaDisciplinas"];
                        }
                        else
                        {

                            DisciplinaNegocio negocio = new DisciplinaNegocio();
                            lista = negocio.listar();
                        }

                        Disciplina seleccionada = lista.Find(x => x.IdDisciplina == idSeleccionado);

                        if (seleccionada != null)
                        {

                            txtIdDisciplina.Text = seleccionada.IdDisciplina.ToString();
                            txtNombre.Text = seleccionada.Nombre;
                            txtImagen.Text = seleccionada.Imagen;


                            if (!string.IsNullOrEmpty(seleccionada.Imagen))
                            {
                                imgDisciplina.ImageUrl = seleccionada.Imagen;
                            }
                        }
                    }
                    catch (Exception ex)
                    {

                        Response.Write("<script>alert('Error al cargar la disciplina: " + ex.Message + "');</script>");
                    }
                }
            }
        }
    }
}