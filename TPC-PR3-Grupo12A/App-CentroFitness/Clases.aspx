<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Clases.aspx.cs" Inherits="App_CentroFitness.Clases" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <h2>Clases Disponibles</h2>

    <p>
        En esta pantalla se visualizarán las clases disponibles según la disciplina seleccionada.
        QUIZÁS, podemos hacer luego un filtro de busqueda. a evaluar despues.
    </p>
    <asp:Label 
    ID="lblSinClases"
    runat="server"
    Text="No hay clases disponibles para la disciplina seleccionada."
   CssClass="text-muted"
    Visible="false">
</asp:Label>

    <asp:Repeater ID="repClases" runat="server">

        <ItemTemplate>
<div class="card shadow mb-3 col-md-5">

                <div class="card-body">

                    <h5>
                        <%# Eval("Disciplina.Nombre") %>
                </h5>

                    <p>
                        Instructor:
                   
                        <%# Eval("Instructor.Nombre") %>
                        <%# Eval("Instructor.Apellido") %>
                    </p>

                    <p>
                        Fecha:
                   
                        <%# Eval("Fecha", "{0:dd/MM/yyyy}") %>
                    </p>

                    <p>
                        Horario:
                   
                        <%# Eval("HoraInicio") %>:00 -
                   
                        <%# Eval("HoraFin") %>:00
               
                    </p>

                    <p>
                        Estado:
                    Disponible
               
                    </p>

                    <asp:Button  ID="btnSeleccionar" runat="server" Text="Seleccionar clase" CssClass="btn btn-success" />

                </div>

            </div>

        </ItemTemplate>

    </asp:Repeater>
    <br />
    <br />

    <asp:Button ID="btnVolver" runat="server" Text="Volver a disciplinas" CssClass="btn btn-primary" OnClick="btnVolver_Click" />


</asp:Content>