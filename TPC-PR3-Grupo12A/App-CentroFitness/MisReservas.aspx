<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="MisReservas.aspx.cs" Inherits="App_CentroFitness.MisReservas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-5">

        <div class="text-center mb-5">
            <h1>Historial de reservas realizadas por el alumno</h1>
            <h2>(Vista de alumno)</h2>
        </div>

        <div class="row justify-content-center">
            <div class="col-md-8">
            </div>
        </div>

        <div class="row justify-content-center g-3">
        </div>

    </div>

    <div class="row mt-4 mb-5">
        <div class="col-12 text-center">
            <asp:Button ID="btnVolverHome" runat="server" Text="🏠 Volver a página principal" OnClick="btnVolverHome_Click" CssClass="btn btn-outline-primary px-4 py-2 shadow-sm" />
        </div>
    </div>

</asp:Content>
