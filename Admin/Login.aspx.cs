
using rwa.Models;
using rwa.Utils;
using rwaLib.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Admin
{
    public partial class Login : System.Web.UI.Page
    {
        private readonly UserRepository _userRepository;

        public Login()
        {
            _userRepository = new UserRepository();
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void lbLogin_Click(object sender, EventArgs e)
        {
            // FormsAuthentication.RedirectFromLoginPage() automatically generates
            // the forms authentication cookie!
            if (ValidateUser(txtUserName.Value, txtUserPass.Value))
                FormsAuthentication.RedirectFromLoginPage(txtUserName.Value, chkPersistCookie.Checked);
            else
                Response.Redirect("Login.aspx", true);
        }

        private bool ValidateUser(string userName, string passWord)
        {
            string hashedPassword = Cryptography.HashPassword(passWord);
            User user = _userRepository.AuthUser(userName, hashedPassword);
            if (user != null)
            {
                Session["user"] = user;
                return true;

            }
            else
            {
                return false;
            }

        }
    }
}