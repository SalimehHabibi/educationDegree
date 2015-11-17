<%@ Page Title="" Language="C#" MasterPageFile="~/UI/Main.Master" AutoEventWireup="true" CodeBehind="PostManage.aspx.cs" Inherits="EducationDegree.UI.PostManage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #postManage .modal-dialog {
        width:25%;
        }
    </style>
<%--////////////////////////////////////////////////////////Functions////////////////////////////////////////////////////////////////////--%>
    <script type="text/javascript">
        function readReferencesCountForSearch() {
            //alert($(document).data("totalCount") + " count");
            //return $(document).data("totalCount");
            return $(document).data("countTotal");
        }

        function PostReq(firstRow) {
         //   $(document).data('countTotal', '0');
            $('#TblPost').empty();
            try {
                $.ajax({
                    type: "POST",
                    url: "PostManage.aspx/PostReq",
                    data: JSON.stringify({ firstRow: firstRow }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (response) {
                        if (response.d == null) {
                            $('#TblPost').append('<tr><td colspan="6"> یافت نشد.</td></tr>');
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
                                if(c.cnt==null)
                                $('#TblPost').append('<tr style="background-color: ' + color + '" id="row_' + c.postCode + '"><td id="1col_' + c.postCode + '" style="text-align:center">' +
                                    c.RowNo + '</td>' +
                                    '<td id="2col_' + c.postCode + '" style="text-align:center">' + c.postName + '</td>' +
                                    '<td id="2col_' + c.postCode + '" style="text-align:center">' + c.raster + '</td>' +
                                   '<td class="edit-remove"><i class="edit fa fa-edit " style="cursor: pointer" id="edit' + c.postCode + '" </i></td>' +
                                   '<td class="edit-remove"><i  class="delete fa fa-times " style="cursor: pointer" id="delete' + c.postCode
                                   + '" </i></td>');
                                $(document).data("countTotal", c.cnt);
                                //alert($(document).data("totalCount") + " search");
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

        function CreateReqPost() {
            var postReq = {};
            postReq.postName = $('#txtPostName').val();
            postReq.raster = $('#txtRaster').val();
            postReq.description = $('#txtDescription').val();
          //  postReq.dateInsert = $('#txtDate').val();

            //save in DB
            try {
                $.ajax({
                    type: "POST",
                    url: "PostManage.aspx/saveReqPost",
                    data: JSON.stringify({ pr: postReq }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var result = $.parseJSON(response.d);
                        if (result.IsSuccessfull) {
                            alert("ثبت اطلاعات با موفقیت انجام شد.");
                            $("#postManage").modal("hide");
                            loadGrid('TblPost', readReferencesCountForSearch, PostReq);

                        }
                        else {
                            alert(result.Message);
                        }
                    },
                    failure: function (response) {
                        $('#lblMessage').text('ارتباط با سرور برقرار نشد-خطای شماره 7');
                    }
                })
            }

            catch (e) {
                alert("اشکال در خواندن اطلاعات");

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
            $("#postManage").modal("show");
            var postCode = id;

            $.ajax({
                type: "POST",
                url: "PostManage.aspx/PostReqSeByID",
                data: JSON.stringify({ postCode: postCode }),
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
                                $('#txtPostName').val(c.postName);
                                $('#txtRaster').val(c.raster);
                                $('#txtDescription').val(c.description);
                          //      $('#txtDate').val(c.dateInsert);


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
            var postCode = id;

            var request = {};
            request.postCode = postCode;
            request.postName = $('#txtPostName').val();
            request.raster = $('#txtRaster').val();
            request.descrition = $('#txtDescription').val();
        //    request.dateInsert = $('#txtDate').val();


            try {
                $.ajax({
                    type: "POST",
                    url: "PostManage.aspx/UpdateReqPost",
                    data: JSON.stringify({ rn: request }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var result = $.parseJSON(response.d);
                        if (result.IsSuccessfull) {
                            alert('ویرایش اطلاعات با موفقیت انجام شد');
                            $("#postManage").modal("hide");
                            loadGrid('TblPost', readReferencesCountForSearch, PostReq);
                           

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

        function SearchByPostName(firstRow) {
          
         //   $(document).data('countTotal', '0');
            $('#TblPost').empty();
            var arr = $(document).data('arrData');
            $.ajax({
                type: "POST",
                url: "PostManage.aspx/SearchByPostName",
                //data: JSON.stringify({ postName: postName }),
               
                data: JSON.stringify({ postName: arr[0], firstRow: firstRow }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (response) {
                    try {

                        if (response.d == null) {
                            $('#TblPost').append('<tr><td colspan="6"> یافت نشد.</td></tr>');
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
                                $('#TblPost').append('<tr style="background-color: ' + color + '" id="row_' + c.postCode + '"><td id="1col_' + c.postCode + '" style="text-align:center">' +
                                   c.RowNo + '</td>' +
                                   '<td id="2col_' + c.postCode + '" style="text-align:center">' + c.postName + '</td>' +
                                   '<td id="2col_' + c.postCode + '" style="text-align:center">' + c.raster + '</td>' +
                                  '<td class="edit-remove"><i class="edit fa fa-edit " style="cursor: pointer" id="edit' + c.postCode + '" </i></td>' +
                                  '<td class="edit-remove"><i  class="delete fa fa-times " style="cursor: pointer" id="delete' + c.postCode
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

        function deletePost(id) {
            var postCode = id;
            $.ajax({
                type: "POST",
                url: "PostManage.aspx/deletePost",
                data: JSON.stringify({ postCode: postCode }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    try {

                        alert("رکورد مورد نظر با موفقیت حذف شد.");
                        loadGrid('TblPost', readReferencesCountForSearch, PostReq);
                       
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
    <script >
        $(document).ready(function () {
            
            $(document).data("countTotal", 0);
            
            bindPager('RequestPager');
            var id;
            checkLenght();
            changeValid();
            loadGrid('TblPost', readReferencesCountForSearch, PostReq);

            $('#txtPostName').data('lenght', '50');
            $('#txtRaster').data('lenght', '40');

            $('#txtPost').keydown(function (e) {
                if (e.keyCode == 13) {
                    $('#btnSearchPost').focus();
                }
            });

            
            $('#btnSave').click(function () {
                if (valid('postManage') == true) {
                    CreateReqPost();
                }
            });

            $("#btnAdd").click(function () {
                emptyElements('postManage');
                $('#btnUpdate').hide();
                $('#btnSave').show();
                validBack('postManage');
            });

            $("#btnUpdate").click(function () {
                if (valid('postManage') == true) {
                    UpdateReq(id);
                }
            });

            $('#btnSearchPost').click(function () {
                var postName = $('#txtPost').val();
                var data = [postName];
                $(document).data('arrData', data);
                loadGrid('TblPost', readReferencesCountForSearch, SearchByPostName);
              
            });

            $("#TblPost").on('click', 'i.edit', function () {
                id = $(this).attr("id").replace("edit", "");
                $("#postManage").modal("show");
                validBack('postManage');
                fillModal(id);
                validBack('postManage');
                $('#btnUpdate').show();
                $('#btnSave').hide();
            });

            $("#TblPost").on('click', 'i.delete', function () {
                id = $(this).attr("id").replace("delete", "");
                var e = confirm("آیا مطمئن هستید؟");
                if (e == true) {
                    deletePost(id);
                   // loadGrid('TblPost', readReferencesCountForSearch, PostReq);
                
                }
            });
        });


    </script>
 <%--////////////////////////////////////////////////////End Script///////////////////////////////////////////////////////////////////--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel panel-primary">
        <div class="panel-title"><span><i class="fa fa-sitemap"></i>&nbsp;اطلاعات مربوط به عناوین شغلی</span>
        </div>
        <div class="panel-body panel-body-back">
                  <div class="row row-margin">
                 <div class="col-md-4 background col-md-padding">
                    <div class="form-group">
                        <div class="input-group row-fluid">
                            <span class="input-group-addon">عنوان شغلی</span>
                           <input type="text" class="form-control" id="txtPost" aria-describedby="basic-addon1" />
                            <span class="input-group-btn"><button type="button" id="btnSearchPost" class="btn btn-success"><i class="fa fa-search"></i></button></span>
                        </div>
                    </div> 
                <div class="form-group">
                      <button type="button" class="btn btn-success" data-toggle="modal" data-target="#postManage" id="btnAdd" data-target=".bs-example-modal-md""><i class="fa fa-plus"></i>&nbsp; عنوان جدید</button>
                </div>
                 </div>
                 <div class="col-md-8 back-right-box col-md-padding">
                 <table id="example" class="table table-hover table-bordered">
                    <thead>
                        <tr>
                            <th class="head-title">ردیف</th>
                            <th class="head-title"> عنوان شغلی</th>
                            <th class="head-title"> رسته</th>
                           <th class="head-title edit-remove">ویرایش</th>
                            <th class="head-title edit-remove">حذف</th>
                        </tr>
                    </thead>
                    <tbody id="TblPost">
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
     <div class="modal fade bs-example-modal-md" id="postManage" tabindex="-1" role="dialog" aria-labelledby="gridSystemModalLabel">
        <div class="modal-dialog modal-md" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="gridSystemModalLabel"><i class="fa fa-sitemap"></i>&nbsp;تعریف عنوان شغلی</h4>
                </div>
                <div class="modal-body">
                    <div class="container-fluid">
                        <div class="row col-md-padding">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <div class="input-group col-md-12">
                                        <span class="input-group-addon">نام عنوان شغلی</span>
                                        <input type="text" class="form-control  required lenght" id="txtPostName" aria-disabled="true" placeholder="" aria-describedby="basic-addon1" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="input-group col-md-12">
                                        <span class="input-group-addon" style="vertical-align: top;">رسته</span>
                                        <input type="text" id="txtRaster" class="form-control  required lenght" aria-disabled="true" placeholder="" aria-describedby="basic-addon1" />
                                    </div>
                                </div>
                                 <%--<div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-addon" style="vertical-align: top;">تاریخ ثبت</span>
                                        <input type="text" id="txtDate" class="form-control date" aria-disabled="true" aria-describedby="basic-addon1" />
                                    </div>
                                </div>--%>
                                <div class="form-group">
                                    <div class="input-group col-md-12">
                                        <span class="input-group-addon" style="vertical-align: top;">توضیحات</span>
                                        <input type="text" id="txtDescription" class="form-control" aria-disabled="true" placeholder="" aria-describedby="basic-addon1" />
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
