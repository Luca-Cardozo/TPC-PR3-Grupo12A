using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class Instructor : Usuario
    {
        // Un instructor puede dar más de una disciplina
        public List<Disciplina> Disciplinas { get; set; }
        public Instructor()
        {
            Disciplinas = new List<Disciplina>();
            this.Rol = Rol.Instructor;
        }
    }
}
