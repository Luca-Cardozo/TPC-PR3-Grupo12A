<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="ReprogramarClase.aspx.cs" Inherits="App_CentroFitness.ReprogramaClase" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="container py-4">

        <div class="row justify-content-center">

            <div class="col-12 col-md-10 col-lg-8">

                <div class="card shadow-sm border-0 rounded-4">

                    <div class="card-header bg-white border-bottom">
                        <h2 class="mb-0 text-center">Reprogramar Clase</h2>
                    </div>

                    <asp:Label ID="lblError" runat="server" Visible="false" CssClass="alert alert-danger d-block text-center" />

                    <div class="card-body p-4">

                        <h4 class="mb-4">Datos de la clase actual</h4>

                        <div class="row">

                            <div class="col-md-6 mb-3">
                                <label class="form-label">ID Clase</label>
                                <asp:TextBox ID="txtIdClase" runat="server" CssClass="form-control bg-light" ReadOnly="true" />
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label">Disciplina</label>
                                <asp:TextBox ID="txtDisciplina" runat="server" CssClass="form-control bg-light" ReadOnly="true" />
                            </div>

                        </div>

                        <div class="row">

                            <div class="col-md-6 mb-3">
                                <label class="form-label">Instructor</label>
                                <asp:TextBox ID="txtInstructor" runat="server" CssClass="form-control bg-light" ReadOnly="true" />

                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label">Fecha actual</label>
                                <asp:TextBox ID="txtFechaActual" runat="server" CssClass="form-control bg-light" ReadOnly="true" />

                            </div>

                        </div>

                        <div class="row">

                            <div class="col-md-6 mb-3">
                                <label class="form-label">Hora actual</label>
                                <asp:TextBox ID="txtHoraActual" runat="server" CssClass="form-control bg-light" ReadOnly="true" />

                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label">Reservas vigentes</label>
                                <asp:TextBox ID="txtReservasVigentes"
                                    runat="server"
                                    CssClass="form-control bg-light"
                                    ReadOnly="true" />
                            </div>

                        </div>

                        <hr class="my-4" />

                        <h4 class="mb-4">Nueva programación</h4>

                        <div class="row">

                            <div class="col-md-6 mb-3">
                                <label class="form-label">Nueva fecha</label>

                                <asp:TextBox ID="txtNuevaFecha" runat="server" CssClass="form-control" TextMode="Date" />

                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNuevaFecha" ErrorMessage="Debe ingresar una nueva fecha." CssClass="text-danger" />
                            </div>

                            <div class="col-md-6 mb-3">

                                <label class="form-label">Nueva hora</label>

                                <asp:DropDownList ID="ddlNuevaHora" runat="server" CssClass="form-select">


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
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlNuevaHora" InitialValue="0" ErrorMessage="Debe seleccionar una nueva hora." CssClass="text-danger" />
                            </div>

                        </div>

                        <div class="d-flex justify-content-center gap-2 mt-4">

                            <asp:Button ID="btnReprogramar" runat="server" Text="Confirmar Reprogramación" CssClass="btn btn-warning" OnClick="btnReprogramar_Click" />

                            <a href="EditarClases.aspx"
                                class="btn btn-secondary">Cancelar
                            </a>

                        </div>


                    </div>

                </div>

            </div>

        </div>

    </div>

</asp:Content>
