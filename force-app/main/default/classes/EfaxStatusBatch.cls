/*
Author : Danish
Date : 6/6/2018
Description : Batch class to update the status 
Test Class : EfaxParseCtrl_Test
*/
global class EfaxStatusBatch implements Database.Batchable < sObject >,Database.AllowsCallouts {

     global final String query;
     
      global EfaxStatusBatch() {
       
        query = 'Select ID,DOCID__c from EFax_Log__c where Is_Processed__c = false';
           
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {

        return Database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext BC, List < EFax_Log__c > scope) {

       List<EFax_Log__c> lstEFaxLog = new List<EFax_Log__c>();
        EFax_Setting__c eFax =  EFax_Setting__c.getValues('Freepu');
       for(EFax_Log__c iFax : scope){
           
            string xml = '<?xml version="1.0"?> <OutboundStatus>   <AccessControl>     <UserName>'+eFax.User_Name__c+'</UserName>     <Password>'+eFax.Password__c+'</Password>   </AccessControl>   <Transmission>     <TransmissionControl> <DOCID>'+iFax.DOCID__c+'</DOCID>     </TransmissionControl>   </Transmission> </OutboundStatus>';   
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://secure.efaxdeveloper.com/EFax_WebFax.serv');    
            String body = 'id='+eFax.Account_ID__c+'&xml='+EncodingUtil.URLENCODE(xml,'UTF-8')+'&respond=XML';
            req.setbody(body);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            
            
            
            res = http.send(req);
            
            Dom.Document doc;
            if(test.isRunningTest()){
                doc= new DOM.Document();
                doc.load('<?xml version="1.0"?><OutboundStatusResponse> <Transmission> <TransmissionControl> <TransmissionID></TransmissionID> </TransmissionControl> <Recipients> <Recipient> <DOCID>42921039</DOCID> <Name>Test Recipient</Name> <Company>Test Company</Company> <Fax>(844) 249-3038</Fax> <Status> <Message>Your transmission has completed.</Message> <Classification>"Success"</Classification> <Outcome>"Success"</Outcome> </Status> <LastAttempt> <LastDate>06/05/2018</LastDate> <LastTime>09:42:54</LastTime> </LastAttempt> <NextAttempt> <NextDate></NextDate> <NextTime></NextTime> </NextAttempt> <Pages> <Scheduled>1</Scheduled> <Sent>1</Sent> </Pages> <BaudRate>28800</BaudRate> <Duration>0.5</Duration> <Retries>1</Retries> <RemoteCSID>"+1.844.249.3038"</RemoteCSID> </Recipient> </Recipients> </Transmission> </OutboundStatusResponse>'); 
            }else{
                doc = res.getBodyDocument();
            }
           // Dom.Document doc = res.getBodyDocument();
            Dom.XMLNode ordDtls = doc.getRootElement();
            Dom.XMLNode RecipentNode = ordDtls.getChildElement('Transmission', null).getChildElement('Recipients', null).getChildElement('Recipient', null);
            string FaxNumber = RecipentNode.getChildElement('Fax', null).getText();
            
            Dom.XMLNode StatustNode = RecipentNode.getChildElement('Status', null);
            string messages = StatustNode.getChildElement('Message', null).getText();
            string outCome = StatustNode.getChildElement('Outcome', null).getText();
            
             Dom.XMLNode LastAttemptNode = RecipentNode.getChildElement('LastAttempt', null);
            string LastAttempt = LastAttemptNode.getChildElement('LastDate', null).getText();
            LastAttempt += '  '+ LastAttemptNode.getChildElement('LastTime', null).getText();
            
             Dom.XMLNode NextAttempttNode = RecipentNode.getChildElement('NextAttempt', null);
            string NextAttempt = NextAttempttNode.getChildElement('NextDate', null).getText();
            NextAttempt += '  '+ NextAttempttNode.getChildElement('NextTime', null).getText();
            
            string BaudRate = RecipentNode.getChildElement('BaudRate', null).getText();
            string Duration = RecipentNode.getChildElement('Duration', null).getText();
            string RemoteCSID = RecipentNode.getChildElement('RemoteCSID', null).getText();
           
           EFax_Log__c eLog = new EFax_Log__c();
           
           eLog.ID = iFax.ID;
           eLog.DOCID__c = iFax.DOCID__c;
           eLog.Fax__c = FaxNumber;
           eLog.Message__c = messages;
           eLog.Outcome__c = outcome;
           eLog.Last_Attempt__c = LastAttempt;
           eLog.Next_Attempt__c = NextAttempt;
           eLog.Baud_Rate__c = BaudRate;
           eLog.Duration__c = Duration;
           eLog.RemoteCSID__c = RemoteCSID;
           eLog.Is_Processed__c = true;
           
           lstEFaxLog.add(eLog);
       }
       
       update lstEFaxLog;
       
        
    }
    
      global void finish(Database.BatchableContext BC) {

    }
     
     

}