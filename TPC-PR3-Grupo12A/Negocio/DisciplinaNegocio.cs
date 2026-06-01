using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using Acceso_Datos;
using Dominio;


namespace Negocio
{
    public class DisciplinaNegocio
    {
        public List<Disciplina> listar()
        {
            List<Disciplina> lista = new List<Disciplina>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT IdDisciplina, Imagen, Nombre, Activa FROM Disciplinas");
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    Disciplina aux = new Disciplina();
                    aux.IdDisciplina = (int)datos.Lector["IdDisciplina"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    aux.Imagen = (string)datos.Lector["Imagen"];
                    aux.Activa = (bool)datos.Lector["Activa"];
                    lista.Add(aux);
                }
                return lista;
            }
            
            catch (Exception ex)
            {
                throw ex;
            }
            
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
