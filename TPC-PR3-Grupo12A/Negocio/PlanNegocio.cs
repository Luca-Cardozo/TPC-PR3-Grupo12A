using Acceso_Datos;
using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class PlanNegocio
    {
        public List<Plan> listar()
        {
            List<Plan> lista = new List<Plan>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT IdPlan, Descripcion, CantidadClases, DuracionMeses, Precio, Activo " +
                    "FROM Planes ORDER BY Activo DESC, Descripcion ASC");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Plan plan = new Plan();

                    plan.IdPlan = (int)datos.Lector["IdPlan"];
                    plan.Descripcion = (string)datos.Lector["Descripcion"];
                    plan.CantidadClases = datos.Lector["CantidadClases"] == DBNull.Value ? (int?)null : (int)datos.Lector["CantidadClases"];
                    plan.DuracionMeses = (int)datos.Lector["DuracionMeses"];
                    plan.Precio = (decimal)datos.Lector["Precio"];
                    plan.Activo = (bool)datos.Lector["Activo"];

                    lista.Add(plan);
                }

                return lista;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void agregar(Plan nuevo)
        {
            if (existePlan(nuevo.Descripcion))
                throw new Exception("Ya existe un plan con esa descripción.");

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("INSERT INTO Planes (Descripcion, CantidadClases, DuracionMeses, Precio, Activo) " +
                    "VALUES (@Descripcion, @CantidadClases, @DuracionMeses, @Precio, 1)");
                datos.setearParametro("@Descripcion", nuevo.Descripcion);
                datos.setearParametro("@CantidadClases", nuevo.CantidadClases.HasValue ? (object)nuevo.CantidadClases.Value : DBNull.Value);
                datos.setearParametro("@DuracionMeses", nuevo.DuracionMeses);
                datos.setearParametro("@Precio", nuevo.Precio);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void modificar(Plan modificado)
        {
            if (existePlan(modificado.Descripcion, modificado.IdPlan))
                throw new Exception("Ya existe otro plan con esa descripción.");

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Planes SET Descripcion = @Descripcion, " +
                    "CantidadClases = @CantidadClases, DuracionMeses = @DuracionMeses, Precio = @Precio " +
                    "WHERE IdPlan = @IdPlan");

                datos.setearParametro("@Descripcion", modificado.Descripcion);
                datos.setearParametro("@CantidadClases", modificado.CantidadClases.HasValue ? (object)modificado.CantidadClases.Value : DBNull.Value);
                datos.setearParametro("@DuracionMeses", modificado.DuracionMeses);
                datos.setearParametro("@Precio", modificado.Precio);
                datos.setearParametro("@IdPlan", modificado.IdPlan);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void eliminar(int idPlan)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Planes SET Activo = 0 WHERE IdPlan = @IdPlan");
                datos.setearParametro("@IdPlan", idPlan);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void reactivar(int idPlan)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Planes SET Activo = 1 WHERE IdPlan = @IdPlan");
                datos.setearParametro("@IdPlan", idPlan);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public bool existePlan(string descripcion, int? idPlan = null)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                string consulta = "SELECT 1 FROM Planes WHERE LOWER(Descripcion) = LOWER(@Descripcion) ";
                if (idPlan.HasValue)
                    consulta += "AND IdPlan <> @IdPlan ";
                datos.setearConsulta(consulta);
                datos.setearParametro("@Descripcion", descripcion.Trim());
                if (idPlan.HasValue)
                    datos.setearParametro("@IdPlan", idPlan.Value);
                datos.ejecutarLectura();
                return datos.Lector.Read();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public int obtenerProximoId()
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT ISNULL(MAX(IdPlan), 0) + 1 FROM Planes");
                datos.ejecutarLectura();
                if (datos.Lector.Read())
                    return (int)datos.Lector[0];
                return 1;
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
