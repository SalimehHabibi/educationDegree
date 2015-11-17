<%@ Page Title="" Language="C#" MasterPageFile="~/UI/Main.Master" AutoEventWireup="true" CodeBehind="search.aspx.cs" Inherits="EducationDegree.UI.search" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        function readReferencesCountForSearch() {
            return $(document).data("countTotal");
        }

        function SearchInTable(firstRow) {
            $(document).data('countTotal', '0');
            $('#panel').show();
            $('#panel1').show();
            $('#tbPostInfo').empty();
            var arr = $(document).data('arrData');
            $.ajax({
                type: "POST",
                url: "search.aspx/SearchInTable",
                // data: JSON.stringify({ fieldName: fieldName, tendencyName: tendencyName, gardeName: gardeName }),
                data: JSON.stringify({ fieldName: arr[0], tendencyName: arr[1], gardeName: arr[2], firstRow: firstRow }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (response) {
                    try {

                        if (response.d == null) {
                            $('#tbPostInfo').append('<tr><td colspan="6"> یافت نشد.</td></tr>');
                        }
                        else {
                            var count = 0;
                            var color;
                            var shart;
                            var result = $.parseJSON(response.d);
                            $.each(result.Value, function (index, c) {
                                count += 1;
                                if (count % 2 == 0) {
                                    color = '#AAFFAA ';
                                }
                                else {
                                    color = ' #f2f2f2';
                                }
                                if (c.description == "") {
                                    shart = "ندارد.";
                                } else
                                    shart = "دارد";
                                if (c.cnt == null)
                                    $('#tbPostInfo').append('<tr style="background-color: ' + color + '" id="row_' + c.postFieldCode + '"><td id="1col_' + c.postCode + '" style="text-align:center">' +
                                         c.RowNo + '</td>' +
                                        '<td id="2col_' + c.postCode + '" style="text-align:center">' + c.postName + '</td>' +
                                        //'<td id="3col_' + c.postCode + '" style="text-align:center">' + c.raster + '</td>' +
                                        '<td id="4col_' + c.postFieldCode + '" style="text-align:center">' + c.fieldName + '</td>' +
                                        '<td id="5col_' + c.postFieldCode + '" style="text-align:center">' + c.tendencyName + '</td>' +
                                        '<td id="6col_' + c.postFieldCode + '" style="text-align:center">' + c.gradeName + '</td>' +
                                        '<td id="6col_' + c.postFieldCode + '" style="text-align:center">' + shart + '</td>' +
                                        '<td class="edit-remove"><i class="detail fa fa-book " style="cursor: pointer" id="detail' + c.postFieldCode + '" </i></td>' +
                                       + '" </i></td></tr>');
                                $(document).data("countTotal", c.cnt);
                            });
                        }
                    }
                    catch (err) {
                    }
                },
                error: function (response) {
                    alert('اشکال در خواندن اطلاعات');
                }
            });
        };

       

        function Search() {

            var fieldName = $('#txtField').val();
            var tendencyName = $('#txtTendency').val();
            var GradeName = $('#ddlGrade').find('option:selected').text();
            var data = [fieldName, tendencyName, GradeName];
            $(document).data('arrData', data);
            loadGrid('tbPostInfo', readReferencesCountForSearch, SearchInTable);

        }



        function FillCmbGrade() {
            $('#ddlGrade').empty();
            $('#ddlGrade').append(' <option value="">انتخاب کنید</option>');
            try {
                $.ajax({
                    type: "POST",
                    url: "manageInfo.aspx/FillCmbGrade",
                    data: "{}",//read only az db
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var result = $.parseJSON(response.d);
                        $.each(result.Value, function (index, c) {
                            $('<option value="' + c.gradeCode + '">' + c.gradeName + '</option>').appendTo("#ddlGrade");
                            //alert(c.gradeName);

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

        function readSharayet(reqCode) {
          
            try {
                $.ajax({
                    type: "POST",
                    url: "search.aspx/showDescription",
                    data: JSON.stringify({ reqCode: reqCode }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var result = $.parseJSON(response.d);
                        if (result.Value != "") {
                            var count = 0;
                            var color;
                           
                            $.each(result.Value, function (index, i) {
                                count += 1;
                                if (count % 2 == 0) {
                                    color = '#eaf6fd';
                                }
                                else {
                                    color = ' #f2f2f2';
                                }
                                if (i.description == "") {
                                    i.description = "ندارد."
                                }
                                
                                $('#TbllstFields' + reqCode).append('<tr style="background-color: ' + color + '"id="' + i.postFieldCode + '" ><td>' + i.description + '</td></tr>');
                            });
                        }
                    },
                    failure: function (response) {
                        alert('ارتباط با سرور برقرار نشد-خطای شماره 65');
                    }
                })
            }

            catch (e) {
                alert('ارتباط با سرور برقرار نشد-خطای شماره 66');

            }
        };

    </script>
    <%--///////////////////////////////////////////////////////Document Ready ////////////////////////////////////////////////////--%>
    <script>
        $(document).ready(function () {
            //PostFieldReq();
            $('#panel').hide();
            $('#panel1').hide();
            FillCmbGrade();
            var id = 0;
            bindPager('RequestPager');
            checkLenght();
            changeValid();
            $('#txtField').data('lenght', '50');
            $('#txtTendency').data('lenght', '30');

            $('#btnSearchFieldName').click(function () {
                Search();
            });
            $('#btnSearchTendencyName').click(function () {
                Search();
            });
            $('#btnSearchGradeName').click(function () {
                Search();
            }); 
            $('#btnSearch').click(function () {
                Search();
            }); 


            $('#txtField').keydown(function (e) {
                if (e.keyCode == 13) {
                    $('#btnSearchFieldName').focus();
                }
            });

            $('#txtTendency').keydown(function (e) {
                if (e.keyCode == 13) {
                    $('#btnSearchTendencyName').focus();
                }
            });

            $('#txtGrade').keydown(function (e) {
                if (e.keyCode == 13) {
                    $('#btnSearchGradeName').focus();
                }
            });
            $("#tbPostInfo").on('click', 'i.detail', function () {
                id = $(this).attr("id").replace("detail", "");
                var idNextRow = $(this).closest('tr').next('tr').attr('id');
                if (idNextRow != ('newRow' + id) || idNextRow == undefined) {
                    var currentRow = $(this).parent().parent();
                    var newRow;
                    newRow = '<tr id="newRow' + id + '" ><td colspan="100%" >' +
                    ' <div class="col-md-12"><div class="form-group"><div class="table-responsive"><table class="table table-hover table-bordered tbl-sub-header"><thead><tr><th class="sub-header">شرایط خاص</th></thead>' +
                    '<tbody id="TbllstFields' + id + '" ></tbody></table></div></div></div></div></td></tr>';
                    console.log(newRow);
                    currentRow.after(newRow);
                    //read
                    readSharayet(id);

                }
                if (idNextRow == 'newRow' + id) {
                    $('#newRow' + id).toggle();
                }

            });

        });
    </script>
    <%--/////////////////////////////////////////////////////////End Script ///////////////////////////////////////////////////////--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel">
        <div class="panel-body">
            <div class="container-fluid">
                <div class="back-top-box">
                    <div class="row">
                        <div class="form-group col-md-4">
                            <div class="input-group">
                                <span class="input-group-addon">نام رشته</span>
                                <input type="text" class="form-control lenght" id="txtField" placeholder="" aria-describedby="basic-addon1" />
                                <span class="input-group-btn">
                                    <button type="button" id="btnSearchFieldName" class="btn btn-success"><i class="fa fa-search"></i></button>
                                </span>
                            </div>

                        </div>
                        <div class="form-group col-md-4">
                            <div class="input-group">
                                <span class="input-group-addon">نام گرایش</span>
                                <input type="text" class="form-control lenght" id="txtTendency" placeholder="" aria-describedby="basic-addon1" />
                                <span class="input-group-btn">
                                    <button type="button" id="btnSearchTendencyName" class="btn btn-success"><i class="fa fa-search"></i></button>
                                </span>
                            </div>
                        </div>
                        <div class="form-group col-md-4">
                            <div class="input-group">
                                <span class="input-group-addon">مقطع تحصیلی</span>
                                <select class="form-control required" id="ddlGrade" data-width="75%">
                                </select>
                                <span class="input-group-btn">
                                    <button type="button" id="btnSearchGradeName" class="btn btn-success"><i class="fa fa-search"></i></button>
                                </span>
                            </div>
                        </div>
                        <div class="clearfix"></div>
                        <div class="form-group col-md-4"></div>
                        <div class="form-group col-md-4"></div>
                        <div class="form-group col-md-4">
                            <div class="btn-group pull-left" role="group" aria-label="basic-addon1">
                                <button type="button" class="btn btn-success" id="btnSearch">جستجو&nbsp;<i class="fa fa-search"></i></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="padding: 10px;">
                    <div class="panel-title" id="panel"><span><i class="fa fa-search"></i>&nbsp;تمامی شغل های مرتبط با جستجو</span></div>
                    <div class="panel-body" id="panel1">
                        <div class="table-responsive table-padding">
                            <table class="table table-hover table-bordered">
                                <tr>
                                    <th class="head-title">ردیف</th>
                                    <th class="head-title">عنوان شغلی</th>
                                   
                                    <th class="head-title">نام رشته</th>
                                    <th class="head-title">نام گرایش</th>
                                    <th class="head-title">مدرک تحصیلی</th>
                                    <th class="head-title">شرایط خاص</th>
                                    <th class="head-title">جزییات</th>


                                </tr>
                                <tbody id="tbPostInfo"></tbody>
                            </table>
                        </div>

                        <div id="RequestPager">
                            <nav class="pull-right">
                                <ul class="pagination">
                                    <li>
                                        <a href="#">
                                            <input id="BtnFirst" name="BtnFirst" type="button" value="اولین" />
                                            <i class="fa fa-fast-forward"></i>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#">
                                            <input id="BtnPrevius" name="BtnPrevius" type="button" value="قبلی" />
                                            <i class="fa fa-forward"></i>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#">
                                            <input style="width: 70px; text-align: center" id="TxtPager" name="TxtPager" type="text" readonly="readonly" />
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#">
                                            <input id="BtnNext" name="BtnNext" type="button" value="بعدی" />
                                            <i class="fa fa-backward"></i>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#">
                                            <input id="BtnLast" name="BtnLast" type="button" value="آخرین" />
                                            <i class="fa fa-fast-backward"></i>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
