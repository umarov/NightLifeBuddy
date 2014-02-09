package nightlifebuddy.db;

import java.util.List;

import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;

import nightlifebuddy.db.Util;

public class Genres 
{

	/**
	   * Update the product
	   * @param name: name of the product
	   * @param description : description
	   * @return  updated product
	   */
	  public static void createOrUpdateGenre(String name) {
	    Entity genre = getGenre(name);
	  	if (genre == null)
	  		genre = new Entity("Genre", name);
	  	else 
	  		genre.setProperty("Genre", name);
	  	
	  	Util.persistEntity(genre);
	  }

	  /**
	   * Retrun all the products
	   * @param kind : of kind product
	   * @return  products
	   */
	  public static Iterable<Entity> getAllGenres(String kind) {
	    return Util.listEntities(kind, null, null);
	  }

	  /**
	   * Get product entity
	   * @param name : name of the product
	   * @return: product entity
	   */
	  public static Entity getGenre(String name) {
	  	Key key = KeyFactory.createKey("Genre",name);
	  	return Util.findEntity(key);
	  }

	  /**
	   * Get all items for a product
	   * @param name: name of the product
	   * @return list of items
	   */
	  
	  @SuppressWarnings("deprecation")
	public static List<Entity> getGenres(String name) {
	  	Query query = new Query();
	  	Key parentKey = KeyFactory.createKey("Genre", name);
	  	query.setAncestor(parentKey);
	  	query.addFilter(Entity.KEY_RESERVED_PROPERTY, Query.FilterOperator.GREATER_THAN, parentKey);
	  		List<Entity> results = Util.getDatastoreServiceInstance()
	  				.prepare(query).asList(FetchOptions.Builder.withDefaults());
	  		return results;
		}
	  
	  /**
	   * Delete product entity
	   * @param productKey: product to be deleted
	   * @return status string
	   */
	  public static String deleteGenre(String genreKey)
	  {
		  Key key = KeyFactory.createKey("Genre",genreKey);	       
		  Util.deleteEntity(key);
		  return "Product deleted successfully";
		  
	  }
	
}
