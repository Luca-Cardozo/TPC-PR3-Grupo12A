<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="App_CentroFitness.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">    
    <div class="container vh-100 d-flex justify-content-center align-items-center">
        <div class="card shadow p-4" style="width: 400px;">

            <h2 class="text-center mb-4">Login</h2>

            <div class="mb-3">
                <label class="form-label">Email</label>
                <asp:TextBox runat="server" CssClass="form-control" ID="txtEmail" />
            </div>

            <div class="mb-3">
                <label class="form-label">Password</label>
                <asp:TextBox runat="server" CssClass="form-control" ID="txtPassword" TextMode="Password" />
            </div>

            <div class="d-grid gap-2">
                <asp:Button Text="Ingresar" CssClass="btn btn-primary" ID="btnLogin" runat="server" />

                <asp:Button ID="btnVolverHome" runat="server" Text="Volver a página principal"
                    OnClick="btnVolverHome_Click"
                    CssClass="btn btn-outline-secondary" />
            </div>

        </div>
    </div>
</asp:Content>
