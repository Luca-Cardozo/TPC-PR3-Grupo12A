using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.IO;
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
                                imgDisciplina.ImageUrl = "~/Images/" + seleccionada.Imagen + ".jpg";
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

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            try
            {
                DisciplinaNegocio negocio = new DisciplinaNegocio();

                string nombre = txtNombre.Text.Trim();

                if (string.IsNullOrWhiteSpace(nombre))
                {
                    lblError.Text = "El nombre es obligatorio.";
                    lblError.Visible = true;
                    return;
                }

                if (negocio.existeDisciplina(nombre))
                {
                    lblError.Text = "Ya existe una disciplina con ese nombre.";
                    lblError.Visible = true;
                    return;
                }

                if (txtImagen.PostedFile.FileName == "")
                {
                    lblError.Text = "Debe cargar una imagen para la disciplina.";
                    lblError.Visible = true;
                    return; ;
                }

                Disciplina nueva = new Disciplina();

                nueva.Nombre = nombre;

                negocio.agregar(nueva);

                string ruta = Server.MapPath("~/Images/");
                string nombreArchivo = "disciplina-" + nueva.IdDisciplina + ".jpg";
                txtImagen.PostedFile.SaveAs(Path.Combine(ruta, nombreArchivo));
                nueva.Imagen = nombreArchivo;

                Response.Redirect("Disciplinas.aspx", false);

            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
                lblError.Visible = true;
            }
        }
    }
}