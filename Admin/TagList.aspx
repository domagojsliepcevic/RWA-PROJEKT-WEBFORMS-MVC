<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TagList.aspx.cs" Inherits="Admin.TagList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Button ID="btnAdd" CssClass="btn btn-primary m-2" runat="server" Text="Add" OnClick="btnAdd_Click" />
    <asp:Panel ID="PanelAddTag" runat="server" Visible="false">

        <div class="row  container ">

            <div class="col-12">
                <asp:TextBox ID="txtName" class="form-control w-25" runat="server" placeholder="Name"></asp:TextBox>
            </div>

            <div class="col-12">
                <asp:TextBox ID="txtNameEng" class="form-control w-25" runat="server" placeholder="NameEng"></asp:TextBox>
            </div>

            <div class="col-12">
                <asp:Label ID="lblType" class="form-label" runat="server" Text="Type"></asp:Label>
                <asp:DropDownList ID="ddlType" class="dropdown form-control w-25" runat="server"></asp:DropDownList>
            </div>

        </div>
    </asp:Panel>

    <asp:Repeater ID="RepeaterTags" runat="server" OnItemCommand="RepeaterTags_DeleteTag">
        <ItemTemplate>
            <ul>
                <li class="fs-6">
                    <%#Eval("Name") %>  (<%#Eval("Count")%>)       
                    <asp:Button ID="btnDelete" Visible='<%# CheckCount(Convert.ToInt32(Eval("Count"))) %>'
                        OnClientClick="return fnConfirmDelete();" CommandArgument=' <%#Eval("Id")%>  ' CssClass="btn btn-danger btn-sm" runat="server" Text="Delete" />
                </li>
            </ul>
        </ItemTemplate>
    </asp:Repeater>
</asp:Content>
