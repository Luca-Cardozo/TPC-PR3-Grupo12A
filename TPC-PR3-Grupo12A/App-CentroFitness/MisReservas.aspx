<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="MisReservas.aspx.cs" Inherits="App_CentroFitness.MisReservas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4 mb-5">

        <div class="row justify-content-center">

            <div class="col-lg-8">

                <div class="card shadow-sm mb-4">

                    <div class="card-body">

                        <h4 class="text-center mb-4">🔎 Filtrar reservas</h4>

                        <div class="row g-3 justify-content-center">

                            <div class="col-md-4">
                                <label class="form-label">Disciplina</label>
                                <asp:DropDownList ID="ddlDisciplinaFiltro" runat="server" CssClass="form-select" />
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">Desde</label>
                                <asp:TextBox ID="txtDesde" runat="server" TextMode="Date" CssClass="form-control" />
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">Hasta</label>
                                <asp:TextBox ID="txtHasta" runat="server" TextMode="Date" CssClass="form-control" />
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">Estado</label>
                                <asp:DropDownList ID="ddlEstadoFiltro" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Todos" Value="0" />
                                    <asp:ListItem Text="Vigentes" Value="1" />
                                    <asp:ListItem Text="Canceladas" Value="2" />
                                    <asp:ListItem Text="Finalizadas" Value="3" />
                                    <asp:ListItem Text="Reprogramadas" Value="4" />
                                </asp:DropDownList>
                            </div>

                        </div>

                        <div class="d-flex justify-content-center gap-2 mt-4">
                            <asp:Button ID="btnBuscar" runat="server" Text="🔍 Buscar" CssClass="btn btn-primary px-4" OnClick="btnBuscar_Click" />
                            <asp:Button ID="btnRecargar" runat="server" Text="↻ Recargar" CssClass="btn btn-outline-secondary px-4" OnClick="btnRecargar_Click" />
                        </div>

                    </div>

                </div>

            </div>

        </div>


        <div class="row justify-content-center">

            <div class="col-lg-7">

                <asp:Repeater ID="rptReservas" runat="server">
                    <ItemTemplate>

                        <div class="card shadow-sm mb-3 border-0">

                            <div class="card-body">

                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h5 class="mb-0 fw-bold"><%# Eval("Clase.Disciplina.Nombre") %></h5>
                                    <span class="badge bg-secondary px-3 py-2"><%# Eval("Estado") %></span>
                                </div>

                                <hr class="my-2" />

                                <p class="mb-2">📅<strong>Fecha: </strong><%# Eval("Clase.Fecha", "{0:dd/MM/yyyy}") %></p>
                                <p class="mb-2">🕐<strong>Horario: </strong><%# Eval("Clase.HoraInicio") %>:00 - <%# Eval("Clase.HoraFin") %>:00 hs</p>
                                <p class="mb-0 text-muted">Reserva realizada: <%# Eval("FechaReserva", "{0:dd/MM/yyyy HH:mm}") %></p>


                                <asp:Button ID="btnCancelar" runat="server" Text="❌ Cancelar reserva" CssClass="btn btn-outline-danger" CommandArgument='<%# Eval("IdReserva") %>' OnClick="btnCancelar_Click" Visible='<%# (Dominio.Estado)Eval("Estado") == Dominio.Estado.Vigente %>' />
                            </div>

                        </div>

                       
                    </ItemTemplate>
                </asp:Repeater>

            </div>

        </div>

    </div>


    <div class="row mt-4 mb-5">
        <div class="col-12 text-center">
            <asp:Button ID="btnVolverHome" runat="server" Text="🏠 Volver a página principal" OnClick="btnVolverHome_Click" CssClass="btn btn-outline-primary px-4 py-2 shadow-sm" />
        </div>
    </div>

</asp:Content>
