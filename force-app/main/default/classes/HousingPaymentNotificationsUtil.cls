public class HousingPaymentNotificationsUtil{
      public static void sendEmail(KIPU_Chart_Audit__c record,string orgWideEmailaddress){
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: orgWideEmailaddress];
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setUseSignature(false); 
            message.setBccSender(false); 
            message.setSaveAsActivity(false); 
            message.setOrgWideEmailAddressId(owea.get(0).Id);
            Contact cnt = [select id, Email from Contact limit 1];
            message.setTargetObjectId(cnt.id);
            //EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = ‘Test Account Alert Email’];
            message.setTemplateID([Select Id from EmailTemplate where DeveloperName ='Housing_Rent_Notification' limit 1][0].ID); 
            message.setWhatId(record.Id); //This is important for the merge fields in template to work
            message.toAddresses = new String[] { record.Opportunity__r.Email__c };
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
 
            if (results[0].success) 
            {
                  System.debug('The email was sent successfully.');
                  return;
            } 
            System.debug('The email failed to send: ' +  results[0].errors[0].message);
      }
    
      public static smagicinteract__smsMagic__c sendSMS(KIPU_Chart_Audit__c record){
            smagicinteract__smsMagic__c smsObjNew = new smagicinteract__smsMagic__c();
            //OpportunityContactRole objContactRole = new OpportunityContactRole();
            list<smagicinteract__smsMagic__c> lstSendSMS = new list<smagicinteract__smsMagic__c>();
            smsObjNew.smagicinteract__PhoneNumber__c = record.Opportunity__r.Phone__c; 
            String text='Dear '+record.Client_Name__c+',Your housing rent payment of amount: $'+ 
            record.Total_Rental_Amount_Pending__c 
            +' is due.Kindly visit the this URL for the payment. https://sunshinebh.force.com/ccp/s/housingrentprocessing?oppID = '
            + record.Opportunity__c;
            smsObjNew.smagicinteract__SMSText__c = text;
            smsObjNew.smagicinteract__senderId__c = '13173155065';
            smsObjNew.smagicinteract__Name__c = record.Opportunity__r.Name;
            smsObjNew.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
            return smsObjNew; 
      }           
}