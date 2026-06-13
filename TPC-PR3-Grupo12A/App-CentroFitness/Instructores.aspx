<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Instructores.aspx.cs" Inherits="App_CentroFitness.ListadoInstructores" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="row">
        <div class="col-12 text-center">
            <h1>¡Conocé a nuestros profes!</h1>
        </div>
    </div>

    <div class="row mb-3">
        <asp:Repeater ID="repInstructores" runat="server">
            <ItemTemplate>
                <div class="col-md-3 mb-3">
                    <div class="card">
                        <img src='<%# "Images/instructor-" + Eval("IdUsuario") + ".jpg" %>'
                            class="card-img-top"
                            alt="Instructor"
                            onerror="this.src='Images/placeholder.jpg';"
                            style="height: 220px; object-fit: cover;">
                        <div class="card-body">
                            <h5 class="card-title"><%# Eval("Nombre") %> <%# " " %> <%# Eval("Apellido") %></h5>
                        </div>
                        <asp:Repeater ID="repDisciplinas" runat="server" DataSource='<%# Eval("Disciplinas") %>'>
                            <ItemTemplate>
                                <span class="badge rounded-pill text-bg-light border me-1 mb-1">
                                    <%# Eval("Nombre") %>
                                </span>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <br />

    <div class="row mt-4 mb-5">
        <div class="col-12 text-center">
            <asp:Button ID="btnVolverHome" runat="server" Text="🏠 Volver a página principal" OnClick="btnVolverHome_Click" CssClass="btn btn-outline-primary px-4 py-2 shadow-sm" />
        </div>
    </div>

</asp:Content>
