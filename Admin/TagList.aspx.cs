using rwa.Models;
using rwaLib.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Admin
{
    public partial class TagList : System.Web.UI.Page
    {


        private readonly TagRepository _tagRepository;
        private readonly TagTypeRepository _tagTypeRepository;

        public TagList()
        {
            _tagRepository = new TagRepository();
            _tagTypeRepository = new TagTypeRepository();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            
            _tagRepository.GetTagCount();
            _tagTypeRepository.GetTagTypes();

            if (!IsPostBack)
            {
                RebindTags();
                RebindTagTypes();
                
            }
        }

        private void RebindTags()
        {
            PanelAddTag.Visible = false;
            RepeaterTags.DataSource = _tagRepository.GetTagCount();
            RepeaterTags.DataBind();
        }

        private void RebindTagTypes()
        {

            ddlType.DataSource = _tagTypeRepository.GetTagTypes();
            ddlType.DataValueField = "Id";
            ddlType.DataTextField = "Name";
            ddlType.DataBind();
        }

        protected void RepeaterTags_DeleteTag(object source, RepeaterCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument.ToString().Trim());

            _tagRepository.DeleteTag(id);
            RebindTags();


        }


        public bool CheckCount(int myValue)
        {
            if (myValue == 0)
            {
                return true;
            }
            return false;

        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            PanelAddTag.Visible = true;
            int typeId = Convert.ToInt32(ddlType.SelectedValue);
            string name = txtName.Text;
            string nameEng = txtNameEng.Text;

            if (ModelState.IsValid && !String.IsNullOrEmpty(name) && !String.IsNullOrEmpty(nameEng))
            {
                Tag tag = new Tag(name, nameEng,typeId);
                _tagRepository.InsertTag(tag);
                RebindTags();


            }
        }
    }
}