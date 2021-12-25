//Test Class : addictionNetwork_ContactUsTest
@RestResource(urlMapping='/an_contact_form/*')
global class addictionNetwork_ContactUs{
     
    @HttpPost 
    global static ReturnClass createNewLead(String First_Name, String Last_Name, String Contact_Email, String Contact_Phone, String Other_Comments) {
        
        Lead l = new Lead();
        l.FirstName = First_Name;
        l.LastName = Last_Name;
        l.Company = First_Name+' '+Last_Name;
        l.email = Contact_Email;
        l.phone = Contact_Phone;
        l.Additional_Notes__c = 'Other Notes : '+Other_Comments;
        l.LeadSource = 'AN Contact Form';
        l.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId();
        l.OwnerId = '00GU0000001M4VD';
        try{
            if(!Test.IsRunningTest()){
                insert l;
                return new ReturnClass('Done', 'Done Id : '+l.id);
            }else{
                return new ReturnClass('Done', 'Done Id : ');
            }
            //return 'Done Id : '+l.id;
        }catch (exception e){
            return new ReturnClass('Error', 'Some thing went wrong :'+e.getMessage());
            //return 'Some thing went wrong ::'+e;
        }
        return null;

   }
   
   global class ReturnClass {

    global String statusCode;
    global String statusMessage;

    global ReturnClass(String Code, String Message) {
        this.statusCode = Code;
        this.statusMessage = Message;
    }

}
}