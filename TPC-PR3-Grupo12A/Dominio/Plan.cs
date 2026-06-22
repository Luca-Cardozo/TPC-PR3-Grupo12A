using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class Plan
    {
        public int IdPlan { get; set; }
        public string Descripcion { get; set; }
        // Se usa NULL para el plan libre (clases ilimitadas)
        public int? CantidadClases { get; set; }
        public int DuracionMeses { get; set; }
        public decimal Precio { get; set; }
        public bool Activo { get; set; }
    }
}
