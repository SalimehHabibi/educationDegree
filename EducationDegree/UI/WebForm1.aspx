<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="EducationDegree.UI.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../Content/css/combo.select.css" rel="stylesheet" />
    <script src="../Content/js/jqueryMin.js"></script>
    <script src="../Content/js/jquery.combo.select.js"></script>
     <script>
         $(function () {

             $('select')
             .comboSelect()

             /**
              * on Change
              */

             $('.js-select').change(function (e, v) {
                 $('.idx').text(e.target.selectedIndex)
                 $('.val').text(e.target.value)
             })

             /**
              * Open select
              */

             $('.js-select-open').click(function (e) {
                 $('.js-select').focus()
                 e.preventDefault();
             })

             /**
              * Open select
              */

             $('.js-select-close').click(function (e) {
                 $('.js-select').trigger('comboselect:close')
                 e.preventDefault();
             })

             /**
              * Add new options
              */

             var $select = $('.js-select-3');

             $('.js-select-add').click(function () {
                 $select.prepend($('<option>', {
                     text: 'A new option: ' + Math.floor(Math.random() * 10) + 1
                 })).trigger('comboselect:update')

                 return false;
             })

         });
         function FillCmbPost() {
             $('#ddlPostName').empty();
             $('#ddlPostName').append(' <option value="">انتخاب کنید</option>');
             try {
                 $.ajax({
                     type: "POST",
                     url: "manageInfo.aspx/FillCmbPost",
                     data: "{}",//read only az db
                     contentType: "application/json; charset=utf-8",
                     dataType: "json",
                     success: function (response) {
                         var result = $.parseJSON(response.d);
                         $.each(result.Value, function (index, c) {
                             $('<option value="' + c.postCode + '">' + c.postName + '</option>').appendTo("#ddlPostName");
                         });


                     },
                     failure: function (response) {
                         alert("اشکال در خواندن اطلاعات20");
                     }

                 })

             }

             catch (e) {
                 alert("اشکال در خواندن اطلاعات");
             }
         };
         $(document).ready(function () {
             FillCmbPost();
         });
	</script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <span class="input-group-addon">عنوان شغلی</span>
                                                
                                                    <select  class="" id="ddlPostName" data-width="75%">
                                                     <option>سلام</option>
                                                     <option>امروز</option>
                                                     <option>دیروز</option>
                                                     <option>پ</option>
                                                     <option>ت</option>
                                                     <option>س</option>
                                                     <option>ذ</option>
                                                     <option>ظ</option>
                                                     <option>ق</option>
                                                     <option>ض</option>
                                                     <option>و</option>
                                                     <option>ی</option>
                                                </select>
    </div>
    </form>
</body>
</html>
