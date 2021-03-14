<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <!-- 后台路径，绝对路径-->
    <!--
        /index，省略了服务器IP、端口、应用程序上下文。
        默认使用当前服务器IP、当前Tomcat端口、当前应用程序上下文
        / 就代表了当前应用程序上下文
    -->
    <jsp:forward page="/index"></jsp:forward>
</body>
</html>
