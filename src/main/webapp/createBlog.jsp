<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>

<%@ page import="java.util.Collections" %>

<%@ page import="com.google.appengine.api.users.User" %>

<%@ page import="com.google.appengine.api.users.UserService" %>

<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>


<%@ page import="com.googlecode.objectify.Objectify" %>

<%@ page import="com.googlecode.objectify.ObjectifyService" %>

<%@ page import="com.googlecode.objectify.*" %>

<%@ page import="guestbook.Greeting" %>


<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>


<head>
	<link type= "text/css" rel = "stylesheet" href="/stylesheets/main.css"/>
</head>



<body>


<%

    String guestbookName = request.getParameter("guestbookName");

    if (guestbookName == null) {

        guestbookName = "default";

    }

    pageContext.setAttribute("guestbookName", guestbookName);

    UserService userService = UserServiceFactory.getUserService();

    User user = userService.getCurrentUser();

%>





    
    <form action="/ofysign" method="post">
    

      <br>
      <h2>Create your Post!</h2>
      <br>
      <div><textarea name="title" placeholder = "Enter title" rows="1" cols="200"></textarea></div>
      
      <br>

      <div><textarea name="content" placeholder = "Enter content" rows="15" cols="200"></textarea></div>

      <div><input type="submit" value="Submit Post" /></div>

      <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>

    </form>
    
    <br>
    
    <form action="ofyguestbook.jsp" method="get">
		<input type="submit" value="Cancel" name="cancel" id="cancel">
	</form>
    



</body>












</html>




