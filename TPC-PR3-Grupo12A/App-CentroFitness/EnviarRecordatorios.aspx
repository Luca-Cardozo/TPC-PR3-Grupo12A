<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="EnviarRecordatorios.aspx.cs" Inherits="App_CentroFitness.EnviarRecordatorios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        .tabla-recordatorios th,
        .tabla-recordatorios td {
            text-align: center;
            vertical-align: middle;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="container mt-4 mb-5">

        <div class="text-center mb-4">
            <h2>📧 Recordatorios de clases</h2>
            <p class="text-muted">
                Envío manual de recordatorios para las clases del día siguiente.           
            </p>
        </div>

        <asp:Label ID="lblMensaje" runat="server" Visible="false" />

        <div class="row justify-content-center">
            <div class="col-lg-10">

                <asp:GridView ID="dgvClases" runat="server"
                    CssClass="table table-striped table-hover shadow-sm tabla-recordatorios"
                    AutoGenerateColumns="false"
                    DataKeyNames="IdClase"
                    OnRowCommand="dgvClases_RowCommand">

                    <HeaderStyle CssClass="table-dark text-center" />

                    <Columns>

                        <asp:TemplateField HeaderText="Disciplina">
                            <ItemTemplate>
                                <%# Eval("Disciplina.Nombre") %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Instructor">
                            <ItemTemplate>
                                <%# Eval("Instructor.Nombre") %> <%# Eval("Instructor.Apellido") %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="Fecha" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" />

                        <asp:TemplateField HeaderText="Horario">
                            <ItemStyle CssClass="text-center" />
                            <ItemTemplate>
                                <%# Eval("HoraInicio") %>:00 - <%# Eval("HoraFin") %>:00 hs                           
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="CantidadReservas" HeaderText="Alumnos" />

                        <asp:TemplateField HeaderText="Estado">
                            <ItemTemplate>
                                <%# Eval("RecordatorioTexto") %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Acción">
                            <ItemStyle CssClass="text-center" />
                            <ItemTemplate>
                                <asp:Button ID="btnEnviar" runat="server"
                                    Text='<%# Convert.ToBoolean(Eval("RecordatorioEnviado")) ? "Reenviar" : "Enviar" %>'
                                    CssClass="btn btn-primary btn-sm"
                                    CommandName="EnviarRecordatorio"
                                    CommandArgument='<%# Eval("IdClase") %>'
                                    OnClientClick="return confirm('¿Confirmás el envío de recordatorios para esta clase?');" />
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>

                <asp:Label ID="lblSinClases" runat="server"
                    Text="No hay clases vigentes programadas para mañana."
                    CssClass="alert alert-info d-block text-center"
                    Visible="false" />

            </div>
        </div>

        <div class="text-center mt-4">
            <asp:Button ID="btnVolver" runat="server"
                Text="← Volver"
                CssClass="btn btn-outline-secondary"
                OnClick="btnVolver_Click" />
        </div>

    </div>

</asp:Content>
