public class HelloMonkeyController {

  public HelloMonkeyController() {}

  /* return TwiML */
  public String getName() {
    // if the caller is known, then greet them by name
    // otherwise, consider them just another monkey
    String name = 'Monkey';
    
    String fromPhone = ApexPages.currentPage().getParameters().get('From');
    if (fromPhone!=null) {
      // remove the country prefix for Phone field search
      if (fromPhone.startsWith('+1'))
        fromPhone = fromPhone.substring(2);
    
      // search Lead and Contact phone number fields
      List<List<SObject>> results = [FIND :fromPhone IN Phone FIELDS
          RETURNING Contact(FirstName, LastName), Lead(FirstName, LastName)
          LIMIT 1];
    
      // extract the name if there’s a match
      if (!results[0].isEmpty()) {
        Contact r = (Contact)results[0][0];
        name = r.firstName + ' ' + r.lastName;
      } else if (!results[1].isEmpty()) {
        Lead r = (Lead)results[1][0];
        name = r.firstName + ' ' + r.lastName;
      }
    }
    return name;
  }
}