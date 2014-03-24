/**
 * Copyright 2013 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Mihai Boicu
 */

package nightlifebuddy;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

/**
 * The Filter to check and redirect parking spot administrative login.
 *
 */
public class AdminLoginFilter implements Filter {
  
	/**
	 * The filter configuration.
	 */
    private FilterConfig filterConfig;

    /**
     * Process the filter request. If an admin is not logged redirect the request to the login page.
     * If the user has no rights for the operation report invalid access. 
     */
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain)
        throws IOException, ServletException {
    	//check if it is in a current session with the client
    	if (!MySession.isAdminLogged(request)) {
    		if (response instanceof HttpServletResponse) {
    			UserService userService = UserServiceFactory.getUserService();
    			String location = null;
    			User user = userService.getCurrentUser();
    			if (request instanceof HttpServletRequest) {
    				try{
        				if (AdminProfile.getAdminProfileWithLoginID(user.getUserId()) == null)
        					location = "/createAdminProfile.jsp";
        				else
        					location = "/admin/adminHome.jsp";
    				} catch(NullPointerException e)
    				{
    					location = "/createAdminProfile.jsp";
    				}
    			} else {
    				location = "/admin/adminHome.jsp";
    			}
    			
    			String address = userService.createLoginURL(location);
    			((HttpServletResponse)response).sendRedirect(address);
    		}
    		
    	}
    	
    	

        filterChain.doFilter(request, response);
    }

    /**
     * Return the current filter configuration.
     * @return a FilterConfig with the configuration.
     */
    public FilterConfig getFilterConfig() {
        return filterConfig;
    }

    /**
     * Initialize the current filter configuration.
     */
    public void init(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
    }
  
    /**
     * Destroy the filter.
     */
    public void destroy() {}
  
}