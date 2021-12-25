//Test Class : CorporateFinanceCasesSummarizeBatchTest
global class CorporateFinanceCasesSummarizeBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    string query;
    string CFDIRecordId='';
    Map<String,Corporate_Finance_Deals_Information__c> tempMap = new Map<String,Corporate_Finance_Deals_Information__c>();
    String closedStage = 'Closed';
    String adjustmentStage1 = 'Adjustment in Progress';
    String adjustmentStage2 = 'Appeal Under Processing';
    String closeFromDate = string.valueOf(date.Today().addDays(-90));
            
    global CorporateFinanceCasesSummarizeBatch(){
        Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        
        query = 'select id, Status, RecordTypeId, Appeal_for_Adjustment_Requested__c, Opportunity__r.Sunshine_Center__r.name, Collected_Amount__c, Collection_Date__c, Adjustment_Amount__c, Adjustment_Collected_Date__c from Case where (Collection_Date__c >= '+closeFromDate+' OR Adjustment_Collected_Date__c >= '+closeFromDate+') AND RecordTypeId =\''+recTypeId+'\' AND (Status =\''+closedStage+'\' OR Status=\''+adjustmentStage1+'\' OR Status =\''+adjustmentStage2+'\')';
        if(Test.isRunningTest())
            query += ' limit 200';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('query :::'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('test');
        
        for(Case c : (list<Case>) scope){
            if(c.Status == closedStage){
                if(tempMap.containsKey(string.valueOf(c.Collection_Date__c))){
                    Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                    tempRecord = tempMap.get(string.valueOf(c.Collection_Date__c));
                    if(c.Opportunity__r.Sunshine_Center__r.Name == 'Monarch Shores'){
                        if(c.Collected_Amount__c != null)
                            tempRecord.MS_Insurance_Revenue__c = tempRecord.MS_Insurance_Revenue__c + c.Collected_Amount__c;
                    }
                    if(c.Opportunity__r.Sunshine_Center__r.Name == 'Chapters Capistrano'){
                        if(c.Collected_Amount__c != null)
                            tempRecord.CC_Insurance_Revenue__c = tempRecord.CC_Insurance_Revenue__c + c.Collected_Amount__c;
                    }
                    if(c.Opportunity__r.Sunshine_Center__r.Name == 'Willow Springs'){
                        if(c.Collected_Amount__c != null)
                            tempRecord.WSR_Insurance_Revenue__c = tempRecord.WSR_Insurance_Revenue__c + c.Collected_Amount__c; 
                    }
                    tempMap.put(string.valueOf(c.Collection_Date__c), tempRecord);   
                }else{
                    Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                    if(c.Opportunity__r.Sunshine_Center__r.Name == 'Monarch Shores'){
                        if(c.Collected_Amount__c != null)
                            tempRecord.MS_Insurance_Revenue__c = c.Collected_Amount__c;
                        else
                            tempRecord.MS_Insurance_Revenue__c = 0;
                        tempRecord.CC_Insurance_Revenue__c = 0;
                        tempRecord.WSR_Insurance_Revenue__c = 0;
                    }
                    if(c.Opportunity__r.Sunshine_Center__r.Name == 'Chapters Capistrano'){
                        if(c.Collected_Amount__c != null)
                            tempRecord.CC_Insurance_Revenue__c = c.Collected_Amount__c;
                        else
                            tempRecord.CC_Insurance_Revenue__c = 0;
                        tempRecord.MS_Insurance_Revenue__c = 0;
                        tempRecord.WSR_Insurance_Revenue__c = 0;
                    }
                    if(c.Opportunity__r.Sunshine_Center__r.Name == 'Willow Springs'){
                        if(c.collected_amount__c != null)
                            tempRecord.WSR_Insurance_Revenue__c = c.Collected_Amount__c;
                        else
                            tempRecord.WSR_Insurance_Revenue__c = 0;
                        tempRecord.MS_Insurance_Revenue__c = 0;
                        tempRecord.CC_Insurance_Revenue__c = 0; 
                    }
                    tempMap.put(string.valueOf(c.Collection_Date__c), tempRecord);
                }
                if(c.Appeal_for_Adjustment_Requested__c == True){
                    if(tempMap.containsKey(string.valueOf(c.Adjustment_Collected_Date__c))){
                        Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                        tempRecord = tempMap.get(string.valueOf(c.Adjustment_Collected_Date__c));
                        if(c.Opportunity__r.Sunshine_Center__r.Name == 'Monarch Shores'){
                            if(c.Adjustment_Amount__c != null)
                                tempRecord.MS_Insurance_Revenue__c = tempRecord.MS_Insurance_Revenue__c + c.Adjustment_Amount__c;
                        }
                        if(c.Opportunity__r.Sunshine_Center__r.Name == 'Chapters Capistrano'){
                            if(c.Adjustment_Amount__c != null)
                                tempRecord.CC_Insurance_Revenue__c = tempRecord.CC_Insurance_Revenue__c + c.Adjustment_Amount__c;
                        }
                        if(c.Opportunity__r.Sunshine_Center__r.Name == 'Willow Springs'){
                            if(c.Adjustment_Amount__c != null)
                                tempRecord.WSR_Insurance_Revenue__c = tempRecord.WSR_Insurance_Revenue__c + c.Adjustment_Amount__c; 
                        }
                        tempMap.put(string.valueOf(c.Adjustment_Collected_Date__c), tempRecord);   
                    }else{
                        Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                        if(c.Opportunity__r.Sunshine_Center__r.Name == 'Monarch Shores'){
                            if(c.Adjustment_Amount__c != null)
                                tempRecord.MS_Insurance_Revenue__c = c.Adjustment_Amount__c;
                            else
                                tempRecord.MS_Insurance_Revenue__c = 0;
                            tempRecord.CC_Insurance_Revenue__c = 0;
                            tempRecord.WSR_Insurance_Revenue__c = 0;
                        }
                        if(c.Opportunity__r.Sunshine_Center__r.Name == 'Chapters Capistrano'){
                            if(c.Adjustment_Amount__c != null)
                                tempRecord.CC_Insurance_Revenue__c = c.Adjustment_Amount__c;
                            else
                                tempRecord.CC_Insurance_Revenue__c = 0;
                            tempRecord.MS_Insurance_Revenue__c = 0;
                            tempRecord.WSR_Insurance_Revenue__c = 0;
                        }
                        if(c.Opportunity__r.Sunshine_Center__r.Name == 'Willow Springs'){
                            if(c.Adjustment_Amount__c != null)
                                tempRecord.WSR_Insurance_Revenue__c = c.Adjustment_Amount__c;
                            else
                                tempRecord.WSR_Insurance_Revenue__c = 0;    
                            tempRecord.MS_Insurance_Revenue__c = 0;
                            tempRecord.CC_Insurance_Revenue__c = 0; 
                        } 
                        tempMap.put(string.valueOf(c.Adjustment_Collected_Date__c), tempRecord);
                    }
                }
                    
            }else{
                if(tempMap.containsKey(string.valueOf(c.Collection_Date__c))){
                    Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                    tempRecord = tempMap.get(string.valueOf(c.Collection_Date__c));
                    if(c.Opportunity__r.Sunshine_Center__r.Name == 'Monarch Shores'){
                        if(c.collected_amount__c != null)
                            tempRecord.MS_Insurance_Revenue__c = tempRecord.MS_Insurance_Revenue__c + c.Collected_Amount__c;
                    }
                    if(c.Opportunity__r.Sunshine_Center__r.Name == 'Chapters Capistrano'){
                        if(c.collected_amount__c != null)
                            tempRecord.CC_Insurance_Revenue__c = tempRecord.CC_Insurance_Revenue__c + c.Collected_Amount__c;
                    }
                    if(c.Opportunity__r.Sunshine_Center__r.Name == 'Willow Springs'){
                        if(c.collected_amount__c != null)
                            tempRecord.WSR_Insurance_Revenue__c = tempRecord.WSR_Insurance_Revenue__c + c.Collected_Amount__c; 
                    }
                    tempMap.put(string.valueOf(c.Collection_Date__c), tempRecord);   
                }else{
                    Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                    if(c.Opportunity__r.Sunshine_Center__r.Name == 'Monarch Shores'){
                        if(c.collected_amount__c != null)
                            tempRecord.MS_Insurance_Revenue__c = c.Collected_Amount__c;
                        else
                            tempRecord.MS_Insurance_Revenue__c = 0;
                        tempRecord.CC_Insurance_Revenue__c = 0;
                        tempRecord.WSR_Insurance_Revenue__c = 0;
                    }
                    if(c.Opportunity__r.Sunshine_Center__r.Name == 'Chapters Capistrano'){
                        if(c.collected_amount__c != null)
                            tempRecord.CC_Insurance_Revenue__c = c.Collected_Amount__c;
                        else
                            tempRecord.CC_Insurance_Revenue__c = 0;
                        tempRecord.MS_Insurance_Revenue__c = 0;
                        tempRecord.WSR_Insurance_Revenue__c = 0;
                    }
                    if(c.Opportunity__r.Sunshine_Center__r.Name == 'Willow Springs'){
                        if(c.collected_amount__c != null)
                            tempRecord.WSR_Insurance_Revenue__c = c.Collected_Amount__c;
                        else
                            tempRecord.WSR_Insurance_Revenue__c = 0;
                        tempRecord.MS_Insurance_Revenue__c = 0;
                        tempRecord.CC_Insurance_Revenue__c = 0; 
                    } 
                    tempMap.put(string.valueOf(c.Collection_Date__c), tempRecord);
                }
                
            }
                
        }
    }
        
    
    
    global void finish(Database.BatchableContext BC){
        
        system.debug('tempMap :::'+tempMap);
        
        List<Corporate_Finance_Deals_Information__c> cfdiUpdateList = new List<Corporate_Finance_Deals_Information__c>();
        List<Corporate_Finance_Deals_Information__c> cfdiInsertList = new List<Corporate_Finance_Deals_Information__c>();
        Map<String,Corporate_Finance_Deals_Information__c> createdDateCFDIMap = new Map<String,Corporate_Finance_Deals_Information__c>();
        
        String queryCFDI = 'Select id, CC_Insurance_Revenue__c, MS_Insurance_Revenue__c, WSR_Insurance_Revenue__c, Close_Date__c from Corporate_Finance_Deals_Information__c where Close_Date__c >='+closeFromDate;
        
        for(Corporate_Finance_Deals_Information__c cfdi : database.query(queryCFDI)){
            createdDateCFDIMap.put(string.valueOf(cfdi.Close_Date__c),cfdi);
        }
        
        if(createdDateCFDIMap.keySet().size()>0){
            for(String tempMapKey : tempMap.KeySet()){
                system.debug('tempMapKey ::'+tempMapKey);
                if(createdDateCFDIMap.containsKey(tempMapKey)){
                    Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                    tempRecord = createdDateCFDIMap.get(tempMapKey);
                    tempRecord.CC_Insurance_Revenue__c = tempMap.get(tempMapKey).CC_Insurance_Revenue__c;
                    tempRecord.MS_Insurance_Revenue__c = tempMap.get(tempMapKey).MS_Insurance_Revenue__c;
                    tempRecord.WSR_Insurance_Revenue__c = tempMap.get(tempMapKey).WSR_Insurance_Revenue__c;
                    tempRecord.Require_Integration__c = True;
                    cfdiUpdateList.add(tempRecord);
                }else{
                    Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                    system.debug('createdDateCFDIMap ::'+createdDateCFDIMap.get(tempMapKey));
                    tempRecord = tempMap.get(tempMapKey);
                    tempRecord.Require_Integration__c = True;
                    cfdiInsertList.add(tempRecord);
                }
            }
        }else{
            for(String tempMapKey : tempMap.KeySet()){
                system.debug('tempMapKey ::'+tempMapKey);
                Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                system.debug('createdDateCFDIMap ::'+createdDateCFDIMap.get(tempMapKey));
                    
                tempRecord = tempMap.get(tempMapKey);
                tempRecord.Require_Integration__c = True;
                cfdiInsertList.add(tempRecord);
            }
        }
        
        if(cfdiInsertList.size()>0){
            system.debug('cfdiInsertList ::::'+cfdiInsertList);
            insert cfdiInsertList;
            
        }
        if(cfdiUpdateList.size()>0){
            update cfdiUpdateList;    
            
        }    
        
        if(!Test.IsRunningTest()){
            CorporateFinancePPLISummarizeBatch obj1 = new CorporateFinancePPLISummarizeBatch();
            DataBase.executeBatch(obj1); 
        }  
    }
}