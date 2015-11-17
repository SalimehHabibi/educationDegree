<%@ Page Title="" Language="C#" MasterPageFile="~/UI/Main.Master" AutoEventWireup="true" CodeBehind="testSelect.aspx.cs" Inherits="EducationDegree.UI.testSelect" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">
        function FillCmbField() {
            $('#ddlField').empty();
            $('#ddlField').append(' <option value="">انتخاب کنید</option>');
            try {
                $.ajax({
                    type: "POST",
                    url: "manageInfo.aspx/FillCmbField",
                    data: "{}",//read only az db
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (response) {
                        var result = $.parseJSON(response.d);
                        $.each(result.Value, function (index, c) {
                            $('<option value="' + c.fieldCode + '">' + c.fieldName + '</option>').appendTo("#ddlField");

                            //alert(c.fieldName);
                        });


                    },
                    failure: function (response) {
                        alert("اشکال در خواندن اطلاعات");
                    }
                })
            }

            catch (e) {
                alert("اشکال در خواندن اطلاعات");
            }
        };
        $(document).ready(function () {
            FillCmbField();

            $(function () {
                var opts = $('#ddlField option').map(function () {
                    return [[this.value, $(this).text()]];
                });


                $('#someinput').keyup(function () {
                    var rxp = new RegExp($('#someinput').val(), 'i');
                    var optlist = $('#ddlField').empty();
                    opts.each(function () {
                        if (rxp.test(this[1])) {
                            optlist.append($('<option/>').attr('value', this[0]).text(this[1]));
                        }
                    });

                });

            });
        });
     </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="form-group">
        <div class="input-group col-md-12">
              <input id="someinput" />
              <span class="input-group-addon">نام رشته</span>
              <select  class="form-control required" id="ddlField" data-width="75%">
                </select>
               </div>
        </div>
</asp:Content>
