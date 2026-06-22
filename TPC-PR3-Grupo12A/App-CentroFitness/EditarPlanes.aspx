<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="EditarPlanes.aspx.cs" Inherits="App_CentroFitness.EditarPlanes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-5">

        <div class="text-center mb-5">
            <h1>Administración de Planes</h1>
        </div>

        <div class="row justify-content-center mb-4">
            <div class="col-lg-9">

                <div class="card shadow-sm mb-4">
                    <div class="card-body">

                        <h5 class="mb-3">Filtros de búsqueda</h5>

                        <div class="row g-3 align-items-end">

                            <div class="col-md-3">
                                <label class="form-label">Estado</label>
                                <asp:DropDownList ID="ddlEstadoFiltro" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlEstadoFiltro_SelectedIndexChanged">
                                    <asp:ListItem Text="Todos" Value="0" />
                                    <asp:ListItem Text="Activos" Value="1" />
                                    <asp:ListItem Text="Inactivos" Value="2" />
                                </asp:DropDownList>
                            </div>

                        </div>

                    </div>
                </div>

                <div class="row justify-content-center mb-4">
                    <div class="col-md-5 d-grid">
                        <a href="FormularioPlan.aspx" class="btn btn-success btn-lg p-3">➕ Agregar Plan
                        </a>
                    </div>
                </div>

                <asp:GridView ID="dgvPlanes" runat="server" DataKeyNames="IdPlan" CssClass="table table-striped table-hover table-bordered shadow-sm" AutoGenerateColumns="false">
                    <Columns>

                        <asp:BoundField DataField="IdPlan" HeaderText="ID" />

                        <asp:BoundField DataField="Descripcion" HeaderText="Descripción" />

                        <asp:TemplateField HeaderText="Cantidad de clases">
                            <ItemTemplate>
                                <%# Eval("CantidadClases") == null ? "Libre" : Eval("CantidadClases") + " clases" %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="DuracionDias" HeaderText="Duración (días)" />

                        <asp:BoundField DataField="Precio" HeaderText="Precio" DataFormatString="{0:C}" />

                        <asp:CheckBoxField DataField="Activo" HeaderText="Activo" />

                        <asp:TemplateField HeaderText="Acción">
                            <ItemStyle CssClass="text-center" />
                            <ItemTemplate>
                                <asp:Button ID="btnEditarPlan" runat="server"
                                    Text="✏️ Ver/Editar"
                                    CssClass="btn btn-primary btn-sm"
                                    CommandArgument='<%# Eval("IdPlan") %>'
                                    OnClick="btnEditarPlan_Click" />
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>

            </div>
        </div>

        <div class="row mt-4 mb-5">
            <div class="col-12 text-center">
                <asp:Button ID="btnVolverHome" runat="server" Text="🏠 Volver a página principal" CssClass="btn btn-outline-primary px-4 py-2 shadow-sm" OnClick="btnVolverHome_Click1" />
            </div>
        </div>

    </div>

</asp:Content>
