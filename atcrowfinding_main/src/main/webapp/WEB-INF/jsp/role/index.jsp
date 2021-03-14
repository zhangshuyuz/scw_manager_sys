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
        table tbody tr:nth-child(odd){background:#F4F4F4;}
        table tbody td:nth-child(even){color:#C00;}
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/jsp/common/top.jsp"></jsp:include>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/jsp/common/sidebar.jsp"></jsp:include>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
                </div>
                <div class="panel-body">
                    <form class="form-inline" role="form" style="float:left;">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input id="condition" class="form-control has-success" type="text" placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button id="queryBtn" type="button" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
                    </form>
                    <button type="button" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
                    <button id="addBtn" type="button" class="btn btn-primary" style="float:right;"><i class="glyphicon glyphicon-plus"></i> 新增</button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr >
                                <th width="30">#</th>
                                <th width="30"><input type="checkbox"></th>
                                <th>名称</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            </tbody>
                            <tfoot>
                              <tr>
                                <td colspan="6" align="center">
                                    <ul class="pagination"></ul>
                                </td>
                              </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
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
                <h4 class="modal-title" id="myModalLabel">添加角色</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="roleName">角色名称</label>
                    <input type="text" class="form-control" id="roleName" name="name" placeholder="请输入角色名称">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">添加</button>
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
                <h4 class="modal-title" id="updateModalLabel">修改角色</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="roleName">角色名称</label>
                    <input type="text" class="form-control" id="updateRoleName" name="name" placeholder="请输入角色名称">
                    <input type="hidden" name="id" value="" id="hiddenUpdateRoleName">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn">修改</button>
            </div>
        </div>
    </div>
</div>

<!-- 设置角色权限 模态框 -->
<div class="modal fade" id="setAssignPermissionModal" tabindex="-1" role="dialog" aria-labelledby="updateModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">设置角色权限</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" name="roleId" id="roleId" value="">
                <ul id="treeDemo" class="ztree"></ul>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="setAssignPermissionBtn">分配</button>
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

        // 发起异步请求
        initData(1);

    });

    var json = {
        pageNum: 1,
    };

    var pubPageNum = 1;

    // 发起异步请求
    function initData(pageNum) {

        // 发起ajax请求，获取分页数据
        var index = -1;
        json.pageNum = pageNum;

        $.ajax({
            type: 'post',
            url: "${PATH}/role/loadData",
            data: json,
            beforeSend: function () {

                index = layer.load(0, {time: 10 * 1000});

                return true;

            },
            success: function (result) {

                layer.close(index);
                console.log(result);

                initShow(result);

                initNavg(result);

            },
            dataType: "json"
        })

        pubPageNum = pageNum;

    }

    // 展示数据
    function initShow(result) {

        $("tbody").empty();

        var list = result.list;

        $.each(list, function (i, e) {

            var tr = $('<tr></tr>');
            tr.append('<td>'+ (i + 1) +'</td>');
            tr.append('<td><input type="checkbox"></td>');
            tr.append('<td>'+ e.name +'</td>');

            var td = $('<td></td>');
            td.append('<button type="button" roleId="'+ e.id +'" class="btn btn-success btn-xs setAssignPermissionClass" ><i class=" glyphicon glyphicon-check"></i></button>');
            td.append('<button type="button" roleId="'+ e.id +'" class="btn btn-primary btn-xs updateClass"><i class=" glyphicon glyphicon-pencil"></i></button>');
            td.append('<button type="button" roleId="'+ e.id +'" class="btn btn-danger btn-xs deleteClass"><i class=" glyphicon glyphicon-remove"></i></button>');

            tr.append(td);

            $('tbody').append(tr);

        })
    }

    // 展示分页条
    function initNavg(result) {

        $(".pagination").empty();

        var navigatepageNums = result.navigatepageNums;

        if (result.isFirstPage) {
            $(".pagination").append($('<li class="disabled"><a href="#">上一页</a></li>'));
        } else {
            $(".pagination").append($('<li><a onclick="initData('+ (result.pageNum - 1) +');">上一页</a></li>'))
        }

        $.each(navigatepageNums, function (i, e) {

            if (e == result.pageNum) {
                $(".pagination").append($('<li class="active"><a href="#">'+ e +' <span class="sr-only">(current)</span></a></li>'));
            } else {
                $(".pagination").append($('<li><a onclick="initData('+ e +');">'+ e +'</a></li>'));
            }


        });

        if (result.isLastPage) {
            $(".pagination").append($('<li class="disabled"><a href="#">下一页</a></li>'));
        } else {
            $(".pagination").append($('<li><a onclick="initData('+ (result.pageNum + 1) +');">下一页</a></li>'));
        }
    }

    $(function () {

        // 模糊查询
        $("#queryBtn").click(function () {
            var condition = $('#condition').val();
            json.condition = condition;

            initData(1);
        })

        // 添加数据开启
        $("#addBtn").click(function () {
            $("#addModal").modal({
                show: true,
                backdrop: 'static',
                keyboard: false
            })
        });

        $('#saveBtn').click(function () {

            var name = $('#addModal #roleName').val();
            var json = {
                name: name
            };

            $.ajax({
                type: "post",
                url: "${PATH}/role/doAdd",
                data: json,
                beforeSend: function () {

                    return true;

                },
                success: function (status) {

                    if ("OK" == status) {
                        layer.msg("保存成功", {time: 1000}, function () {
                            // 成功，清除文本框数据，自动关闭模态框，跳转到最后一页
                            $('#addModal').modal('hide');
                            $('#addModal #roleName').val("");

                            initData(65535);
                        });
                    } else if ("403" == status){
                        layer.msg("没有权限访问该功能");
                    } else {
                        layer.msg("保存失败");
                    }

                },

            });
        });
        // 添加数据结束

        // 修改数据开始
        $('tbody').on('click', '.updateClass', function () {
            var roleId = $(this).attr('roleId');

            // 通过异步的get请求，获取到要修改的角色信息
            $.get("${PATH}/role/getRoleById", {id: roleId}, function (result) {
                $("#updateModal").modal({
                    show: true,
                    backdrop: 'static',
                    keyboard: false
                })

                $('#updateModal #updateRoleName').val(result.name);
                $('#updateModal #hiddenUpdateRoleName').val(result.id);

            });

            // 通过异步post请求，提交修改后的角色信息
            $('#updateBtn').click(function () {
                var name = $('#updateModal #updateRoleName').val();
                var id = $('#updateModal #hiddenUpdateRoleName').val();

                $.post("${PATH}/role/doUpdate", {id: id, name: name}, function (status) {
                    if ("OK" == status) {
                        layer.msg("修改成功", {time: 1000}, function () {
                            // 修改成功，关闭模态框，重新局部刷新当前页
                            $('#updateModal').modal('hide');

                        });
                        initData(pubPageNum);
                    } else {
                        layer.msg("修改失败");
                    }
                });
            })
        })

        // 修改数据结束

        // 删除开始

        $('tbody').on('click', '.deleteClass', function () {

            var roleId = $(this).attr('roleId');

            layer.confirm('您确定要删除该数据吗？', {btn: ['确定', '取消']}, function (index) {

                $.post('${PATH}/role/doDelete', {id: roleId}, function (status) {
                    if ('OK' == status) {
                        layer.msg('删除成功', {time: 1000}, function () {
                            // 初始化当前页
                            initData(pubPageNum);
                        });
                    } else {
                        layer.msg('删除失败');
                    }
                })

                layer.close(index);

            }, function (index) {

                layer.close(index);

            })

        })

        // 删除结束

    })

    // 设置权限开始

    // 初始化树开始
    function initTree(roleId) {
        var setting = {
            check: {
              enable: true
            },
            data: {
                simpleData: {
                    enable: true,
                    idKey: "id",
                    pIdKey: "pid"
                },
                key: {
                    url: "xUrl",
                    name:"title"
                }
            },
            view: {
                addDiyDom: addDiyDom
            }

        };

        // 1.加载数据
        $.get("${PATH}/permission/loadTree", {}, function(data){
            // data.push({"id":0,"title":"系统权限","icon":"glyphicon glyphicon-asterisk"});

            // console.log(data);

            $.fn.zTree.init($("#treeDemo"), setting, data);
            var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            treeObj.expandAll(true);

            // 2. 回显已经分配的许可
            // 因为加载树和回显都是异步请求，因此如果同时发送请求无法保证谁先返回。
            // 但是因为要先加载树然后才回显，因此我们要将回显的请求放在加载树请求的回调函数中，保证加载顺序

            $.get("${PATH}/permission/listPermissionIdByRoleId", {roleId: roleId}, function(data){


                $.each(data, function (i, e) {
                    var permissionId = e;
                    var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
                    var node = treeObj.getNodeByParam("id", permissionId, null);
                    treeObj.checkNode(node, true, false, false);
                })

            });

        });


        // 3. 设置roleId
        $("#setAssignPermissionModal #roleId").val(roleId);

    }


    function addDiyDom(treeId,treeNode){
        $("#"+treeNode.tId+"_ico").removeClass();
        $("#"+treeNode.tId+"_span").before('<span class="'+treeNode.icon+'"></span>');
    }

    // 初始化树结束


    $(function () {
        $("tbody").on('click', '.setAssignPermissionClass', function () {

            $("#setAssignPermissionModal").modal({
                show: true,
                backdrop: 'static',
                keyboard: false
            })

            var roleId = $(this).attr("roleId");
            initTree(roleId);

        })

        $("#setAssignPermissionBtn").click(function () {

            var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            var nodes = treeObj.getCheckedNodes(true);

            var json = {};
            json.roleId = $("#setAssignPermissionModal #roleId").val();
            $.each(nodes, function (i, e) {

                var permissionId = e.id;
                json['ids['+ i +']'] = permissionId;

            })

            $.post("${PATH}/role/doAssignPermissionToRole", json, function (status) {

                if ("OK" == status) {
                    layer.msg("分配成功", {icon: 6, time: 1000})
                } else {
                    layer.msg("分配失败")
                }

                $("#setAssignPermissionModal").modal('hide');


            })

        });

    })

</script>
</body>
</html>

