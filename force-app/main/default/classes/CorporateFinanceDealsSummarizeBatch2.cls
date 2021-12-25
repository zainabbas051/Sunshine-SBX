//Test Class : CorporateFinanceDealsSummarizeBatchTest
global class CorporateFinanceDealsSummarizeBatch2 implements Database.Batchable<sObject>, Database.Stateful{
    
    string query;
    string CFDIRecordId='';
    Map<String,Corporate_Finance_Deals_Information__c> tempMap = new Map<String,Corporate_Finance_Deals_Information__c>();
    
    global CorporateFinanceDealsSummarizeBatch2(){
        String closeFromDate = string.valueOf(date.Today().addDays(-90));
        String rescuedStage = 'Rescued';
        String admittedStage = 'Admitted';
        String dischargedStage = 'Discharged';
        query = 'select id, StageName, RecordTypeId, Sunshine_Center__r.name, Sunshine_Center__r.Corporate_Finance_ID__c, LastModifiedDate, CreatedDate, LeadSource, CloseDate, Amount from Opportunity where CloseDate >= '+closeFromDate+' AND (StageName =\''+rescuedStage+'\' OR StageName=\''+admittedStage+'\' OR StageName =\''+dischargedStage+'\')';
        if(Test.isRunningTest())
            query += ' limit 200';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('query :::'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('test');
        
        Id erpRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId();
        Id msRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        
        for(Opportunity opp : (list<Opportunity>) scope){
            if(opp.RecordTypeId == erpRecTypeId){
                if(tempMap.containsKey(string.valueOf(opp.CloseDate))){
                    Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                    tempRecord = tempMap.get(string.valueOf(opp.CloseDate));
                    if(tempRecord.no_of_erp_closed__c != null)
                        tempRecord.no_of_erp_closed__c = tempRecord.no_of_erp_closed__c+1;
                    else
                        tempRecord.no_of_erp_closed__c = 1;
                    if(tempRecord.Total_ERP_Revenue__c != null){
                        if(opp.Amount!=null)
                            tempRecord.Total_ERP_Revenue__c = tempRecord.Total_ERP_Revenue__c + opp.Amount;
                    }else{
                        if(opp.Amount != null)
                            tempRecord.Total_ERP_Revenue__c = opp.Amount;
                    }
                    tempMap.put(string.valueOf(opp.CloseDate), tempRecord);
                }else{
                    Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                    tempRecord.no_of_erp_closed__c = 1;
                    if(opp.Amount != null)
                        tempRecord.Total_ERP_Revenue__c = opp.Amount;
                    tempRecord.Close_Date__c = opp.CloseDate;
                    tempMap.put(string.valueOf(opp.CloseDate), tempRecord);
                }
            }
            
            if(opp.RecordTypeId == msRecTypeId){
                if(opp.Sunshine_Center__r.Name == 'Monarch Shores'){
                    if(tempMap.containsKey(string.valueOf(opp.CloseDate))){
                        Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                        tempRecord = tempMap.get(string.valueOf(opp.CloseDate));
                        if(tempRecord.no_of_ms_closed__c != null)
                            tempRecord.no_of_ms_closed__c = tempRecord.no_of_ms_closed__c+1;
                        else
                            tempRecord.no_of_ms_closed__c = 1;
                        tempMap.put(string.valueOf(opp.CloseDate), tempRecord);
                    }else{
                        Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                        tempRecord.no_of_ms_closed__c = 1;
                        tempRecord.Close_Date__c = opp.CloseDate;
                        tempMap.put(string.valueOf(opp.CloseDate), tempRecord);
                    }
                }
                if(opp.Sunshine_Center__r.Name == 'Monarch Shores' && opp.LeadSource != 'Elite Rehab Placement'){
                    if(tempMap.containsKey(string.valueOf(opp.CloseDate))){
                        Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                        tempRecord = tempMap.get(string.valueOf(opp.CloseDate));
                        if(tempRecord.unique_no_of_ms__c != null)
                            tempRecord.unique_no_of_ms__c = tempRecord.unique_no_of_ms__c+1;
                        else
                            tempRecord.unique_no_of_ms__c = 1;
                        tempMap.put(string.valueOf(opp.CloseDate), tempRecord);
                    }else{
                        Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                        tempRecord.unique_no_of_ms__c = 1;
                        tempRecord.Close_Date__c = opp.CloseDate;
                        tempMap.put(string.valueOf(opp.CloseDate), tempRecord);
                    }
                }
                if(opp.Sunshine_Center__r.Name == 'Chapters Capistrano'){
                    if(tempMap.containsKey(string.valueOf(opp.CloseDate))){
                        Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                        tempRecord = tempMap.get(string.valueOf(opp.CloseDate));
                        if(tempRecord.no_of_cc_closed__c != null)
                            tempRecord.no_of_cc_closed__c = tempRecord.no_of_cc_closed__c+1;
                        else
                            tempRecord.no_of_cc_closed__c = 1;
                        tempMap.put(string.valueOf(opp.CloseDate), tempRecord);
                    }else{
                        Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                        tempRecord.no_of_cc_closed__c = 1;
                        tempRecord.Close_Date__c = opp.CloseDate;
                        tempMap.put(string.valueOf(opp.CloseDate), tempRecord);
                    }
                }
                if(opp.Sunshine_Center__r.Name == 'Chapters Capistrano' && opp.LeadSource != 'Elite Rehab Placement'){
                    if(tempMap.containsKey(string.valueOf(opp.CloseDate))){
                        Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                        tempRecord = tempMap.get(string.valueOf(opp.CloseDate));
                        if(tempRecord.unique_no_of_cc__c != null)
                            tempRecord.unique_no_of_cc__c = tempRecord.unique_no_of_cc__c+1;
                        else
                            tempRecord.unique_no_of_cc__c = 1;
                        tempMap.put(string.valueOf(opp.CloseDate), tempRecord);
                    }else{
                        Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                        tempRecord.unique_no_of_cc__c = 1;
                        tempRecord.Close_Date__c = opp.CloseDate;
                        tempMap.put(string.valueOf(opp.CloseDate), tempRecord);
                    }
                }
                if(opp.Sunshine_Center__r.Name == 'Willow Springs'){
                    if(tempMap.containsKey(string.valueOf(opp.CloseDate))){
                        Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                        tempRecord = tempMap.get(string.valueOf(opp.CloseDate));
                        if(tempRecord.no_of_wsr_closed__c != null)
                            tempRecord.no_of_wsr_closed__c = tempRecord.no_of_wsr_closed__c+1;
                        else
                            tempRecord.no_of_wsr_closed__c = 1;
                        tempMap.put(string.valueOf(opp.CloseDate), tempRecord);
                    }else{
                        Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                        tempRecord.no_of_wsr_closed__c = 1;
                        tempRecord.Close_Date__c = opp.CloseDate;
                        tempMap.put(string.valueOf(opp.CloseDate), tempRecord);
                    }
                }
                if(opp.Sunshine_Center__r.Name == 'Willow Springs' && opp.LeadSource != 'Elite Rehab Placement'){
                    if(tempMap.containsKey(string.valueOf(opp.CloseDate))){
                        Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                        tempRecord = tempMap.get(string.valueOf(opp.CloseDate));
                        if(tempRecord.unique_no_of_wsr__c != null)
                            tempRecord.unique_no_of_wsr__c = tempRecord.unique_no_of_wsr__c+1;
                        else
                            tempRecord.unique_no_of_wsr__c = 1;
                        tempMap.put(string.valueOf(opp.CloseDate), tempRecord);
                    }else{
                        Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                        tempRecord.unique_no_of_wsr__c = 1;
                        tempRecord.Close_Date__c = opp.CloseDate;
                        tempMap.put(string.valueOf(opp.CloseDate), tempRecord);
                    }
                }
            }
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        
        system.debug('tempMap :::'+tempMap);
        
        List<Corporate_Finance_Deals_Information__c> cfdiUpdateList = new List<Corporate_Finance_Deals_Information__c>();
        List<Corporate_Finance_Deals_Information__c> cfdiInsertList = new List<Corporate_Finance_Deals_Information__c>();
        Map<String,Corporate_Finance_Deals_Information__c> createdDateCFDIMap = new Map<String,Corporate_Finance_Deals_Information__c>();
        
        String fromDate = string.valueOf(date.Today().addDays(-90));
        String queryCFDI = 'Select id, no_of_erp_closed__c, no_of_ms_closed__c, unique_no_of_ms__c, no_of_cc_closed__c, unique_no_of_cc__c, no_of_wsr_closed__c, unique_no_of_wsr__c, Close_Date__c, Total_ERP_Revenue__c from Corporate_Finance_Deals_Information__c where Close_Date__c >='+fromDate;
        
        for(Corporate_Finance_Deals_Information__c cfdi : database.query(queryCFDI)){
            createdDateCFDIMap.put(string.valueOf(cfdi.Close_Date__c),cfdi);
        }
        
        if(createdDateCFDIMap.keySet().size()>0){
            for(String tempMapKey : tempMap.KeySet()){
                system.debug('tempMapKey ::'+tempMapKey);
                if(createdDateCFDIMap.containsKey(tempMapKey)){
                    Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                    tempRecord = createdDateCFDIMap.get(tempMapKey);
                    tempRecord.no_of_erp_closed__c = tempMap.get(tempMapKey).no_of_erp_closed__c;
                    tempRecord.no_of_ms_closed__c = tempMap.get(tempMapKey).no_of_ms_closed__c;
                    tempRecord.unique_no_of_ms__c = tempMap.get(tempMapKey).unique_no_of_ms__c;
                    tempRecord.no_of_cc_closed__c = tempMap.get(tempMapKey).no_of_cc_closed__c;
                    tempRecord.unique_no_of_cc__c = tempMap.get(tempMapKey).unique_no_of_cc__c;
                    tempRecord.no_of_wsr_closed__c = tempMap.get(tempMapKey).no_of_wsr_closed__c;
                    tempRecord.unique_no_of_wsr__c = tempMap.get(tempMapKey).unique_no_of_wsr__c;
                    tempRecord.Total_ERP_Revenue__c = tempMap.get(tempMapKey).Total_ERP_Revenue__c;
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
            CorporateFinanceCasesSummarizeBatch obj1 = new CorporateFinanceCasesSummarizeBatch();
            DataBase.executeBatch(obj1); 
        }
    }
}