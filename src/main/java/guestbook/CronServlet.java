package guestbook;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.mail.*;
import javax.mail.internet.*;
import java.util.*;

import com.googlecode.objectify.ObjectifyService;

import guestbook.Subscriber;
import guestbook.Greeting;
import guestbook.Guestbook;
import guestbook.OfySignGuestbookServlet;
import guestbook.GuestbookServlet;

@SuppressWarnings("serial")
public class CronServlet extends HttpServlet {
	private static final Logger _logger = Logger.getLogger(CronServlet.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
		throws IOException {
		try {
			_logger.info("Cron Job has been executed");
			ObjectifyService.register(Subscriber.class);
			List<Greeting>greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
			List<Subscriber>subs = ObjectifyService.ofy().load().type(Subscriber.class).list();
			Collections.sort(greetings);
			List<Greeting> recent = new ArrayList<Greeting>();
			for(Greeting greet : greetings) {
				if(greet.getDate().getTime() > System.currentTimeMillis() - (60*60*24*1000)) {
					recent.add(greet);
				}
			}
			for(Greeting greet : recent) {
				_logger.info(greet.getTitle());
			}
			
			for(Subscriber sub : subs){
	    	    Properties props = new Properties();
						Session ses = Session.getDefaultInstance(props, null);
						
						Message msg = new MimeMessage(ses);
						
						//set message attributes
						msg.setFrom(new InternetAddress("update@blogapp39.appspotmail.com", "Blog Update"));
						msg.addRecipient(Message.RecipientType.TO, new InternetAddress(sub.getEmail()));
						msg.setSubject("New Blog Posts");
						StringBuilder sb = new StringBuilder();
						for(Greeting g : recent){
							sb.append(g.getTitle());
							sb.append("\n");
							sb.append(g.getContent());
							sb.append("\n");
							sb.append("Author: "+ g.getUser().getEmail());
							sb.append("\n");
						}
						sb.append("Thanks for subscribing.");
						msg.setText(sb.toString());
						
						Transport.send(msg); //send out the email
	    }
			
			

		}
		catch (Exception ex) {
		//Log any exceptions in your Cron Job
		}
		

		
		
	}
@Override
public void doPost(HttpServletRequest req, HttpServletResponse resp)
throws ServletException, IOException {
doGet(req, resp);
}
}