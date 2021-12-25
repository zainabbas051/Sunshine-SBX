//Test Class : corporateFinanceUtilityTest
global class corporateFinanceUtility{
    
    public static String recrdId;
    public static sObject sObj;
    public static Corporate_Finance_Endpoints__c cfe;
    
    Webservice static sObject createRevenue(ID recordID, String sObjType, Integer companyId, Date collectionDate, Decimal amount, String amountType){
        
        
        cfe = Corporate_Finance_Endpoints__c.getValues('Default');
        
        String query = 'SELECT Id, Corporate_Finance_Integration_Message__c, Corporate_Finance_Integration_Status__c, Close_Date__c FROM '+ sObjType +' WHERE Id=: recordID';
        recrdId = recordID;
        
        System.debug('Query ::::::::::::::'+ query);
        sObj = Database.Query(query);
        
        String body = '';
        try{
            
            body = corporateFinanceIntegrationHelper.createRevenueHelper(companyId, collectionDate, amount, amountType);
        }catch(exception e){
            sObj.put('Corporate_Finance_Integration_Status__c', 'SFDC Error');
            sObj.put('Corporate_Finance_Integration_Message__c', (String)sObj.get('Corporate_Finance_Integration_Message__c')+'\r\n'+e.getMessage());
            return sObj;
        }
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(cfe.Create_Revenue_URL__c);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization',cfe.Authorization__c);
        req.setBody(body);
        req.setTimeout(50000);
        
        Http http = new Http();
        
        // create a new HTTP response for receiving the remote response for Sign In request.
        HTTPResponse res;
        
        try{
            if(!Test.IsRunningTest()){
                res = http.send(req);
            }else{
                res = new HTTPResponse();
                res.setBody('{"revenue": {"id": 3,"company_id": "2","type_of_revenue": "Cash","sf_id": "3","amount": 30,"date": "2017-03-01","created_at": "2017-05-26T18:25:12.710Z","updated_at": "2017-05-26T18:25:12.710Z"}}');
                res.setStatusCode(200);
               
            }
        }catch(Exception e){
            sObj.put('Corporate_Finance_Integration_Status__c', 'SFDC Error');
            sObj.put('Corporate_Finance_Integration_Message__c', (String)sObj.get('Corporate_Finance_Integration_Message__c')+'\r\n'+e.getMessage());
            return sObj;
        }
        
        system.debug('response :::'+res);
        system.debug('response status code :::'+res.getStatusCode());
        system.debug('response body :::'+res.getBody());
        
        if(res != NULL && res.getStatusCode() == 200){
            
            sObj.put('Corporate_Finance_Integration_Status__c', 'Integration Succesfull');
            sObj.put('Require_Integration__c',False);
            return sObj;
        }else{
            sObj.put('Corporate_Finance_Integration_Status__c', 'Integration Failed');
            sObj.put('Corporate_Finance_Integration_Message__c', (String)sObj.get('Corporate_Finance_Integration_Message__c')+'\r\n'+res.getBody());
            return sObj;
        }
        
    }
    
    Webservice static sObject createDeals(ID recordID, String sObjType, Integer companyId, Date collectionDate, Integer noOfDeals, String typeOfDeals){
        
      
        
        cfe = Corporate_Finance_Endpoints__c.getValues('Default');
        
        String query = 'SELECT Id, Corporate_Finance_ID__c, Corporate_Finance_Integration_Message__c FROM '+ sObjType +' WHERE Id=: recordID';
        recrdId = recordID;
        
        System.debug('Query ::::::::::::::'+ query);
        sObj = Database.Query(query);
        
        String body = '';
        try{
            body = corporateFinanceIntegrationHelper.createNoOfDealsHelper(companyId,collectionDate,noOfDeals,typeOfDeals);
        }catch(exception e){
            sObj.put('Corporate_Finance_Integration_Status__c', 'SFDC Error');
            sObj.put('Corporate_Finance_Integration_Message__c', (String)sObj.get('Corporate_Finance_Integration_Message__c')+'\r\n'+e.getMessage());
             return sObj;
        }
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(cfe.Create_No_Of_Deals_URL__c);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization',cfe.Authorization__c);
        req.setBody(body);
        req.setTimeout(50000);
        
        Http http = new Http();
        
        // create a new HTTP response for receiving the remote response for Sign In request.
        HTTPResponse res;
        
        try{
            if(!Test.IsRunningTest()){
                res = http.send(req);
            }else{
                res = new HTTPResponse();
                res.setBody('{"revenue": {"id": 3,"company_id": "2","type_of_revenue": "Cash","sf_id": "3","amount": 30,"date": "2017-03-01","created_at": "2017-05-26T18:25:12.710Z","updated_at": "2017-05-26T18:25:12.710Z"}}');
                res.setStatusCode(200);
               
            }
        }catch(Exception e){
            sObj.put('Corporate_Finance_Integration_Status__c', 'SFDC Error');
            sObj.put('Corporate_Finance_Integration_Message__c', (String)sObj.get('Corporate_Finance_Integration_Message__c')+'\r\n'+e.getMessage());
            return sObj;
        }
        
        system.debug('response :::'+res);
        system.debug('response status code :::'+res.getStatusCode());
        system.debug('response body :::'+res.getBody());
        
        if(res != NULL && res.getStatusCode() == 200){
            
            sObj.put('Corporate_Finance_Integration_Status__c', 'Integration Succesfull');
            sObj.put('Require_Integration__c',False);
            return sObj;
        }else{
            sObj.put('Corporate_Finance_Integration_Status__c', 'Integration Failed');
            sObj.put('Corporate_Finance_Integration_Message__c', (String)sObj.get('Corporate_Finance_Integration_Message__c')+'\r\n'+res.getBody());
            return sObj;
        }
        
    }
    
}