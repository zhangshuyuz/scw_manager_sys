<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <%@ include file="/WEB-INF/jsp/common/css.jsp" %>
    <style>
        .tree li {
            list-style-type: none;
            cursor:pointer;
        }
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/jsp/common/top.jsp"></jsp:include>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/jsp/common/sidebar.jsp"></jsp:include>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">

            <div class="panel panel-default">
                <div class="panel-heading"><i class="glyphicon glyphicon-th-list"></i> 许可权限管理 <div style="float:right;cursor:pointer;" data-toggle="modal" data-target="#myModal"><i class="glyphicon glyphicon-question-sign"></i></div></div>
                <div class="panel-body">
                    <ul id="treeDemo" class="ztree"></ul>
                </div>
            </div>
        </div>
    </div>
</div>


<!-- Modal -->
<div class="modal fade" id="AddModal" tabindex="-1" role="dialog" aria-labelledby="AddModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">添加许可</h4>
            </div>
            <form id="addPermissionForm">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="addFormName">许可名称</label>
                        <input type="hidden" id="addFormPid" name="pid">
                        <input type="text" class="form-control" id="addFormName" name="name"  placeholder="请输入许可名称">
                    </div>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="addFormIcon">许可图标</label>
                        <input type="text" class="form-control" id="addFormIcon" name="icon"  placeholder="请输入许可图标">
                    </div>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="addFormTitle">许可标题</label>
                        <input type="text" class="form-control" id="addFormTitle" name="title"  placeholder="请输入许可标题">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" onclick="savePermission()">保存</button>
                </div>
            </form>
        </div>
    </div>
</div>



<!-- Modal -->
<div class="modal fade" id="UpdateModal" tabindex="-1" role="dialog" aria-labelledby="AddModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">修改许可</h4>
            </div>
            <form id="addMenuForm">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="updateFormName">许可名称</label>
                        <input type="hidden" id="addFormId" name="id">
                        <input type="text" class="form-control" id="updateFormName" name="name"  placeholder="请输入许可名称">
                    </div>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="updateFormIcon">许可图标</label>
                        <input type="text" class="form-control" id="updateFormIcon" name="icon"  placeholder="请输入许可图标">
                    </div>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="updateFormTitle">许可标题</label>
                        <input type="text" class="form-control" id="updateFormTitle" name="title"  placeholder="请输入许可标题">
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" onclick="updatePermission()">修改</button>
                </div>
            </form>
        </div>
    </div>
</div>


<%@ include file="/WEB-INF/jsp/common/javascript.jsp" %>
<script type="text/javascript">

    $(function () {  // ready事件，当前页面被浏览器加载完成时触发的事件。
        $(".list-group-item").click(function(){
            if ( $(this).find("ul") ) {
                $(this).toggleClass("tree-closed");
                if ( $(this).hasClass("tree-closed") ) {
                    $("ul", this).hide("fast");
                } else {
                    $("ul", this).show("fast");
                }
            }
        });


        initTree();
    });

    function initTree(){

        var setting = {
            data: {
                simpleData: {
                    enable: true,
                    idKey: "id",
                    pIdKey: "pid"
                },
                key: {
                    name:"title"
                }
            },
            view: {
                addDiyDom: addDiyDom,
                addHoverDom: addHoverDom, //显示按钮
                removeHoverDom: removeHoverDom //移除按钮
            }

        };

        //1.加载数据
        $.get("${PATH}/permission/loadTree",function(data){
            data.push({"id":0,"title":"系统权限","icon":"glyphicon glyphicon-asterisk"});

            console.log(data);

            $.fn.zTree.init($("#treeDemo"), setting, data);
            var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            treeObj.expandAll(true);
        });

    }


    function addDiyDom(treeId,treeNode){
        $("#"+treeNode.tId+"_ico").removeClass();
        $("#"+treeNode.tId+"_span").before('<span class="'+treeNode.icon+'"></span>');
    }

    function addHoverDom(treeId,treeNode){
        var aObj = $("#" + treeNode.tId + "_a");
        aObj.attr("href", "javascript:;");
        aObj.attr("target", "_self");
        if (treeNode.editNameFlag || $("#btnGroup"+treeNode.tId).length>0) return;
        var s = '<span id="btnGroup'+treeNode.tId+'">';
        if ( treeNode.level == 0 ) {
            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#" onclick="addBtn('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
        } else if ( treeNode.level == 1 ) {
            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  href="#" onclick="updateBtn('+treeNode.id+')" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
            if (treeNode.children.length == 0) {
                s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#" onclick="deleteBtn('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
            }
            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#" onclick="addBtn('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
        } else if ( treeNode.level == 2 ) {
            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  href="#" onclick="updateBtn('+treeNode.id+')" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#" onclick="deleteBtn('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
        }

        s += '</span>';
        aObj.after(s);
    }

    function removeHoverDom(treeId,treeNode){
        $("#btnGroup"+treeNode.tId).remove();
    }



    function addBtn(id){
        $("#addFormPid").val(id);
        $("#AddModal").modal({show:true,backdrop:'static',keyboard:false})
    }

    function savePermission(){
        var pid = $("#addFormPid").val();
        var name = $("#addFormName").val();
        var icon = $("#addFormIcon").val();
        var title = $("#addFormTitle").val();
        $.post("${PATH}/permission/doAdd",{pid:pid,name:name,icon:icon,title:title},function(result){
            if(result=="OK"){
                $("#AddModal").modal("hide");
                initTree();
            }
        });

        $("#addPermissionForm")[0].reset();
    }

    function updateBtn(id){
        $.get("${PATH}/permission/get",{id:id},function(result){
            $("#UpdateModal input[name='id']").val(result.id);
            $("#UpdateModal input[name='name']").val(result.name);
            $("#UpdateModal input[name='icon']").val(result.icon);
            $("#UpdateModal input[name='title']").val(result.title);
            $("#UpdateModal").modal({show:true,backdrop:'static',keyboard:false})
        });
    }

    function deleteBtn(id){
        layer.confirm("确定要删除这个许可吗?",{btn:["确定","取消"]},function(index){
            $.post("${PATH}/permission/doDelete",{id:id,_method:"delete"},function(result){
                if(result=="OK"){
                    initTree();
                }
            });
            layer.close(index);
        },function(index){
            layer.close(index);
        });

    }

    function updatePermission(){
        var id = $("#UpdateModal input[name='id']").val();
        var name = $("#UpdateModal input[name='name']").val();
        var icon = $("#UpdateModal input[name='icon']").val();
        var title = $("#UpdateModal input[name='title']").val();
        $.post("${PATH}/permission/doUpdate",{id:id,name:name,icon:icon,title:title},function(result){
            if(result=="OK"){
                $("#UpdateModal").modal("hide");
                initTree();
            }
        });
    }


</script>
</body>
</html>
