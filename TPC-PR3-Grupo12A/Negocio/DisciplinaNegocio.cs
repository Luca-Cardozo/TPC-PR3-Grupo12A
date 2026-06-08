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

        public void agregar(Disciplina disciplinaNueva)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("INSERT INTO Disciplinas (Nombre, Imagen) " +
                     "VALUES (@Nombre, @Imagen)");

                datos.setearParametro("@Nombre", disciplinaNueva.Nombre);
                datos.setearParametro("@Imagen", disciplinaNueva.Imagen);

                datos.ejecutarAccion();
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

        public void modificar(Disciplina disciplinaModificada)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("UPDATE Disciplinas SET Nombre = @Nombre, Imagen = @Imagen " +
                    "WHERE IdDisciplina = @IdDisciplina");

                datos.setearParametro("@Id", disciplinaModificada.IdDisciplina);
                datos.setearParametro("@Nombre", disciplinaModificada.Nombre);
                datos.setearParametro("@Imagen", disciplinaModificada.Imagen);

                datos.ejecutarAccion();
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

        public void eliminar(Disciplina disciplina)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {

                datos.setearConsulta("UPDATE Disciplinas SET Activo = 0 " +
                    "WHERE IdDisciplina = @IdDisciplina");

                datos.setearParametro("@IdDisciplina", disciplina.IdDisciplina);

                datos.ejecutarAccion();
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
