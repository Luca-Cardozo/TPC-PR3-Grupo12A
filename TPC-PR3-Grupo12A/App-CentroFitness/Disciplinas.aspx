<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Disciplinas.aspx.cs" Inherits="App_CentroFitness.Disciplinas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    




      <div class="row mb-3">
   <asp:Repeater ID="repDisciplinas" runat="server">
      <ItemTemplate>
       <div class="col-md-3 mb-3">
           <div class="card">
               <img src='<%# "Images/disciplina-" + Eval("IdDisciplina") + ".jpg" %>' 
                   class="card-img-top" 
                   alt="Disciplina" 
                   onerror="this.src='Images/placeholder.jpg';"
                   style="height: 220px; object-fit: cover;">
               <div class="card-body">
                   <h5 class="card-title"><%# Eval("Nombre") %></h5>

                   <p class="card-text">
                       Estado:
   <%# (bool)Eval("Activa") ? "Disponible" : "No disponible" %>
                   </p>

                   <asp:Button  Text="Ver clases" ID="btnVerClases" runat="server" CssClass="btn btn-primary"   OnClick="btnVerClases_Click" />
                      
                       
               </div>
           </div>
       </div>
   </ItemTemplate>
   </asp:Repeater>
</div>
    <br />
    <div class="row">
    <div class="col-4 d-grid gap-2 d-md-block">
        <asp:Button ID="btnVolverHome" runat="server" Text="Volver a página principal" OnClick="btnVolverHome_Click" CssClass="btn btn-primary" />
    </div>
</div>
</asp:Content>
