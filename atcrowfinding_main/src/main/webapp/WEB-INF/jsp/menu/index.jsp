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
                <div class="panel-heading"><i class="glyphicon glyphicon-th-list"></i> 权限菜单列表 <div style="float:right;cursor:pointer;" data-toggle="modal" data-target="#myModal"><i class="glyphicon glyphicon-question-sign"></i></div></div>
                <div class="panel-body">
                    <ul id="treeDemo" class="ztree"></ul>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 修改数据 模态框 -->
<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="updateModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="ModalLabel">修改菜单</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" name="pid" value="" id="updateHiddenPid">
                <input type="hidden" name="id" value="" id="updateHiddenId">
                <div class="form-group">
                    <label for="menuName">菜单名称</label>
                    <input type="text" class="form-control" id="updateMenuName" name="menuName" placeholder="请输入菜单名称">
                </div>
                <div class="form-group">
                    <label for="menuUrl">菜单URL</label>
                    <input type="text" class="form-control" id="updateMenuUrl" name="menuUrl" placeholder="请输入菜单URL">
                </div>
                <div class="form-group">
                    <label for="menuIcon">菜单图标</label>
                    <input type="text" class="form-control" id="updateMenuIcon" name="menuIcon" placeholder="请输入菜单图标">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateMenuBtn">修改</button>
            </div>
        </div>
    </div>
</div>


<!-- 添加数据 模态框 -->
<div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">添加菜单</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" name="pid" value="" id="hiddenPid">
                <div class="form-group">
                    <label for="menuName">菜单名称</label>
                    <input type="text" class="form-control" id="menuName" name="menuName" placeholder="请输入菜单名称">
                </div>
                <div class="form-group">
                    <label for="menuUrl">菜单URL</label>
                    <input type="text" class="form-control" id="menuUrl" name="menuUrl" placeholder="请输入菜单URL">
                </div>
                <div class="form-group">
                    <label for="menuIcon">菜单图标</label>
                    <input type="text" class="form-control" id="menuIcon" name="menuIcon" placeholder="请输入菜单图标">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">添加</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/common/javascript.jsp" %>
<script type="text/javascript">
    $(function () {
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


    /*****************************节点的添加、修改、删除***************************/

    // 添加节点
    function addBtn(id) {

        $("#addModal").modal({
            show: true,
            backdrop: 'static',
            keyboard: false
        })

        $("#addModal #hiddenPid").val(id);

    }

    $(function() {

        $('#saveBtn').click(function () {

            var pid = $("#addModal #hiddenPid").val();
            var name = $("#addModal #menuName").val();
            var url = $("#addModal #menuUrl").val();
            var icon = $("#addModal #menuIcon").val();

            var json = {
                pid: pid,
                name: name,
                url: url,
                icon: icon
            }

            $.post("${PATH}/menu/doAdd", json, function (status) {

                if ("OK" == status) {
                    layer.msg("添加成功", {time: 1000}, function () {

                        $("#addModal").modal('hide');

                        $("#addModal #menuName").val("");
                        $("#addModal #menuUrl").val("");
                        $("#addModal #menuIcon").val("");
                        $("#addModal #hiddenPid").val("");

                        initTree();

                    })
                }

            })

        });

    })

    // 修改节点
    function updateBtn(id) {

        var json ={id: id};

        $.get("${PATH}/menu/getMenuById", json, function (result) {

            $("#updateModal #updateMenuName").val(result.name);
            $("#updateModal #updateMenuIcon").val(result.icon);
            $("#updateModal #updateMenuUrl").val(result.url);

            $("#updateModal #updateHiddenPid").val(result.pid);
            $("#updateModal #updateHiddenId").val(id);

            $("#updateModal").modal({
                show: true,
                backdrop: 'static',
                keyboard: false
            })

        })
    }

    $(function () {
        $("#updateMenuBtn").click(function () {

            var name = $("#updateModal #updateMenuName").val();
            var icon = $("#updateModal #updateMenuIcon").val();
            var url = $("#updateModal #updateMenuUrl").val();

            var pid = $("#updateModal #updateHiddenPid").val();
            var id = $("#updateModal #updateHiddenId").val();

            var json = {
                id: id,
                name: name,
                icon: icon,
                url: url,
                pid: pid
            }

            $.post("${PATH}/menu/doUpdate", json, function (status) {

                if ("OK" == status) {
                    layer.msg("修改成功", {time: 1000}, function () {

                        $("#updateModal").modal('hide');

                        $("#updateModal #updateMenuName").val("");
                        $("#updateModal #updateMenuUrl").val("");
                        $("#updateModal #updateMenuIcon").val("");
                        $("#updateModal #updateHiddenPid").val("");

                        initTree();

                    })
                }

            });
        });
    })

    // 删除节点
    function deleteBtn(id) {

        layer.confirm("是否确定要删除该数据？", {btn: ["确定", "取消"]}, function (index) {

                $.post("${PATH}/menu/doDelete", {id: id}, function (status) {

                    if ("OK" == status) {

                        layer.msg('删除成功', {time: 1000}, function () {
                            // 初始化当前页
                            initTree();
                        });

                    } else {

                        layer.msg("删除失败");

                    }

                })

                layer.close(index);

            },
            function (index) {

                layer.close(index);

            })

    }

    /********************************节点的添加、修改、删除完毕*****************************/

    /************************zTree展示*********************/
    function initTree() {

        var setting = {
            data: {
                simpleData: {
                    enable: true,
                    idKey: "id",
                    pIdKey: "pid"
                }
            },
            view: {
                addDiyDom: function (treeId, treeNode) {
                    $('#'+ treeNode.tId +'_ico').removeClass();
                    $('#'+ treeNode.tId +'_span').before('<span class="'+ treeNode.icon +'"></span>')
                },
                addHoverDom: function(treeId, treeNode){
                    var aObj = $("#" + treeNode.tId + "_a"); // tId = permissionTree_1, ==> $("#permissionTree_1_a")
                    aObj.attr("href", "javascript:void(0);");
                    aObj.attr("target", "_self");
                    if (treeNode.editNameFlag || $("#btnGroup"+treeNode.tId).length>0) return;
                    var s = '<span id="btnGroup'+treeNode.tId+'">';
                    if ( treeNode.level == 0 ) {
                        s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="addBtn('+ treeNode.id +')" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
                    } else if ( treeNode.level == 1 ) {
                        s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  onclick="updateBtn('+ treeNode.id +')" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
                        if (treeNode.children.length == 0) {
                            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="deleteBtn('+ treeNode.id +')" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
                        }
                        s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="addBtn('+ treeNode.id +')">&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
                    } else if ( treeNode.level == 2 ) {
                        s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  onclick="updateBtn('+ treeNode.id +')" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
                        s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="deleteBtn('+ treeNode.id +')">&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
                    }
                    s += '</span>';
                    aObj.after(s);
                },
                removeHoverDom: function(treeId, treeNode){
                    $("#btnGroup"+treeNode.tId).remove();
                }
            }
        };


        var json = {};

        $.get("${PATH}/menu/loadTree", json, function (result) {

            var zNodes = result;
            zNodes.push({"id": 0, "name": "系统菜单", "icon": "glyphicon glyphicon-th-list"});

            $.fn.zTree.init($("#treeDemo"), setting, zNodes);

            var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            treeObj.expandAll(true);

        })
    }
    /*************************zTree展示完毕***********************/
</script>
</body>
</html>
