<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
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
            <ol class="breadcrumb">
                <li><a href="#">首页</a></li>
                <li><a href="#">数据列表</a></li>
                <li class="active">分配角色</li>
            </ol>
            <div class="panel panel-default">
                <div class="panel-body">
                    <form role="form" class="form-inline">
                        <div class="form-group">
                            <label>未分配角色列表</label><br>
                            <select class="form-control" multiple size="10" style="width:200px;overflow-y:auto;" id="assignSelect">
                                <c:forEach items="${unAssignList}" var="assign">
                                    <option value="${assign.id}">${assign.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <ul>
                                <li class="btn btn-default glyphicon glyphicon-chevron-right" id="leftToRightBtn"></li>
                                <br>
                                <li class="btn btn-default glyphicon glyphicon-chevron-left" style="margin-top:20px;" id="rightToLeftBth"></li>
                            </ul>
                        </div>
                        <div class="form-group" style="margin-left:40px;">
                            <label>已分配角色列表</label><br>
                            <select class="form-control" multiple size="10" style="width:200px;overflow-y:auto;" id="unAssignSelect">
                                <c:forEach items="${assignList}" var="assign">
                                <option value="${assign.id}">${assign.name}</option>
                                </c:forEach>
                        </div>
                    </form>
                </div>
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

        // 从左往右分配
        $("#leftToRightBtn").click(function () {

            var assignSelected = $("#assignSelect option:selected");

            // 判断是否选中元素
            if (assignSelected.length == 0) {
                layer.msg("请选择角色后，再进行分配", {icon: 5, time: 1000})
                return false;
            } else {

                var str = 'adminId=${param.id}';
                $.each(assignSelected, function (i, e) {
                    var roleId = e.value;
                    str = str + '&id=' + roleId;
                })

                $.post("${PATH}/admin/doAssign", str, function (status) {

                    if ("OK" == status) {

                        layer.msg("成功", {icon: 6, time: 1000}, function (){

                            // 左侧选中元素移动到右侧
                            $("#unAssignSelect").append(assignSelected.clone());
                            assignSelected.remove();

                        });

                    } else {
                        layer.msg("失败", {icon: 5, time: 1000});
                    }
                })

            }

        });

        // 从右往左分配
        $("#rightToLeftBth").click(function () {

            var unAssignSelected = $("#unAssignSelect option:selected");

            // 判断是否选中元素
            if (unAssignSelected.length == 0) {
                layer.msg("请选择已分配角色后，再取消分配", {icon: 5, time: 1000})
                return false;
            } else {

                var str = 'adminId=${param.id}';
                $.each(unAssignSelected, function (i, e) {
                    var roleId = e.value;
                    str = str + '&id=' + roleId;
                })

                $.post("${PATH}/admin/doUnAssign", str, function (status) {

                    if ("OK" == status) {

                        layer.msg("成功", {icon: 6, time: 1000}, function (){

                            // 左侧选中元素移动到右侧
                            $("#assignSelect").append(unAssignSelected.clone());
                            unAssignSelected.remove();

                        });

                    } else {
                        layer.msg("失败", {icon: 5, time: 1000});
                    }
                })

            }
        });

    });
</script>
</body>
</html>

