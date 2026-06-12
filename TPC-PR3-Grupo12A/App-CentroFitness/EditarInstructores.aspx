<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="EditarInstructores.aspx.cs" Inherits="App_CentroFitness.EditarInstructores" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-5">

        <div class="text-center mb-5">
            <h1>Administración de Instructores</h1>
        </div>

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

                    <div class="col-md-2">
                        <label class="form-label">DNI</label>
                        <asp:TextBox ID="txtDniFiltro" runat="server" CssClass="form-control" TextMode="Number" placeholder="00000000" />
                    </div>

                    <div class="col-md-2">
                        <label class="form-label">Disciplina</label>
                        <asp:DropDownList ID="ddlDisciplinaFiltro" runat="server" CssClass="form-select" />
                    </div>

                    <div class="col-md-2">
                        <label class="form-label">Estado</label>
                        <asp:DropDownList ID="ddlEstadoFiltro" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Todos" Value="0" />
                            <asp:ListItem Text="Activos" Value="1" />
                            <asp:ListItem Text="Inactivos" Value="2" />
                        </asp:DropDownList>
                    </div>

                </div>

                <div class="d-flex gap-2 mt-4">

                    <asp:Button ID="btnBuscar" runat="server" Text="🔍 Buscar" CssClass="btn btn-primary" OnClick="btnBuscar_Click" />
                    <asp:Button ID="btnLimpiar" runat="server" Text="↻ Recargar" CssClass="btn btn-outline-secondary" OnClick="btnLimpiar_Click" />

                </div>

            </div>

        </div>

        <div class="row justify-content-center">
            <div class="col-md-8">
                <asp:GridView ID="dgvInstructores" runat="server" DataKeyNames="IdUsuario"
                    CssClass="table table-striped table-hover" AutoGenerateColumns="false"
                    OnSelectedIndexChanged="dgvInstructores_SelectedIndexChanged">
                    <Columns>
                        <asp:BoundField HeaderText="Nombre" DataField="Nombre">
                            <HeaderStyle CssClass="w-20" />
                        </asp:BoundField>

                        <asp:BoundField HeaderText="Apellido" DataField="Apellido">
                            <HeaderStyle CssClass="w-20" />
                        </asp:BoundField>

                        <asp:BoundField HeaderText="DNI" DataField="DNI">
                            <HeaderStyle CssClass="w-20" />
                        </asp:BoundField>

                        <asp:BoundField HeaderText="Email" DataField="Email">
                            <HeaderStyle CssClass="w-20" />
                        </asp:BoundField>

                        <asp:CommandField HeaderText="Acción" ShowSelectButton="true" SelectText="✍️ Modificar/Eliminar">
                            <HeaderStyle CssClass="text-center w-20" />
                            <ItemStyle CssClass="text-center" />
                        </asp:CommandField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <div class="row justify-content-center g-3">

            <div class="col-md-3 d-grid">
                <a href="FormularioInstructor.aspx" class="btn btn-success btn-lg p-4">➕ Agregar Instructor </a>
            </div>

        </div>

    </div>

    <div class="row">
        <div class="col-4 d-grid gap-2 d-md-block">
            <asp:Button ID="btnVolverHome" runat="server" Text="Volver a página principal" OnClick="btnVolverHome_Click" CssClass="btn btn-primary" />
        </div>
    </div>
</asp:Content>
