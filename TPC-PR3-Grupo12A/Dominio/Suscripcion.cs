using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class Suscripcion
    {
        public Plan Plan { get; set; }
        public DateTime FechaInicio { get; set; }
        public DateTime FechaFin { get; set; }
        public int ClasesConsumidas { get; set; }
        public bool EnGracia(DateTime ahora, int diasGracia = 5)
        {
            return ahora > FechaFin && ahora <= FechaFin.AddDays(diasGracia);
        }
        public bool EstaVigente(DateTime ahora)
        {
            return ahora <= FechaFin || EnGracia(ahora);
        }
    }
}
