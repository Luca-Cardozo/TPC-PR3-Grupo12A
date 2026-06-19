<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="ConfirmarReserva.aspx.cs" Inherits="App_CentroFitness.ConfirmarReserva" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4 mb-5">

        <div class="row justify-content-center mb-4">
            <div class="col-lg-8 text-center">
                <h2 class="fw-bold">✅ Confirmar reserva</h2>
                <p class="text-muted">Revisá los datos de la clase antes de confirmar</p>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-6">

                <div class="card shadow-sm">
                    <div class="card-body">

                        <h5 class="mb-3">📌 Detalle de la clase</h5>

                        <p>
                            <strong>Disciplina:</strong>
                            <asp:Label ID="lblDisciplina" runat="server" />
                        </p>
                        <p>
                            <strong>Instructor:</strong>
                            <asp:Label ID="lblInstructor" runat="server" />
                        </p>
                        <p>
                            <strong>Fecha:</strong>
                            <asp:Label ID="lblFecha" runat="server" />
                        </p>
                        <p>
                            <strong>Horario:</strong>
                            <asp:Label ID="lblHorario" runat="server" />
                        </p>

                        <hr />

                        <div class="d-flex justify-content-between mt-3">

                            <asp:Button ID="btnCancelar" runat="server"
                                Text="← Volver"
                                CssClass="btn btn-outline-secondary"
                                OnClick="btnCancelar_Click" />

                            <asp:Button ID="btnConfirmar" runat="server"
                                Text="Confirmar reserva"
                                CssClass="btn btn-success px-4"
                                OnClick="btnConfirmar_Click" />

                        </div>

                        <asp:Label ID="lblMensaje" runat="server" CssClass="d-block mt-3 text-center" />

                    </div>
                </div>

            </div>
        </div>

    </div>

</asp:Content>
