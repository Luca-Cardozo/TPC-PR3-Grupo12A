<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="App_CentroFitness.Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-12 text-center">
            <h1>Bienvenido a Centro Fitness</h1>
        </div>
    </div>
    <div id="carouselExampleDark" class="carousel carousel-dark slide">
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#carouselExampleDark" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
            <button type="button" data-bs-target="#carouselExampleDark" data-bs-slide-to="1" aria-label="Slide 2"></button>
            <button type="button" data-bs-target="#carouselExampleDark" data-bs-slide-to="2" aria-label="Slide 3"></button>
            <button type="button" data-bs-target="#carouselExampleDark" data-bs-slide-to="3" aria-label="Slide 4"></button>
            <button type="button" data-bs-target="#carouselExampleDark" data-bs-slide-to="4" aria-label="Slide 5"></button>
            <button type="button" data-bs-target="#carouselExampleDark" data-bs-slide-to="5" aria-label="Slide 6"></button>
        </div>
        <div class="carousel-inner">
            <div class="carousel-item active" data-bs-interval="10000">
                <img src="Images/home-1.jpg"
                    class="d-block w-100"
                    alt="..."
                    onerror="this.src='Images/placeholder.jpg';">
                <div class="carousel-caption d-none d-md-block">
                    <h4>Amplio espacio y comodidad para todos nuestros alumnos</h4>
                    <h5>Aprendé con instructores especializados</h5>
                    <p>¡Actividades todos los días y para todas las edades!</p>
                </div>
            </div>
            <div class="carousel-item" data-bs-interval="2000">
                <img src="Images/home-2.jpg"
                    class="d-block w-100"
                    alt="..."
                    onerror="this.src='Images/placeholder.jpg';">
                <div class="carousel-caption d-none d-md-block">
                    <h4>Amplio espacio y comodidad para todos nuestros alumnos</h4>
                    <h5>Aprendé con instructores especializados</h5>
                    <p>¡Actividades todos los días y para todas las edades!</p>
                </div>
            </div>
            <div class="carousel-item">
                <img src="Images/home-3.jpg"
                    class="d-block w-100"
                    alt="..."
                    onerror="this.src='Images/placeholder.jpg';">
                <div class="carousel-caption d-none d-md-block">
                    <h4>Amplio espacio y comodidad para todos nuestros alumnos</h4>
                    <h5>Aprendé con instructores especializados</h5>
                    <p>¡Actividades todos los días y para todas las edades!</p>
                </div>
            </div>
            <div class="carousel-item">
                <img src="Images/home-4.jpg"
                    class="d-block w-100"
                    alt="..."
                    onerror="this.src='Images/placeholder.jpg';">
                <div class="carousel-caption d-none d-md-block">
                    <h4>Amplio espacio y comodidad para todos nuestros alumnos</h4>
                    <h5>Aprendé con instructores especializados</h5>
                    <p>¡Actividades todos los días y para todas las edades!</p>
                </div>
            </div>
            <div class="carousel-item">
                <img src="Images/home-5.jpg"
                    class="d-block w-100"
                    alt="..."
                    onerror="this.src='Images/placeholder.jpg';">
                <div class="carousel-caption d-none d-md-block">
                    <h4>Amplio espacio y comodidad para todos nuestros alumnos</h4>
                    <h5>Aprendé con instructores especializados</h5>
                    <p>¡Actividades todos los días y para todas las edades!</p>
                </div>
            </div>
            <div class="carousel-item">
                <img src="Images/home-6.jpg"
                    class="d-block w-100"
                    alt="..."
                    onerror="this.src='Images/placeholder.jpg';">
                <div class="carousel-caption d-none d-md-block">
                    <h4>Amplio espacio y comodidad para todos nuestros alumnos</h4>
                    <h5>Aprendé con instructores especializados</h5>
                    <p>¡Actividades todos los días y para todas las edades!</p>
                </div>
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleDark" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleDark" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>
    </div>
</asp:Content>
