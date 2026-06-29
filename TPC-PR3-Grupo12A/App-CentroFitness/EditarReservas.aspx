<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="EditarReservas.aspx.cs" Inherits="App_CentroFitness.EditarReservas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <div class="container mt-4 mb-5">

        <div class="text-center mb-5">
            <h1>Administración de Reservas</h1>
        </div>

        <asp:UpdatePanel ID="upReservas" runat="server">
            <ContentTemplate>

                <div class="row justify-content-center">

                    <div class="col-12">

                        <div class="card shadow-sm mb-4">

                            <div class="card-body">

                                <h4 class="text-center mb-4">🔎 Filtrar reservas</h4>

                                <div class="row g-3 mb-2">
                                    <div class="col-md-4">
                                        <label class="form-label">Nombre</label>
                                        <asp:TextBox ID="txtNombreFiltro" runat="server" CssClass="form-control" placeholder="Ingrese un nombre" />
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label">Apellido</label>
                                        <asp:TextBox ID="txtApellidoFiltro" runat="server" CssClass="form-control" placeholder="Ingrese un apellido" />
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label">DNI</label>
                                        <asp:TextBox ID="txtDniFiltro" runat="server" CssClass="form-control" TextMode="Number" placeholder="Ingrese un DNI" />
                                    </div>

                                </div>

                                <div class="row g-3 justify-content-center mt-1">
                                    <div class="col-md-3">
                                        <label class="form-label">Disciplina</label>
                                        <asp:DropDownList ID="ddlDisciplinaFiltro" runat="server" CssClass="form-select" />
                                    </div>

                                    <div class="col-md-2">
                                        <label class="form-label">Desde</label>
                                        <asp:TextBox ID="txtDesde" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>

                                    <div class="col-md-2">
                                        <label class="form-label">Hasta</label>
                                        <asp:TextBox ID="txtHasta" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>

                                    <div class="col-md-3">
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
                </div>

    <div class="row justify-content-center mb-4">
        <div class="col-md-4 d-grid">
            <asp:Button ID="btnNuevaReserva" runat="server" Text="➕ Nueva reserva" CssClass="btn btn-success btn-lg p-3" OnClick="btnNuevaReserva_Click" />
        </div>
    </div>

                <div class="container mb-5">
                    <div class="row justify-content-center">
                        <div class="col-12">

                            <asp:GridView ID="dgvReservas" runat="server" DataKeyNames="IdReserva" AutoGenerateColumns="false" CssClass="table table-striped table-bordered table-hover shadow-sm" AllowPaging="true" PageSize="8"
                                OnPageIndexChanging="dgvReservas_PageIndexChanging">

                                <Columns>
                                    <asp:BoundField HeaderText="DNI" DataField="Alumno.DNI" />
                                    <asp:BoundField HeaderText="Apellido" DataField="Alumno.Apellido" />
                                    <asp:BoundField HeaderText="Nombre" DataField="Alumno.Nombre" />
                                    <asp:BoundField HeaderText="Disciplina" DataField="Clase.Disciplina.Nombre" />
                                    <asp:BoundField HeaderText="Fecha" DataField="Clase.Fecha" DataFormatString="{0:dd/MM/yyyy}" />
                                    <asp:TemplateField HeaderText="Hora">
                                        <ItemStyle CssClass="text-center" />
                                        <ItemTemplate>
                                            <%# Eval("Clase.HoraInicio") %>:00 hs   
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Estado">
                                        <ItemStyle CssClass="text-center" />
                                        <ItemTemplate>
                                            <span class='<%# obtenerClaseBadgeEstado(Eval("Estado")) %>'>
                                                <%# Eval("Estado") %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="Observaciones" DataField="Observaciones" />
                                    <asp:TemplateField HeaderText="Acción">
                                        <ItemTemplate>
                                            <div class="d-flex flex-column gap-2 align-items-center">

                                                <asp:Button ID="btnEditar"
                                                    runat="server"
                                                    Text="✏️ Editar"
                                                    CssClass="btn btn-primary btn-sm"
                                                    CommandArgument='<%# Eval("IdReserva") %>'
                                                    OnClick="btnEditar_Click"
                                                    Visible='<%# (Dominio.Estado)Eval("Estado") == Dominio.Estado.Vigente %>' />

                                                <asp:Button ID="btnReprogramar"
                                                    runat="server"
                                                    Text="🔄 Reprogramar"
                                                    CssClass="btn btn-info btn-sm"
                                                    CommandArgument='<%# Eval("IdReserva") %>'
                                                    OnClick="btnReprogramar_Click"
                                                    Visible='<%# (Dominio.Estado)Eval("Estado") == Dominio.Estado.Vigente %>' />

                                                <asp:Button ID="btnVer"
                                                    runat="server"
                                                    Text="👁 Ver"
                                                    CssClass="btn btn-secondary btn-sm"
                                                    CommandArgument='<%# Eval("IdReserva") %>'
                                                    OnClick="btnVer_Click"
                                                    Visible='<%# (Dominio.Estado)Eval("Estado") != Dominio.Estado.Vigente %>' />

                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>

                            </asp:GridView>

                        </div>
                    </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <div class="row mt-4 mb-5">
        <div class="col-12 text-center">
            <asp:Button ID="btnVolverHome" runat="server" Text="🏠 Volver a página principal" OnClick="btnVolverHome_Click" CssClass="btn btn-outline-primary px-4 py-2 shadow-sm" />
        </div>
    </div>
</asp:Content>
