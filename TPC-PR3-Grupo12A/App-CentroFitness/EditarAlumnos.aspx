<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="EditarAlumnos.aspx.cs" Inherits="App_CentroFitness.ListadoAlumnos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-5">

        <div class="text-center mb-5">
            <h1>Administración de Alumnos</h1>

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

                    <div class="d-flex gap-2 mt-4">
                        <asp:Button ID="btnBuscar" runat="server" Text="🔍 Buscar" CssClass="btn btn-primary" OnClick="btnBuscar_Click" />
                        <asp:Button ID="btnLimpiar" runat="server" Text="↻ Recargar" CssClass="btn btn-outline-secondary" OnClick="btnLimpiar_Click" />
                    </div>
                </div>
            </div>


            <div class="row justify-content-center mb-4">
                <div class="col-md-4 d-grid">
                    <a href="FormularioAlumno.aspx" class="btn btn-success btn-lg p-3">➕ Agregar Alumno
                    </a>
                </div>
            </div>

            <div class="row justify-content-center">
                <div class="col-md-8">
                    <asp:GridView ID="dgvAlumnos" runat="server" DataKeyNames="IdUsuario"
                        CssClass="table table-striped table-hover" AutoGenerateColumns="false" AllowPaging="true"  PageSize="8"
    OnPageIndexChanging="dgvAlumnos_PageIndexChanging">
                        <Columns>
                            <asp:BoundField DataField="IdUsuario" HeaderText="ID" />

                            <asp:BoundField DataField="Nombre" HeaderText="Nombre" />

                            <asp:BoundField DataField="Apellido" HeaderText="Apellido" />

                            <asp:BoundField DataField="DNI" HeaderText="DNI" />

                            <asp:BoundField DataField="Email" HeaderText="Email" />
                            <asp:CheckBoxField DataField="Activo" HeaderText="Estado" />

                            <asp:TemplateField HeaderText="Acciones">
                                <ItemTemplate>

                                    <asp:Button
                                        ID="btnEditarAlumno"
                                        runat="server"
                                        Text="✏️ Ver/Editar"
                                        CssClass="btn btn-primary btn-sm me-1"
                                        CommandArgument='<%# Eval("IdUsuario") %>'
                                        OnClick="btnEditarAlumno_Click" />

                                    <asp:Button
                                        ID="btnEditarSuscripcion"
                                        runat="server"
                                        Text="📋 Suscripción"
                                        CssClass="btn btn-outline-success btn-sm"
                                        CommandArgument='<%# Eval("IdUsuario") %>'
                                        OnClick="btnEditarSuscripcion_Click" />

                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <div class="row mt-4 mb-5">
        <div class="col-12 text-center">
            <asp:Button ID="btnVolverHome" runat="server" Text="🏠 Volver a página principal" OnClick="btnVolverHome_Click" CssClass="btn btn-outline-primary px-4 py-2 shadow-sm" />
        </div>
    </div>

</asp:Content>
