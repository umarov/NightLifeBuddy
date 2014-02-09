package nightlifebuddy.db;

import java.util.List;

import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;

import nightlifebuddy.db.Util;



public class Venues 
{
	
	/**
	   * Update the product
	   * @param name: name of the product
	   * @param description : description
	   * @return  updated product
	   */
	  public static void createOrUpdateVenues(String name, String description, String address) {
	    Entity venue = getVenue(name);
	  	if (venue == null) {
	  		venue = new Entity("Venue", name);
	  		venue.setProperty("description", description);
	  		venue.setProperty("address", address);
	  	} else {
	  		venue.setProperty("description", description);
	  		venue.setProperty("address", address);
	  	}
	  	Util.persistEntity(venue);
	  }

	  /**
	   * Retrun all the products
	   * @param kind : of kind product
	   * @return  products
	   */
	  public static Iterable<Entity> getAllVenues(String kind) {
	    return Util.listEntities(kind, null, null);
	  }

	  /**
	   * Get product entity
	   * @param name : name of the product
	   * @return: product entity
	   */
	  public static Entity getVenue(String name) {
	  	Key key = KeyFactory.createKey("Venue",name);
	  	return Util.findEntity(key);
	  }

	  /**
	   * Get all items for a product
	   * @param name: name of the product
	   * @return list of items
	   */
	  
	  @SuppressWarnings("deprecation")
	public static List<Entity> getEvents(String name) {
	  	Query query = new Query();
	  	Key parentKey = KeyFactory.createKey("Venue", name);
	  	query.setAncestor(parentKey);
	  	query.addFilter(Entity.KEY_RESERVED_PROPERTY, Query.FilterOperator.GREATER_THAN, parentKey);
	  		List<Entity> results = Util.getDatastoreServiceInstance()
	  				.prepare(query).asList(FetchOptions.Builder.withDefaults());
	  		return results;
		}
	  
	  /**
	   * Get all items for a product
	   * @param name: name of the product
	   * @return list of items
	   */
	  
	  @SuppressWarnings("deprecation")
	public static List<Entity> getGenres(String name) {
	  	Query query = new Query();
	  	Key parentKey = KeyFactory.createKey("Venue", name);
	  	query.setAncestor(parentKey);
	  	query.addFilter(Entity.KEY_RESERVED_PROPERTY, Query.FilterOperator.GREATER_THAN, parentKey);
	  		List<Entity> results = Util.getDatastoreServiceInstance()
	  				.prepare(query).asList(FetchOptions.Builder.withDefaults());
	  		return results;
		}
	  
	  /**
	   * Delete product entity
	   * @param venueKey: product to be deleted
	   * @return status string
	   */
	  public static String deleteVenues(String venueKey)
	  {
		  Key key = KeyFactory.createKey("Product",venueKey);	   
		  
		  List<Entity> events = getEvents(venueKey);
		  if (!events.isEmpty()){
		      return "Cannot delete, as there are items associated with this product.";	      
		    }	    
		  Util.deleteEntity(key);
		  return "Product deleted successfully";
		  
	  }
	
}
