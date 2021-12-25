//Test Class : SoberRecoveryChatWebToLeadClassTest
global class SoberRecoveryChatWebToLeadClass implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope){
        system.debug('Email Body: '+email.plainTextBody);
        //String emailBody = email.plainTextBody;
        
        Pattern htmlPattern = Pattern.compile('</?[a-z][a-z0-9]*[^<>]*>'); 
        String emailBody= htmlPattern.matcher(email.HTMLBody).replaceAll('');
        system.debug('content without html: '+emailBody);
        
        Integer nameIndex = emailBody.indexOf('Name:');
        Integer phoneIndex = emailBody.indexOf('Phone:');
        Integer chatSummaryIndex = emailBody.indexOf('Chat Summary');
        Integer chatStartIndex = emailBody.indexOf('Chat Transcript');
        Integer chatEndIndex = emailBody.indexOf('We encourage you to contact this lead in a timely manner.');
        system.debug('Name Index: '+nameIndex);
        system.debug('Phone Index: '+phoneIndex);
        system.debug('Chat Start Index: '+chatStartIndex);
        system.debug('Chat End Index: '+chatEndIndex);
        
        String clientName = emailBody.substring(nameIndex+5,phoneIndex);
        system.debug('Client Name: '+clientName);
        
        String clientPhone = emailBody.substring(phoneIndex+6,chatSummaryIndex);
        system.debug('Client Phone: '+clientPhone);
        
        String chatSummary = emailBody.substring(chatStartIndex+15,chatEndIndex-2);
        system.debug('Chat Summary: '+chatSummary);
        
        Id recTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId();
        
        Lead l = new Lead();
        l.LastName = clientName;
        l.Company = clientName;
        l.Phone = clientPhone;
        l.Additional_Notes__c = chatSummary;
        l.RecordTypeId = recTypeId;
        l.Status = 'Open';
        l.RT_Source__c = 'Sober Recovery Chat';
        l.LeadSource = 'External Sources';
        //l.OwnerId = '00GU0000001M4VD';//Intake Queue
        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = true;
        l.setOptions(dmo);
        
        try{
            insert l;
        }catch (exception e){}
        
        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

        return result;
    }
}