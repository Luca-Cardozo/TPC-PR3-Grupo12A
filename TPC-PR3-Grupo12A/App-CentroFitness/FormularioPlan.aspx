<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="FormularioPlan.aspx.cs" Inherits="App_CentroFitness.FormularioPlan" %>

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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4 mb-5">

        <div class="row justify-content-center">

            <div class="col-md-10 col-lg-7">

                <div class="card shadow p-4">

                    <h2 class="text-center mb-4">
                        <asp:Label ID="lblTitulo" runat="server" />
                    </h2>

                    <div class="row">

                        <div class="col-md-6 mb-3">
                            <label class="form-label">ID Plan</label>
                            <asp:TextBox ID="txtIdPlan" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label">Estado</label>
                            <asp:TextBox ID="txtEstado" runat="server" CssClass="form-control input-readonly" ReadOnly="true" />
                        </div>

                    </div>

                    <div class="mb-3">
                        <label class="form-label">Descripción</label>
                        <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" MaxLength="100" placeholder="Ej: Pack x clases mensuales" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDescripcion" ErrorMessage="La descripción es obligatoria" CssClass="validacion" Display="Dynamic" />
                    </div>

                    <div class="row">

                        <div class="col-md-6 mb-3">
                            <label class="form-label">Cantidad de clases</label>
                            <asp:TextBox ID="txtCantidadClases" runat="server" CssClass="form-control" TextMode="Number" placeholder="Ej: 8" />
                            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtCantidadClases" ValidationExpression="^[0-9]+$" ErrorMessage="Solo puede ingresar números" CssClass="validacion" Display="Dynamic" />
                            <small class="text-muted">Dejar vacío si es pase libre o no corresponde.</small>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label">Duración en meses</label>
                            <asp:TextBox ID="txtDuracionMeses" runat="server" CssClass="form-control" TextMode="Number" placeholder="Ej: 1" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDuracionMeses" ErrorMessage="La duración es obligatoria" CssClass="validacion" Display="Dynamic" />
                            <asp:RangeValidator runat="server" ControlToValidate="txtDuracionMeses" MinimumValue="1" MaximumValue="12" Type="Integer" ErrorMessage="La duración debe estar entre 1 y 12 meses" CssClass="validacion" Display="Dynamic" />
                        </div>

                    </div>

                    <div class="mb-3">
                        <label class="form-label">Precio</label>
                        <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control" placeholder="Ej: 15000" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPrecio" ErrorMessage="El precio es obligatorio" CssClass="validacion" Display="Dynamic" />
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPrecio" ValidationExpression="^\d+([.,]\d{1,2})?$" ErrorMessage="Ingrese un precio válido" CssClass="validacion" Display="Dynamic" />
                    </div>

                    <div class="alert alert-info small">
                        Para crear un pase libre, deje vacío el campo <strong>Cantidad de clases</strong>.                   
                    </div>

                    <div class="d-flex justify-content-center gap-2 mt-4">
                        <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" CssClass="btn btn-primary" OnClick="btnAceptar_Click" />
                        <a href="EditarPlanes.aspx" class="btn btn-secondary">Cancelar</a>
                        <asp:Button ID="btnEliminar" runat="server" Text="Eliminar" CssClass="btn btn-outline-danger" OnClick="btnEliminar_Click" />
                    </div>

                    <div class="d-flex justify-content-center gap-2 mt-3">
                        <asp:Label ID="lblError" runat="server" CssClass="text-danger fw-bold" Visible="false" />
                    </div>

                </div>

            </div>

        </div>

    </div>

</asp:Content>
