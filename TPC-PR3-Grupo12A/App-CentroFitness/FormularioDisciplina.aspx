<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="FormularioDisciplina.aspx.cs" Inherits="App_CentroFitness.FormularioDisciplina" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <div class="container mt-4">

        <div class="row justify-content-center">

            <div class="col-md-6 col-lg-5">

                <div class="card shadow p-4">

                    <h2 class="text-center mb-4">Editar Disciplina </h2>

                    <div class="mb-3">
                        <label for="txtIdDisciplina" class="form-label">Id</label>
                        <asp:TextBox runat="server" ID="txtIdDisciplina" CssClass="form-control" Enabled="false" />
                    </div>

                    <div class="mb-3">
                        <label for="txtNombre" class="form-label">Nombre</label>
                        <asp:TextBox runat="server" ID="txtNombre" CssClass="form-control" />
                    </div>

                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>

                            <div class="mb-3">
                                <label for="txtImagen" class="form-label">Imagen</label>
                                <asp:TextBox type="file" runat="server" ID="txtImagen" CssClass="form-control" />
                            </div>

                            <div class="text-center mb-4">
                                <asp:Image ImageUrl="/Images/placeholder.jpg" runat="server" ID="imgDisciplina" CssClass="img-fluid rounded border" Width="60%" />
                            </div>

                        </ContentTemplate>
                    </asp:UpdatePanel>

                    <div class="d-flex justify-content-center gap-2">

                        <asp:Button Text="Aceptar" ID="btnAceptar" CssClass="btn btn-primary" runat="server" />
                        <a href="EditarDisciplinas.aspx" class="btn btn-secondary">Cancelar</a>
                        <asp:Button Text="Eliminar" ID="btnEliminar" CssClass="btn btn-outline-danger" runat="server" />

                    </div>

                </div>

            </div>

        </div>

    </div>


</asp:Content>
