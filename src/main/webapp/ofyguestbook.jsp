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
	  <li><a href="#news">News</a></li>
	  <li><a href="#contact">Contact</a></li>
	  	  
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
	ObjectifyService.register(Subscriber.class);

    List<Greeting>greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
    List<Subscriber>subs = ObjectifyService.ofy().load().type(Subscriber.class).list();

    Collections.sort(greetings);
	
    boolean found = false;
    Long id;
    //show unsub button if subbed, show sub button if unsubbed
    if(user != null){
	    for(Subscriber sub : subs){
	    	if(sub.getEmail().equals(user.getEmail())){
	    		found = true;
	    		id = sub.getID();
	    		pageContext.setAttribute("userid", id.toString());
	    		//TODO: check types
	    	}
	    }
    }
    
    if(!found && user!=null){
    	%>
    	<form action="/subscribe" method="post">
    		<div><input type="submit" value="Subscribe to our latest Blog posts" /></div>
    		<input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
    	</form>
    	<%
    }else if (user!= null){
		%>
    			<form action="/unsubscribe" method="post">
		    		<div><input type="submit" value="Unsubscribe from our latest Blog posts" /></div>
		    		<input type="hidden" name="userid" value="${fn:escapeXml(userid)}"/>
    			</form>		
		
		<%
    }
    

    if (greetings.isEmpty()) {

        %>

        <p>Blog '${fn:escapeXml(guestbookName)}' has no posts yet.</p>

        <%

    } else {

        %>

        <p>Latest posts '${fn:escapeXml(guestbookName)}'.</p>

        <%

        for (int i = 0; i < 5; i++) {
        	
        	if(greetings.size() > i){
        		Greeting greeting = greetings.get(i);

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
		
        
        
    }
    

%>

	<form action="allposts.jsp" method="get">
		<input type="submit" value="View All Posts" name="viewall" id="viewposts">
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

