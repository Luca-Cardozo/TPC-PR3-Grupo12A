<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="EditarReservas.aspx.cs" Inherits="App_CentroFitness.EditarReservas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-5">

    <div class="text-center mb-5">
        <h1>Administración de Reservas</h1>
    </div>

    <div class="row justify-content-center">
        <div class="col-md-8">

        </div>
    </div>

    <div class="row justify-content-center g-3">

        <div class="col-md-3 d-grid">

        </div>

    </div>

</div>

<div class="row">
    <div class="col-4 d-grid gap-2 d-md-block">
        <asp:Button ID="btnVolverHome" runat="server" Text="Volver a página principal" OnClick="btnVolverHome_Click" CssClass="btn btn-primary" />
    </div>
</div>

</asp:Content>
