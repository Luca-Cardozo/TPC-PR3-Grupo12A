<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AltaReserva.aspx.cs" Inherits="App_CentroFitness.AltaReserva" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <div class="container mt-4 mb-5">

        <div class="row justify-content-center mb-4">
            <div class="col-lg-10 text-center">
                <h2 class="mb-1">➕ Registrar nueva reserva</h2>
                <p class="text-muted">Filtrá clases y seleccioná dónde inscribir al alumno</p>
            </div>
        </div>

        <asp:Panel ID="pnlSeleccionClase" runat="server">

            <div class="container mt-4 mb-4">
                <div class="row justify-content-center">
                    <div class="col-lg-9">

                        <div class="card shadow-sm">
                            <div class="card-body">

                                <h4 class="text-center mb-4">🔎 Filtros de búsqueda</h4>

                                <div class="row g-3 justify-content-center mb-2">

                                    <div class="col-md-6">
                                        <label class="form-label">Disciplina</label>
                                        <asp:DropDownList ID="ddlDisciplinaFiltro" runat="server" CssClass="form-select" />
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">Instructor</label>
                                        <asp:DropDownList ID="ddlInstructorFiltro" runat="server" CssClass="form-select" />
                                    </div>

                                </div>

                                <div class="row g-3 justify-content-center">

                                    <div class="col-md-6">
                                        <label class="form-label">Fecha desde</label>
                                        <asp:TextBox ID="txtFechaDesde" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">Fecha hasta</label>
                                        <asp:TextBox ID="txtFechaHasta" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>

                                </div>

                                <div class="d-flex justify-content-center gap-2 mt-4">
                                    <asp:Button ID="btnBuscar" runat="server" Text="🔍 Buscar" CssClass="btn btn-primary px-4" OnClick="btnBuscar_Click" ValidationGroup="filtros" />
                                    <asp:Button ID="btnLimpiar" runat="server" Text="↻ Limpiar" CssClass="btn btn-outline-secondary px-4" OnClick="btnLimpiar_Click" />
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>



            <div class="row justify-content-center mb-4">
                <div class="col-lg-10">

                    <asp:Label ID="lblSinClases" runat="server" Text="No hay clases disponibles con los filtros seleccionados" CssClass="text-muted text-center d-block mb-3" Visible="false" />
                    <asp:Repeater ID="repClases" runat="server">
                        <ItemTemplate>
                            <div class="card shadow-sm mb-3">
                                <div class="card-body d-flex justify-content-between align-items-center">

                                    <div>
                                        <h5 class="mb-1"><%# Eval("Disciplina.Nombre") %></h5>
                                        <div class="text-muted">
                                            <div>
                                                👨‍🏫 <%# Eval("Instructor.Nombre") %> <%# Eval("Instructor.Apellido") %>
                                            </div>
                                            <div>
                                                📅 <%# Eval("Fecha", "{0:dd/MM/yyyy}") %>
                                            </div>
                                            <div>
                                                🕐 <%# Eval("HoraInicio") %>:00 - <%# Eval("HoraFin") %>:00 hs
                                            </div>
                                            <div>
                                                👥 Cupos disponibles: <%# Eval("CuposDisponibles") %> de <%# Eval("CupoMaximo") %>
                                            </div>
                                        </div>
                                    </div>

                                    <asp:Button ID="btnSeleccionar"
                                        runat="server"
                                        Text='<%# (int)Eval("CuposDisponibles") > 0 ? "Seleccionar" : "Clase completa" %>'
                                        Enabled='<%# (int)Eval("CuposDisponibles") > 0 %>'
                                        CssClass="btn btn-success px-4"
                                        CommandArgument='<%# Eval("IdClase") %>'
                                        OnClick="btnSeleccionar_Click" />

                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                </div>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlDatosReserva" runat="server" Visible="false">

            <div class="row justify-content-center">
                <div class="col-lg-10">

                    <div class="card shadow-sm">
                        <div class="card-body">

                            <h5 class="mb-3">👤 Datos de inscripción</h5>

                            <div class="row g-3">

                                <div class="col-md-6">
                                    <label class="form-label">Alumno</label>
                                    <asp:DropDownList ID="ddlAlumno" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlAlumno_SelectedIndexChanged" />
                                    <asp:RequiredFieldValidator
                                        runat="server"
                                        ControlToValidate="ddlAlumno"
                                        InitialValue="0"
                                        ErrorMessage="Debe seleccionar un alumno"
                                        CssClass="text-danger d-block"
                                        ValidationGroup="Reserva" />
                                    <asp:Label ID="lblClasesDisponiblesAlumno" runat="server" CssClass="d-block mt-2 fw-bold" Visible="false" />
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Clase seleccionada</label>

                                    <asp:TextBox ID="txtClaseSeleccionada" runat="server" CssClass="form-control bg-light" ReadOnly="true" />

                                    <asp:Button ID="btnCambiarClase"
                                        runat="server"
                                        Text="Cambiar clase"
                                        CssClass="btn btn-outline-primary btn-sm mt-2"
                                        OnClick="btnCambiarClase_Click"
                                        CausesValidation="false" />

                                    <asp:RequiredFieldValidator
                                        runat="server"
                                        ControlToValidate="txtClaseSeleccionada"
                                        InitialValue=""
                                        ErrorMessage="Debe seleccionar una clase"
                                        CssClass="text-danger d-block"
                                        ValidationGroup="Reserva" />
                                </div>

                                <div class="col-12">
                                    <label class="form-label">Observaciones</label>
                                    <asp:TextBox ID="txtObservaciones" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" MaxLength="300" />
                                </div>

                            </div>

                            <div class="d-flex justify-content-between mt-4">

                                <asp:Button ID="btnVolver" runat="server" Text="← Volver" CssClass="btn btn-outline-secondary" OnClick="btnVolver_Click" />
                                <asp:Button ID="btnGuardar" runat="server" Text="Guardar reserva" CssClass="btn btn-success px-4" OnClick="btnGuardar_Click" ValidationGroup="Reserva" />

                            </div>

                        </div>
                    </div>

                </div>
            </div>

        </asp:Panel>

    </div>

</asp:Content>
