using Dominio;
using Negocio;
using System;
using System.Collections;
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

                    btnEliminar.Visible = true;

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


                            if (!string.IsNullOrEmpty(seleccionada.Imagen))
                            {
                                imgDisciplina.ImageUrl = "~/Images/" + seleccionada.Imagen + ".jpg";
                            }

                            if (seleccionada.Activa)
                            {
                                btnEliminar.Text = "Eliminar";
                                btnEliminar.CssClass = "btn btn-danger";
                            }
                            else
                            {
                                btnEliminar.Text = "Reactivar";
                                btnEliminar.CssClass = "btn btn-success";
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

                bool esModificacion = Request.QueryString["id"] != null;

                int? idDisciplina = null;

                if (esModificacion)
                {
                    idDisciplina = int.Parse(Request.QueryString["id"]);
                }

                if (negocio.existeDisciplina(nombre, idDisciplina))
                {
                    lblError.Text = "Ya existe una disciplina con ese nombre.";
                    lblError.Visible = true;
                    return;
                }

                Disciplina nueva = new Disciplina();

                nueva.Nombre = nombre;

                if (esModificacion)
                {
                    nueva.IdDisciplina = idDisciplina.Value;
                    nueva.Imagen = "disciplina-" + nueva.IdDisciplina;

                    if (txtImagen.PostedFile.FileName != "")
                    {
                        string ruta = Server.MapPath("~/Images/");
                        txtImagen.PostedFile.SaveAs(Path.Combine(ruta, nueva.Imagen + ".jpg"));
                    }

                    negocio.modificar(nueva);
                }
                else
                {
                    if (txtImagen.PostedFile.FileName == "")
                    {
                        lblError.Text = "Debe cargar una imagen.";
                        lblError.Visible = true;
                        return;
                    }

                    negocio.agregar(nueva);

                    string ruta = Server.MapPath("~/Images/");
                    txtImagen.PostedFile.SaveAs(Path.Combine(ruta, nueva.Imagen + ".jpg"));
                }

                Response.Redirect("Disciplinas.aspx", false);

            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
                lblError.Visible = true;
            }
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            try
            {
                DisciplinaNegocio negocio = new DisciplinaNegocio();

                int idDisciplina = int.Parse(Request.QueryString["id"]);

                Disciplina disciplina = negocio.listar().Find(x => x.IdDisciplina == idDisciplina);

                if (disciplina.Activa)
                {
                    if (negocio.tieneInstructoresAsociados(idDisciplina))
                    {
                        lblError.Text = "No se puede eliminar la disciplina porque tiene instructores asociados.";
                        lblError.Visible = true;
                        return;
                    }
                    negocio.eliminar(idDisciplina);
                }
                else
                {
                    negocio.reactivar(idDisciplina);
                }

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