<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="EditarDisciplinas.aspx.cs" Inherits="App_CentroFitness.EditarDisciplinas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-5">

        <div class="text-center mb-5">
            <h1>Administración de Disciplinas</h1>
        </div>

        <div class="row justify-content-center">
            <div class="col-md-8">
                <asp:GridView ID="dgvDisciplinas" runat="server" DataKeyNames="IdDisciplina"
                    CssClass="table table-striped table-hover" AutoGenerateColumns="false"
                    OnSelectedIndexChanged="dgvDisciplinas_SelectedIndexChanged">
                    <columns>
                        <asp:BoundField HeaderText="Nombre" DataField="Nombre">
                            <headerstyle cssclass="w-50" />
                        </asp:BoundField>
                        <asp:CheckBoxField HeaderText="Activa" DataField="Activa">
                            <headerstyle cssclass="text-center w-25" />
                            <itemstyle cssclass="text-center" />
                        </asp:CheckBoxField>
                        <asp:CommandField HeaderText="Acción" ShowSelectButton="true" SelectText="✍️ Modificar/Eliminar">
                            <headerstyle cssclass="text-center w-25" />
                            <itemstyle cssclass="text-center" />
                        </asp:CommandField>
                    </columns>
                </asp:GridView>
            </div>
        </div>

        <div class="row justify-content-center g-3">

            <div class="col-md-3 d-grid">
                <a href="FormularioDisciplina.aspx" class="btn btn-success btn-lg p-4">➕ Agregar Disciplina </a>
            </div>

        </div>

    </div>

</asp:Content>
