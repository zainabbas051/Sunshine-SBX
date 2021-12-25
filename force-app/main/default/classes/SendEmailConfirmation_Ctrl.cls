public  class SendEmailConfirmation_Ctrl {

   public string ppName{get;set;}
   public string referenceId {get;set;}
   public Payment_Plan_Line_Items__c pp {get;set;}
  
   
    public void updateRecord(){
    
         string recordId = ApexPages.currentPage().getParameters().get('Id') ;
          
           pp = [select id,Status__c,Collection_Reference_ID__c,Date_of_Cash_Collection__c,Sunshine_Center__c,
                                          Email_Address_of_Person_Responsible__c,Name,Payment_Plan__r.Name,Amount_For_Collection__c,Closed_Date__c,Payment_Plan__r.Opportunity__r.Name,
                                          Payment_Plan__r.Opportunity__r.Sunshine_Center__r.Name 
                                          from Payment_Plan_Line_Items__c where id=: recordId];
          if(pp.Status__c == 'Cash Collected'){
              return;
          }                               
          referenceId = String.valueOf(pp.id);
          pp.Status__c = 'Cash Collected';
          pp.Date_of_Cash_Collection__c=System.Now();
          pp.Collection_Reference_ID__c=String.valueOf(pp.id);
          pp.Closed_Date__c  = Date.Today();
          update pp;
          sendEmailWithPdfAttachment(recordId);
    
    }
    
    @Future(callout=true)
    private static void sendEmailWithPdfAttachment(string aRecordId){
        
     
        //PageReference ref = page.SendEmailConfimationPdf;
        PageReference ref = new PageReference(Label.SiteUrl + 'SendEmailConfimationPdf');
        List<String> EmailIds = new List<string>();
        List<String> ccEmailIds = new List<string>();
      
        ref.getParameters().put('Id',aRecordId);
         Blob b =Blob.valueOf('test string');
        if(!test.isRunningTest()){
            b = ref.getContentAsPDF();
        }
       
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where Address = 'contact.admissions@sunshinebh.com' limit 1];
        Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
        efa1.setFileName('PaymentPlanConfirmantion'+String.valueOf(DateTime.now())+'.pdf');
        efa1.setBody(b);

        String addresses;
        Payment_Plan_Line_Items__c ppl = [select id,Sunshine_Center__c, Email_Address_of_Person_Responsible__c, Payment_Plan__r.Opportunity__r.AccountId from Payment_Plan_Line_Items__c where id =: aRecordId limit 1];
        Contact con = [Select id from Contact where AccountId =: ppl.Payment_Plan__r.Opportunity__r.AccountId limit 1];
        EmailTemplate templateId = [Select id from EmailTemplate where name = 'Cash Collection Confirmation - Email Template Rule 2'];
          EmailIds.add(ppl.Email_Address_of_Person_Responsible__c);
         if(ppl.Sunshine_Center__c.indexOf('Monarch') != -1 || ppl.Sunshine_Center__c.indexOf('Chapter') != -1 || ppl.Sunshine_Center__c.indexOf('Lincoln') != -1)
           ccEmailIds.add(System.Label.MSCCLincolnEmailIds);
         if(ppl.Sunshine_Center__c.indexOf('Mountain') != -1 || ppl.Sunshine_Center__c.indexOf('Willow') != -1) 
           ccEmailIds.add(System.Label.MountainWillowEmailIds);
        email.setCcAddresses(ccEmailIds);
        email.setToAddresses( EmailIds  );
         email.setWhatId(aRecordId);
        email.setTemplateID(templateId.Id);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
        email.setOrgWideEmailAddressId(owa.id);
        email.setTargetObjectId(con.Id);
        email.saveAsActivity = false;
       // email.setWhatId(aRecordId);
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    
    }
}