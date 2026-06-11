using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace App_CentroFitness
{
    public partial class Master : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            imgAvatar.ImageUrl = "~/Images/default-user.jpg";
            bool logueado = Session["Usuario"] != null;

            liLogin.Visible = !logueado;
            liLogout.Visible = logueado;
            liPerfil.Visible = logueado;

            if (logueado)
            {
                Usuario usuario = (Usuario)Session["Usuario"];
                lblUsuarioLogueado.Text = "👤 " + usuario.Nombre;
                if (!string.IsNullOrEmpty(usuario.Imagen))
                    imgAvatar.ImageUrl = "~/Images/" + usuario.Imagen + ".jpg";
            }
        }
    }
}