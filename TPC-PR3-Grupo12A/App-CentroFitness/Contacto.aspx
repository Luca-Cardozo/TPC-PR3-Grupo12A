<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Contacto.aspx.cs" Inherits="App_CentroFitness.Contacto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-5 mb-5">

        <div class="text-center mb-5">
            <h1 class="fw-bold">📞 Contacto</h1>
            <p class="text-muted fs-5">
                Comunicate con Centro Fitness para consultar por clases, planes y horarios.
           
            </p>
        </div>

        <div class="row justify-content-center g-4">

            <div class="col-md-5">
                <div class="card shadow-sm h-100 border-0">
                    <div class="card-body">

                        <h4 class="mb-4">🏋️ Centro Fitness</h4>

                        <p class="mb-3">
                            <strong>📍 Dirección:</strong><br />
                            Calle False 123, Springfield                       
                        </p>

                        <p class="mb-3">
                            <strong>📞 Teléfono:</strong><br />
                            +54 9 11 1234-5678                       
                        </p>

                        <p class="mb-3">
                            <strong>📧 Email:</strong><br />
                            centrofitness160@gmail.com                       
                        </p>

                        <p class="mb-0">
                            <strong>🕐 Horarios de atención:</strong><br />
                            Lunes a domingo: 07:00 a 22:00 hs<br />
                        </p>

                    </div>
                </div>
            </div>

            <div class="col-md-5">
                <div class="card shadow-sm h-100 border-0">
                    <div class="card-body">

                        <h4 class="mb-4">💬 Consultas frecuentes</h4>

                        <p>
                            Podés comunicarte con recepción para consultar sobre:                       
                        </p>

                        <ul>
                            <li>Planes mensuales y pase libre.</li>
                            <li>Disciplinas disponibles.</li>
                            <li>Horarios de clases.</li>
                            <li>Alta de alumnos y suscripciones.</li>
                            <li>Reservas, cancelaciones y reprogramaciones.</li>
                        </ul>

                        <div class="alert alert-info mt-4 mb-0">
                            Para utilizar la plataforma como alumno, primero debés registrarte presencialmente en el centro.                       
                        </div>

                    </div>
                </div>
            </div>

        </div>

        <div class="text-center mt-5">
            <a href="Disciplinas.aspx" class="btn btn-primary px-4">💪 Ver disciplinas
            </a>
            <a href="Instructores.aspx" class="btn btn-outline-secondary px-4 ms-2">👨‍🏫 Ver instructores
            </a>
            <div class="text-center mt-4 mb-5">
                <a href="Home.aspx"
                    class="btn btn-outline-primary px-4 py-2 shadow-sm">🏠 Volver a página principal
                </a>
            </div>
        </div>

    </div>

</asp:Content>
