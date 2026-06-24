using Acceso_Datos;
using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public enum TipoMovimientoSuscripcion
    {
        Alta = 1,
        Actualizacion = 2
    }
    public class SuscripcionNegocio
    {
        public Suscripcion obtenerSuscripcionActualUsuario(int idUsuario)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT S.FechaInicio, S.FechaFin, S.ClasesConsumidas, " +
                    "P.IdPlan, P.Descripcion, P.CantidadClases, P.DuracionMeses, P.Precio, P.Activo " +
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
                plan.DuracionMeses = (int)datos.Lector["DuracionMeses"];
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

        public void altaSuscripcion(int idUsuario, int idPlan, int mes, int anio)
        {
            validarPeriodoSuscripcion(mes, anio);

            if (obtenerSuscripcionActualUsuario(idUsuario) != null)
                throw new Exception("El alumno ya posee una suscripción cargada. Puede actualizarla.");

            Plan plan = new PlanNegocio().listar().Find(x => x.IdPlan == idPlan);

            if (plan == null)
                throw new Exception("El plan seleccionado no existe.");

            if (!plan.Activo)
                throw new Exception("No se puede asignar un plan inactivo.");

            DateTime inicio = new DateTime(anio, mes, 1);
            DateTime fin = inicio.AddMonths(plan.DuracionMeses).AddDays(-1);

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "INSERT INTO Suscripciones (IdUsuario, IdPlan, FechaInicio, FechaFin, ClasesConsumidas) " +
                    "VALUES (@IdUsuario, @IdPlan, @FechaInicio, @FechaFin, 0)");

                datos.setearParametro("@IdUsuario", idUsuario);
                datos.setearParametro("@IdPlan", idPlan);
                datos.setearParametro("@FechaInicio", inicio);
                datos.setearParametro("@FechaFin", fin);

                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }

            registrarHistorial(idUsuario, idPlan, inicio, fin, (int)TipoMovimientoSuscripcion.Alta);
            enviarMailSuscripcion(idUsuario, plan, inicio, fin);
        }

        public void actualizarSuscripcion(int idUsuario, int idPlan, int mes, int anio)
        {
            validarPeriodoSuscripcion(mes, anio);

            Suscripcion actual = obtenerSuscripcionActualUsuario(idUsuario);

            if (actual == null)
                throw new Exception("El alumno no posee una suscripción cargada. Debe dar de alta una primero.");

            Plan plan = new PlanNegocio().listar().Find(x => x.IdPlan == idPlan);

            if (plan == null)
                throw new Exception("El plan seleccionado no existe.");

            if (!plan.Activo)
                throw new Exception("No se puede asignar un plan inactivo.");

            DateTime inicio = new DateTime(anio, mes, 1);
            DateTime fin = inicio.AddMonths(plan.DuracionMeses).AddDays(-1);

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Suscripciones SET IdPlan = @IdPlan, FechaInicio = @FechaInicio, " +
                    "FechaFin = @FechaFin, ClasesConsumidas = 0, FechaUltimaActualizacion = GETDATE() " +
                    "WHERE IdUsuario = @IdUsuario");

                datos.setearParametro("@IdUsuario", idUsuario);
                datos.setearParametro("@IdPlan", idPlan);
                datos.setearParametro("@FechaInicio", inicio);
                datos.setearParametro("@FechaFin", fin);

                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
            registrarHistorial(idUsuario, idPlan, inicio, fin, (int)TipoMovimientoSuscripcion.Actualizacion);
            enviarMailSuscripcion(idUsuario, plan, inicio, fin);
        }


        private void registrarHistorial(int idUsuario, int idPlan, DateTime fechaInicio, DateTime fechaFin, int tipoMovimiento)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(
                    "INSERT INTO HistorialSuscripciones (IdUsuario, IdPlan, FechaInicio, FechaFin, TipoMovimiento) " +
                    "VALUES (@IdUsuario, @IdPlan, @FechaInicio, @FechaFin, @TipoMovimiento)");

                datos.setearParametro("@IdUsuario", idUsuario);
                datos.setearParametro("@IdPlan", idPlan);
                datos.setearParametro("@FechaInicio", fechaInicio);
                datos.setearParametro("@FechaFin", fechaFin);
                datos.setearParametro("@TipoMovimiento", tipoMovimiento);

                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        private void validarPeriodoSuscripcion(int mes, int anio)
        {
            DateTime inicioSeleccionado = new DateTime(anio, mes, 1);
            DateTime inicioMesActual = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1);

            if (inicioSeleccionado < inicioMesActual)
                throw new Exception("No se puede cargar una suscripción para un período anterior al mes actual.");
        }

        private void enviarMailSuscripcion(int idUsuario, Plan plan, DateTime inicio, DateTime fin)
        {
            UsuarioNegocio usuarioNegocio = new UsuarioNegocio();
            string email = usuarioNegocio.obtenerEmailActual(idUsuario);

            Suscripcion suscripcion = new Suscripcion();
            suscripcion.Plan = plan;
            suscripcion.FechaInicio = inicio;
            suscripcion.FechaFin = fin;
            suscripcion.ClasesConsumidas = 0;

            usuarioNegocio.enviarMailSuscripcionActualizada(email, suscripcion);
        }
    }
}
