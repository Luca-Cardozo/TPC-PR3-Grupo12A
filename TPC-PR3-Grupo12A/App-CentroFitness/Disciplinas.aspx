<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Disciplinas.aspx.cs" Inherits="App_CentroFitness.Disciplinas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4">

        <div class="row mb-4">
            <div class="col-12 text-center">
                <h1 class="fw-bold">🏋️ ¡Mirá todas las actividades que podés realizar!</h1>
                <p class="text-muted">Elegí una disciplina y consultá los horarios disponibles.</p>
            </div>
        </div>

        <div class="row g-4">
            <asp:Repeater ID="repDisciplinas" runat="server">
                <ItemTemplate>
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="card shadow-sm h-100 border-0">
                            <img src='<%# "Images/disciplina-" + Eval("IdDisciplina") + ".jpg" %>' class="card-img-top" alt="Disciplina" onerror="this.src='Images/placeholder.jpg';" style="height: 220px; object-fit: cover;" />
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title text-center mb-3"><%# Eval("Nombre") %></h5>
                                <div class="text-center mb-3">
                                    <span class='<%# (bool)Eval("Activa") ? "badge bg-success" : "badge bg-secondary" %>'><%# (bool)Eval("Activa") ? "Disponible" : "No disponible" %></span>
                                </div>
                                <div class="mt-auto text-center">
                                    <asp:Button ID="btnVerClases" runat="server" Text="📅 Ver clases" CssClass="btn btn-primary w-100" CommandArgument='<%# Eval("IdDisciplina") %>' OnClick="btnVerClases_Click" Visible='<%# (bool)Eval("Activa") %>' />
                                </div>
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
