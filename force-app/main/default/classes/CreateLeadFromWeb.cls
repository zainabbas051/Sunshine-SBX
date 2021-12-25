public class CreateLeadFromWeb {



      private final id leadId;
    
    public String PatientfirstName {get; set;}
    public String PatientlastName {get; set;}
    Public String PatientDOB {get;set;}
    public String Email {get; set;}
    public String PhoneNumber {get; Set;}
    Public String LeadSource {get; set;}
    Public String RTSource {get; set;}    
    Public String campaignID {get; set;}
    Public String firstName {get;set;}
    Public String lastName {get;set;}
    Public String SubscriberFirstName {get;set;}
    Public String SubscriberLastName {get;set;}
    Public String SubscriberDOB {get;set;}
    Public String SubscriberSSN {get;set;}
    Public String SubscriberInsuranceProvider {get;set;}
    Public String SubscriberInsuranceID {get;set;}
    Public String SubscriberGroupID {get;set;}
    Public String SubscriberInsurancePhone {get;set;}
    Public String OtherNotes {get;set;}
    
    
    
    
    public CreateLeadFromWeb(){
        
 
    }
    
     public List<selectOption> getCampaigns() {
        List<selectOption> options = new List<selectOption>(); 

        options.add(new selectOption('', '- None -')); 

        if(LeadSource=='Monarch Shores')
        options.add(new selectOption('MS Social','MS Social')); 

        
        if(LeadSource=='Chapters Capistrano')
        options.add(new selectOption('CC Social','CC Social')); 
        
        if(LeadSource=='Willow Springs')
        options.add(new selectOption('WS Social','WS Social')); 
        
        if(LeadSource=='Mountain Springs Recovery')
        options.add(new selectOption('MSR Social','MSR Social')); 


        
        
        return options; //return the picklist options
    
}

public boolean checkRequiredFieldsSave() {
        String message1 = '';
        String message2 = '';
        String message3 = '';
        String message4 = '';
        String message5 ='';
        Boolean success = true;

       if(PatientlastName==null || PatientlastName==''||LeadSource==null || RTSource==null || campaignID==null)
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please Enter Required Fields\n'));
       
        if (PatientlastName==null || PatientlastName=='') {
            success = false;
            message1 = 'Patient`s Last Name';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message1));
        }
        
         if (PhoneNumber==null ||PhoneNumber=='') {
            success = false;
            message5 = 'Phone Number';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message5));
        }
        
        if (LeadSource==null) {
            success = false;
            message2 = 'Lead Source';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message2));
        }
        
        if (RTSource==null) {
            success = false;
            message3 = 'RT Source';
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message3));
        }
        
        if (campaignID==null) {
            success = false;
            message4 = 'Campaign';
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message4));
        }

       
      
        
        
        
        return success;
}
 

    
public Void save() {
    if(checkRequiredFieldsSave() == True){
        
    id LeadRecTypeID=[select Id from RecordType where DeveloperName = 'Monarch_Shores' AND sObjectType = 'Lead' limit 1].id;
    string AdditionalNotes='';
    if(firstName!=null || lastName!=null)
    AdditionalNotes+='Contact Name :'+firstName+' '+lastName+',';
    AdditionalNotes+=' Other Notes :'+OtherNotes;
     Lead l = new Lead(
    FirstName=PatientfirstName,
    LastName=PatientlastName,
    LeadSource=LeadSource,
    Patient_DOB__c=PatientDOB,
    Email=Email, 
    Phone=PhoneNumber,
    Incoming_Number__c=PhoneNumber,
    RT_Source__c=RTSource,
    Campaign__c=campaignID,
    Contact_first_Name__c=firstName,
    Contact_Last_Name__c=lastName,
    Subscriber_Name__c=SubscriberFirstName+' '+SubscriberLastName,
    Subscriber_First_Name__c=SubscriberFirstName,
    subscriber_Last_Name__c=SubscriberLastName,
    Subscriber_DOB_Text__c=SubscriberDOB,
    SSN_Last_4__c=SubscriberSSN,
    Insurance_Providors__c=SubscriberInsuranceProvider,
    Insurance_Policy__c=SubscriberInsuranceID,
    Group_Number__c=SubscriberGroupID,
    Insurance_Provider_Phone_Number__c=SubscriberInsurancePhone,
    RecordTypeId=LeadRecTypeID,
    Phone_Web__c='Web',
    Company=PatientfirstName+' '+PatientlastName,
    Additional_Notes__c=OtherNotes
    );
    
try{
    
    insert l;
     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Lead has been created successfully; Lead id:'+l.id));
    
    
    } 


catch(DmlException e) {


  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage()));

}

}
    
}
    
}