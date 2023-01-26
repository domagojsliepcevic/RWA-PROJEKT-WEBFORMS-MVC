<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserList.aspx.cs" Inherits="Admin.UserList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:GridView ID="gvRegisteredUsers" runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="20" CssClass="table table-striped table-condensed table-hover" OnPageIndexChanging ="gvRegisteredUsers_PageIndexChanging">
        <Columns>
            <asp:BoundField DataField="Id" HeaderText="Id" />
            <asp:BoundField DataField="UserName" HeaderText="UserName" />
            <asp:BoundField DataField="CreatedAt" HeaderText="CreatedAt" />
            <asp:BoundField DataField="Email" HeaderText="Email" />
            <asp:BoundField DataField="Address" HeaderText="Address" ItemStyle-HorizontalAlign="Right" />
            <asp:BoundField DataField="PhoneNumber" HeaderText="PhoneNumber" ItemStyle-HorizontalAlign="Right" />
        </Columns>
        <PagerTemplate>
            <asp:Button ID="btnFirst" runat="server" Text="First" CommandName="Page" CommandArgument="First" />
            <asp:Button ID="btnPrevious" runat="server" Text="Previous" CommandName="Page" CommandArgument="Prev" />
            <asp:Label ID="lblCurrentPage" runat="server" Text="Page"></asp:Label>
            <asp:TextBox ID="txtCurrentPage" runat="server" Width="30px"></asp:TextBox>
            <asp:Label ID="lblTotalPages" runat="server" Text="of"></asp:Label>
            <asp:Button ID="btnNext" runat="server" Text="Next" CommandName="Page" CommandArgument="Next" />
            <asp:Button ID="btnLast" runat="server" Text="Last" CommandName="Page" CommandArgument="Last" />
        </PagerTemplate>
    </asp:GridView>

</asp:Content>
