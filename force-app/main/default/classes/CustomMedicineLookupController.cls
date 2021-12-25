public with sharing class CustomMedicineLookupController {

  public Medicine__c medicine{get;set;} // new medicineto create
  public List<Medicine__c> medicines{get;set;} // search results
  public string searchString{get;set;} // search keyword

  public CustomMedicineLookupController () {
    medicine = new Medicine__c ();
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    runSearch();  
  }

  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }

  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    medicines = performSearch(searchString);               
  } 

  // run the search and return the records found. 
  private List<Medicine__c> performSearch(string searchString) {

    String soql = 'select id, name from Medicine__c ';
    if(searchString != '' && searchString != null)
      soql = soql +  ' where name LIKE \'%' + searchString +'%\'';
    soql = soql + ' limit 25';
    System.debug(soql);
    return database.query(soql); 

  }

  // save the new account record
  public PageReference saveMedicine() {
    insert medicine ;
    // reset the account
    //medicine = new Medicine__c ();
    return null;
  }

  // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }

  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }

}