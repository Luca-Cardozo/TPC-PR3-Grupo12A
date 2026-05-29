<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Alumnos.aspx.cs" Inherits="App_CentroFitness.ListadoAlumnos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-4 d-grid gap-2 d-md-block">
            <asp:Button ID="btnVolverHome" runat="server" Text="Volver a página principal" OnClick="btnVolverHome_Click" CssClass="btn btn-primary" />
        </div>
    </div>
</asp:Content>
