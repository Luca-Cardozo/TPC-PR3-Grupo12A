using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class Recepcionista : Usuario
    {
        public Recepcionista()
        {
            this.Rol = Rol.Recepcionista;
        }
    }
}
