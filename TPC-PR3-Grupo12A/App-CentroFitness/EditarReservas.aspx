<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="EditarReservas.aspx.cs" Inherits="App_CentroFitness.EditarReservas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-5">

        <div class="text-center mb-5">
            <h1>Administración de Reservas</h1>
        </div>
        <div class="row justify-content-center mb-4">
            <div class="col-md-12">
                <asp:GridView ID="dgvReservas" runat="server" DataKeyNames="IdReserva" AutoGenerateColumns="false"
                    CssClass="table table-striped table-bordered table-hover shadow-sm" OnSelectedIndexChanged="dgvReservas_SelectedIndexChanged">
                    <Columns>
                        <asp:BoundField HeaderText="ID" DataField="IdReserva" ItemStyle-Width="50px" />
                        <asp:BoundField HeaderText="Apellido" DataField="Alumno.Apellido" />
                        <asp:BoundField HeaderText="Nombre" DataField="Alumno.Nombre" />
                        <asp:BoundField HeaderText="Disciplina" DataField="Clase.Disciplina.Nombre" />
                        <asp:BoundField HeaderText="Fecha" DataField="Clase.Fecha" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:BoundField HeaderText="Hora" DataField="Clase.HoraInicio" ItemStyle-Width="80px" />
                        <asp:BoundField HeaderText="Estado" DataField="Estado" />
                        <asp:BoundField HeaderText="Observaciones" DataField="Observaciones" />


                        <asp:CommandField HeaderText="Acción" SelectText="❌ Cancelar" ShowSelectButton="true" ControlStyle-CssClass="btn btn-danger btn-sm" />
                    </Columns>
                </asp:GridView>
            </div>

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

    <div class="row mt-4 mb-5">
        <div class="col-12 text-center">
            <asp:Button ID="btnVolverHome" runat="server" Text="🏠 Volver a página principal" OnClick="btnVolverHome_Click" CssClass="btn btn-outline-primary px-4 py-2 shadow-sm" />
        </div>
    </div>

</asp:Content>
