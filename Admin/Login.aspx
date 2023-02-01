<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Admin.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />
    <link href="Content/Login.css" rel="stylesheet" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

</head>
<body>
    <div class="container">
        <div class="row">
            <div class="col-sm-12 col-md-6 offset-md-3">
                <div class="box">
                    <form id="form1" runat="server">
                        <h3 class="text-center">Login Page</h3>
                        <table class="table">
                            <tr>
                                <td>Email:</td>
                                <td>
                                    <input id="txtUserName" type="text" runat="server">
                                </td>
                                <td>
                                    <asp:RequiredFieldValidator ControlToValidate="txtUserPass"
                                        Display="Static" ErrorMessage="<span class='text-danger'>Invalid UserName</span>" runat="server"
                                        ID="vUserName" />
                                </td>
                            </tr>
                            <tr>
                                <td>Password:</td>
                                <td>
                                    <input id="txtUserPass" type="password" runat="server">
                                </td>
                                <td>
                                    <asp:RequiredFieldValidator ControlToValidate="txtUserPass"
                                         Display="Static" ErrorMessage="<span class='text-danger'>Invalid Password</span>" runat="server"
                                        ID="vUserPass" />
                                </td>
                            </tr>
                            <tr>
                                <td>Persistent Cookie:</td>
                                <td>
                                    <asp:CheckBox ID="chkPersistCookie" runat="server" AutoPostBack="false" />
                                </td>
                                <td></td>
                            </tr>
                        </table>
                        <asp:LinkButton ID="lbLogin" runat="server" OnClick="lbLogin_Click" class="btn btn-primary btn-block">Login</asp:LinkButton>
                        <asp:Label ID="lblMsg" ForeColor="red" Font-Name="Verdana" Font-Size="10" runat="server" />
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
