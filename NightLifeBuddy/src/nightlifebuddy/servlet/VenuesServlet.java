package nightlifebuddy.servlet;


import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashSet;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.Entity;

import nightlifebuddy.db.Util;
import nightlifebuddy.db.Venues;

/**
 * This servlet responds to the request corresponding to product entities. The servlet
 * manages the Product Entity
 * 
 * 
 */
@SuppressWarnings("serial")
public class VenuesServlet extends BaseServlet {

  private static final Logger logger = Logger.getLogger(VenuesServlet.class.getCanonicalName());
  /**
   * Get the entities in JSON format.
   */

  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
	super.doGet(req, resp);
    logger.log(Level.INFO, "Obtaining product listing");
    String searchFor = req.getParameter("q");
    PrintWriter out = resp.getWriter();
    Iterable<Entity> entities = null;
    if (searchFor == null || searchFor.equals("") || searchFor == "*") {
      entities = Venues.getAllVenues("Venue");
      out.println(Util.writeResults(entities));
    } else {
      Entity venue = Venues.getVenue(searchFor);
      
      if (venue != null) {
        Set<Entity> result = new HashSet<Entity>();
        result.add(venue);
        out.println(Util.writeResults(result));
      }
    }
	RequestDispatcher rd = getServletContext().getRequestDispatcher("/results.html");
	rd.forward(req, resp);
  }

  /**
   * Create the entity and persist it.
   */
  protected void doPut(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    logger.log(Level.INFO, "Creating Product");
    PrintWriter out = resp.getWriter();

    String category = req.getParameter("name");
    String description = req.getParameter("description");
    String address = req.getParameter("address");
    try {
      Venues.createOrUpdateVenues(category, description, address);
    } catch (Exception e) {
      String msg = Util.getErrorMessage(e);
      out.print(msg);
    }
    RequestDispatcher rd = getServletContext().getRequestDispatcher("/index.html");
	rd.forward(req, resp);
  }

  /**
   * Delete the product entity
   */
  protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    String venuekey = req.getParameter("id");
    PrintWriter out = resp.getWriter();
    try{    	
    	out.println(Venues.deleteVenues(venuekey));
    } catch(Exception e) {
    	out.println(Util.getErrorMessage(e));
    }    
  }

  /**
   * Redirect the call to doDelete or doPut method
   */
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    
	  
	  
	 logger.log(Level.INFO, "Creating Product");
	    PrintWriter out = resp.getWriter();

	    String category = req.getParameter("name");
	    String description = req.getParameter("description");
	    String address = req.getParameter("address");
	    try {
	      Venues.createOrUpdateVenues(category, description, address);
	    } catch (Exception e) {
	      String msg = Util.getErrorMessage(e);
	      out.print(msg);
	    }
	    RequestDispatcher rd = getServletContext().getRequestDispatcher("/index.html");
		rd.forward(req, resp);
    
  }

}