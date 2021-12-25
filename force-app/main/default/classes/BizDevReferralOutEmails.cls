//Test Class :  BizDevReferralOutEmailsTest
global class BizDevReferralOutEmails{
    
     webservice static String BizDevReferralOutEmail_Leads(String leadId){
         
         system.debug('leadId ::::'+leadId);
         string result;
         string newOwnerId;
         
         newOwnerId =String.valueOf(UserInfo.getUserId()).substring(0, 15);
         Lead leadRecord = [select id, Biz_Dev_Access_Checkbox__c, FirstName, LastName, Phone, Patient_DOB__c, City__c, State__c, 
                             Insurance_Providors__c, Insurance_Policy__c, Group_Number__c, Insurance_Provider_Phone_Number__c, 
                             Subscriber_First_Name__c, Subscriber_Last_Name__c, Subscriber_DOB_Text__c, Reason_for_Referral_Out__c, 
                             Additional_Notes__c from Lead where id=:leadId];
         system.debug('leadRecord :::'+leadRecord);
         
         if(leadRecord.id != null){
             String emailSubject = 'Referral out - '+leadRecord.FirstName+' '+leadRecord.LastName.left(1);
             
             String emailBody = 'Name : '+leadRecord.FirstName+' '+leadRecord.LastName;
             if(leadRecord.Phone != null)
                 emailBody = emailBody+'\nPhone : '+leadRecord.Phone;
             else
                 emailBody = emailBody+'\nPhone : ';
             if(leadRecord.Patient_DOB__c != null)
                 emailBody = emailBody+'\nClient DOB : '+leadRecord.Patient_DOB__c;
             else
                 emailBody = emailBody+'\nClient DOB : ';
             if(leadRecord.City__c != null)
                 emailBody = emailBody+'\nCity : '+leadRecord.City__c;
             else
                 emailBody = emailBody+'\nCity : ';
             if(leadRecord.State__c != null)
                 emailBody = emailBody+'\nState : '+leadRecord.State__c;
             else
                 emailBody = emailBody+'\nState : ';
             if(leadRecord.Insurance_Providors__c != null)
                 emailBody = emailBody+'\n\nInsurance Providors : '+leadRecord.Insurance_Providors__c;
             else
                 emailBody = emailBody+'\n\nInsurance Providors : ';
             if(leadRecord.Insurance_Policy__c != null)
                 emailBody = emailBody+'\nInsurance Policy # : '+leadRecord.Insurance_Policy__c;
             else
                 emailBody = emailBody+'\nInsurance Policy # : ';
             if(leadRecord.Group_Number__c != null)
                 emailBody = emailBody+'\nGroup Number : '+leadRecord.Group_Number__c;
             else
                 emailBody = emailBody+'\nGroup Number : ';    
             if(leadRecord.Insurance_Provider_Phone_Number__c != null)
                 emailBody = emailBody+'\nInsurance Provider Phone Number : '+leadRecord.Insurance_Provider_Phone_Number__c;
             else
                 emailBody = emailBody+'\nInsurance Provider Phone Number : ';
             if(leadRecord.Subscriber_First_Name__c != null || leadRecord.Subscriber_Last_Name__c != null)
                 emailBody = emailBody+'\nSubscriber Name : '+leadRecord.Subscriber_First_Name__c+' '+leadRecord.Subscriber_Last_Name__c;
             else
                 emailBody = emailBody+'\nSubscriber Name : ';
             if(leadRecord.Subscriber_DOB_Text__c != null)
                 emailBody = emailBody+'\nSubscriber DOB : '+leadRecord.Subscriber_DOB_Text__c;
             else
                 emailBody = emailBody+'\nSubscriber DOB : ';
             if(leadRecord.Reason_for_Referral_Out__c != null)
                 emailBody = emailBody+'\n\nReason for Referral Out : '+leadRecord.Reason_for_Referral_Out__c;
             else
                 emailBody = emailBody+'\n\nReason for Referral Out : ';    
             if(leadRecord.Additional_Notes__c != null)
                 emailBody = emailBody+'\n\nAdditional Notes : '+leadRecord.Additional_Notes__c;
             else
                 emailBody = emailBody+'\n\nAdditional Notes : ';
             
             system.debug('emailBody ::::'+emailBody);
             system.debug('emailBody ::::'+emailSubject);
             
             List<String> emailRecipients = new List<String>();
             emailRecipients.add('bizdev@sunshinebh.com');
             emailRecipients.add('admissions@sunshinebh.com');
             //emailRecipients.add('naveenc@sunshinebh.com');
             
             //Setting up the Chatter Feed Post for the email that just went out
             String feedBody = 'From : '+UserInfo.getName()+'\n'+'To : '+emailRecipients+'\n'+'Subject : '+emailSubject+'\n'+'\n'+emailBody;
             FeedItem fi = new FeedItem();
             fi.Body = feedBody;
             fi.Type = 'AdvancedTextPost';
             fi.ParentId = leadRecord.id; 
                
             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
             message.toAddresses = emailRecipients;
             message.subject = emailSubject;
             message.plainTextBody = emailBody;
             //message.setTargetObjectId(leadRecord.id);//This field will link the out going email as an Activity on the Lead
             message.setSenderDisplayName(UserInfo.getName());
             message.setUseSignature(false); 
             try{
                 Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                 Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                 if (results[0].success) {
                     insert fi;
                     if(leadRecord.Biz_Dev_Access_Checkbox__c == False){
                         leadRecord.Biz_Dev_Access_Checkbox__c = True;
                         update leadRecord;
                     }    
                     result = 'The Email was Sucessfully Sent!!';
                 } else {
                     System.debug('The email failed to send: '+ results[0].errors[0].message);
                     result = 'OOOPS, Some thing went wrong while Sending the email. Please Contact Naveen on Chatter!!';    
                 }
             }catch(exception e){
                 result = 'OOOPS, Some thing went wrong while claiming the lead. Please Contact Naveen on Chatter!!';    
             }
                 
              
          }else{
              result = 'OOOPS, Some thing went wrong while claiming the lead. Please Contact Naveen on Chatter!!';  
          }
          
          system.debug('result:'+ result);
          return result;
      }
      
      
      webservice static String BizDevReferralOutEmail_Opps(String oppId){
         
         system.debug('oppId ::::'+oppId);
         string result;
         string newOwnerId;
         
         newOwnerId =String.valueOf(UserInfo.getUserId()).substring(0, 15);
         Opportunity oppRecord = [select id, Biz_Dev_Access_Checkbox__c, Name, Incoming_Number__c, Client_DOB__c, Insurance_Provider__r.Name,
                                  Insurance_Policy__c, Carve_Out_for_Behavioral_Health__c, Carve_Out_Policy_Number__c, Carve_Out_Phone_Number__c,
                                  Reason_for_Referral_Out__c, Reason_Lost__c, Additional_Notes__c, Latest_VOB_Request__c from Opportunity where id=:oppId];
         system.debug('oppRecord :::'+oppRecord);
         
         list<Insurance_Information__c> relatedInsuranceList = new list<Insurance_Information__c>();
         Insurance_Information__c insuranceRecord = new Insurance_Information__c();
         
         for(Insurance_Information__c ii : [Select id, City__c, State__c, Insurance_Provider_Phone_Number__c, Subscriber_Name__c, Subscriber_DOB__c, Insurance_Status__c
                                            from Insurance_Information__c where Opportunity__c =: oppRecord.Id]){
             relatedInsuranceList.add(ii);
         }
         
         if(relatedInsuranceList.isEmpty() == False){
             if(relatedInsuranceList.size() == 1)//If only one Insurance is found than that insurance is used
                 insuranceRecord = relatedInsuranceList[0];
             else{
                 for(Insurance_Information__c ii : relatedInsuranceList){//If more than one Insurance is found than the Primary insurance is used
                     if(ii.Insurance_Status__c != null && ii.Insurance_Status__c == 'Primary'){
                         insuranceRecord = ii;
                     }
                 }
             }
         }
         
         
         if(oppRecord.id != null){
             String emailSubject = 'Referral out - '+oppRecord.Name.split(' ')[0]+' '+oppRecord.Name.split(' ')[1].left(1);
             
             String emailBody = 'Opportunity Name : '+oppRecord.Name;
             if(oppRecord.Incoming_Number__c != null)
                 emailBody = emailBody+'\nIncoming Number : '+oppRecord.Incoming_Number__c;
             else
                 emailBody = emailBody+'\nIncoming Number : ';
             if(oppRecord.Client_DOB__c != null)
                 emailBody = emailBody+'\nClient DOB : '+oppRecord.Client_DOB__c;
             else
                 emailBody = emailBody+'\nClient DOB : ';
             if(insuranceRecord.City__c != null)
                 emailBody = emailBody+'\nCity : '+insuranceRecord.City__c;
             else
                 emailBody = emailBody+'\nCity : ';
             if(insuranceRecord.State__c != null)
                 emailBody = emailBody+'\nState : '+insuranceRecord.State__c;
             else
                 emailBody = emailBody+'\nState : ';
             if(oppRecord.Insurance_Provider__r.Name != null)
                 emailBody = emailBody+'\n\nInsurance Provider : '+oppRecord.Insurance_Provider__r.Name;
             else
                 emailBody = emailBody+'\n\nInsurance Provider : ';
             if(oppRecord.Insurance_Policy__c != null)
                 emailBody = emailBody+'\nInsurance Policy # : '+oppRecord.Insurance_Policy__c;
             else
                 emailBody = emailBody+'\nInsurance Policy # : ';
             if(insuranceRecord.Insurance_Provider_Phone_Number__c != null)
                 emailBody = emailBody+'\nInsurance Provider Phone Number  : '+insuranceRecord.Insurance_Provider_Phone_Number__c;
             else
                 emailBody = emailBody+'\nInsurance Provider Phone Number  : ';    
             if(oppRecord.Carve_Out_for_Behavioral_Health__c!= null)
                 emailBody = emailBody+'\nCarve Out for Behavioral Health : '+oppRecord.Carve_Out_for_Behavioral_Health__c;
             else
                 emailBody = emailBody+'\nCarve Out for Behavioral Health : ';
             if(oppRecord.Carve_Out_Policy_Number__c != null)
                 emailBody = emailBody+'\nCarve Out Policy Number : '+oppRecord.Carve_Out_Policy_Number__c;
             else
                 emailBody = emailBody+'\nCarve Out Policy Number : ';
             if(oppRecord.Carve_Out_Phone_Number__c != null)
                 emailBody = emailBody+'\nCarve Out Phone Number : '+oppRecord.Carve_Out_Phone_Number__c;
             else
                 emailBody = emailBody+'\nCarve Out Phone Number : ';
             if(insuranceRecord.Subscriber_Name__c != null)
                 emailBody = emailBody+'\nSubscriber Name : '+insuranceRecord.Subscriber_Name__c;
             else
                 emailBody = emailBody+'\nSubscriber Name : ';    
             if(insuranceRecord.Subscriber_DOB__c != null)
                 emailBody = emailBody+'\nSubscriber DOB : '+insuranceRecord.Subscriber_DOB__c;
             else
                 emailBody = emailBody+'\nSubscriber DOB : ';
             if(oppRecord.Reason_for_Referral_Out__c != null)
                 emailBody = emailBody+'\n\nReason for Referral Out : '+oppRecord.Reason_for_Referral_Out__c;
             else
                 emailBody = emailBody+'\n\nReason for Referral Out : ';
             if(oppRecord.Reason_Lost__c != null)
                 emailBody = emailBody+'\nReason Lost : '+oppRecord.Reason_Lost__c;
             else
                 emailBody = emailBody+'\nReason Lost : ';
             if(oppRecord.Reason_Lost__c != null)
                 emailBody = emailBody+'\nAdditional Notes : '+oppRecord.Additional_Notes__c;
             else
                 emailBody = emailBody+'\nAdditional Notes : ';
                 
             system.debug('emailBody ::::'+emailBody);
             system.debug('emailBody ::::'+emailSubject);
             
             List<String> emailRecipients = new List<String>();
             emailRecipients.add('bizdev@sunshinebh.com');
             emailRecipients.add('admissions@sunshinebh.com');
             //emailRecipients.add('naveenc@sunshinebh.com');
             
             //Setting up the Chatter Feed Post for the email that just went out
             String feedBody = 'From : '+UserInfo.getName()+'\n'+'To : '+emailRecipients+'\n'+'Subject : '+emailSubject+'\n'+'\n'+emailBody;
             FeedItem fi = new FeedItem();
             fi.Body = feedBody;
             fi.Type = 'AdvancedTextPost';
             fi.ParentId = oppRecord.id;
             
             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
             message.toAddresses = emailRecipients;
             message.subject = emailSubject;
             message.plainTextBody = emailBody;
             message.setWhatId(oppRecord.id);//This field will link the out going email as an Activity on the Lead
             message.setSenderDisplayName(UserInfo.getName());
             message.setUseSignature(false); 
             try{
                 Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                 Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                 if (results[0].success) {
                     insert fi;
                     if(oppRecord.Biz_Dev_Access_Checkbox__c == False){
                         oppRecord.Biz_Dev_Access_Checkbox__c = True;
                         update oppRecord;
                     }   
                     result = 'The Email was Sucessfully Sent!!';
                 } else {
                     System.debug('The email failed to send: '+ results[0].errors[0].message);
                     result = 'OOOPS, Some thing went wrong while Sending the email. Please Contact Naveen on Chatter!!';    
                 }
             }catch(exception e){
                 result = 'OOOPS, Some thing went wrong while claiming the lead. Please Contact Naveen on Chatter!!';    
             }
             
              
          }else{
              result = 'OOOPS, Some thing went wrong while claiming the lead. Please Contact Naveen on Chatter!!';  
          }
          
          system.debug('result:'+ result);
          return result;
      }

}