<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="EditarAlumnos.aspx.cs" Inherits="App_CentroFitness.ListadoAlumnos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-5">

        <div class="text-center mb-5">
            <h1>Administración de Alumnos</h1>
        </div>
               <%--   <div class="row justify-content-center mb-4">
<div class="col-md-7">


              <asp:TextBox ID="txtFiltro" runat="server" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtFiltro_TextChanged" placeholder="Buscar por nombre, apellido, DNI o email..." />

          </div>
      </div>--%>


          <div class="row justify-content-center mb-4">
      <div class="col-md-4 d-grid">
          <a href="FormularioAlumno.aspx" class="btn btn-success btn-lg p-3">➕ Agregar Alumno
      </a>
      </div>
  </div>

        <div class="row justify-content-center">
            <div class="col-md-8">
                <asp:GridView ID="dgvAlumnos" runat="server" DataKeyNames="IdUsuario"
                    CssClass="table table-striped table-hover" AutoGenerateColumns="false"
                    OnSelectedIndexChanged="dgvAlumnos_SelectedIndexChanged">
                    <Columns>
                        <asp:BoundField DataField="IdUsuario" HeaderText="ID" />

<asp:BoundField DataField="Nombre" HeaderText="Nombre" />

<asp:BoundField DataField="Apellido" HeaderText="Apellido" />

<asp:BoundField DataField="DNI" HeaderText="DNI" />

<asp:BoundField DataField="Email" HeaderText="Email" />
<asp:CheckBoxField DataField="Activo" HeaderText="Estado" />

<asp:CommandField
    ShowSelectButton="true"
    SelectText="Ver/Editar" />
                        
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        

    </div>


    <div class="row">
        <div class="col-4 d-grid gap-2 d-md-block">
            <asp:Button ID="btnVolverHome" runat="server" Text="Volver a página principal" OnClick="btnVolverHome_Click" CssClass="btn btn-primary" />
        </div>
    </div>
</asp:Content>
