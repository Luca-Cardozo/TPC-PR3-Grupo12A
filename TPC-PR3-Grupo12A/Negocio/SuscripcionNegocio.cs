using Acceso_Datos;
using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class SuscripcionNegocio
    {
        public Suscripcion obtenerSuscripcionActualUsuario(int idUsuario)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT S.FechaInicio, S.FechaFin, S.ClasesConsumidas, " +
                    "P.IdPlan, P.Descripcion, P.CantidadClases, P.DuracionDias, P.Precio, P.Activo " +
                    "FROM Suscripciones S " +
                    "INNER JOIN Planes P ON P.IdPlan = S.IdPlan " +
                    "WHERE S.IdUsuario = @IdUsuario");
                datos.setearParametro("@IdUsuario", idUsuario);
                datos.ejecutarLectura();

                if (!datos.Lector.Read())
                    return null;

                Suscripcion suscripcion = new Suscripcion();

                suscripcion.FechaInicio = (DateTime)datos.Lector["FechaInicio"];
                suscripcion.FechaFin = (DateTime)datos.Lector["FechaFin"];
                suscripcion.ClasesConsumidas = (int)datos.Lector["ClasesConsumidas"];

                Plan plan = new Plan();
                plan.IdPlan = (int)datos.Lector["IdPlan"];
                plan.Descripcion = (string)datos.Lector["Descripcion"];
                plan.CantidadClases = datos.Lector["CantidadClases"] != DBNull.Value ? (int?)datos.Lector["CantidadClases"] : null;
                plan.DuracionDias = (int)datos.Lector["DuracionDias"];
                plan.Precio = (decimal)datos.Lector["Precio"];
                plan.Activo = (bool)datos.Lector["Activo"];

                suscripcion.Plan = plan;

                return suscripcion;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public bool estaVigente(int idUsuario)
        {
            Suscripcion sus = obtenerSuscripcionActualUsuario(idUsuario);

            if (sus == null)
                return false;

            return sus.EstaVigente(DateTime.Now);
        }

        public void incrementarClasesConsumidas(int idAlumno)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Suscripciones " +
                    "SET ClasesConsumidas = ClasesConsumidas + 1 " +
                    "WHERE IdUsuario = @IdUsuario");
                datos.setearParametro("@IdUsuario", idAlumno);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void disminuirClasesConsumidas(int idAlumno)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Suscripciones " +
                    "SET ClasesConsumidas = CASE " +
                    "WHEN ClasesConsumidas > 0 THEN ClasesConsumidas - 1 " +
                    "ELSE 0 END " +
                    "WHERE IdUsuario = @IdUsuario");
                datos.setearParametro("@IdUsuario", idAlumno);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        public void validarClaseDentroDeSuscripcion(int idAlumno, Clase clase)
        {
            Suscripcion suscripcion = obtenerSuscripcionActualUsuario(idAlumno);

            if (suscripcion == null)
                throw new Exception("El alumno no posee una suscripción cargada.");

            DateTime fechaClase = clase.Fecha.Date;

            DateTime inicio = suscripcion.FechaInicio.Date;
            DateTime finConGracia = suscripcion.FechaFin.Date.AddDays(5);

            if (fechaClase < inicio || fechaClase > finConGracia)
                throw new Exception("La clase seleccionada no corresponde al período de la suscripción vigente.");
        }
    }
}
