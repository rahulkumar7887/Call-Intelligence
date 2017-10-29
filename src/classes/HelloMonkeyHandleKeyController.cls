public class HelloMonkeyHandleKeyController {

  public String getDialNumber() {
    // if the caller is known, then find their owner's phone number
    String dialNumber;
    
    String fromPhone = ApexPages.currentPage().getParameters().get('From');
    if (fromPhone!=null) {
      // remove the country prefix for Phone field search
      if (fromPhone.startsWith('+1'))
        fromPhone = fromPhone.substring(2);
    
      // search Lead and Contact phone number fields
      List<List<SObject>> results = [FIND :fromPhone IN Phone FIELDS
          RETURNING Contact(Owner.Phone), Lead(Owner.Phone)
          LIMIT 1];
    
      // extract the owner phone if there’s a match
      if (!results[0].isEmpty()) {
        Contact r = (Contact)results[0][0];
        if (r.owner!=null && r.owner.phone!=null)
          dialNumber = r.owner.phone;
      } else if (!results[1].isEmpty()) {
        Lead r = (Lead)results[1][0];
        if (r.owner!=null && r.owner.phone!=null)
          dialNumber = r.owner.phone;
      }
    }
    return dialNumber;
  }

  // if the caller pressed anything but 1 send them back
  public String redirect() {
    if (ApexPages.currentPage().getParameters().get('Digits') != '1')
      return '/hello_monkey';
    return null;
  }
}