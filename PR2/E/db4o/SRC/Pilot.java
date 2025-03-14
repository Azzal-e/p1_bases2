/**
 * Example extracted and adapted from http://community.versant.com/documentation/reference/db4o-8.0/java/tutorial/docs/FirstGlance.html
 * Date: March 15, 2014
 */
 
public class Pilot {    

    private String name;
    private int points;  
    
    public Pilot(String name,int points) {
        this.name=name;
        this.points=points;
    }
        
    public int getPoints() {
        return points;
    }
    
    public void addPoints(int points) {
        this.points+=points;
    }
    
    public String getName() {
        return name;
    }
    
    public String toString() {
        return name+"/"+points;
    }
}
