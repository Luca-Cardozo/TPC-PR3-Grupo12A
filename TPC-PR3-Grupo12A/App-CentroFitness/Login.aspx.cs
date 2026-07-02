using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App_CentroFitness
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnVolverHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                UsuarioNegocio negocio = new UsuarioNegocio();

                Usuario usuario = negocio.login(txtEmail.Text, txtPassword.Text);

                if (usuario != null)
                {                  

                    if (!usuario.Activo)
                    {
                        lblError.Text = "No tiene acceso al sistema. Comuníquese con el administrador.";
                        return;
                    }

                    Session["usuario"] = usuario;
                    Response.Redirect("Home.aspx");
                    
                }
                else
                {
                    lblError.Text = "Email o contraseña incorrectos";                        
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
            }
        }
    }
}