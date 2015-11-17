<%@ Page Title="" Language="C#" MasterPageFile="~/UI/Main.Master" AutoEventWireup="true" CodeBehind="FieldManage.aspx.cs" Inherits="EducationDegree.UI.FieldManage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
   <style>
       #fieldManage .modal-dialog {
           width: 75%;
       }
   </style>
<%--////////////////////////////////////////////////////////Functions////////////////////////////////////////////////////////////////////--%>
    <script type="text/javascript">

        function readReferencesCountForSearch() {
            return $(document).data("countTotal");
        }


        function FieldReq(firstRow) {
            $(document).data('countTotal', '0');
            $('#TblField').empty();
            try {
                $.ajax({
                    type: "POST",
                    url: "FieldManage.aspx/FieldReq",
                    data: JSON.stringify({ firstRow: firstRow }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (response) {
                        if (response.d == null) {
                            $('#TblField').append('<tr><td colspan="6"> یافت نشد.</td></tr>');
                        }
                        else {
                            var count = 0;
                            var color;
                            var result = $.parseJSON(response.d);
                            $.each(result.Value, function (index, c) {
                                count += 1;
                                if (count % 2 == 0) {
                                    color = '#eaf6fd ';
                                }
                                else {
                                    color = ' #f2f2f2';
                                }
                                if (c.cnt == null)
                                $('#TblField').append('<tr style="background-color: ' + color + '" id="row_' + c.fieldCode + '"><td id="1col_' + c.fieldCode + '" style="text-align:center">' +
                                     c.RowNo + '</td>' +
                                   '<td id="2col_' + c.fieldCode + '" style="text-align:center">' + c.fieldName + '</td>' +
                                   '<td class="edit-remove"><i class="edit fa fa-edit " style="cursor: pointer" id="edit' + c.fieldCode + '" </i></td>' +
                                   '<td class="edit-remove"><i  class="delete fa fa-times " style="cursor: pointer" id="delete' + c.fieldCode
                                   + '" </i></td>');
                                $(document).data("countTotal", c.cnt);
                            });
                        }

                    },
                    error: function (response) {
                        alert('اشکال در خواندن اطلاعات');
                    }
                });
            }
            catch (err) {
            }

        };

        function emptyElements(container) {
            var strContainer = '#' + container;
            $('input[type=text]', strContainer).each(function (element) {
                $(this).val('');
            });
            $('select', strContainer).each(function (element) {
                $(this).val("0");
            });
        }

        function fillModal(id) {
            var fieldCode = id;
            $.ajax({
                type: "POST",
                url: "FieldManage.aspx/FieldReqSeByID",
                data: JSON.stringify({ fieldCode: fieldCode }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    try {

                        if (response.d == null) {
                            alert("جوابی یافت نشد");
                        }
                        else {
                            var result = $.parseJSON(response.d);
                            $.each(result.Value, function (index, c) {
                                $('#txtfieldName').val(c.fieldName);
                              //  $('#txtDate').val(c.dateInsert);
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
        }

        function UpdateReq(id) {
            var fieldCode = id;
            var request = {};
            request.fieldCode = fieldCode;
            request.fieldName = $('#txtfieldName').val();
          //  request.dateInsert = $('#txtDate').val();

            var arrType = new Array();
            var j = 1;
            $.each($('#tblTendency tr'), function (index) {
                var tendencyReqType = {};
                tendencyReqType.fieldCode = fieldCode;
                tendencyReqType.tendencyName = $('#ROW_' + j + ' td:nth-child(2)').text();
                arrType.push(tendencyReqType);
                j++;

            });
            try {
                $.ajax({
                    type: "POST",
                    url: "FieldManage.aspx/UpdateReqField",
                    data: JSON.stringify({ rn: request, rgr: arrType, fieldCode: fieldCode }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var result = $.parseJSON(response.d);
                        if (result.IsSuccessfull) {
                            alert('ویرایش اطلاعات با موفقیت انجام شد');
                            $("#fieldManage").modal("hide");
                            loadGrid('TblField', readReferencesCountForSearch, FieldReq);
                           

                        }
                        else {
                            alert(result.Message);
                        }
                    },
                    failure: function (response) {
                        $('#lblMessage').text('ارتباط با سرور برقرار نشد-خطای شماره 3');
                    }
                })
            }

            catch (e) {
                alert("اشکال در خواندن اطلاعات");

            }
        };

        function addToTableTendency() {
            var i2 = 0;
            $.each($('#tblTendency tr'), function (index) {
                i2++;
            });
            if (i2 == 0)
                var i = $(document).data('i');
            else
                var i = i2;
            i++;
            var color = '';
            if (i % 2 == 0) {
                color = '#eaf6fd';
            }
            else {
                color = ' #f2f2f2';
            }


            var TendencyName = $('#txtTendency').val();

            $('#tblTendency').append('<tr class="addItem" style="background-color: ' + color + '" id="ROW_' + i + '"><td id="1col_' + i + '" style="text-align:center">' +
                               i + '</td><td id="2col_' + i + '" style="text-align:center">' +
                               TendencyName + '</td>'
                               + '<td class="edit-remove"><i  class="delete fa fa-times " style="cursor: pointer" id="delete' + i
                                 + '" </i></td>');

            $(document).data('i', i);
        };

        function createReq() {
            var request = {};

            request.fieldName = $('#txtfieldName').val();
        //    request.dateInsert = $('#txtDate').val();


            var arrType = new Array();
            var j = 1;
            $.each($('#tblTendency tr'), function (index) {
                var tendencyReqType = {};
                tendencyReqType.tendencyName = $('#ROW_' + j + ' td:nth-child(2)').text();
                arrType.push(tendencyReqType);
                j++;

            });
            try {
                $.ajax({
                    type: "POST",
                    url: "FieldManage.aspx/creatReq",
                    data: JSON.stringify({ rn: request, rgr: arrType }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var result = $.parseJSON(response.d);
                        if (result.IsSuccessfull) {
                            alert('ثبت اطلاعات با موفقیت انجام شد');
                            $("#fieldManage").modal("hide");
                            loadGrid('TblField', readReferencesCountForSearch, FieldReq);
                           

                        }
                        else {
                            alert(result.Message);
                        }
                    },
                    failure: function (response) {
                        $('#lblMessage').text('ارتباط با سرور برقرار نشد-خطای شماره 3');
                    }
                })
            }

            catch (e) {
                alert("اشکال در خواندن اطلاعات");

            }
        };

        function TendencyReq(id) {
            $('#tblTendency').empty();
            var fieldCode = id
            $.ajax({
                type: "POST",
                url: "FieldManage.aspx/TendencyReq",
                data: JSON.stringify({ fieldCode: fieldCode }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    try {

                        if (response.d == null) {
                            $('#tblTendency').append('<tr><td colspan="6"> یافت نشد.</td></tr>');
                        }
                        else {
                            var count = 0;
                            var color;
                            var result = $.parseJSON(response.d);
                            $.each(result.Value, function (index, c) {
                                count += 1;

                                if (count % 2 == 0) {
                                    color = '#AAFFAA ';
                                }
                                else {
                                    color = ' #f2f2f2';
                                }
                                $('#tblTendency').append('<tr class="addItem" style="background-color: ' + color + '" id="ROW_' + count + '"><td id="1col_' + count + '" style="text-align:center">' +
                                count + '</td><td id="2col_' + count + '" style="text-align:center">' +
                                c.tendencyName + '</td>'
                                + '<td class="edit-remove"><i  class="delete fa fa-times " style="cursor: pointer" id="delete' + count
                                + '" </i></td>');
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

        function SearchByFieldName(firstRow) {
            $(document).data('countTotal', '0');
            $('#TblField').empty();
            var arr = $(document).data('arrData');
            $.ajax({
                type: "POST",
                url: "FieldManage.aspx/SearchByFieldName",
              //  data: JSON.stringify({ fieldName: fieldName }),
                data: JSON.stringify({ fieldName: arr[0], firstRow: firstRow }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (response) {
                    try {

                        if (response.d == null) {
                            $('#TblField').append('<tr><td colspan="6"> یافت نشد.</td></tr>');
                        }
                        else {
                            var count = 0;
                            var color;
                            var result = $.parseJSON(response.d);
                            $.each(result.Value, function (index, c) {
                                count += 1;
                                if (count % 2 == 0) {
                                    color = '#eaf6fd ';
                                }
                                else {
                                    color = ' #f2f2f2';
                                }
                                if (c.cnt == null)
                                $('#TblField').append('<tr style="background-color: ' + color + '" id="row_' + c.fieldCode + '"><td id="1col_' + c.fieldCode + '" style="text-align:center">' +
                                     c.RowNo + '</td>' +
                                   '<td id="2col_' + c.fieldCode + '" style="text-align:center">' + c.fieldName + '</td>' +
                                   '<td class="edit-remove"><i class="edit fa fa-edit " style="cursor: pointer" id="edit' + c.fieldCode + '" </i></td>' +
                                   '<td class="edit-remove"><i  class="delete fa fa-times " style="cursor: pointer" id="delete' + c.fieldCode
                                   + '" </i></td>');
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

        function deleteField(id) {
            var fieldCode = id;
            $.ajax({
                type: "POST",
                url: "FieldManage.aspx/deleteField",
                data: JSON.stringify({ fieldCode: fieldCode }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    try {

                        alert("رکورد مورد نظر با موفقیت حذف شد.");
                        loadGrid('TblField', readReferencesCountForSearch, FieldReq);
                        
                    }
                    catch (err) {
                    }
                },
                error: function (response) {
                    alert('اشکال در خواندن اطلاعات');
                }
            });
        };
    </script>
<%--/////////////////////////////////////////////////////Document.Ready///////////////////////////////////////////////////////////////////--%>
    <script type="text/javascript">
        $(document).ready(function () {

            bindPager('RequestPager');
            var id;
            checkLenght();
            changeValid();
            loadGrid('TblField', readReferencesCountForSearch, FieldReq);
            $('#divTable').hide();

            $('#txtfieldName').data('lenght', '30');
            $('#txtTendency').data('lenght', '30');

            $('#btnSave').click(function () {
                if (valid('fieldManage') == true) {
                    createReq();

                }
            });

            $("#btnAdd").click(function () {
                $('#divTable').hide();
                emptyElements('fieldManage');
                $(document).data('i', '0');
                $('#btnUpdate').hide();
                $('#btnSave').show();
                validBack('fieldManage');
                $('#tblTendency').empty();
            });

            $("#btnUpdate").click(function () {
                $('#divTable').show();
                if (valid('fieldManage') == true) {
                    UpdateReq(id);
                    //UpdateTendency(id);

                }
            });

            $("#TblField").on('click', 'i.edit', function () {
                id = $(this).attr("id").replace("edit", "");

                $("#fieldManage").modal("show");
                validBack('fieldManage');
                fillModal(id);
                TendencyReq(id);
                $(document).data('i', '0');
                $('#btnUpdate').show();
                $('#btnSave').hide();
            });

            $("#btnAddTendency").click(function () {
                $('#divTable').show();
                if ($('#txtTendency').val() == "") {
                    alert(" قیلد مربوط به گرایش رو پر نمایید.");
                }
                else{
                    if(valid('fieldManage') == true)
                    {
                        addToTableTendency();
                        $('#txtTendency').val('');
                        
                    }
                }
            });

            $("#tblTendency").on('click', 'i.delete', function () {
                id = $(this).attr("id").replace("delete", "");
                $('#ROW_' + id).remove();
                var len = $('#tblTendency tr').length;
                if (len > 0) {
                    var n = 0;
                    $.each($('#tblTendency tr'), function (index) {
                        n++;
                        $(this).attr('id', 'ROW_' + n)
                        $(this).find("td").eq(0).text(n);
                        $(this).children().children('.delete').attr('id', 'delete' + n);
                    });
                    $(document).data('i', n);
                }
                else {
                    $(document).data('i', 0);
                }

            });

            $("#btnSearchField").click(function () {
                var fieldName = $('#txtField').val();
                var data = [fieldName];
                $(document).data('arrData', data);
                loadGrid('TblField', readReferencesCountForSearch, SearchByFieldName);
            });

            $("#TblField").on('click', 'i.delete', function () {
                id = $(this).attr("id").replace("delete", "");
                var e = confirm("آیا مطمئن هستید؟");
                if (e == true) {
                    deleteField(id);
                   
                    //   loadGrid('TblPost', readReferencesCountForSearch, UserReq);
                }
            });


            $('#txtField').keydown(function (e) {
                if (e.keyCode == 13) {
                    $('#btnSearchField').focus();
                }
            });
        });


    </script>
 <%--////////////////////////////////////////////////////End Script///////////////////////////////////////////////////////////////////--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel panel-primary">
        <div class="panel-title"><span><i class="fa fa-graduation-cap"></i>&nbsp;اطلاعات مربوط به رشته های تحصیلی</span>
        </div>
        <div class="panel-body panel-body-back">
                  <div class="row row-margin">
                 <div class="col-md-4 background col-md-padding">
                    <div class="form-group">
                        <div class="input-group row-fluid">
                            <span class="input-group-addon">نام رشته</span>
                           <input type="text" class="form-control" id="txtField" aria-describedby="basic-addon1" />
                            <span class="input-group-btn"><button type="button" id="btnSearchField" class="btn btn-success"><i class="fa fa-search"></i></button></span>
                        </div>
                    </div>   
                          <div class="form-group">
                      <button type="button" class="btn btn-success" data-toggle="modal" data-target="#fieldManage" id="btnAdd" data-target=".bs-example-modal-lg""><i class="fa fa-plus"></i>&nbsp; رشته جدید</button>
                </div>
                 </div>
                 <div class="col-md-8 back-right-box col-md-padding">
                 <table id="example" class="table table-hover table-bordered">
                    <thead>
                        <tr>
                            <th class="head-title">ردیف</th>
                            <th class="head-title"> نام رشته</th>
                            <th class="head-title edit-remove">ویرایش</th>
                            <th class="head-title edit-remove">حذف</th>
                        </tr>
                    </thead>
                    <tbody id="TblField">
                        <tr>
                        </tr>
                    </tbody>
                </table>
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
                                    <input style="width:70px; text-align:center" id="TxtPager" name="TxtPager" type="text" readonly="readonly" />
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
<%---------------------------------------------------------------------------------Modal--------------------------------------------------------------------------------------%>
     <div class="modal fade bs-example-modal-lg" id="fieldManage" tabindex="-1" role="dialog" aria-labelledby="gridSystemModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="gridSystemModalLabel"><i class="fa fa-graduation-cap"></i>&nbsp;تعریف رشته تحصیلی</h4>
                </div>
                <div class="modal-body back-right-box">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-md-4 background col-md-padding">
                                <div class="form-group">
                                    <div class="input-group col-md-12">
                                        <span class="input-group-addon">نام رشته تحصیلی</span>
                                        <input type="text"style="width:100% !important" class="form-control  required lenght" id="txtfieldName" aria-disabled="true" placeholder="" aria-describedby="basic-addon1" />
                                    </div>
                                </div>
                             <%--    <div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-addon" style="vertical-align: top;">تاریخ ثبت</span>
                                        <input type="text" id="txtDate" style="width:100% !important" class="form-control date" aria-disabled="true" placeholder="" aria-describedby="basic-addon1" />
                                    </div>
                                </div>--%>
                                  <div class="form-group">
                                    <div class="input-group col-md-12">
                                        <span class="input-group-addon" style="vertical-align: top;">گرایش</span>
                                        <input type="text" id="txtTendency"  style="width:100% !important" class="form-control lenght" aria-disabled="true" placeholder="" aria-describedby="basic-addon1" />
                                    </div>
                                </div>
                                     <div class="form-group" style="padding-left: 0px">
                                    <div class="input-group pull-left">
                                        <button type="button" id="btnAddTendency" class="btn btn-success"><i class="fa fa-plus"></i>&nbsp;اضـافـه&nbsp;</button>
                                    <div class="clearfix"></div>
                                    </div>
                                </div>
                            </div>
                           
                            <div class="col-md-8 back-right-box col-md-padding">
                    <div class="form-group">
                        <div class="table-responsive" id="divTable">
                            <table class="table table-hover table-bordered">
                                <thead>
                                    <tr>
                                        <th class="head-title">ردیف</th>
                                        <th class="head-title">نام گرایش</th>
                                        <th class="head-title edit-remove">حذف</th>
                                    </tr>
                                </thead>
                                <tbody id="tblTendency">
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" id="btnUpdate" class="btn btn-success">ویرایش اطلاعات</button>
                    <button type="button" id="btnSave" class="btn btn-success">ذخیره اطلاعات</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">انصراف</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
