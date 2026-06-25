using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public enum Estado
    {
        Vigente = 1,
        Cancelada = 2,
        Finalizada = 3,
        Reprogramada = 4
    }

    public enum EstadoAsistencia
    {
        Presente = 1,
        Ausente = 2
    }

    public class Reserva
    {
        public int IdReserva { get; set; }
        public Clase Clase { get; set; }
        public Alumno Alumno { get; set; }
        public DateTime FechaReserva { get; set; }
        public Estado Estado { get; set; }
        // Property para tomar asistencia del alumno
        // Es un enum nulleable que admite 1 (asistió), 2 (no asistió), null (todavía no ocurrió la clase)
        // Se cambió de int? a EstadoAsistencia? para permitir el agregado de otras opciones en el futuro si es necesario (ej: presente tarde, ausente justificado, etc.)
        public EstadoAsistencia? Asistencia { get; set; }
        public string Observaciones { get; set; }
    }
}