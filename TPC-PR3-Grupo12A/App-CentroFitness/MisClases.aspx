<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="MisClases.aspx.cs" Inherits="App_CentroFitness.MisClases" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="container mt-4">

        <div class="text-center mb-4">
            <h1 class="display-6 mb-1">Mis Clases</h1>
            <asp:Label ID="lblTitulo" runat="server" CssClass="text-muted fs-5" />
        </div>

        <asp:Panel ID="pnlProximasClases" runat="server">

            <div class="card shadow-sm mb-4">
                <div class="card-body">

                    <h5 class="mb-4 border-bottom pb-2">📅 Clases de hoy y mañana</h5>

                    <asp:Repeater ID="rptProximasClases" runat="server">
                        <ItemTemplate>

                            <div class="border rounded p-3 mb-3 bg-light">

                                <div class="d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0"><%# Eval("Disciplina.Nombre") %></h5>
                                    <span class="badge bg-primary px-3 py-2">
                                        <%# Eval("Fecha", "{0:dd/MM/yyyy}") %>
                                    </span>
                                </div>

                                <div class="text-muted mt-2">
                                    🕐 <%# Eval("HoraInicio") %>:00 - <%# Eval("HoraFin") %>:00 hs
                                </div>

                                <div class="text-muted">
                                    👥 Reservas: <%# Eval("CantidadReservas") %> / <%# Eval("CupoMaximo") %>
                                </div>

                            </div>

                        </ItemTemplate>
                    </asp:Repeater>

                    <asp:Label ID="lblSinProximasClases" runat="server"
                        Text="No tenés próximas clases vigentes asignadas."
                        CssClass="alert alert-info d-block text-center mb-0"
                        Visible="false" />

                </div>
            </div>

        </asp:Panel>


        <div class="card shadow-sm mb-4">
            <div class="card-body">

                <h5 class="mb-4 border-bottom pb-2">📋 Tomar asistencia</h5>

                <div class="row g-3 align-items-end justify-content-center">
                    <div class="col-md-7">
                        <label class="form-label">Seleccione una clase para registrar asistencia</label>
                        <asp:DropDownList ID="ddlClases" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlClases_SelectedIndexChanged" />
                    </div>

                    <div class="col-md-2">
                        <asp:Button ID="btnLimpiar" runat="server" Text="Recargar"
                            CssClass="btn btn-outline-secondary w-100"
                            OnClick="btnLimpiar_Click" />
                    </div>
                </div>

            </div>
        </div>

        <asp:Label ID="lblInfoClase" runat="server"
            CssClass="alert alert-info d-block text-center"
            Visible="false" />

        <asp:Panel ID="pnlAsistencia" runat="server" Visible="false">

            <div class="card shadow-sm mb-4">
                <div class="card-body">

                    <h5 class="mb-4 border-bottom pb-2">📋 Registro de asistencia</h5>

                    <asp:GridView ID="dgvAsistencia" runat="server"
                        CssClass="table table-hover table-striped align-middle shadow-sm"
                        AutoGenerateColumns="false"
                        DataKeyNames="IdReserva">

                        <HeaderStyle CssClass="table-dark text-center" />

                        <Columns>
                            <asp:TemplateField HeaderText="Alumno">
                                <ItemStyle CssClass="text-center" />
                                <ItemTemplate>
                                    <%# Eval("Alumno.Nombre") %> <%# Eval("Alumno.Apellido") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Presente">
                                <ItemStyle CssClass="text-center" />
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkPresente" runat="server"
                                        Checked='<%# Eval("Asistencia") != null && (int)Eval("Asistencia") == 1 %>' />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Observaciones">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtObservaciones" runat="server"
                                        Text='<%# Eval("Observaciones") %>'
                                        CssClass="form-control"
                                        placeholder="Observaciones del alumno..." />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                    <div class="text-end mt-3">
                        <asp:Button ID="btnGuardarAsistencia" runat="server"
                            Text="💾 Guardar asistencia"
                            CssClass="btn btn-success px-4"
                            OnClick="btnGuardarAsistencia_Click" />
                    </div>

                </div>
            </div>

        </asp:Panel>

    </div>


    <div class="row mt-4 mb-5">
        <div class="col-12 text-center">
            <asp:Button ID="btnVolverHome" runat="server" Text="🏠 Volver a página principal" OnClick="btnVolverHome_Click" CssClass="btn btn-outline-primary px-4 py-2 shadow-sm" />
        </div>
    </div>

</asp:Content>
