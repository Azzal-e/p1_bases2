/**
 * Example extracted and adapted from http://community.versant.com/documentation/reference/db4o-8.0/java/tutorial/docs/FirstGlance.html
 * Date: March 15, 2014
 */

import java.util.*;

public class Util {

      public static void listResult(List<?> result){
        System.out.println(result.size());
        for (Object o : result) {
            System.out.println(o);
        }
    }
}

