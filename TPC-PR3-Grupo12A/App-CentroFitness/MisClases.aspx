<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="MisClases.aspx.cs" Inherits="App_CentroFitness.MisClases" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    
        <div class="container mt-4">

    <div class="text-center mb-4">
        <h1 class="display-6 mb-1">Mis Clases</h1>
        <asp:Label ID="lblTitulo" runat="server" CssClass="text-muted fs-5" />
    </div>

           <div class="card shadow-sm mb-4">
        <div class="card-body">

            <h5 class="mb-4 border-bottom pb-2">Seleccionar clase</h5>

            <div class="row g-3 align-items-end justify-content-center">
                <div class="col-md-7">
                    <label class="form-label">Clase</label>
                    <asp:DropDownList ID="ddlClases" runat="server" CssClass="form-select" />
                </div>

                <div class="col-md-2">
                    <asp:Button ID="btnBuscarClase" runat="server" Text="Buscar"
                        CssClass="btn btn-primary w-100"
                        OnClick="btnBuscarClase_Click" />
                </div>

                <div class="col-md-2">
                    <asp:Button ID="btnLimpiar" runat="server" Text="Recargar"
                        CssClass="btn btn-outline-secondary w-100"
                        OnClick="btnLimpiar_Click" />
                </div>
            </div>

        </div>
    </div>

    <asp:Label ID="lblInfoClase" runat="server"
        CssClass="alert alert-info d-block text-center" />

    <asp:GridView ID="dgvAsistencia" runat="server" CssClass="table table-hover shadow-sm" AutoGenerateColumns="false"> <HeaderStyle CssClass="table-dark text-center" />

        <Columns>
            <asp:TemplateField HeaderText="Alumno">  <ItemStyle CssClass="text-center" />
                <ItemTemplate>
  <%# Eval("Alumno.Nombre") %> <%# Eval("Alumno.Apellido") %>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Asistió"> <ItemStyle CssClass="text-center" />
                <ItemTemplate>
                    <asp:CheckBox ID="chkAsistio" runat="server"
                        Checked='<%# Eval("Asistio") != null && (bool)Eval("Asistio") %>' />
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Observaciones">
                <ItemTemplate>
                    <asp:TextBox ID="txtObservaciones" runat="server"
                        Text='<%# Eval("Observaciones") %>'
                        CssClass="form-control" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <div class="text-end mt-3 mb-4">
        <asp:Button ID="btnGuardarAsistencia" runat="server" Text="Guardar asistencia" CssClass="btn btn-success" />
    </div>

</div>

        <div class="row justify-content-center">
            <div class="col-md-8">
            </div>
        </div>

        <div class="row justify-content-center g-3">
        </div>

    </div>

    <div class="row mt-4 mb-5">
        <div class="col-12 text-center">
            <asp:Button ID="btnVolverHome" runat="server" Text="🏠 Volver a página principal" OnClick="btnVolverHome_Click" CssClass="btn btn-outline-primary px-4 py-2 shadow-sm" />
        </div>
    </div>

</asp:Content>
