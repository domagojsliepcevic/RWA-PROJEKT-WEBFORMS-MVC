<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Admin.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <h3>
            <font face="Verdana">Logon Page</font>
        </h3>
        <table>
            <tr>
                <td>Email:</td>
                <td>
                    <input id="txtUserName" type="text" runat="server"></td>
                <td>
                    <asp:RequiredFieldValidator ControlToValidate="txtUserName"
                        Display="Static" ErrorMessage="*" runat="server"
                        ID="vUserName" /></td>
            </tr>
            <tr>
                <td>Password:</td>
                <td>
                    <input id="txtUserPass" type="password" runat="server"></td>
                <td>
                    <asp:RequiredFieldValidator ControlToValidate="txtUserPass"
                        Display="Static" ErrorMessage="*" runat="server"
                        ID="vUserPass" />
                </td>
            </tr>
            <tr>
                <td>Persistent Cookie:</td>
                <td>
                    <asp:CheckBox ID="chkPersistCookie" runat="server" AutoPostBack="false" /></td>
                <td></td>
            </tr>
        </table>
        <asp:LinkButton ID="lbLogin" runat="server" OnClick="lbLogin_Click">Login</asp:LinkButton>
        <asp:Label ID="lblMsg" ForeColor="red" Font-Name="Verdana" Font-Size="10" runat="server" />
    </form>
</body>
</html>
