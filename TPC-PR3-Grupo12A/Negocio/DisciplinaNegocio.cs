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
            if (existeDisciplina(disciplinaNueva.Nombre))
                throw new Exception("Ya existe una disciplina con ese nombre.");

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("INSERT INTO Disciplinas (Nombre, Imagen) " +
                    "OUTPUT INSERTED.IdDisciplina " +
                     "VALUES (@Nombre, '')");

                datos.setearParametro("@Nombre", disciplinaNueva.Nombre);

                datos.ejecutarLectura();

                int idDisciplina;

                if (datos.Lector.Read())
                    idDisciplina = (int)datos.Lector["IdDisciplina"];
                else
                    throw new Exception("No se pudo generar la disciplina.");

                datos.cerrarConexion();

                string nombreImagen = "disciplina-" + idDisciplina;

                datos = new AccesoDatos();

                datos.setearConsulta("UPDATE Disciplinas SET Imagen = @Imagen " +
                    "WHERE IdDisciplina = @IdDisciplina");

                datos.setearParametro("@Imagen", nombreImagen);
                datos.setearParametro("@IdDisciplina", idDisciplina);

                datos.ejecutarAccion();

                // Se actualizan los valores del objeto por si se necesitan en el front
                disciplinaNueva.IdDisciplina = idDisciplina;
                disciplinaNueva.Imagen = nombreImagen;
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
            if (existeDisciplina(disciplinaModificada.Nombre, disciplinaModificada.IdDisciplina))
                throw new Exception("Ya existe una disciplina con ese nombre.");

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Disciplinas SET Nombre = @Nombre, Imagen = @Imagen " +
                    "WHERE IdDisciplina = @IdDisciplina");

                datos.setearParametro("@IdDisciplina", disciplinaModificada.IdDisciplina);
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

        public void eliminar(int idDisciplina)
        {
            if (tieneInstructoresAsociados(idDisciplina))
                throw new Exception("No se puede eliminar una disciplina con instructores asociados.");

            AccesoDatos datos = new AccesoDatos();

            try
            {

                datos.setearConsulta("UPDATE Disciplinas SET Activa = 0 " +
                    "WHERE IdDisciplina = @IdDisciplina");

                datos.setearParametro("@IdDisciplina", idDisciplina);

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

        public void reactivar(int idDisciplina)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Disciplinas SET Activa = 1 " +
                    "WHERE IdDisciplina = @IdDisciplina");

                datos.setearParametro("@IdDisciplina", idDisciplina);

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

        public bool tieneInstructoresAsociados(int idDisciplina)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT IdDisciplina FROM DisciplinasXInstructores " +
                    "WHERE IdDisciplina = @IdDisciplina");

                datos.setearParametro("@IdDisciplina", idDisciplina);
                datos.ejecutarLectura();
                if (datos.Lector.Read())
                {
                    return true;
                }
                return false;
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

        public bool existeDisciplina(string nombre, int? idExcluir = null)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                string consulta = "SELECT 1 FROM Disciplinas WHERE Nombre = @Nombre";

                // En el caso de modificar la disciplina, se excluye el id de la misma
                // Sirve para el caso donde se quiere modificar la imagen nomás, y que el nombre de la disciplina quede igual que antes
                if (idExcluir.HasValue)
                    consulta += " AND IdDisciplina <> @IdDisciplina";

                datos.setearConsulta(consulta);
                datos.setearParametro("@Nombre", nombre);

                // En caso de modificación
                if (idExcluir.HasValue)
                    datos.setearParametro("@IdDisciplina", idExcluir.Value);

                datos.ejecutarLectura();

                return datos.Lector.Read();
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
