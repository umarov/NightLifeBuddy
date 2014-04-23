/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Muzafar Umarov
 */

package nightlifebuddy;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Search for a venue.
 */
@SuppressWarnings("serial")
public class EventsWithGenreServletJSON extends HttpServlet {
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                
                req.setCharacterEncoding("utf8");
                resp.setCharacterEncoding("utf8");
                resp.setContentType("application/json");
                PrintWriter out = resp.getWriter();
                out.print(Events.getFirstEventsJSON());
                
                
                             
        }
        
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            
        	System.out.println(req.getParameter("genreName"));
        	String search = (String) req.getParameter("genreName");
        	
            resp.setContentType("application/json");
            PrintWriter out = resp.getWriter();
            out.print(Events.searchGenres(search));
            
            
                         
    }
}
