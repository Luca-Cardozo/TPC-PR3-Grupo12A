<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="EditarDisciplinas.aspx.cs" Inherits="App_CentroFitness.EditarDisciplinas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-5">

        <asp:GridView ID="dgvDisciplinas" runat="server" DataKeyNames="IdDisciplina" CssClass="table table-striped table-hover" AutoGenerateColumns="false">
            <columns>
                <asp:BoundField HeaderText="Nombre" DataField="Nombre" />
                <asp:CheckBoxField HeaderText="Activa" DataField="Activa" />
                <asp:CommandField HeaderText="Acción" ShowSelectButton="true" SelectText="✍" />
            </columns>
        </asp:GridView>

        <div class="text-center mb-5">
            <h1>Administración de Disciplinas</h1>
        </div>

        <div class="row justify-content-center g-3">

            <div class="col-md-3 d-grid">
                <a href="FormularioDisciplina.aspx" class="btn btn-success btn-lg p-4">➕ Agregar Disciplina </a>
            </div>

            <div class="col-md-3 d-grid">
                <a href="FormularioDisciplina.aspx" class="btn btn-warning btn-lg p-4">✏️ Modificar / Eliminar </a>
            </div>

        </div>

    </div>

</asp:Content>
