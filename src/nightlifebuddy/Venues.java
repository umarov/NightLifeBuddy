package nightlifebuddy;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.google.appengine.api.datastore.BaseDatastoreService;
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
import com.google.appengine.labs.repackaged.org.json.JSONException;
import com.google.appengine.labs.repackaged.org.json.JSONObject;
import com.google.gson.*;

/**
 * GAE ENTITY UTIL CLASS: "Venue" <br>
 * PARENT: NONE <br>
 * KEY: A name long Id generated by GAE <br>
 * FEATURES: <br>
 * - "name" a {@link String} with the name of the venue (e.g. "Lima")<br>
 * - "description" a {@link String} with the description of the venue (e.g. "East End downtown restaurant serving Latin-infused cuisine in a modern,
 * 														 bar/lounge setting. Online reservations available through Open Table.") <br>
 * - "address" a {@link String} with the address of the venue (e.g. "401 K St NW, Washington, DC 20005") <br>
 * AUTHORS: Muzafar Umarov <br>
 */

public class Venues
{

	//
    // SECURITY
    //
    
    /**
     * Private constructor to avoid instantiation.
     */
	private Venues()
	{}
	
	//
	// LIST FOR THE RESULTS OF THE SEARCH DONE
	//
	
	/**
	 * The list for the results that will be used in the index page
	 */
	private static List<Entity> result;
	
	//
	// KIND
	//
	
	/**
	 * The name of the Venue ENTITY KIND used in GAE.
	 */
	private static final String ENTITY_KIND = "Venue";
	
	
	/**
     * Return the Key for a given venue name given as String. 
     * @param name A string with the venueName (a long).
     * @return the Key for this venueName. 
     */
	public static Key getKey(String name) 
	{
        Key venueKey = KeyFactory.createKey(ENTITY_KIND, name);
        return venueKey;
	}
	
	
	/**
     * Return the string ID corresponding to the key for the venue.
     * @param venue The GAE Entity storing the venue.
     * @return A string with the lot ID (a long).
     */
	public static String getStringID(Entity venue) 
	{
        return Long.toString(venue.getKey().getId());
	}
	
	//
    // NAME
    //
    
    /**
     * The property name for the <b>name</b> of the venue profile.
     */
	private static final String NAME_PROPERTY = "name";
	
	/**
     * Return the name of the venue. 
     * @param venue The GAE Entity storing the venue.
     * @return the name of the venue. 
     */
	public static String getName(Entity venue) 
	{
        Object name = "";
        		
        if (venue == null) 
        	name = "";
        else
        	name = venue.getProperty(NAME_PROPERTY);
        return (String) name;
	}
	
	/**
     * The regular expression pattern for the name of the venue profile.
     */
    private static final Pattern NAME_PATTERN = Pattern.compile("\\A[A-Za-z]+([ -][A-Za-z]+){0,10}\\Z");
    
    
    /**
     * Check if the name is correct for a venue. 
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
     * The property name for the <b>description</b> of the venue profile.
     */
	private static final String DESCRIPTION_PROPERTY = "description";
	
	/**
     * Return the description of the venue. 
     * @param venue The GAE Entity storing the venue.
     * @return the description of the venue. 
     */
	public static String getDescription(Entity venue) 
	{
        Object description = venue.getProperty(DESCRIPTION_PROPERTY);
        if (description == null) description = "";
        return (String) description;
	}
    
	//
    // ADDRESS
    //
    
    /**
     * The property name for the <b>address</b> of the venue profile.
     */
    private static final String ADDRESS_PROPERTY = "address";
	
    /**
     * Return the address of the venue. 
     * @param venue The GAE Entity storing the venue.
     * @return the address of the venue. 
     */
	public static String getAddress(Entity venue) 
	{
        Object address = venue.getProperty(ADDRESS_PROPERTY);
        if (address == null) address = "";
        return (String) address;
	}
	
	//
	// AGE REQUIREMENT
	//
	
	private static final String AGE_REQ_PROPERTY = "ageRequirement";
	
	public static int getAgeRequirement(Entity venue)
	{
		int ageReq = 0;
		if (((Number)venue.getProperty(AGE_REQ_PROPERTY)) == null)
		{
			ageReq = 21;
			venue.setProperty(AGE_REQ_PROPERTY, ageReq);
		} else
			ageReq = ((Number)venue.getProperty(AGE_REQ_PROPERTY)).intValue();
		return (int) ageReq;
	}
	
	//
	// Hours
	//
	
	private static final String VENUE_HOURS_PROPERTY = "venueHours";
	
	public static String getVenueHours(Entity venue)
	{
		Object hours = venue.getProperty(VENUE_HOURS_PROPERTY);
		if (hours == null)
		{
			hours = "10:00pm to 3:00am";
			venue.setProperty(VENUE_HOURS_PROPERTY, hours);
		}
		return (String) hours;
	}
	
	//
    // CREATE A VENUE
    //

    /**
     * Create a new venue if the venueName is correct and none exists with this name.
     * @param name The name for this venue.
     * @param description The description for this venue.
     * @param address The address for this venue.
     * @return the Entity created with this name or null if error
     */
	public static Entity createVenue(String name, String description, String address, int age, String hours) 
	{
        Entity venue = null;
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        Transaction txn = datastore.beginTransaction();
        try {
        
                venue = getVenueWithName(name);
                if (venue!=null) {
                        return null;
                }
                List<Key> allEvents = new ArrayList<Key>();
        	
                venue = new Entity(ENTITY_KIND);
                venue.setProperty(NAME_PROPERTY, name);
                venue.setProperty(DESCRIPTION_PROPERTY, description);
                venue.setProperty(ADDRESS_PROPERTY, address);
                venue.setProperty(AGE_REQ_PROPERTY, age);
                venue.setProperty(VENUE_HOURS_PROPERTY, hours);
                venue.setUnindexedProperty("events", allEvents);
                datastore.put(venue);

            txn.commit();
        } finally {
            if (txn.isActive()) {
                txn.rollback();
            }
        }
        
        return venue;
	}

	
	/**
     * Get an venue based on a string containing its venueName.
     * @param name The name of the venue as a String.
     * @return A GAE {@link Entity} for the venue or <code>null</code> if none or error.
     */
	public static Entity getVenueWithName(String name) 
	{
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        return getVenueWithName(datastore, name);
	}
	
	/**
     * Get a venue based on a string containing its name.
     * @param datastore The current datastore instance. 
     * @param name The name of the venue as a String.
     * @return A GAE {@link Entity} for the Venue or <code>null</code> if none or error.
     */
	public static Entity getVenueWithName(DatastoreService datastore,
			String name) 
	{
		Entity venue = null;
        try {                
                Filter hasName = new FilterPredicate(NAME_PROPERTY,
                                                      FilterOperator.EQUAL,
                                                      name);
                Query query = new Query(ENTITY_KIND);
                query.setFilter(hasName);
                List<Entity> result = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(10));
                if (result!=null && result.size()>0) {
                        venue=result.get(0);
                }
        } catch (Exception e) {
                // TODO log the error
        }
        return venue;
	}
	
	//ArrayList of all the event Key's in this venue
	
	public static final String EVENTS_PROPERTY = "events";
	
	/**
     * Add a whole array list to 
     * @param datastore The current datastore instance. 
     * @param name The name of the venue as a String.
     * @return A GAE {@link Entity} for the Venue or <code>null</code> if none or error.
     */
	
	public static List<Key> addEventKeys(Entity venue, List<Key> keys)
	{
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		List<Key> allEvents = new ArrayList<Key>();
		for(Key key : keys)
		{
			allEvents.add(key);
		}
		venue.setProperty("events", allEvents);
		
		datastore.put(venue);
		return allEvents;
	}
	
	/**
     * Add the key of the event to the venue. 
     * @param venue The venue instance where an event being hosted on. 
     * @param key The key of the event which is being hosted on this venue.
     * @return return list of all the events in this venue.
     */
	
	public static List<Key> addEventKey(Entity venue, Key key)
	{
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		@SuppressWarnings("unchecked")
		List<Key> allEvents = (List<Key>) (venue.getProperty(EVENTS_PROPERTY));
		
		allEvents.add(key);
		venue.setProperty("events", allEvents);
		
		datastore.put(venue);
		return allEvents;
	}
	
	
	
	
	//
    // GET A VENUE
    //

    /**
     * Get the venue based on a string containing its name.
     * 
     * @param name A {@link String} containing the name (a <code>long</code> number)
     * @return A GAE {@link Entity} for the Venue or <code>null</code> if none or error.
     */
	public static Entity getVenue(Key key) 
	{
        Entity venue = null;
        try {
                DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
                venue = datastore.get(key);
        } catch (Exception e) {
                // TODO log the error
        }
        return venue;
	}
	
	//
    // UPDATE A VENUE
    //
    
    /**
     * Update the current description of the Venue.
     * @param name A string with the venue name.
     * @param description The description of the venue as a String.
     * @param address The address of the user as a String.
     * @return true if succeed and false otherwise
     */
	public static boolean updateVenueCommand(String oldName, String name, String description, String address, int age, String hours) 
	{
        Entity venue = null;
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        Transaction txn = datastore.beginTransaction();
        try {
        		venue = getVenueWithName(oldName);
        		venue.setProperty(NAME_PROPERTY, name);
        		venue.setProperty(DESCRIPTION_PROPERTY, description);
        		venue.setProperty(ADDRESS_PROPERTY, address);
        		venue.setProperty(AGE_REQ_PROPERTY, age);
        		venue.setProperty(VENUE_HOURS_PROPERTY, hours);
                datastore = DatastoreServiceFactory.getDatastoreService();
                datastore.put(venue);
                txn.commit();
        } catch (Exception e) {
                return false;
        } finally {
            if (txn.isActive()) {
                txn.rollback();
            }
        }
        return true;
	}
	
	 //
    // DELETE A VENUE
    //
    
    /**
     * Delete the venue if not linked to anything else.
     * @param name A string with the venue name.
     * @return True if succeed, false otherwise.
     */
    public static boolean deleteVenueCommand(String name) {
            try {
                    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
                    datastore.delete(getKey(name));
            } catch (Exception e) {
                    return false;
            }
            return true;
    }
    
    //
    // QUERY VENUES
    //
    
    /**
     * Return the requested number of venues (e.g. 20).  
     * @param limit The number of venues to be returned. 
     * @return A list of GAE {@link Entity entities}. 
     */
    public static List<Entity> getFirstVenues(int limit) {
            
    		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
            Query query = new Query(ENTITY_KIND);
            List<Entity> result = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(limit));
            return result;
    }
    
    /**
     * Get a venue based on a key.
     * @param key The key of the venue that's being searched on. 
     * @return A GAE {@link Entity} for the Venue or <code>null</code> if none or error.
     */
    
    public static Entity getVenueByKey(Key key)
    {
    	Entity venue = null;
    	Filter hasVenue = new FilterPredicate(NAME_PROPERTY,
                FilterOperator.EQUAL,
                key);
    	Query query = new Query(ENTITY_KIND);
    	query.setFilter(hasVenue);
    	BaseDatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		venue = datastore .prepare(query).asSingleEntity();
		return venue;
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
     * Return the local List variable result in JSON format
     * @param none.
     * @return String of results in JSON 
     */
    public static JSONObject getFirstVenuesJSON()
    {
    	List<Entity> firstVenues = getFirstVenues(20);
    	JSONObject allVenues = new JSONObject();
    	try {
			allVenues.put("name", getAllVenueNames(firstVenues));
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return allVenues;
    }
    
    public static List<String> getAllVenueNames(List<Entity> firstVenues)
    {
    	List<String> venueNames = new ArrayList<String>();
    	for (int i = 0; i < firstVenues.size(); i++)
    	{
    		venueNames.add((String)firstVenues.get(i).getProperty(NAME_PROPERTY));
    	}
    	return venueNames;
    }
    
    

    /**
     * Search for the venues matching the search String parameter value.
     * The query result is send to the local List variable result by 
     * using the setResults(List<Entity) method.
     * @param search A String of the search query (e.g. "Lima", "Darna"). 
     * @return nothing. 
     */
	public static void searchVenueCommand(String search) 
	{
		result = null;
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
