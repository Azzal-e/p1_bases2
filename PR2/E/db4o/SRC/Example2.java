/**
 * Example extracted and adapted from http://community.versant.com/documentation/reference/db4o-8.0/java/tutorial/docs/FirstGlance.html
 * Date: March 15, 2014
 */
 
import java.io.*;
import com.db4o.*;

public class Example2 extends Util {

    final static String DB_FOLDER = "./DB-FILES";
    //final static String DB_FOLDER = System.getProperty("user.home");
    
    final static String DB_FILE = "formula1.db4o";
    
    final static String DB4OFILENAME = DB_FOLDER + "/" + DB_FILE;
	    
    public static void main(String[] args) {
        // deleteDatabase
        new File(DB4OFILENAME).delete();

        // storePilots
        ObjectContainer db=Db4oEmbedded.openFile(Db4oEmbedded
           .newConfiguration(), DB4OFILENAME);
        try {
           Pilot pilot1=new Pilot("Michael Schumacher",100);
           db.store(pilot1);
           System.out.println("Stored "+pilot1);
           Pilot pilot2=new Pilot("Rubens Barrichello",99);
           db.store(pilot2);
           System.out.println("Stored "+pilot2);
        }
        finally {
            db.close();
        }
    }
}
