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

    if (user != null) {

      pageContext.setAttribute("user", user);

%>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can

<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>

<%

    } else {

%>

<h1>Welcome to the Blog!</h1>

<p><a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>

to create you own blog posts!</p>

<%

    }

%>

 

<%

    ObjectifyService.register(Greeting.class);
    List<Greeting>greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
    Collections.sort(greetings);


    if (greetings.isEmpty()) {

        %>

        <p>Blog '${fn:escapeXml(guestbookName)}' has no posts yet.</p>

        <%

    } else {

        %>

        <p>Latest posts '${fn:escapeXml(guestbookName)}'.</p>

        <%

        for (Greeting greeting : greetings) {

            pageContext.setAttribute("greeting_content",greeting.getContent());
            pageContext.setAttribute("greeting_title", greeting.getTitle());
            pageContext.setAttribute("greeting_Date", greeting.getDate());

            

            %>
            
            <div class="border">
            	<blockquote> <h3> ${fn:escapeXml(greeting_title)} </h3></blockquote>
	            <blockquote>${fn:escapeXml(greeting_content)}</blockquote>
	            <blockquote>Posted on ${fn:escapeXml(greeting_Date)}</blockquote>
          
            <% 
            
            if (greeting.getUser() == null) {

                %>

                <blockquote>By anonymous</blockquote>

                <%

            } else {

                pageContext.setAttribute("greeting_user",

                                         greeting.getUser());

                %>

                <blockquote> By <b>${fn:escapeXml(greeting_user.nickname)}</b></blockquote>


                <%

            }
            %>
            </div>
            <br>
            <%

        }
		
        
        
    }
    

%>

<% 
    if (user != null) {


%>
	<div><button>Create New Post</button></div>

<%

    } else {


    }

%>



  </body>

</html>

