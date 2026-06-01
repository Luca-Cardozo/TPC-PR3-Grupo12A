using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public enum Rol
    {
        Administrador = 1,
        Recepcionista = 2,
        Instructor = 3,
        Alumno = 4
    }

    public class Usuario
    {
        public int IdUsuario { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string DNI { get; set; }
        public string Telefono { get; set; }
        public DateTime FechaNacimiento { get; set; }
        public string Imagen { get; set; }
        public Rol Rol { get; set; }
        public bool Activo { get; set; }
    }
}
