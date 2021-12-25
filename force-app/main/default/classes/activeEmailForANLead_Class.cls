Public without sharing class activeEmailForANLead_Class{
    Public ID leadId;
    public void activeEmailForANLead_Class(){
        leadId = ApexPages.currentPage().getParameters().get('id');
        system.debug('Lead Id:'+leadId);    
    }
    
    public pagereference sendEmail(){
        leadId = ApexPages.currentPage().getParameters().get('id');
        system.debug('Lead Id:'+leadId);  
        
        Id org_wide_id =  [Select Id,Address,DisplayName From OrgWideEmailAddress Where DisplayName LIKE '%Addiction%'][0].Id;
        
        list<Messaging.SingleEmailMessage> messages = new list<Messaging.SingleEmailMessage>();
        if(leadId != null){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            String[] toaddress = new String[]{};
            //toAddress.add('developers.salesforce.com@gmail.com');//Setting the To Email Address of the user to which the email should go.
            //message.setToAddresses(toAddress);
            message.setTemplateId('00XU0000000sIyO');//Setting the template of the email.
            //message.setTemplateId('00XJ0000000EZQw');//Setting the template of the email.
            message.setTargetObjectId(leadId); 
            message.setBccSender(false);
            message.setUseSignature(false);
            message.saveAsActivity = False;
            message.setOrgWideEmailAddressId(org_wide_id);
            messages.add(message);    
        }
        if(messages.size()>0){
            try{
                System.debug('Trying to send the email');
                String feedBody = 'Active Email sent to Treatment Center ';
            
                FeedItem fi = new FeedItem();
                fi.Body = feedBody;
                fi.Type = 'AdvancedTextPost';
                fi.ParentId = leadId;
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                insert fi;
            }catch(exception e){System.debug('exception'+e);}
        }
        if(leadId != null){
            String baseurl = 'https://na12.salesforce.com';
            baseurl = baseurl+'/'+leadId;
            pageReference returnUrl = new pageReference(baseurl);
            return returnUrl; 
        }
        return null;       
    }
}