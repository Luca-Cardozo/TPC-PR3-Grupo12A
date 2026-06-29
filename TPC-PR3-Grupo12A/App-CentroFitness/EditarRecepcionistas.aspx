<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="EditarRecepcionistas.aspx.cs" Inherits="App_CentroFitness.EditarRecepcionistas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <div class="container mt-5">

        <div class="text-center mb-5">
            <h1>Administración de Recepcionistas</h1>
        </div>

        <asp:UpdatePanel ID="upRecepcionistas" runat="server">
            <ContentTemplate>

                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <h5 class="mb-3">Filtros de búsqueda</h5>

                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label">Nombre</label>
                                <asp:TextBox ID="txtNombreFiltro" runat="server" CssClass="form-control" placeholder="Nombre..." />
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">Apellido</label>
                                <asp:TextBox ID="txtApellidoFiltro" runat="server" CssClass="form-control" placeholder="Apellido..." />
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">DNI</label>
                                <asp:TextBox ID="txtDniFiltro" runat="server" CssClass="form-control" TextMode="Number" placeholder="00000000" />
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">Estado</label>
                                <asp:DropDownList ID="ddlEstadoFiltro" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Todos" Value="0" />
                                    <asp:ListItem Text="Activos" Value="1" />
                                    <asp:ListItem Text="Inactivos" Value="2" />
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div class="d-flex justify-content-center gap-2 mt-4">
                            <asp:Button ID="btnBuscar" runat="server" Text="🔍 Buscar" CssClass="btn btn-primary" OnClick="btnBuscar_Click" />
                            <asp:Button ID="btnLimpiar" runat="server" Text="↻ Recargar" CssClass="btn btn-outline-secondary" OnClick="btnLimpiar_Click" />
                        </div>
                    </div>
                </div>

                <div class="row justify-content-center mb-4">
                    <div class="col-md-4 d-grid">
                        <a href="FormularioRecepcionista.aspx" class="btn btn-success btn-lg p-3">➕ Agregar Recepcionista </a>
                    </div>
                </div>

                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <asp:GridView ID="dgvRecepcionistas" runat="server" DataKeyNames="IdUsuario"
                            CssClass="table table-striped table-hover" AutoGenerateColumns="false"
                            OnSelectedIndexChanged="dgvRecepcionistas_SelectedIndexChanged">
                            <Columns>
                                <asp:BoundField HeaderText="Nombre" DataField="Nombre">
                                    <HeaderStyle CssClass="w-15" />
                                </asp:BoundField>

                                <asp:BoundField HeaderText="Apellido" DataField="Apellido">
                                    <HeaderStyle CssClass="w-15" />
                                </asp:BoundField>

                                <asp:BoundField HeaderText="DNI" DataField="DNI">
                                    <HeaderStyle CssClass="w-15" />
                                </asp:BoundField>

                                <asp:BoundField HeaderText="Email" DataField="Email">
                                    <HeaderStyle CssClass="w-25" />
                                </asp:BoundField>

                                <asp:TemplateField HeaderText="Estado">
                                    <ItemStyle CssClass="text-center" />
                                    <ItemTemplate>
                                        <span class='<%# (bool)Eval("Activo") ? "badge bg-success" : "badge bg-danger" %>'>
                                            <%# (bool)Eval("Activo") ? "Activo" : "Inactivo" %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:CommandField HeaderText="Acción" ShowSelectButton="true" SelectText="✍️ Modificar/Eliminar">
                                    <HeaderStyle CssClass="text-center" />
                                    <ItemStyle CssClass="text-center" />
                                </asp:CommandField>

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
