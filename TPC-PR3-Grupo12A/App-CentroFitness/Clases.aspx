<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Clases.aspx.cs" Inherits="App_CentroFitness.Clases" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4">

        <div class="text-center mb-4">
            <h2 class="fw-bold">📅 Clases Disponibles</h2>
            <p class="text-muted">Seleccione una clase para realizar la reserva.</p>
        </div>


        <div class="card shadow-sm mb-4">
            <div class="card-body">

                <h5 class="mb-3">🔎 Filtrar clases</h5>

                <div class="row g-3 align-items-end justify-content-center">

                    <div class="col-md-3">
                        <label class="form-label">Fecha desde</label>
                        <asp:TextBox ID="txtFechaDesde" runat="server" TextMode="Date" CssClass="form-control" />
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Fecha hasta</label>
                        <asp:TextBox ID="txtFechaHasta" runat="server" TextMode="Date" CssClass="form-control" />
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Disponibilidad</label>
                        <asp:DropDownList ID="ddlDisponibilidad" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Todas" Value="0" />
                            <asp:ListItem Text="Solo con cupo disponible" Value="1" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-3 d-flex gap-2">
                        <asp:Button ID="btnFiltrar" runat="server" Text="Buscar" CssClass="btn btn-primary w-50" OnClick="btnFiltrar_Click" />
                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn btn-outline-secondary w-50" OnClick="btnLimpiar_Click" />
                    </div>

                </div>

            </div>
        </div>


        <asp:Label ID="lblSinClases" runat="server" Visible="false" CssClass="alert alert-info d-block text-center">
            No hay clases disponibles para la disciplina seleccionada.
        </asp:Label>

        <asp:Repeater ID="repClases" runat="server">
            <ItemTemplate>
                <div class="row justify-content-center mb-4">
                    <div class="col-lg-6">
                        <div class="card shadow-sm border-0">
                            <div class="card-body">
                                <h4 class="card-title text-center mb-3"><%# Eval("Disciplina.Nombre") %></h4>
                                <hr />
                                <p class="mb-2">🏋️‍<strong>Instructor: </strong><%# Eval("Instructor.Nombre") %> <%# Eval("Instructor.Apellido") %></p>
                                <p class="mb-2">📅<strong>Fecha: </strong><%# Eval("Fecha", "{0:dd/MM/yyyy}") %></p>
                                <p class="mb-3">🕐<strong>Horario: </strong><%# Eval("HoraInicio") %>:00 - <%# Eval("HoraFin") %>:00 hs</p>
                                <p class="mb-3">
                                    👥 <strong>Cupos disponibles:</strong>
                                    <%# Eval("CuposDisponibles") %> / <%# Eval("CupoMaximo") %>
                                </p>
                                <div class="text-center">
                                    <asp:Button ID="btnSeleccionar"
                                        runat="server"
                                        Text='<%# (int)Eval("CuposDisponibles") > 0 ? "✅ Reservar clase" : "❌ Clase completa" %>'
                                        CssClass="btn btn-success px-4"
                                        CommandArgument='<%# Eval("IdClase") %>'
                                        OnClick="btnSeleccionar_Click"
                                        Enabled='<%# (int)Eval("CuposDisponibles") > 0 %>' />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <div class="row mt-4 mb-5">
            <div class="col-12 text-center">
                <asp:Button ID="btnVolver" runat="server" Text="💪 Volver a disciplinas" CssClass="btn btn-outline-primary px-4 py-2 shadow-sm" OnClick="btnVolver_Click" />
            </div>
        </div>

    </div>

</asp:Content>
