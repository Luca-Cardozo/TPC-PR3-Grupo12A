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
    public partial class FormularioPlan : System.Web.UI.Page
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
                btnEliminar.Visible = false;

                if (Request.QueryString["id"] != null)
                {
                    lblTitulo.Text = "Editar Plan";
                    btnEliminar.Visible = true;

                    int idPlan = int.Parse(Request.QueryString["id"]);

                    try
                    {
                        PlanNegocio negocio = new PlanNegocio();
                        List<Plan> lista = negocio.listar();

                        Plan seleccionado = lista.Find(x => x.IdPlan == idPlan);

                        if (seleccionado != null)
                        {
                            txtIdPlan.Text = seleccionado.IdPlan.ToString();
                            txtDescripcion.Text = seleccionado.Descripcion;
                            txtCantidadClases.Text = seleccionado.CantidadClases.HasValue ? seleccionado.CantidadClases.Value.ToString() : "";
                            txtDuracionMeses.Text = seleccionado.DuracionMeses.ToString();
                            txtPrecio.Text = seleccionado.Precio.ToString("0.##");
                            txtEstado.Text = seleccionado.Activo ? "Activo" : "Inactivo";

                            if (seleccionado.Activo)
                            {
                                btnEliminar.Text = "Eliminar";
                                btnEliminar.CssClass = "btn btn-outline-danger";
                                btnEliminar.OnClientClick = "return confirm('¿Está seguro de eliminar este plan?');";
                            }
                            else
                            {
                                btnEliminar.Text = "Reactivar";
                                btnEliminar.CssClass = "btn btn-success";
                                btnEliminar.OnClientClick = "return confirm('¿Está seguro de reactivar este plan?');";
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        lblError.Text = ex.Message;
                        lblError.Visible = true;
                    }
                }
                else
                {
                    lblTitulo.Text = "Nuevo Plan";
                    txtEstado.Text = "Activo";

                    PlanNegocio negocio = new PlanNegocio();
                    txtIdPlan.Text = negocio.obtenerProximoId().ToString();
                }
            }
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            Page.Validate();

            if (!Page.IsValid)
                return;

            try
            {
                Plan plan = new Plan();

                string descripcion = txtDescripcion.Text.Trim();

                if (string.IsNullOrWhiteSpace(descripcion))
                    throw new Exception("La descripción es obligatoria.");

                if (string.IsNullOrWhiteSpace(txtDuracionMeses.Text))
                    throw new Exception("La duración es obligatoria.");

                int duracionMeses;

                if (!int.TryParse(txtDuracionMeses.Text, out duracionMeses))
                    throw new Exception("La duración debe ser numérica.");

                if (duracionMeses <= 0)
                    throw new Exception("La duración debe ser mayor a cero.");

                if (string.IsNullOrWhiteSpace(txtPrecio.Text))
                    throw new Exception("El precio es obligatorio.");

                decimal precio;

                if (!decimal.TryParse(txtPrecio.Text.Trim(), out precio))
                    throw new Exception("El precio debe ser numérico.");

                if (precio < 0)
                    throw new Exception("El precio no puede ser negativo.");

                int? cantidadClases = null;

                if (!string.IsNullOrWhiteSpace(txtCantidadClases.Text))
                {
                    int cantidad;

                    if (!int.TryParse(txtCantidadClases.Text, out cantidad))
                        throw new Exception("La cantidad de clases debe ser numérica.");

                    if (cantidad <= 0)
                        throw new Exception("La cantidad de clases debe ser mayor a cero.");

                    cantidadClases = cantidad;
                }

                plan.Descripcion = descripcion;
                plan.CantidadClases = cantidadClases;
                plan.DuracionMeses = duracionMeses;
                plan.Precio = precio;

                PlanNegocio negocio = new PlanNegocio();

                if (Request.QueryString["id"] != null)
                {
                    plan.IdPlan = int.Parse(Request.QueryString["id"]);
                    negocio.modificar(plan);
                }
                else
                {
                    negocio.agregar(plan);
                }

                Response.Redirect("EditarPlanes.aspx", false);
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
                if (Request.QueryString["id"] == null)
                    throw new Exception("No se seleccionó ningún plan.");

                int idPlan = int.Parse(Request.QueryString["id"]);

                PlanNegocio negocio = new PlanNegocio();
                Plan seleccionado = negocio.listar().Find(x => x.IdPlan == idPlan);

                if (seleccionado == null)
                    throw new Exception("No se encontró el plan seleccionado.");

                if (seleccionado.Activo)
                    negocio.eliminar(idPlan);
                else
                    negocio.reactivar(idPlan);

                Response.Redirect("EditarPlanes.aspx", false);
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
                lblError.Visible = true;
            }
        }
    }
}