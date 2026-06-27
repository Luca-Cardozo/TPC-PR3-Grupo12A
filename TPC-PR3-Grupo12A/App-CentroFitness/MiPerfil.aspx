<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="MiPerfil.aspx.cs" Inherits="App_CentroFitness.MiPerfil" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        .validacion {
            color: red;
            font-size: 10px;
        }

        .input-readonly {
            background-color: #f1f3f5 !important;
            color: #6c757d;
            cursor: not-allowed;
        }
    </style>

    <script>

        function previewImagen(input) {

            if (input.files && input.files[0]) {

                const reader = new FileReader();

                reader.onload = function (e) {
                    document.getElementById('<%= imgPerfil.ClientID %>').src = e.target.result;
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4">

        <div class="row justify-content-center">

            <div class="col-lg-8">

                <div class="card shadow">

                    <div class="card-header">
                        <h3 class="mb-0">Mi Perfil</h3>
                    </div>

                    <div class="card-body">

                        <div class="row">

                            <div class="col-md-4 text-center mb-4">

                                <asp:Image ID="imgPerfil" runat="server" CssClass="img-fluid rounded-circle border mb-3" Width="220px" ImageUrl="~/Images/default-user.jpg" />
                                <label class="form-label">Imagen de perfil</label>
                                <input type="file" runat="server" id="txtImagen" class="form-control" accept=".jpg" onchange="previewImagen(this)" />

                            </div>

                            <div class="col-md-8">

                                <h5 class="mb-3">Datos personales</h5>

                                <div class="row">

                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Rol</label>
                                        <asp:TextBox ID="txtRol" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">DNI</label>
                                        <asp:TextBox ID="txtDni" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Nombre</label>
                                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Apellido</label>
                                        <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Fecha nacimiento</label>
                                        <asp:TextBox ID="txtFechaNacimiento" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                                    </div>

                                </div>

                            </div>

                        </div>

                        <hr />

                        <div class="row">

                            <div class="col-md-6">

                                <h5 class="mb-3">Datos editables</h5>

                                <div class="mb-3">
                                    <label class="form-label">Teléfono</label>
                                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" />
                                    <asp:RegularExpressionValidator CssClass="validacion" ErrorMessage="Solo puede ingresar números" ControlToValidate="txtTelefono" ValidationExpression="^[0-9]+$" runat="server" />
                                </div>

                                <asp:Panel ID="pnlObservaciones" runat="server" Visible="false">

                                    <div class="mb-3">
                                        <label class="form-label">Observaciones médicas</label>
                                        <asp:TextBox ID="txtObservaciones" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Ej: lesión lumbar, molestias, limitaciones físicas..." />
                                    </div>

                                </asp:Panel>

                            </div>

                            <div class="col-md-6">

                                <asp:Panel ID="pnlSuscripcion" runat="server" Visible="false">

                                    <h5 class="mb-3">📋 Suscripción actual</h5>

                                    <div class="card border-0 bg-light mb-3">
                                        <div class="card-body">

                                            <asp:Panel ID="pnlSuscripcionVigente" runat="server" Visible="false">

                                                <div class="mb-3">
                                                    <label class="form-label">Plan</label>
                                                    <asp:TextBox ID="txtPlan" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                                                </div>

                                                <div class="mb-3">
                                                    <label class="form-label">Clases consumidas</label>
                                                    <asp:TextBox ID="txtClasesConsumidas" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                                                </div>

                                                <div class="row">

                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Fecha inicio</label>
                                                        <asp:TextBox ID="txtFechaInicioSuscripcion" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                                                    </div>

                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Fecha fin</label>
                                                        <asp:TextBox ID="txtFechaFinSuscripcion" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                                                    </div>

                                                </div>

                                                <asp:Label ID="lblEstadoSuscripcion" runat="server" CssClass="badge bg-success p-2" />

                                            </asp:Panel>

                                            <asp:Panel ID="pnlSinSuscripcion" runat="server" Visible="false">

                                                <div class="alert alert-warning mb-0">
                                                    No tenés una suscripción vigente actualmente. Comunicate con recepción para dar de alta o renovar tu plan.
                                                </div>

                                            </asp:Panel>

                                        </div>
                                    </div>

                                </asp:Panel>

                            </div>

                        </div>

                        <hr />

                        <asp:Panel ID="pnlInasistencias" runat="server" Visible="false">

                            <div class="alert alert-warning mt-3">
                                <strong>Inasistencias del mes:</strong>
                                <asp:Label ID="lblInasistenciasMes" runat="server" />
                            </div>

                        </asp:Panel>


                        <hr />

                        <h5>Cambiar contraseña</h5>

                        <div class="row">

                            <div class="col-md-4 mb-3">

                                <label class="form-label">Contraseña actual</label>
                                <asp:TextBox ID="txtPasswordActual" runat="server" CssClass="form-control" TextMode="Password" />

                            </div>

                            <div class="col-md-4 mb-3">

                                <label class="form-label">Nueva contraseña</label>
                                <asp:TextBox ID="txtNuevaPassword" runat="server" CssClass="form-control" TextMode="Password" />

                            </div>

                            <div class="col-md-4 mb-3">

                                <label class="form-label">Confirmar contraseña</label>
                                <asp:TextBox ID="txtConfirmarPassword" runat="server" CssClass="form-control" TextMode="Password" />

                            </div>

                        </div>

                        <div class="d-flex justify-content-between mt-4">
                            <asp:Button ID="btnVolverHome" runat="server" Text="🏠 Volver al inicio" CssClass="btn btn-outline-secondary" OnClick="btnVolverHome_Click" />
                            <asp:Button ID="btnGuardar" runat="server" Text="Guardar cambios" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
                        </div>

                        <div>
                            <asp:Label ID="lblError" runat="server" CssClass="text-danger fw-bold" Visible="false" />
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
