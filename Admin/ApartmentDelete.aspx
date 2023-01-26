<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ApartmentDelete.aspx.cs" Inherits="Admin.ApartmentDelete" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="form-group">
        <label>Vlasnik</label>
        <asp:Label ID="lblApartmentOwner" runat="server" CssClass="form-control"></asp:Label>
    </div>
    <div class="form-group">
        <label>Naziv</label>
        <asp:Label ID="lblName" runat="server" CssClass="form-control"></asp:Label>
    </div>
    <div class="form-group">
        <label>Adresa</label>
        <asp:Label ID="lblAddress" runat="server" CssClass="form-control"></asp:Label>
    </div>
    <div class="form-group">
        <label>Grad</label>
        <asp:Label ID="lblCity" runat="server" CssClass="form-control"></asp:Label>
    </div>
    <div>
        <asp:LinkButton ID="lbConfirmDelete" runat="server" Text="Potvrdi brisanje" CssClass="btn btn-danger" OnClick="lbConfirmDelete_Click" />
        <asp:LinkButton ID="lbBack" runat="server" Text="Odustani" CssClass="btn btn-primary"  OnClick="lbBack_Click"/>
    </div>
</asp:Content>
