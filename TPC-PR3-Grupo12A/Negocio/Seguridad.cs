using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dominio;
using System.Web.SessionState;

namespace Negocio
{
    public static class Seguridad
    {
        public static bool sesionActiva(object usuario)
        {
            return usuario != null;
        }

        public static Usuario usuarioActual(HttpSessionState session)
        {
            return session["usuario"] as Usuario;
        }

        public static bool esRol(HttpSessionState session, Rol rol)
        {
            Usuario usuario = usuarioActual(session);
            return usuario != null && usuario.Rol == rol;
        }

        public static bool esAdmin(HttpSessionState session)
        {
            return esRol(session, Rol.Administrador);
        }

        public static bool esRecepcionista(HttpSessionState session)
        {
            return esRol(session, Rol.Recepcionista);
        }

        public static bool esAlumno(HttpSessionState session)
        {
            return esRol(session, Rol.Alumno);
        }

        public static bool esInstructor(HttpSessionState session)
        {
            return esRol(session, Rol.Instructor);
        }
    }
}
