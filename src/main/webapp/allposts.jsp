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
<%@ page import="guestbook.Subscriber" %>



<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

 

<html>

  <head>
	<link type= "text/css" rel = "stylesheet" href="/stylesheets/main.css"/>
  </head>

 

  <body>
	<ul>
	  <li><img alt="laugh" src="images/laugh.png" height="46"></li>
	  <li><a class="active" href="#home">Home</a></li>

	  
	</ul>
 

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
<h1>Welcome to the Jokes Blog!</h1>
<p>Share your smiles!</p>

<img src="images/laughing_girl.jpg" alt="laughing girl" height="300">
<p>Hello, ${fn:escapeXml(user.nickname)}! (You can

<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>

<%

    } else {

%>

<h1>Welcome to the Jokes Blog!</h1>
<p>Share your smiles!</p>
<img src="images/laughing_girl.jpg" alt="laughing girl" height="300">

<p><a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>

to create you own blog posts!</p>

<%

    }

%>

 

<%

    ObjectifyService.register(Greeting.class);
	ObjectifyService.register(Subscriber.class);

    List<Greeting>greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
    List<Subscriber>subs = ObjectifyService.ofy().load().type(Subscriber.class).list();

    Collections.sort(greetings);
	
    boolean found = false;
    //show unsub button if subbed, show sub button if unsubbed
    if(user != null){
	    for(Subscriber sub : subs){
	    	if(sub.getEmail().equals(user.getEmail())){
	    		found = true;
	    	}
	    }
    }
    
    if(!found && user!=null){
    	%>
    	<form action="/subscribe" method="post">
    		<div><input type="submit" value="Subscribe" /></div>
    		<input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
    	</form>
    	<%
    }else{
    	for(Subscriber sub : subs){
    		pageContext.setAttribute("user_email",
    				
                    sub.getEmail());
    	}
    }
    

    if (greetings.isEmpty()) {

        %>

        <p>Blog '${fn:escapeXml(guestbookName)}' has no posts yet.</p>

        <%

    } else {

        %>

        <p>Latest posts '${fn:escapeXml(guestbookName)}'.</p>

        <%

        for (Greeting greeting: greetings) {
        	


	            pageContext.setAttribute("greeting_content",greeting.getContent());
	            pageContext.setAttribute("greeting_title", greeting.getTitle());
	            pageContext.setAttribute("greeting_Date", greeting.getDate());
	
	            
	
	            %>
	            
	            <div class="border">
	            	<blockquote> <h3> ${fn:escapeXml(greeting_title)} </h3></blockquote>
		            <blockquote>${fn:escapeXml(greeting_content)}</blockquote>
		            <blockquote>Posted on ${fn:escapeXml(greeting_Date)}</blockquote>
	          
	            <% 
	            
	            
	
	                pageContext.setAttribute("greeting_user",
	
	                                         greeting.getUser());
	
	                %>
	
	                <blockquote> By <b>${fn:escapeXml(greeting_user.nickname)}</b></blockquote>
	
	
	                <%
	
	            
	            %>
	            </div>
	            <br>
	            <%
        	}

        
		
        
        
    }
    

%>

	<form action="ofyguestbook.jsp" method="get">
		<input type="submit" value="View less Posts" name="viewall" id="viewposts">
	</form>

<% 
    if (user != null) {


%>
	<form action="createBlog.jsp" method="get">
    	<input type="submit" value="Create new Blog Post" name="Submit" id="createPost" />
	</form>
	
	

<%

    } else {


    }

%>



  </body>

</html>

