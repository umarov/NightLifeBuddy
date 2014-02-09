package nightlifebuddy.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashSet;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.Entity;

import nightlifebuddy.db.Util;
import nightlifebuddy.db.Genres;

@SuppressWarnings("serial")
public class GenresServlet extends BaseServlet
{

	private static final Logger logger = Logger.getLogger(GenresServlet.class.getCanonicalName());
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
	      entities = Genres.getAllGenres("Genre");
	      out.println(Util.writeJSON(entities));
	    } else {
	      Entity genre = Genres.getGenre(searchFor);
	      if (genre != null) {
	        Set<Entity> result = new HashSet<Entity>();
	        result.add(genre);
	        out.println(Util.writeJSON(result));
	      }
	    }
	  }

	  /**
	   * Create the entity and persist it.
	   */
	  protected void doPut(HttpServletRequest req, HttpServletResponse resp)
	      throws ServletException, IOException {
	    logger.log(Level.INFO, "Creating Product");
	    PrintWriter out = resp.getWriter();

	    String genre = req.getParameter("Genre");
	    try {
	      Genres.createOrUpdateGenre(genre);
	    } catch (Exception e) {
	      String msg = Util.getErrorMessage(e);
	      out.print(msg);
	    }
	  }

	  /**
	   * Delete the product entity
	   */
	  protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
	      throws ServletException, IOException {
	    String genrekey = req.getParameter("id");
	    PrintWriter out = resp.getWriter();
	    try{    	
	    	out.println(Genres.deleteGenre(genrekey));
	    } catch(Exception e) {
	    	out.println(Util.getErrorMessage(e));
	    }    
	  }

	  /**
	   * Redirect the call to doDelete or doPut method
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
