<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ApartmentEditor.aspx.cs" Inherits="Admin.ApartmentEditor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
        <div class="col-md-6">
            <div class="form-group">
                <label>Vlasnik</label>
                <asp:DropDownList ID="ddlApartmentOwner" runat="server" CssClass="form-control" DataValueField="Id" DataTextField="Name"></asp:DropDownList>
            </div>
            <div class="form-group">
                <label>Status</label>
                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control" DataValueField="Id" DataTextField="Name"></asp:DropDownList>
            </div>
            <div class="form-group">
                <label>Naziv</label>
                <asp:TextBox ID="tbName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group">
                <label>Adresa</label>
                <asp:TextBox ID="tbAddress" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group">
                <label>Grad</label>
                <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-control" DataValueField="Id" DataTextField="Name"></asp:DropDownList>
            </div>
            <div class="form-group">
                <label>Cijena</label>
                <div class="input-group">
                    <span class="input-group-addon" id="sizing-addon1">€</span>
                    <asp:TextBox ID="tbPrice" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="form-group">
                <label>Broj odraslih</label>
                <asp:TextBox ID="tbMaxAdults" runat="server" TextMode="Number" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group">
                <label>Broj djece</label>
                <asp:TextBox ID="tbMaxChildren" runat="server" TextMode="Number" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group">
                <label>Broj soba</label>
                <asp:TextBox ID="tbTotalRooms" runat="server" TextMode="Number" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group">
                <label>Udaljenost od plaže</label>
                <asp:TextBox ID="tbBeachDistance" runat="server" TextMode="Number" CssClass="form-control"></asp:TextBox>
            </div>
        </div>
        <div class="col-md-6">
            <div class="form-group">
                <label>Odabir tagova</label>
                <asp:DropDownList
                    ID="ddlTags"
                    runat="server"
                    CssClass="form-control"
                    DataValueField="Id"
                    DataTextField="Name" OnSelectedIndexChanged="ddlTags_SelectedIndexChanged" AutoPostBack="true">
                </asp:DropDownList>
            </div>
            <asp:Repeater ID="repTags" runat="server">
                <HeaderTemplate>
                    <ul class="list-group">
                </HeaderTemplate>
                <ItemTemplate>
                    <li class="list-group-item">
                        <asp:HiddenField runat="server" ID="hidTagId" Value='<%# Eval("ID") %>' />
                        <asp:Label runat="server" ID="txtTagName" Text='<%# Eval("Name") %>' />
                        <asp:HiddenField runat="server" ID="HiddenField1" Value='<%# Eval("ID") %>' />
                        <asp:Label runat="server" ID="Label1" Text='<%# Eval("Name") %>' />
                        <asp:LinkButton runat="server" ID="btnDeleteTag" CssClass="btn" OnClick="btnDeleteTag_Click">
                        <span class="glyphicon glyphicon-trash"></span>
                        </asp:LinkButton>
                    </li>
                </ItemTemplate>
                <FooterTemplate>
                    </ul>
                </FooterTemplate>
            </asp:Repeater>
        </div>
        <div class="container">
            <div class="form-group">
                <label class="btn btn-default">
                    Upload slika
                <asp:FileUpload ID="uplImages" runat="server" CssClass="hidden" AllowMultiple="true" OnChange="handleFileSelect(this.files)" />
                </label>
                <div id="uplImageInfo"></div>
                <script>
            function handleFileSelect(files) {
                for (var i = 0; i < files.length; i++) {
                    $span = $("<span class='label label-info'></span>").text(files[i].name);
                    $('#uplImageInfo').append($span);
                    $('#uplImageInfo').append("<br />");
                }
            }
                </script>
            </div>
        </div>
        <asp:Repeater ID="repApartmentPictures" runat="server">
      <ItemTemplate>
          <div class="form-group">
              <div class="row">
                  <asp:HiddenField runat="server" ID="hidApartmentPictureId" Value='<%# Eval("ID") %>' />
                  <div class="col-md-3">
                      <a href="<%# Eval("Path") %>">
                          <asp:Image ID="imgApartmentPicture" runat="server" CssClass="img-thumbnail" ImageUrl='<%# Eval("Path") %>' Width="320" Height="200" />
                      </a>
                  </div>
                  <div class="col-md-3">
                      <div class="form-group">
                          <asp:TextBox ID="txtApartmentPicture" runat="server" CssClass="form-control" Text='<%# Eval("Name") %>' placeholder="Naziv" />
                      </div>
                      <div class="form-group">
                          <label class="btn btn-success">Glavna slika
                              <asp:CheckBox ID="cbIsRepresentative" runat="server" CssClass="is-representative-picture" Checked='<%# Eval("IsRepresentative") %>' />
                          </label>
                      </div>
                      <div class="form-group">
                          <label class="btn btn-danger">
                              <span class="glyphicon glyphicon-trash"></span>
                              <asp:CheckBox ID="cbDelete" runat="server" Checked="false" />
                          </label>
                      </div>
                  </div>
              </div>
          </div>
      </ItemTemplate>
  </asp:Repeater>
        <script>
            $(function () {
                var repPicCheckboxes = $(".is-representative-picture > input[type=checkbox]");
                repPicCheckboxes.change(function () {
                    currentCheckbox = this;
                    if (currentCheckbox.checked) {
                        repPicCheckboxes.each(function () {
                            otherCheckbox = this
                            if (currentCheckbox != otherCheckbox && otherCheckbox.checked) {
                                otherCheckbox.checked = false;
                            }
                        })
                    }
                });
            })
        </script>
        <div>
            <asp:LinkButton ID="lblSave" runat="server" Text="Spremi" CssClass="btn btn-primary" OnClick="lblSave_Click" />
            <asp:LinkButton ID="lblCancel" runat="server" Text="Odustani" CssClass="btn btn-danger" OnClick="lblCancel_Click" />
        </div>
    </div>
</asp:Content>
