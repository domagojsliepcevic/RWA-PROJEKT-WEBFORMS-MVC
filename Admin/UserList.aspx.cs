using rwaLib.DAL;
using System;
using System.Web.UI.WebControls;

namespace Admin
{
    public partial class UserList : System.Web.UI.Page
    {

        private readonly UserRepository _userRepository;

        public UserList()
        {
            _userRepository = new UserRepository();
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            _userRepository.GetUsers();
            if (!IsPostBack)
            {
                AppendUsers();
            }
        }

        private void AppendUsers()
        {
            gvRegisteredUsers.DataSource = _userRepository.GetUsers();
            gvRegisteredUsers.DataBind();
        }

        protected void gvRegisteredUsers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvRegisteredUsers.DataSource = _userRepository.GetUsers();
            gvRegisteredUsers.PageIndex = e.NewPageIndex;
            gvRegisteredUsers.DataBind();
        }
    }

}