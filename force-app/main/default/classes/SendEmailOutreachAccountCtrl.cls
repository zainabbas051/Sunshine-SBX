public with sharing class SendEmailOutreachAccountCtrl {
    public OUTREACH_ACCOUNT__c OutreachIns {get;set;}   
    string OutreachAccountID; 
        public EmailMessage emailMsg {get; private set;}

    
    public Attachment attachment {

        get {
            if (attachment==null) {

                System.debug('==========> creating new empty Attachment.');

                attachment = new Attachment();

            }

            return attachment;

        }

        set;

    }


    public SendEmailOutreachAccountCtrl (){
    
         OutreachAccountID=apexpages.currentpage().getparameters().get('id');
        //if(!Test.isRunningTest()){


         OutreachIns = [select Subject__c,From_Email_Adresses__c,Body__c,Recipient_Name__c,ownerid,Email_Type__c,CC_Email__c,Contact_Email_Address__c from OUTREACH_ACCOUNT__c where id=:OutreachAccountID] ;
        
    
    
    }
    
    public PageReference SendEmail(){
                emailMsg = new EmailMessage();

        if(OutreachIns.Recipient_Name__c==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter "Recipient Name"'));
            return null;
        
        }
       else  if(OutreachIns.From_Email_Adresses__c==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter "From" Address'));
            return null;
        
        }
        
        else if(OutreachIns.Contact_Email_Address__c ==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter "To" Address'));
            return null;
        
        }
        
        else if(OutreachIns.Email_Type__c==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select "Email Type"'));
            return null;
        
        }
        
        
        
        else{
               //New instance of a single email message
                       Messaging.reserveSingleEmailCapacity(2);

             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
              
                //   mail.setOrgWideEmailAddressId(OutreachIns.From_Email_Adresses__c);
            OrgWideEmailAddress[] owea = [select Id,DisplayName from OrgWideEmailAddress where Address = :OutreachIns.From_Email_Adresses__c limit 1];
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
            OutreachIns.Sender_Name__c=owea.get(0).DisplayName;
        }
        
        update OutreachIns;
        
        
            
                  // Who you are sending the email to
             List<string> toAddress = new List<string>();
             toAddress.add(OutreachIns.Contact_Email_Address__c);
             
             String[] ccAddrs = new List<String>{OutreachIns.CC_Email__c};
             mail.setToAddresses(toAddress);
             mail.setTargetObjectId(OutreachIns.ownerID );
             mail.setTreatTargetObjectAsRecipient(false);
             
              // The email template ID used for the email
           if (outreachIns.Email_Type__c=='GP')
               mail.setTemplateId('00X1O000002c91i');
           else if(outreachIns.Email_Type__c=='Resource')
               mail.setTemplateId('00X1O000002c91j');
           else if(outreachIns.Email_Type__c=='Custom') {
           //email.setSubject( subject );

mail.setsubject(OutreachIns.subject__C);

        mail.setPlainTextBody( OutreachIns.body__c);

           
           }          
        if(OutreachIns.CC_Email__c!=null)
              mail.setCcAddresses( ccAddrs );
      mail.setSaveAsActivity(true);

        mail.setWhatId(OutreachAccountID );    
        mail.setBccSender(false);
        mail.setUseSignature(false);
   //mail.setReplyTo('zoobeezfatima@gmail.com');
        mail.setSaveAsActivity(true);
        
                    if (attachment.Body != null) {
                    Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();

                emailAttachment.setBody(attachment.Body);

                emailAttachment.setFileName(attachment.Name);

                mail.setFileAttachments(new List<Messaging.EmailFileAttachment> {emailAttachment});
                    
                    }
  

         if(!Test.isRunningTest()){

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        OutreachIns.Subject__c='';
        OutreachIns.Body__c='';
        
        update OutreachIns;
        
}
        
           
            PageReference pr;

            pr = new Pagereference('/'+OutreachAccountID);
            return pr;
            
            }
    }

}