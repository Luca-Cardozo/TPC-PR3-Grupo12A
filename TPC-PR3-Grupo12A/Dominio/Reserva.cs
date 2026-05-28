using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class Reserva
    {
        public int IdReserva { get; set; }
        public Clase Clase { get; set; }
        public Alumno Alumno { get; set; }
        public DateTime FechaReserva { get; set; }
        public EstadoReserva Estado { get; set; }
        // Property para tomar asistencia del alumno
        // Es un bool nulleable que admite true (asistió), false (no asistió), null (todavía no ocurrió la clase)
        public bool? Asistio { get; set; }
        public string Observaciones { get; set; }
    }
}
