<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="FormularioReserva.aspx.cs" Inherits="App_CentroFitness.FormularioReserva" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="container mt-4 mb-5">
        <div class="row justify-content-center">
            <div class="col-lg-7">

                <div class="card shadow-sm">

                    <div class="card-header text-center">
                        <h4 class="mb-0">
                            <asp:Label ID="lblTitulo" runat="server" Text="Editar Reserva" />
                        </h4>
                    </div>

                    <asp:Label ID="lblMensaje" runat="server" CssClass="alert alert-danger d-block text-center" Visible="false" />


                    <div class="card-body">

                        <div class="mb-3">
                            <label class="form-label">ID Reserva</label>
                            <asp:TextBox ID="txtIdReserva" runat="server" CssClass="form-control bg-light text-muted" ReadOnly="true" />
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Clase</label>
                            <asp:TextBox ID="txtClase" runat="server" CssClass="form-control bg-light text-muted" ReadOnly="true" />
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Fecha</label>
                                <asp:TextBox ID="txtFechaClase" runat="server" CssClass="form-control bg-light text-muted" ReadOnly="true" />
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label">Horario</label>
                                <asp:TextBox ID="txtHorario" runat="server" CssClass="form-control bg-light text-muted" ReadOnly="true" />
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Alumno</label>
                            <asp:TextBox ID="txtAlumno" runat="server" CssClass="form-control bg-light text-muted" ReadOnly="true" />
                        </div>

                        <hr />

                        <div class="mb-3">
                            <label class="form-label">Estado de la reserva</label>
                            <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Cancelada" Value="2" />
                                <asp:ListItem Text="Finalizada" Value="3" />
                            </asp:DropDownList>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Asistencia</label>
                            <asp:DropDownList ID="ddlAsistencia" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Sin definir" Value="" />
                                <asp:ListItem Text="Presente" Value="1" />
                                <asp:ListItem Text="Ausente" Value="2" />
                            </asp:DropDownList>
                        </div>


                        <div class="mb-3">
                            <label class="form-label">Observaciones</label>
                            <asp:TextBox ID="txtObservaciones" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                        </div>

                        <div class="d-flex justify-content-between mt-4">
                            <asp:Button ID="btnGuardar" runat="server" Text="💾 Guardar cambios" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
                            <asp:Button ID="btnVolver" runat="server" Text="↩ Volver" CssClass="btn btn-secondary" OnClick="btnVolver_Click" />
                        </div>

                    </div>
                </div>

            </div>
        </div>

    </div>

</asp:Content>
