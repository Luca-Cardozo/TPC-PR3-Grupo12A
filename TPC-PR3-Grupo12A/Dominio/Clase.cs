using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public enum EstadoClase
    {
        Vigente = 1,
        Cancelada = 2
    }

    public class Clase
    {
        private int horaInicio;
        public int IdClase { get; set; }
        public Instructor Instructor { get; set; }
        public Disciplina Disciplina { get; set; }
        public DateTime Fecha { get; set; }
        // Trabajamos con turnos de 1 hora de duración, desde una hora redonda a otra. Ej: 18 a 19 hs
        public int HoraInicio 
        {
            get
            {
                return horaInicio;
            }
            set
            {
                if (value < 0 || value > 23)
                {
                    throw new Exception("La hora debe estar entre 7 y 22.");
                }
                horaInicio = value;
            }
        }
        public int HoraFin
        {
            get { return HoraInicio + 1; }
        }
        public int CupoMaximo { get; set; }
        public EstadoClase Estado { get; set; }

        public Clase()
        {
            Estado = EstadoClase.Vigente;
        }

    }
}
