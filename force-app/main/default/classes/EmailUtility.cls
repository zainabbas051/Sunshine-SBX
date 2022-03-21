public without sharing class EmailUtility {
    
    public static void sendEmail(string emailAddress,string emailBody,string emailSubject,string fromAddress,
                           boolean isAttachment,string url,string fileName,string recordId){
        
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where Address =:fromAddress  limit 1];
        emailMessage.setToAddresses(emailAddress.split(';'));
        emailMessage.setHtmlBody(emailBody);
        emailMessage.setSubject(emailSubject);
        
        emailMessage.setOrgWideEmailAddressId(owa.id);
        emailMessage.saveAsActivity = false;

        if(isAttachment){
            //PageReference pdf = pdfAttachment;
            PageReference pdf = new PageReference(url);
            pdf.getParameters().put('id',(String)recordId);
            // Take the PDF content
            Blob b = Blob.valueof('Some random String');
            if(!test.isRunningTest()){
                b = pdf.getContent();
            }
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(fileName+'.pdf');
            efa.setBody(b);
            emailMessage.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        }
        // email.setWhatId(aRecordId);
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMessage});
    }
    
    public static void sendEmailwithVFBody(string emailAddress,string templateID,string fromAddress,string recordId){
      try{  
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where Address =:fromAddress  limit 1];
         User cnt = [SELECT Id, Email FROM User WHERE Profile.Name = 'System Administrator' limit 1];
         Anonymous_Concern__c an =[select id from Anonymous_Concern__c where id=:Id.ValueOf(recordId) ];
        emailMessage.setTargetObjectId(cnt.id);
        emailMessage.setToAddresses(emailAddress.split(';'));
        emailMessage.setOrgWideEmailAddressId(owa.id);
        emailMessage.saveAsActivity = false;

         EmailTemplate emailTemplate =[Select Id,Subject,Description,
                                 HtmlValue,DeveloperName,Body
                                 from EmailTemplate where id =:Id.ValueOf(templateID)];
        // email.setWhatId(aRecordId);
        emailMessage.setTemplateID(emailTemplate.Id);
        emailMessage.setWhatId(an.id);
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMessage});
        }
        catch(Exception ex){
        system.debug(ex.getStackTraceString());
        }
    }
}