global class createLeadFrmEmail implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
    Messaging.InboundEnvelope envelope) {

        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

        String subToLeadInsompare = 'New submission from Contact Form';
                    Lead LeadIns;
                    string bodyText;
                    LeadIns = new Lead();
            if(email.plainTextBody!=''){

             Pattern htmlPattern = Pattern.compile('</?[a-z][a-z0-9]*[^<>]*>'); 
        String emailBody= htmlPattern.matcher(email.HTMLBody).replaceAll('');
        
        system.debug('content without html: '+emailBody);
        
       emailBody= emailBody.Replace('&nbsp;', '');
            emailBody = emailBody.Replace('\n', '');
            emailBody = emailBody.Replace('  ', '');
              system.debug('After all: '+emailBody);
                
                string separator = '\u039A';

            emailBody = emailBody.Replace('\t', separator);
            system.debug('Before arrary::'+emailbody);
            string[] testArray = emailBody.Split(separator);
             for (integer index = 0; index < testArray.size(); index++)
            {
                if (testArray [index]==null || testArray [index]=='' || testArray [index]==' ')
                {
                    testArray.remove(index);
                    index--;
                }
                
            }
            
            system.debug('Final value:::'+testArray);
        
        Integer NameIndex = testArray.indexOf('Name');
        Integer EmailIndex = testArray.indexOf('Email');
        Integer PhoneIndex = testArray.indexOf('Phone');
        Integer PreferredContactIndex = testArray.indexOf('Preferred Contact');
        Integer MessageIndex = testArray.indexOf('Message');
        Integer LeadSourceIndex = testArray.indexOf('Lead Source');
        Integer RTSourceIndex = testArray.indexOf('RT Source');
        Integer CallWebIndex = testArray.indexOf('Call / Web');
        Integer  CampaignIndex = testArray.indexOf('Campaign'); 
       
   
            LeadIns.lastname= testArray[NameIndex +1];
            leadIns.email=testArray[EmailIndex +1];
            leadIns.phone=testArray[PhoneIndex +1];
            leadIns.Preferred_Contact__c= testArray[PreferredContactIndex +1];
            if(testArray[MessageIndex +1]=='Lead Source'){
                leadIns.Additional_Notes__c='';
            }
            
            else{
                leadIns.Additional_Notes__c=testArray[MessageIndex +1];
            }
            
            LeadIns.leadsource=testArray[LeadSourceIndex +1];
            LeadIns.RT_Source__c=testArray[RTSourceIndex +1];
            LeadIns.Phone_Web__c=testArray[CallWebIndex +1];
            LeadIns.Campaign__c=testArray[CampaignIndex +1];


            
            LeadIns.company='Test com';
            system.debug('lead Ins:::'+ leadIns);
            if(!Test.isRunningTest())

            insert LeadIns;}

              
        

    result.success = true;
        return result;
    }
    
  

    }