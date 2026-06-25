<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Instructores.aspx.cs" Inherits="App_CentroFitness.Instructores" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4">

        <div class="row mb-4">
            <div class="col-12 text-center">
                <h1 class="fw-bold">💪 ¡Conocé a nuestros profes!</h1>
                <p class="text-muted">Nuestro equipo de profesionales te acompaña en cada entrenamiento.</p>
            </div>
        </div>

        <div class="row g-4">
            <asp:Repeater ID="repInstructores" runat="server">
                <ItemTemplate>
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="card shadow-sm h-100 border-0">
                            <img src='<%# "Images/instructor-" + Eval("IdUsuario") + ".jpg" %>' class="card-img-top" alt="Instructor" onerror="this.src='Images/placeholder.jpg';" style="height: 220px; object-fit: cover;" />
                            <div class="card-body text-center">
                                <h5 class="card-title mb-3"><%# Eval("Nombre") %><%# " " %><%# Eval("Apellido") %></h5>
                                <asp:Repeater ID="repDisciplinas" runat="server" DataSource='<%# Eval("Disciplinas") %>'>
                                    <ItemTemplate>
                                        <span class="badge rounded-pill text-bg-light border me-1 mb-1"><%# Eval("Nombre") %></span>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div class="row mt-5 mb-5">
            <div class="col-12 text-center">
                <asp:Button ID="btnVolverHome" runat="server" Text="🏠 Volver a página principal" OnClick="btnVolverHome_Click" CssClass="btn btn-outline-primary px-4 py-2 shadow-sm" />
            </div>
        </div>

    </div>

</asp:Content>
