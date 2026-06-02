<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="EditarAlumnos.aspx.cs" Inherits="App_CentroFitness.ListadoAlumnos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-5">

        <div class="text-center mb-5">
            <h1>Administración de Alumnos</h1>
        </div>

        <div class="row justify-content-center">
            <div class="col-md-8">
                <%--<asp:GridView ID="dgvAlumnos" runat="server" DataKeyNames="IdUsuario"
                    CssClass="table table-striped table-hover" AutoGenerateColumns="false"
                    OnSelectedIndexChanged="dgvAlumnos_SelectedIndexChanged">
                    <Columns>
                        
                    </Columns>
                </asp:GridView>--%>
            </div>
        </div>

        <div class="row justify-content-center g-3">

            <div class="col-md-3 d-grid">
                <a href="FormularioAlumno.aspx" class="btn btn-success btn-lg p-4">➕ Agregar Alumno </a>
            </div>

        </div>

    </div>


    <div class="row">
        <div class="col-4 d-grid gap-2 d-md-block">
            <asp:Button ID="btnVolverHome" runat="server" Text="Volver a página principal" OnClick="btnVolverHome_Click" CssClass="btn btn-primary" />
        </div>
    </div>
</asp:Content>
