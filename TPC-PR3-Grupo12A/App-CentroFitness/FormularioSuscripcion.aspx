<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="FormularioSuscripcion.aspx.cs" Inherits="App_CentroFitness.FormularioSuscripcion" MaintainScrollPositionOnPostback="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .input-readonly {
            background-color: #f1f3f5 !important;
            color: #6c757d;
            cursor: not-allowed;
        }

        .validacion {
            color: red;
            font-size: 10px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <div class="container mt-4 mb-5">

        <div class="row justify-content-center">

            <div class="col-md-10 col-lg-8">

                <div class="card shadow p-4">

                    <h2 class="text-center mb-4">Gestión de Suscripción</h2>

                    <h5 class="mb-3">👤 Datos del alumno</h5>

                    <div class="row">

                        <div class="col-md-4 mb-3">
                            <label class="form-label">ID Alumno</label>
                            <asp:TextBox ID="txtIdAlumno" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                        </div>

                        <div class="col-md-4 mb-3">
                            <label class="form-label">Nombre</label>
                            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                        </div>

                        <div class="col-md-4 mb-3">
                            <label class="form-label">Apellido</label>
                            <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                        </div>

                    </div>

                    <div class="row">

                        <div class="col-md-6 mb-3">
                            <label class="form-label">DNI</label>
                            <asp:TextBox ID="txtDni" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label">Email</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                        </div>

                    </div>

                    <hr />

                    <h5 class="mb-3">📋 Suscripción actual</h5>

                    <asp:Panel ID="pnlSuscripcionActual" runat="server" Visible="false">

                        <div class="card bg-light border-0 mb-3">
                            <div class="card-body">

                                <div class="row">

                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Plan actual</label>
                                        <asp:TextBox ID="txtPlanActual" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Estado</label>
                                        <asp:TextBox ID="txtEstadoSuscripcion" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                                    </div>

                                </div>

                                <div class="row">

                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Fecha inicio</label>
                                        <asp:TextBox ID="txtFechaInicio" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Fecha fin</label>
                                        <asp:TextBox ID="txtFechaFin" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                                    </div>

                                </div>

                                <div class="row">

                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Clases consumidas</label>
                                        <asp:TextBox ID="txtClasesConsumidas" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                                    </div>

                                </div>

                            </div>
                        </div>

                    </asp:Panel>

                    <asp:Panel ID="pnlSinSuscripcion" runat="server" Visible="false">

                        <div class="alert alert-warning">
                            Este alumno no posee una suscripción cargada actualmente.                       
                        </div>

                    </asp:Panel>

                    <hr />

                    <asp:UpdatePanel ID="updSuscripcion" runat="server">
                        <ContentTemplate>

                            <h5 class="mb-3">⚙️ Gestionar plan</h5>

                            <div class="row">

                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Plan</label>
                                    <asp:DropDownList ID="ddlPlanes" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="datosVigencia_SelectedIndexChanged" />
                                    <asp:RequiredFieldValidator
                                        runat="server"
                                        ControlToValidate="ddlPlanes"
                                        InitialValue="0"
                                        ErrorMessage="Debe seleccionar un plan"
                                        CssClass="validacion"
                                        ValidationGroup="Suscripcion" />
                                </div>

                                <div class="col-md-3 mb-3">
                                    <label class="form-label">Mes</label>
                                    <asp:DropDownList ID="ddlMes" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="datosVigencia_SelectedIndexChanged" />
                                    <asp:RequiredFieldValidator
                                        runat="server"
                                        ControlToValidate="ddlMes"
                                        InitialValue="0"
                                        ErrorMessage="Seleccione un mes"
                                        CssClass="validacion"
                                        ValidationGroup="Suscripcion" />
                                </div>

                                <div class="col-md-3 mb-3">
                                    <label class="form-label">Año</label>
                                    <asp:DropDownList ID="ddlAnio" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="datosVigencia_SelectedIndexChanged" />
                                    <asp:RequiredFieldValidator
                                        runat="server"
                                        ControlToValidate="ddlAnio"
                                        InitialValue="0"
                                        ErrorMessage="Seleccione un año"
                                        CssClass="validacion"
                                        ValidationGroup="Suscripcion" />
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-12 mb-3">
                                    <label class="form-label">Nueva vigencia</label>
                                    <asp:TextBox ID="txtNuevaVigencia" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                                </div>

                            </div>

                        </ContentTemplate>
                    </asp:UpdatePanel>


                    <div class="alert alert-info small">
                        La vigencia siempre comienza el día 1 del mes seleccionado y finaliza al cierre del período correspondiente.                   
                    </div>

                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>

                            <div class="d-flex justify-content-center gap-2 mt-4">

                                <asp:Button ID="btnAlta" runat="server"
                                    Text="Alta suscripción"
                                    CssClass="btn btn-success"
                                    ValidationGroup="Suscripcion"
                                    OnClick="btnAlta_Click" />

                                <asp:Button ID="btnActualizar" runat="server"
                                    Text="Actualizar suscripción"
                                    CssClass="btn btn-primary"
                                    ValidationGroup="Suscripcion"
                                    OnClick="btnActualizar_Click" />

                            </div>

                            <div class="d-flex justify-content-between mt-4">

                                <asp:Button ID="btnVolver" runat="server"
                                    Text="← Volver"
                                    CssClass="btn btn-outline-secondary"
                                    CausesValidation="false"
                                    OnClick="btnVolver_Click" />

                            </div>

                            <div class="text-center mt-3">
                                <asp:Label ID="lblMensaje" runat="server" CssClass="fw-bold" Visible="false" />
                            </div>

                        </ContentTemplate>
                    </asp:UpdatePanel>

                </div>

            </div>

        </div>

    </div>

</asp:Content>
