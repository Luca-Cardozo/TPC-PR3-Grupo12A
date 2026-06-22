using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class Alumno : Usuario
    {
        // Observaciones que el usuario crea pertinente dejar asentadas (lesión, condición física, etc.)
        public string Observaciones { get; set; }
        public Suscripcion SuscripcionActual { get; set; }
        public Alumno()
        {
            this.Rol = Rol.Alumno;
        }
        public string NombreCompleto
        {
            get
            {
                return Nombre + " " + Apellido;
            }
        }
    }
}
