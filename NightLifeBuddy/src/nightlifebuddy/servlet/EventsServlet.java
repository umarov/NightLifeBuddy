package nightlifebuddy.servlet;


import java.io.IOException;
import java.io.PrintWriter;

import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.Entity;




import nightlifebuddy.db.Events;
import nightlifebuddy.db.Util;

@SuppressWarnings("serial")
public class EventsServlet extends BaseServlet 
{

	private static final Logger logger = Logger.getLogger(EventsServlet.class.getCanonicalName());

	  /**
	   * Searches for the entity based on the search criteria and returns result in
	   * JSON format
	   */
	  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
	      throws ServletException, IOException {

	    super.doGet(req, resp);
	    logger.log(Level.INFO, "Obtaining Item listing");
	    String searchBy = req.getParameter("item-searchby");
	    String searchFor = req.getParameter("q");
	    PrintWriter out = resp.getWriter();
	    if (searchFor == null || searchFor.equals("")) {
	      Iterable<Entity> entities = Events.getAllEvents();
	      out.println(Util.writeJSON(entities));
	    } else if (searchBy == null || searchBy.equals("name")) {
	      Iterable<Entity> entities = Events.getEvent(searchFor);
	      out.println(Util.writeJSON(entities));
	    } else if (searchBy != null && searchBy.equals("product")) {
	      Iterable<Entity> entities = Events.getItemsForVenue("Events", searchFor);
	      out.println(Util.writeJSON(entities));
	    }
	  }

	  /**
	   * Creates entity and persists the same
	   */
	  protected void doPut(HttpServletRequest req, HttpServletResponse resp)
	      throws ServletException, IOException {
	    logger.log(Level.INFO, "Creating Event");
	    String eventName = req.getParameter("name");
	    String venueName = req.getParameter("venue");
	    String price = req.getParameter("price");
	    Events.createOrUpdateEvent(venueName, eventName, price);
	  }

	  /**
	   * Delete the entity from the datastore. Throws an exception if there are any
	   * orders associated with the item and ignores the delete action for it.
	   */
	  protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
	      throws ServletException, IOException {
		logger.log(Level.INFO, "deleting event");
	    String eventKey = req.getParameter("id");
	    PrintWriter out = resp.getWriter();
	    try{      
	      out.println(Events.deleteEvent(eventKey));
	    } catch(Exception e) {
	      out.println(Util.getErrorMessage(e));
	    }      
	  }

	  /**
	   * Redirects to delete or insert entity based on the action in the HTTP
	   * request.
	   */
	  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
	      throws ServletException, IOException {
	    String action = req.getParameter("action");
	    if (action.equalsIgnoreCase("delete")) {
	      doDelete(req, resp);
	      return;
	    } else if (action.equalsIgnoreCase("put")) {
	      doPut(req, resp);
	      return;
	    }
	  }
		
}
