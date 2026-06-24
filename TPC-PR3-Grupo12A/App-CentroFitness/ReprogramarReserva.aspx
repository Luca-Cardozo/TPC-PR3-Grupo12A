<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="ReprogramarReserva.aspx.cs" Inherits="App_CentroFitness.ReprogramarReserva" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">



    <div class="container mt-4 mb-5">

    <div class="row justify-content-center">

        <div class="col-lg-7">

            <div class="card shadow-sm">

                <div class="card-header text-center">
                    <h4 class="mb-0">Reprogramar Reserva</h4>
                </div>

                <div class="card-body">

                    <div class="mb-3">
                        <label class="form-label">ID Reserva</label>
                        <asp:TextBox ID="txtIdReserva" runat="server"
                            CssClass="form-control bg-light text-muted"
                            ReadOnly="true" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Alumno</label>
                        <asp:TextBox ID="txtAlumno" runat="server"
                            CssClass="form-control bg-light text-muted"
                            ReadOnly="true" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Clase actual</label>
                        <asp:TextBox ID="txtClaseActual" runat="server"
                            CssClass="form-control bg-light text-muted"
                            ReadOnly="true" />
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Fecha actual</label>
                            <asp:TextBox ID="txtFechaActual" runat="server"
                                CssClass="form-control bg-light text-muted"
                                ReadOnly="true" />
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label">Horario actual</label>
                            <asp:TextBox ID="txtHorarioActual" runat="server"
                                CssClass="form-control bg-light text-muted"
                                ReadOnly="true" />
                        </div>
                    </div>

                                        <hr />
                    <div class="alert alert-warning">
    <strong>Importante:</strong>
    La reprogramación está sujeta a disponibilidad de cupos.

    Si no hay opciones disponibles en este momento, puede volver a verificar más adelante ante posibles liberaciones de cupo.
</div>

                    <div class="mb-3">
                        <label class="form-label">Nueva clase disponible</label>
                        <asp:DropDownList ID="ddlNuevaClase"
                            runat="server"
                            CssClass="form-select">
                        </asp:DropDownList>
                    </div>

                    <div class="d-flex justify-content-between mt-4">

                        <asp:Button ID="btnGuardar"
                            runat="server"
                            Text="🔄 Confirmar Reprogramación"
                            CssClass="btn btn-warning"
                            OnClick="btnGuardar_Click" />

                        <asp:Button ID="btnVolver"
                            runat="server"
                            Text="↩ Volver"
                            CssClass="btn btn-secondary"
                            OnClick="btnVolver_Click" />

                    </div>

                </div>

            </div>

        </div>

    </div>

</div>
</asp:Content>
