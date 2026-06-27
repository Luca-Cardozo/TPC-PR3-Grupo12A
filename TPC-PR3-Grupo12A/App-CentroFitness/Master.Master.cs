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
    public partial class Master : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            imgAvatar.ImageUrl = "~/Images/default-user.jpg";

            bool paginaPublica = Page is Home || Page is Login || Page is Disciplinas 
                || Page is Instructores || Page is AccesoDenegado || Page is Logout || Page is Contacto;

            if (!paginaPublica && !Seguridad.sesionActiva(Session["usuario"]))
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            Usuario usuario = Seguridad.usuarioActual(Session);
            bool logueado = usuario != null;

            if (!paginaPublica && !logueado)
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            configurarNavbar(usuario);         

        }

        private void configurarNavbar(Usuario usuario)
        {
            bool logueado = usuario != null;

            liLogin.Visible = !logueado;
            liLogout.Visible = logueado;
            liPerfil.Visible = logueado;

            liMisReservas.Visible = false;
            liMisClases.Visible = false;

            liAdministracion.Visible = false;
            liAdminDisciplinas.Visible = false;
            liAdminInstructores.Visible = false;
            liAdminAlumnos.Visible = false;
            liAdminRecepcionistas.Visible = false;
            liAdminClases.Visible = false;
            liAdminReservas.Visible = false;
            liAdminPlanes.Visible = false;
            liEnviarRecordatorios.Visible = false;

            lblUsuarioLogueado.Text = "";

            if (!logueado)
                return;

            lblUsuarioLogueado.Text = "👤 " + usuario.Nombre;

            if (!string.IsNullOrEmpty(usuario.Imagen))
                imgAvatar.ImageUrl = "~/Images/" + usuario.Imagen + ".jpg";

            if (usuario.Rol == Rol.Alumno)
            {
                liMisReservas.Visible = true;
            }
            else if (usuario.Rol == Rol.Instructor)
            {
                liMisClases.Visible = true;
            }
            else if (usuario.Rol == Rol.Recepcionista)
            {
                liAdministracion.Visible = true;

                liAdminAlumnos.Visible = true;
                liAdminClases.Visible = true;
                liAdminReservas.Visible = true;
                liEnviarRecordatorios.Visible = true;
            }
            else if (usuario.Rol == Rol.Administrador)
            {
                liAdministracion.Visible = true;

                liAdminDisciplinas.Visible = true;
                liAdminInstructores.Visible = true;
                liAdminAlumnos.Visible = true;
                liAdminRecepcionistas.Visible = true;
                liAdminClases.Visible = true;
                liAdminReservas.Visible = true;
                liAdminPlanes.Visible = true;
                liEnviarRecordatorios.Visible = true;
            }
        }
    }
}