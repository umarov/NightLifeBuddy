/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Muzafar Umarov
 */

package nightlifebuddy;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * Answer to the HTTP Servlet to add a user. Redirect to the list of users. If error (e.g.
 * duplicated login ID) show error page.
 */
@SuppressWarnings("serial")
public class AddGenreServlet extends HttpServlet {
        
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                String name = req.getParameter("genreName");
                Genres.createGenre(name);
                resp.sendRedirect("/admin/allGenres.jsp");
        }
}