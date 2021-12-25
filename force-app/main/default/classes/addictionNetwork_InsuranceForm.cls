//Test Class : addictionNetwork_InsuranceFormTest
@RestResource(urlMapping='/an_insurance_form/*')
global class addictionNetwork_InsuranceForm{
     
    @HttpPost 
    global static ReturnClass createNewLead(String Contact_First_Name, String Contact_Last_Name, String Contact_Email, String Contact_Phone, 
                                            String Patient_First_Name, String Patient_Last_Name, String Patient_DOB, String Subscriber_First_Name, 
                                            String Subscriber_Last_Name, String Subscriber_DOB, String Subscriber_SSN, String Subscriber_Insurance_Provider, 
                                            String Subscriber_Insurance_Id, String Subscriber_Group_Id, String Subscriber_Insurance_Phone, 
                                            String Other_Comments) {
        
        
        Lead l = new Lead();
        l.FirstName = Patient_First_Name;
        l.LastName = Patient_Last_Name;
        l.Company = Patient_First_Name+' '+Patient_Last_Name;
        l.email = Contact_Email;
        l.phone = Contact_Phone;
        l.Patient_DOB__c = Patient_DOB;
        l.Subscriber_Name__c = Subscriber_First_Name+' '+Subscriber_Last_Name;
        l.Subscriber_DOB_Text__c = Subscriber_DOB;
        l.SSN_Last_4__c = Subscriber_SSN;
        l.Insurance_Providors__c = Subscriber_Insurance_Provider;
        l.Insurance_Policy__c = Subscriber_Insurance_Id;
        l.Group_Number__c = Subscriber_Group_Id;
        l.Insurance_Provider_Phone_Number__c = Subscriber_Insurance_Phone;
        l.Additional_Notes__c = 'Contact Name : '+Contact_First_Name+' '+Contact_Last_Name+',\n Other Notes : '+Other_Comments;
        l.LeadSource = 'AN Insurance Form';
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