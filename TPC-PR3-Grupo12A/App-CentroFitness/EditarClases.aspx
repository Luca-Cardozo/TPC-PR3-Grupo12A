<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="EditarClases.aspx.cs" Inherits="App_CentroFitness.EditarClases" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-5">

        <div class="text-center mb-5">
            <h1>Administración de Clases</h1>
        </div>

        <div class="container mt-4">

            <div class="d-flex justify-content-between mb-4">
                <asp:Button ID="btnNuevaClase" runat="server" Text="+ Nueva clase" CssClass="btn btn-success" OnClick="btnNuevaClase_Click" />
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
                                        <span class='badge <%#(Dominio.EstadoClase)Eval("Estado") == Dominio.EstadoClase.Vigente ? "bg-success" : "bg-danger"%>'>
                                            <%# Eval("Estado") %>
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <asp:Button ID="btnEditar" runat="server" Text="✏️ Editar" CssClass="btn btn-outline-primary btn-sm" CommandArgument='<%#Eval("IdClase") %>' OnClick="btnEditar_Click" />
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>

                    </tbody>

                </table>

            </div>

        </div>

    </div>

    <div class="row mt-4">

        <div class="col-12 text-center">

            <asp:Button ID="btnVolverHome" runat="server" Text="🏠 Volver a página principal" OnClick="btnVolverHome_Click" CssClass="btn btn-outline-primary px-4 py-2 shadow-sm" />

        </div>

    </div>


</asp:Content>
