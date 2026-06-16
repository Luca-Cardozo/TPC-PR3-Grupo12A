using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;
using System.Net.Security;
using System.Security.Authentication;

namespace Negocio
{
    public class EmailService
    {
        private MailMessage email;
        private SmtpClient server;

        // Cuenta emisora
        private string remitente = "centrofitness160@gmail.com";
        private string password = "wfrqsmuitphintjd";

        public EmailService()
        {
            server = new SmtpClient();

            server.Host = "smtp.gmail.com";
            server.Port = 587;
            server.EnableSsl = true;
            server.DeliveryMethod = SmtpDeliveryMethod.Network;
            server.UseDefaultCredentials = false;

            server.Credentials = new NetworkCredential(
                "centrofitness160@gmail.com",
                "wfrqsmuitphintjd"
            );

            ServicePointManager.SecurityProtocol =
                SecurityProtocolType.Tls12;
        }

        public void armarCorreo(string emailDestino, string asunto, string cuerpo)
        {
            email = new MailMessage();

            email.From = new MailAddress(remitente, "Centro Fitness");
            email.To.Add(emailDestino);

            email.Subject = asunto;
            email.Body = cuerpo;
            email.IsBodyHtml = true;
        }

        public void enviarEmail()
        {
            try
            {
                server.Send(email);
            }
            catch (SmtpException ex)
            {
                throw new Exception(
                    $"SMTP ERROR\n" +
                    $"StatusCode: {ex.StatusCode}\n" +
                    $"Message: {ex.Message}\n" +
                    $"Inner: {ex.InnerException}"
                );
            }
        }

    }
}
