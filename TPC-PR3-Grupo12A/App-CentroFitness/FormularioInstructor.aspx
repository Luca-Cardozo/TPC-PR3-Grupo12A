<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="FormularioInstructor.aspx.cs" Inherits="App_CentroFitness.FormularioInstructor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        .validacion {
            color: red;
            font-size: 10px;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <div class="container mt-4">

        <div class="row justify-content-center">

            <div class="col-md-6 col-lg-5">

                <div class="card shadow p-4">

                    <h2 class="text-center mb-4">Editar Instructor </h2>

                    <%--Acá va el formulario de registro--%>
                    <div class="mb-3">
                        <label for="txtIdUsuario" class="form-label">Id</label>
                        <asp:TextBox runat="server" ID="txtIdUsuario" CssClass="form-control" Enabled="false" />
                    </div>

                    <div class="mb-3">
                        <label for="txtNombre" class="form-label">Nombre</label>
                        <asp:TextBox runat="server" ID="txtNombre" CssClass="form-control" />
                        <asp:RequiredFieldValidator CssClass="validacion" ErrorMessage="El nombre es requerido" ControlToValidate="txtNombre" runat="server" />
                        <asp:RegularExpressionValidator CssClass="validacion" runat="server" ControlToValidate="txtNombre" ErrorMessage="Solo puede ingresar letras" ValidationExpression="^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$" />
                    </div>

                    <div class="mb-3">
                        <label for="txtApellido" class="form-label">Apellido</label>
                        <asp:TextBox runat="server" ID="txtApellido" CssClass="form-control" />
                        <asp:RequiredFieldValidator CssClass="validacion" ErrorMessage="El apellido es requerido" ControlToValidate="txtApellido" runat="server" />
                        <asp:RegularExpressionValidator CssClass="validacion" runat="server" ControlToValidate="txtApellido" ErrorMessage="Solo puede ingresar letras" ValidationExpression="^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$" />
                    </div>

                    <div class="mb-3">
                        <label for="txtDni" class="form-label">DNI</label>
                        <asp:TextBox runat="server" ID="txtDni" CssClass="form-control" MaxLength="10" />
                        <asp:RequiredFieldValidator CssClass="validacion" ErrorMessage="El DNI es requerido" ControlToValidate="txtDni" runat="server" />
                        <asp:RegularExpressionValidator CssClass="validacion" ErrorMessage="Solo puede ingresar números" ControlToValidate="txtDni" ValidationExpression="^[0-9]+$" runat="server"/>
                    </div>

                    <div class="mb-3">
                        <label for="txtEmail" class="form-label">Email</label>
                        <asp:TextBox runat="server" ID="txtEmail" CssClass="form-control" />
                        <asp:RequiredFieldValidator CssClass="validacion" ErrorMessage="El email es requerido" ControlToValidate="txtEmail" runat="server" />
                        <asp:RegularExpressionValidator CssClass="validacion" ErrorMessage="Ingrese un email válido por favor" ControlToValidate="txtEmail" ValidationExpression="^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$" runat="server" />
                    </div>

                    <div class="mb-3">
                        <label for="txtTelefono" class="form-label">Teléfono</label>
                        <asp:TextBox runat="server" ID="txtTelefono" CssClass="form-control" MaxLength="20"/>
                        <asp:RequiredFieldValidator CssClass="validacion" ErrorMessage="El teléfono es requerido" ControlToValidate="txtTelefono" runat="server" />
                        <asp:RegularExpressionValidator CssClass="validacion" ErrorMessage="Solo puede ingresar números" ControlToValidate="txtTelefono" ValidationExpression="^[0-9]+$" runat="server"/>
                    </div>

                    <div class="mb-3">
                        <label for="txtFechaNacimiento" class="form-label">Fecha de nacimiento</label>
                        <asp:TextBox runat="server" TextMode="Date" ID="txtFechaNacimiento" CssClass="form-control" />
                        <asp:RequiredFieldValidator CssClass="validacion" ErrorMessage="La fecha de nacimiento es requerida" ControlToValidate="txtFechaNacimiento" runat="server" />
                    </div>

                    <div class="mb-3">
                        <asp:CheckBoxList ID="cblDisciplinas" runat="server" CssClass="form-check" />
                    </div>

                    <%--<asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>

                            <div class="mb-3">
                                <label for="txtImagen" class="form-label">Imagen de Perfil</label>
                                <asp:TextBox type="file" runat="server" ID="txtImagen" CssClass="form-control" />
                            </div>

                            <div class="text-center mb-4">
                                <asp:Image ImageUrl="/Images/placeholder.jpg" runat="server" ID="imgInstructor" CssClass="img-fluid rounded border" Width="60%" />
                            </div>

                        </ContentTemplate>
                    </asp:UpdatePanel>--%>

                    <div class="d-flex justify-content-center gap-2">

                        <asp:Button Text="Aceptar" ID="btnAceptar" CssClass="btn btn-primary" runat="server" OnClick="btnAceptar_Click" />
                        <a href="EditarInstructores.aspx" class="btn btn-secondary">Cancelar</a>
                        <asp:Button Text="Eliminar" ID="btnEliminar" CssClass="btn btn-outline-danger" runat="server" />

                    </div>

                    <div class="d-flex justify-content-center gap-2">
                        <asp:Label ID="lblError" runat="server" CssClass="text-danger" Visible="false" />
                    </div>

                </div>

            </div>

        </div>

    </div>

</asp:Content>
