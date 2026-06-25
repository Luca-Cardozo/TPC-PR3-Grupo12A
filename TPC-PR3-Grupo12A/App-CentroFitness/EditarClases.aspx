<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="EditarClases.aspx.cs" Inherits="App_CentroFitness.EditarClases" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-5">

        <div class="text-center mb-5">
            <h1>Administración de Clases</h1>
        </div>

        <div class="container mt-4">

            <div class="card shadow-sm mb-4">

                <div class="card-body">

                    <h5 class="mb-3">Filtros de búsqueda</h5>

                    <div class="row g-3">

                        <div class="col-md-2">
                            <label class="form-label">Desde</label>
                            <asp:TextBox ID="txtFechaDesde" runat="server" CssClass="form-control" TextMode="Date" />
                        </div>

                        <div class="col-md-2">
                            <label class="form-label">Hasta</label>
                            <asp:TextBox ID="txtFechaHasta" runat="server" CssClass="form-control" TextMode="Date" />
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Instructor</label>
                            <asp:DropDownList ID="ddlInstructorFiltro" runat="server" CssClass="form-select" />
                        </div>

                        <div class="col-md-2">
                            <label class="form-label">Disciplina</label>
                            <asp:DropDownList ID="ddlDisciplinaFiltro" runat="server" CssClass="form-select" />
                        </div>

                        <div class="col-md-2">
                            <label class="form-label">Estado</label>
                            <asp:DropDownList ID="ddlEstadoFiltro" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Todas" Value="0" />
                                <asp:ListItem Text="Vigentes" Value="1" />
                                <asp:ListItem Text="Canceladas" Value="2" />
                                <asp:ListItem Text="Finalizadas" Value="3" />
                                <asp:ListItem Text="Reprogramadas" Value="4" />
                            </asp:DropDownList>
                        </div>

                    </div>

                    <div class="d-flex gap-2 mt-4">

                        <asp:Button ID="btnBuscar" runat="server" Text="🔍 Buscar" CssClass="btn btn-primary" OnClick="btnBuscar_Click" />
                        <asp:Button ID="btnRecargar" runat="server" Text="↻ Recargar" CssClass="btn btn-outline-secondary" OnClick="btnRecargar_Click" />

                    </div>

                </div>

            </div>

            <div class="row justify-content-center mb-4">
                <div class="col-md-4 d-grid">
                    <asp:Button ID="btnNuevaClase" runat="server" Text="➕ Nueva clase" CssClass="btn btn-success btn-lg p-3" OnClick="btnNuevaClase_Click" />
                </div>
            </div>

            <div class="table-responsive">

                <table class="table table-hover align-middle shadow-sm">

                    <thead class="table-dark">

                        <tr>
                            <th>Fecha</th>
                            <th>Horario</th>
                            <th>Disciplina</th>
                            <th>Instructor</th>
                            <th>Cupo</th>
                            <th>Estado</th>
                            <th class="text-center">Acción</th>
                        </tr>

                    </thead>

                    <tbody>

                        <asp:Repeater ID="repClases" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <%# Eval("Fecha", "{0:dd/MM/yyyy}") %>
                                    </td>
                                    <td>
                                        <%# Eval("HoraInicio") %>:00 - <%# Eval("HoraFin") %>:00
                                    </td>
                                    <td>
                                        <%# Eval("Disciplina.Nombre") %>
                                    </td>
                                    <td>
                                        <%# Eval("Instructor.Nombre") %>
                                        <%# Eval("Instructor.Apellido") %>
                                    </td>
                                    <td>
                                        <%# Eval("CupoMaximo") %>
                                    </td>
                                    <td>
                                        <span class='badge 
                                        <%# (Dominio.EstadoClase)Eval("Estado") == Dominio.EstadoClase.Vigente ? "bg-success" :
                                            (Dominio.EstadoClase)Eval("Estado") == Dominio.EstadoClase.Finalizada ? "bg-primary" :
                                            (Dominio.EstadoClase)Eval("Estado") == Dominio.EstadoClase.Reprogramada ? "bg-warning text-dark" :
                                            "bg-danger" %>'>
                                            <%# Eval("Estado") %>
                                        </span>
                                    </td>
                                    <td class="text-center">

                                        <asp:Button ID="btnEditar" runat="server" Text="✏️ Editar" CssClass="btn btn-outline-primary btn-sm" CommandArgument='<%#Eval("IdClase") %>' OnClick="btnEditar_Click" Visible='<%# (Dominio.EstadoClase)Eval("Estado") == Dominio.EstadoClase.Vigente %>' />

                                        <br />

                                        <asp:Button ID="btnReprogramar" runat="server" Text="🔄 Reprogramar" CssClass="btn btn-outline-warning btn-sm" CommandArgument='<%# Eval("IdClase") %>' OnClick="btnReprogramar_Click" Visible='<%# (Dominio.EstadoClase)Eval("Estado") == Dominio.EstadoClase.Vigente %>' />


                                        <asp:Button ID="btnVer" runat="server" Text="👁 Ver" CssClass="btn btn-outline-secondary btn-sm" CommandArgument='<%# Eval("IdClase") %>' OnClick="btnVer_Click" Visible='<%# (Dominio.EstadoClase)Eval("Estado") != Dominio.EstadoClase.Vigente %>' />
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>

                    </tbody>

                </table>

            </div>

        </div>

    </div>


    
    
<div class="row mt-4 mb-5">
    <div class="col-12 text-center">
        <asp:Button ID="btnVolverHome" runat="server" Text="🏠 Volver a página principal" OnClick="btnVolverHome_Click" CssClass="btn btn-outline-primary px-4 py-2 shadow-sm" />
            
       
    </div>
</div>

</asp:Content>
