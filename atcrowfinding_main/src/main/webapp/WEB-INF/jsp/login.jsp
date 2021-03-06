<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="keys" content="">
    <meta name="author" content="">
    <link rel="stylesheet" href="${PATH}/static/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${PATH}/static/css/font-awesome.min.css">
    <link rel="stylesheet" href="${PATH}/static/css/login.css">
    <style>

    </style>
</head>
<body>
<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="container">
        <div class="navbar-header">
            <div><a class="navbar-brand" href="index.html" style="font-size:32px;">尚筹网-创意产品众筹平台</a></div>
        </div>
    </div>
</nav>

<div class="container">

    <form class="form-signin" role="form" id="loginform" action="${PATH}/dologin" method="post">
        <h2 class="form-signin-heading"><i class="glyphicon glyphicon-log-in"></i> 用户登录</h2>

        <c:if test="${not empty SPRING_SECURITY_LAST_EXCEPTION.message}" >
            <div class="form-group has-success has-feedback">
                ${SPRING_SECURITY_LAST_EXCEPTION.message}
            </div>
        </c:if>
<%--        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" >--%>
        <div class="form-group has-success has-feedback">
            <input type="text" class="form-control" value="${param.loginacct}" id="loginacct" name="loginacct" placeholder="请输入登录账号" autofocus>
            <span class="glyphicon glyphicon-user form-control-feedback"></span>
        </div>
        <div class="form-group has-success has-feedback">
            <input type="password" class="form-control" id="userpswd" name="userpswd" placeholder="请输入登录密码" style="margin-top:10px;">
            <span class="glyphicon glyphicon-lock form-control-feedback"></span>
        </div>
        <div class="checkbox">
            <label>
                <input type="checkbox" name="remember-me"> 记住我
            </label>
            <br>
            <label>
                忘记密码
            </label>
            <label style="float:right">
                <a href="reg.html">我要注册</a>
            </label>
        </div>
        <a class="btn btn-lg btn-success btn-block" onclick="dologin()" > 登录</a>
    </form>
</div>
<script src="${PATH}/static/jquery/jquery-2.1.1.min.js"></script>
<script src="${PATH}/static/bootstrap/js/bootstrap.min.js"></script>
<script>
    function dologin() {
        $("#loginform").submit();
    }
</script>
</body>
</html>
