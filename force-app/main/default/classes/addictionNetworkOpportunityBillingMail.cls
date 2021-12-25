Public without sharing class addictionNetworkOpportunityBillingMail{
    
    public void addictionNetworkOpportunityBillingMail(){
        
        list<Opportunity> todayOpps = new list<Opportunity>();
        list<Opportunity> oppUpdate = new list<Opportunity>();
        list<String> renewalEmailBody = new list<String>();
        todayOpps = [select id, Renew_Date__c, Treatment_Center__c, Monthly_Bill__c, Account_Status__c from Opportunity Where Renew_Date__c =: date.Today() AND Account_Status__c =: 'Active'];
        
        if(todayOpps.size()>0){
            String Treatment_Center = '';
            for(Opportunity opp : todayOpps){
                if(opp.Account_Status__c == 'Active'){
                    String emailBody = 'Treatment Center : '+opp.Treatment_Center__c+'; Bill Amount : '+opp.Monthly_Bill__c+'; Renewal Date : '+opp.Renew_Date__c;
                    renewalEmailBody.add(emailBody);
                    date newDate = opp.Renew_Date__c.addMonths(1);
                    opp.Renew_Date__c = newDate;
                    oppUpdate.add(opp);
                    Treatment_Center = opp.Treatment_Center__c;
                }
            }
               
            if(renewalEmailBody.size()>0){
                 list<Messaging.SingleEmailMessage> messages = new list<Messaging.SingleEmailMessage>();
                
                for(String emailBody : renewalEmailBody){
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    String[] toaddress = new String[]{};
                    toAddress.add('tom@eliterehabplacement.com');//Setting the To Email Address of the user to which the email should go.
                    message.setToAddresses(toAddress);
                    message.setsubject('Renewal Email For : '+Treatment_Center );//Setting the subject of the email.
                    message.setPlainTextBody(emailBody);
                    message.setBccSender(false);
                    message.setUseSignature(false);
                    message.saveAsActivity = False;
                    messages.add(message);  
                             
                }
                
                try{
                    System.debug('Trying to send the email');
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                }catch(exception e){System.debug('exception'+e);}
                                    
            }
            
            if(oppUpdate.size()>0){
                Update oppUpdate;
            }     
        }
    
    }
    
     
}