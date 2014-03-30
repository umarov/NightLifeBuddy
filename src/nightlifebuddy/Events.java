package nightlifebuddy;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Transaction;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.datastore.TransactionOptions;

/**
 * GAE ENTITY UTIL CLASS: "Events" <br>
 * PARENT: NONE <br>
 * KEY: A name long Id generated by GAE <br>
 * FEATURES: <br>
 * - "name" a {@link String} with the name of the event (e.g. "party")<br>
 * - "description" a {@link String} with the description of the event (e.g. "East End downtown restaurant serving Latin-infused cuisine in a modern,
 * 														 bar/lounge setting. Online reservations available through Open Table.") <br>
 * - "address" a {@link String} with the address of the event (e.g. "401 K St NW, Washington, DC 20005") <br>
 * AUTHORS: Alfredo Loris <br>
 */

public class Events 
{

	//
    // SECURITY
    //
    
    /**
     * Private constructor to avoid instantiation.
     */
	private Events()
	{}
	
	//
	// LIST FOR THE RESULTS OF THE SEARCH DONE
	//
	
	/**
	 * The list for the results that will be used in the index page
	 */
	private static List<Entity> result = null;
	
	//
	// KIND
	//
	
	/**
	 * The name of the Events ENTITY KIND used in GAE.
	 */
	private static final String ENTITY_KIND = "Event";
	
	
	/**
     * Return the Key for a given event name given as String. 
     * @param name A string with the eventName (a long).
     * @return the Key for this eventName. 
     */
	public static Key getKey(String name) 
	{
        Key eventKey = KeyFactory.createKey(ENTITY_KIND, name);
        return eventKey;
	}
	
	
	/**
     * Return the string ID corresponding to the key for the event.
     * @param venue The GAE Entity storing the event.
     * @return A string with the lot ID (a long).
     */
	public static String getStringID(Entity event) 
	{
        return Long.toString(event.getKey().getId());
	}
	
	//
    // NAME
    //
    
    /**
     * The property name for the <b>name</b> of the event profile.
     */
	private static final String NAME_PROPERTY = "name";
	
	/**
     * Return the name of the event. 
     * @param venue The GAE Entity storing the event.
     * @return the name of the event. 
     */
	public static String getName(Entity event) 
	{
        Object name = event.getProperty(NAME_PROPERTY);
        if (name == null) name = "";
        return (String) name;
	}
	
	/**
     * The regular expression pattern for the name of the event profile.
     */
    private static final Pattern NAME_PATTERN = Pattern.compile("\\A[A-Za-z]+([ -][A-Za-z]+){0,10}\\Z");
    
    
    /**
     * Check if the name is correct for a event. 
     * @param name The checked string. 
     * @return true is the name is correct. 
     */
    public static boolean checkName(String name) {
        Matcher matcher=NAME_PATTERN.matcher(name);
        return matcher.find();
    }
    
    
    //
    // DESCRIPTION
    //
    
    /**
     * The property name for the <b>description</b> of the event profile.
     */
	private static final String DESCRIPTION_PROPERTY = "description";
	
	/**
     * Return the description of the event. 
     * @param venue The GAE Entity storing the event.
     * @return the description of the event. 
     */
	public static String getDescription(Entity event) 
	{
        Object description = event.getProperty(DESCRIPTION_PROPERTY);
        if (description == null) description = "";
        return (String) description;
	}
    
	//
    // ADDRESS
    //
    
    /**
     * The property name for the <b>address</b> of the event profile.
     */
    private static final String ADDRESS_PROPERTY = "address";
	
    /**
     * Return the address of the event. 
     * @param venue The GAE Entity storing the event.
     * @return the address of the event. 
     */
	public static String getAddress(Entity event) 
	{
        Object address = event.getProperty(ADDRESS_PROPERTY);
        if (address == null) address = "";
        return (String) address;
	}
	
	//
    // Venue of the event
    //

    public static final String VENUE_PROPERTY = "venue";
    
    
	
	//
    // CREATE A VENUE
    //

    /**
     * Create a new event if the venueName is correct and none exists with this name.
     * @param name The name for this event.
     * @param description The description for this event.
     * @param address The address for this event.
     * @return the Entity created with this name or null if error
     */
	public static Entity createEvent(String name, String description, String address, String venueName) 
	{
        Entity event = null;
        Entity venue = null;
        
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        TransactionOptions options = TransactionOptions.Builder.withXG(true);
        Transaction txn = datastore.beginTransaction(options);
        
        try {
        
                event = getEventWithName(name);
                if (event!=null) {
                        return null;
                }
                
                event = new Entity(ENTITY_KIND);
                venue = Venues.getVenueWithName(venueName);
                event.setProperty(NAME_PROPERTY, name);
                event.setProperty(DESCRIPTION_PROPERTY, description);
                event.setProperty(ADDRESS_PROPERTY, address);
                event.setProperty(VENUE_PROPERTY, Venues.getKey(Venues.getName(venue)));
                
                datastore.put(event);           
                txn.commit();
                //Venues.addEventKey(venue, event.getKey()); This causes a nullpointer. I am commenting out. To use it, but uncomment it. 
        } finally {
            if (txn.isActive()) {
                txn.rollback();
            }
        }
        
        return event;
	}
	
	//
	// GET VENUE KEY
	//

	public static Key getVenueKey(Entity event)
	{
		Key venueKey =  (Key) event.getProperty(VENUE_PROPERTY);
		return venueKey;
	}
	
	/**
     * Get an event based on a string containing its venueName.
     * @param name The name of the event as a String.
     * @return A GAE {@link Entity} for the event or <code>null</code> if none or error.
     */
	private static Entity getEventWithName(String name) 
	{
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        return getEventWithName(datastore, name);
	}
	
	/**
     * Get a event based on a string containing its name.
     * @param datastore The current datastore instance. 
     * @param name The name of the event as a String.
     * @return A GAE {@link Entity} for the Event or <code>null</code> if none or error.
     */
	private static Entity getEventWithName(DatastoreService datastore,
			String name) 
	{
		Entity event = null;
        try {
                
                Filter hasName =
                                  new FilterPredicate(NAME_PROPERTY,
                                                      FilterOperator.EQUAL,
                                                      name);
                Query query = new Query(ENTITY_KIND);
                query.setFilter(hasName);
                List<Entity> result = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(10));
                if (result!=null && result.size()>0) {
                        event=result.get(0);
                }
        } catch (Exception e) {
                // TODO log the error
        }
        return event;
	}
	
	//
    // GET AN EVENT
    //

    /**
     * Get the venue based on a string containing its name.
     * 
     * @param name A {@link String} containing the name (a <code>long</code> number)
     * @return A GAE {@link Entity} for the Event or <code>null</code> if none or error.
     */
	public static Entity getEvent(String name) 
	{
        Entity event = null;
        try {
                DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
                Key eventKey = KeyFactory.createKey(ENTITY_KIND, name);
                event = datastore.get(eventKey);
        } catch (Exception e) {
                // TODO log the error
        }
        return event;
	}
	
	//
    // UPDATE A VENUE
    //
    
    /**
     * Update the current description of the Event.
     * @param name A string with the event name.
     * @param description The description of the event as a String.
     * @param address The address of the user as a String.
     * @return true if succeed and false otherwise
     */
	public static boolean updateEventCommand(String name, String description, String address) 
	{
        Entity event = null;
        try {
        		event = getEvent(name);
        		event.setProperty(NAME_PROPERTY, name);
        		event.setProperty(DESCRIPTION_PROPERTY, description);
        		event.setProperty(ADDRESS_PROPERTY, address);
                DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
                datastore.put(event);
        } catch (Exception e) {
                return false;
        }
        return true;
	}
	
	 //
    // DELETE AN EVENT
    //
    
    /**
     * Delete the event if not linked to anything else.
     * @param name A string with the event name.
     * @return True if succeed, false otherwise.
     */
    public static boolean deleteEventCommand(String name) {
            try {
                    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
                    datastore.delete(getKey(name));
            } catch (Exception e) {
                    return false;
            }
            return true;
    }
    
    //
    // QUERY EVENTS
    //
    
    /**
     * Return the requested number of venues (e.g. 20).  
     * @param limit The number of venues to be returned. 
     * @return A list of GAE {@link Entity entities}. 
     */
    public static List<Entity> getFirstEvents(int limit) {
            
    		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
            Query query = new Query(ENTITY_KIND);
            List<Entity> result = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(limit));
            return result;
    }
    
    
    /**
     * Assign the parameter results to the local List variable result.  
     * @param results List of entities. 
     * @return nothing. 
     */
    public static void setResults(List<Entity> results)
    {
    	result = results;
    }
    
    /**
     * Return the local List variable result.  
     * @param none. 
     * @return result List variable. 
     */
    public static List<Entity> getResults()
    {
    	return result;
    }

    /**
     * Search for the events matching the search String parameter value.
     * The query result is send to the local List variable result by 
     * using the setResults(List<Entity) method.
     * @param search A String of the search query (e.g. "Lima", "Darna"). 
     * @return nothing. 
     */
	public static void searchEventsCommand(String search) 
	{
		
        try {
                
                Filter hasSearch = new FilterPredicate(NAME_PROPERTY,
                                                      FilterOperator.EQUAL,
                                                      search);
                Query query = new Query(ENTITY_KIND);
                query.setFilter(hasSearch);
                DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
				setResults(datastore.prepare(query).asList(FetchOptions.Builder.withLimit(10)));
                
        } catch (Exception e) {
                // TODO log the error
        }
        
		
	}
	
	
}
