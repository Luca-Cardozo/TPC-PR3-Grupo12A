<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="EditarDisciplinas.aspx.cs" Inherits="App_CentroFitness.EditarDisciplinas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-5">

        <div class="text-center mb-5">
            <h1>Administración de Disciplinas</h1>
        </div>

        <div class="row mb-4 align-items-end justify-content-center">

            <div class="col-md-4">

                <label class="form-label">Estado</label>

                <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlEstado_SelectedIndexChanged">
                    <asp:ListItem Text="Todas" Value="0" />
                    <asp:ListItem Text="Activas" Value="1" />
                    <asp:ListItem Text="Inactivas" Value="2" />
                </asp:DropDownList>

            </div>

        </div>

        <div class="row justify-content-center mb-4">
            <div class="col-md-4 d-grid">
                <a href="FormularioDisciplina.aspx" class="btn btn-success btn-lg p-3">➕ Agregar Disciplina </a>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-md-8">
                <asp:GridView ID="dgvDisciplinas" runat="server" DataKeyNames="IdDisciplina"
                    CssClass="table table-striped table-hover" AutoGenerateColumns="false"
                    OnSelectedIndexChanged="dgvDisciplinas_SelectedIndexChanged">
                    <Columns>
                        <asp:BoundField HeaderText="Nombre" DataField="Nombre">
                            <HeaderStyle CssClass="w-50" />
                        </asp:BoundField>
                        <asp:CheckBoxField HeaderText="Activa" DataField="Activa">
                            <HeaderStyle CssClass="text-center w-25" />
                            <ItemStyle CssClass="text-center" />
                        </asp:CheckBoxField>
                        <asp:CommandField HeaderText="Acción" ShowSelectButton="true" SelectText="✍️ Modificar/Eliminar">
                            <HeaderStyle CssClass="text-center w-25" />
                            <ItemStyle CssClass="text-center" />
                        </asp:CommandField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <div class="row mt-4 mb-5">
        <div class="col-12 text-center">
            <asp:Button ID="btnVolverHome" runat="server" Text="🏠 Volver a página principal" OnClick="btnVolverHome_Click" CssClass="btn btn-outline-primary px-4 py-2 shadow-sm" />
        </div>
    </div>

</asp:Content>
