//Test Class : CorporateFinanceDealsIntegrationTest
global class CorporateFinanceDealsIntegrationBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String fromDate = string.valueOf(date.Today().addDays(-90));
        string queryField = '';
        for(Corporate_Finance_Integration_Fields__c cfif : Corporate_Finance_Integration_Fields__c.getall().values()){
            if(cfif.Integration_Type__c == 'Deals Creation'){
                if(queryField == ''){
                    queryField = ', '+cfif.Field_Name__c;    
                }else{
                    queryField = queryField+', '+cfif.Field_Name__c;
                }
            }
            
        }
        String query = 'Select id'+queryField+', Close_Date__c from Corporate_Finance_Deals_Information__c where Close_Date__c >='+fromDate;
        if(Test.isRunningTest())
            query += ' limit 200';
        system.debug('query :::'+query);
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('test');
        list<Corporate_Finance_Deals_Information__c> cfdiList = new List<Corporate_Finance_Deals_Information__c>();
        for(Corporate_Finance_Deals_Information__c cfdi : (list<Corporate_Finance_Deals_Information__c>) scope){
            system.debug('all cfif :::'+Corporate_Finance_Integration_Fields__c.getall().values());
            for(Corporate_Finance_Integration_Fields__c cfif : Corporate_Finance_Integration_Fields__c.getall().values()){
                system.debug('cfif :::'+cfif);
                if(cfif.Integration_Type__c == 'Deals Creation'){
                    if((decimal)cfdi.get(cfif.Field_Name__c) != null){
                        sObject sObj = corporateFinanceUtility.createDeals(cfdi.id,'Corporate_Finance_Deals_Information__c',integer.valueOf(cfif.Company_Id__c),cfdi.Close_Date__c,integer.valueOf((Decimal)cfdi.get(cfif.Field_Name__c)),cfif.Type_of_Deals__c);    
                        cfdiList.add((Corporate_Finance_Deals_Information__c)sObj);
                    }
                }
            }
        }
        
        if(cfdiList.size()>0){
            boolean cfdiErrorFlag = False;
            for(Corporate_Finance_Deals_Information__c cfdi : cfdiList){
                if(cfdi.Corporate_Finance_Integration_Status__c == 'SFDC Error' || cfdi.Corporate_Finance_Integration_Status__c == 'Integration Failed'){
                    cfdiErrorFlag = True;   
                    Map<String,String> smsMap = new Map<String,String>();
                    string smsBody = 'An Error Occured in Revenue Creation Batch : '+cfdi.Corporate_Finance_Integration_Message__c+', for the Date'+cfdi.Close_Date__c;
                    smsMap.put(label.Naveen_User_Id,smsBody);
                    Utilities.sendSMS(smsMap);
                }
            } 
            
            if(cfdiErrorFlag == True){
                Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c(id = cfdiList[0].id, Corporate_Finance_Integration_Status__c = 'SFDC Error', Corporate_Finance_Integration_Message__c = cfdiList[0].Corporate_Finance_Integration_Message__c);
                update tempRecord;
            }else{
                Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c(id = cfdiList[0].id, Corporate_Finance_Integration_Status__c = 'Integration Succesfull', Require_Integration__c = False);
                update tempRecord;
            }
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
    }
}