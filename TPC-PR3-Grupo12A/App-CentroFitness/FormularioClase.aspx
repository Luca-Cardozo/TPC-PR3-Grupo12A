<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="FormularioClase.aspx.cs" Inherits="App_CentroFitness.FormularioClase" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <div class="container mt-4">

        <div class="row justify-content-center">

            <div class="col-lg-8">

                <div class="card shadow">

                    <div class="card-header">
                        <h3 class="mb-0">Gestión de Clases</h3>
                    </div>

                    <div class="card-body">

                        <asp:Label ID="lblError" runat="server" Visible="false" CssClass="text-danger fw-bold" />

                        <div class="mb-3">
                            <label class="form-label">ID Clase</label>
                            <asp:TextBox ID="txtIdClase" runat="server" CssClass="form-control bg-light text-muted" ReadOnly="true" />
                        </div>


                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <div class="mb-3">
                                    <label class="form-label">Instructor</label>
                                    <asp:DropDownList ID="ddlInstructor" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlInstructor_SelectedIndexChanged" />
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlInstructor" InitialValue="0" ErrorMessage="Debe seleccionar un instructor" CssClass="text-danger" />
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Disciplina</label>
                                    <asp:DropDownList ID="ddlDisciplina" runat="server" CssClass="form-select" />
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlDisciplina" InitialValue="0" ErrorMessage="Debe seleccionar una disciplina" CssClass="text-danger" />
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>


                        <div class="mb-3">
                            <label class="form-label">Fecha</label>
                            <asp:TextBox ID="txtFecha" runat="server" CssClass="form-control" TextMode="Date" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFecha" ErrorMessage="Debe ingresar una fecha" CssClass="text-danger" />
                        </div>

                        <div class="row">

                            <div class="col-md-6 mb-3">

                                <label class="form-label">Hora inicio</label>

                                <asp:DropDownList ID="ddlHora" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Seleccione una hora" Value="0" />
                                    <asp:ListItem Text="07:00" Value="7" />
                                    <asp:ListItem Text="08:00" Value="8" />
                                    <asp:ListItem Text="09:00" Value="9" />
                                    <asp:ListItem Text="10:00" Value="10" />
                                    <asp:ListItem Text="11:00" Value="11" />
                                    <asp:ListItem Text="12:00" Value="12" />
                                    <asp:ListItem Text="13:00" Value="13" />
                                    <asp:ListItem Text="14:00" Value="14" />
                                    <asp:ListItem Text="15:00" Value="15" />
                                    <asp:ListItem Text="16:00" Value="16" />
                                    <asp:ListItem Text="17:00" Value="17" />
                                    <asp:ListItem Text="18:00" Value="18" />
                                    <asp:ListItem Text="19:00" Value="19" />
                                    <asp:ListItem Text="20:00" Value="20" />
                                    <asp:ListItem Text="21:00" Value="21" />
                                    <asp:ListItem Text="22:00" Value="22" />
                                </asp:DropDownList>

                                <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlHora" InitialValue="0" ErrorMessage="Debe seleccionar un horario" CssClass="text-danger" />
                            </div>


                            <div class="col-md-6 mb-3">

                                <label class="form-label">Cupo máximo</label>
                                <asp:TextBox ID="txtCupoMaximo" runat="server" CssClass="form-control" TextMode="Number" />
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCupoMaximo" ErrorMessage="Debe ingresar un cupo" CssClass="text-danger" />
                                <asp:RangeValidator runat="server" ControlToValidate="txtCupoMaximo" MinimumValue="1" MaximumValue="15" Type="Integer" ErrorMessage="El cupo debe estar entre 1 y 15" CssClass="text-danger" />
                            
                            </div>

                        </div>

                        <div class="d-flex justify-content-between mt-4">

                            <asp:Button Text="Aceptar" ID="btnAceptar" CssClass="btn btn-primary" runat="server" OnClick="btnAceptar_Click" />
                            <a href="EditarClases.aspx" class="btn btn-secondary">Cancelar</a>
                            <asp:Button Text="Eliminar" ID="btnEliminar" Visible="false" CssClass="btn btn-outline-danger" runat="server" OnClick="btnEliminar_Click" />

                        </div>

                    </div>
                </div>
            </div>

        </div>

    </div>
</asp:Content>
