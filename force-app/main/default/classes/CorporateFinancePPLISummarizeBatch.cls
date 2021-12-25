/* Developer Name: Zoobeez Fatima
   Created Date: 8/25/2017
   Modified Date: 8/25/2017
   Purpose: Calculate CC,MS and WSR opportunities into respective feild of CFDI feilds of collecting revenue
  */
//Test Class: CorporateFinancePPLISummarizeBatchTest
global class CorporateFinancePPLISummarizeBatch implements Database.Batchable<sObject>, Database.Stateful{
    string query;
    string CFDIRecordId='';
    String ClosedStatus = 'Closed';

   
    Map<String,Corporate_Finance_Deals_Information__c> tempMap = new Map<String,Corporate_Finance_Deals_Information__c>();
    
    global CorporateFinancePPLISummarizeBatch (){
         String closeFromDate = string.valueOf(date.Today().addDays(-90));
        query = 'select id, Amount_For_Collection__c, Closed_Date__c, Payment_Plan__r.Opportunity__r.RecordTypeId, Payment_Plan__r.Opportunity__r.Sunshine_Center__r.name from Payment_Plan_Line_Items__c where Closed_Date__c >= '+closeFromDate+' AND (Status__c =\''+ClosedStatus +'\') ';
        if(Test.isRunningTest())
            query += ' limit 200';
   
    }
    
     global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('query :::'+query);
        return Database.getQueryLocator(query);
    }
  
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('test');
        Id msRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
          for(Payment_Plan_Line_Items__c PPL: (list<Payment_Plan_Line_Items__c >) scope){
              if(PPL.Payment_Plan__r.Opportunity__r.RecordTypeId==msRecTypeId){
                  if(PPL.Payment_Plan__r.Opportunity__r.Sunshine_Center__r.Name == 'Monarch Shores'){
                      if(tempMap.containsKey(string.valueOf(PPL.Closed_Date__c))){
                          Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                          tempRecord = tempMap.get(string.valueOf(ppl.Closed_Date__c));
                          if(tempRecord.MS_Cash_Revenue__c!= null){
                              if(PPL.Amount_For_Collection__c != null)
                                  tempRecord.MS_Cash_Revenue__c= tempRecord.MS_Cash_Revenue__c+PPL.Amount_For_Collection__c;
                          }else{
                              if(PPL.Amount_For_Collection__c != null)
                                  tempRecord.MS_Cash_Revenue__c= PPL.Amount_For_Collection__c;
                              else
                                  tempRecord.MS_Cash_Revenue__c=0;
                          }
                          tempMap.put(string.valueOf(ppl.Closed_Date__c), tempRecord);
                        }
                        else{
                            Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                            if(PPL.Amount_For_Collection__c != null)
                                tempRecord.MS_Cash_Revenue__c= PPL.Amount_For_Collection__c;
                            else
                                tempRecord.MS_Cash_Revenue__c=0;
                            tempRecord.Close_Date__c = ppl.Closed_Date__c;
                            tempMap.put(string.valueOf(ppl.Closed_Date__c), tempRecord);
                        }
                    }
                    
                    if(PPL.Payment_Plan__r.Opportunity__r.Sunshine_Center__r.Name == 'Chapters Capistrano'){
                      if(tempMap.containsKey(string.valueOf(PPL.Closed_Date__c))){
                          Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                          tempRecord = tempMap.get(string.valueOf(ppl.Closed_Date__c));
                          if(tempRecord.CC_Cash_Revenue__c!= null){
                              if(PPL.Amount_For_Collection__c != null)
                                  tempRecord.CC_Cash_Revenue__c = tempRecord.CC_Cash_Revenue__c+PPL.Amount_For_Collection__c;
                          }else{
                              if(PPL.Amount_For_Collection__c != null)
                                  tempRecord.CC_Cash_Revenue__c = PPL.Amount_For_Collection__c;
                              else
                                  tempRecord.CC_Cash_Revenue__c =0;
                          }
                          tempMap.put(string.valueOf(ppl.Closed_Date__c), tempRecord);
                        }
                        else{
                            Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                            if(PPL.Amount_For_Collection__c != null)
                                tempRecord.CC_Cash_Revenue__c = PPL.Amount_For_Collection__c;
                            else
                                tempRecord.CC_Cash_Revenue__c = 0;
                            tempRecord.Close_Date__c = ppl.Closed_Date__c;
                            tempMap.put(string.valueOf(ppl.Closed_Date__c), tempRecord);
                        }
                    }
                    
                    if(PPL.Payment_Plan__r.Opportunity__r.Sunshine_Center__r.Name == 'Willow Springs'){
                      if(tempMap.containsKey(string.valueOf(PPL.Closed_Date__c))){
                          Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                          tempRecord = tempMap.get(string.valueOf(ppl.Closed_Date__c));
                          if(tempRecord.WSR_Cash_Revenue__c!= null){
                              if(PPL.Amount_For_Collection__c != null)
                                  tempRecord.WSR_Cash_Revenue__c= tempRecord.WSR_Cash_Revenue__c+PPL.Amount_For_Collection__c;
                          }else{
                              if(PPL.Amount_For_Collection__c != null)
                                  tempRecord.WSR_Cash_Revenue__c= PPL.Amount_For_Collection__c;
                              else
                                  tempRecord.WSR_Cash_Revenue__c=0;
                          }
                          tempMap.put(string.valueOf(ppl.Closed_Date__c), tempRecord);
                        }
                        else{
                            Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                            if(PPL.Amount_For_Collection__c != null)
                                tempRecord.WSR_Cash_Revenue__c= PPL.Amount_For_Collection__c;
                            else
                                tempRecord.WSR_Cash_Revenue__c=0;
                            tempRecord.Close_Date__c = ppl.Closed_Date__c;
                            tempMap.put(string.valueOf(ppl.Closed_Date__c), tempRecord);
                        }
                    }
                }
            }   
        }
    
    global void finish(Database.BatchableContext BC){
    
        List<Corporate_Finance_Deals_Information__c> cfdiUpdateList = new List<Corporate_Finance_Deals_Information__c>();
        List<Corporate_Finance_Deals_Information__c> cfdiInsertList = new List<Corporate_Finance_Deals_Information__c>();
        Map<String,Corporate_Finance_Deals_Information__c> createdDateCFDIMap = new Map<String,Corporate_Finance_Deals_Information__c>();
        
        String fromDate = string.valueOf(date.Today().addDays(-90));
        String queryCFDI = 'Select id, WSR_Cash_Revenue__c, CC_Cash_Revenue__c, MS_Cash_Revenue__c, Close_Date__c from Corporate_Finance_Deals_Information__c where Close_Date__c >='+fromDate;
        
        for(Corporate_Finance_Deals_Information__c cfdi : database.query(queryCFDI)){
            createdDateCFDIMap.put(string.valueOf(cfdi.Close_Date__c),cfdi);
        }
        
        
        if(createdDateCFDIMap.keySet().size()>0){
            for(String tempMapKey : tempMap.KeySet()){
                system.debug('tempMapKey ::'+tempMapKey);
                if(createdDateCFDIMap.containsKey(tempMapKey)){
                    Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                    tempRecord = createdDateCFDIMap.get(tempMapKey);
                    tempRecord.WSR_Cash_Revenue__c= tempMap.get(tempMapKey).WSR_Cash_Revenue__c;
                    tempRecord.CC_Cash_Revenue__c= tempMap.get(tempMapKey).CC_Cash_Revenue__c;
                    tempRecord.MS_Cash_Revenue__c= tempMap.get(tempMapKey).MS_Cash_Revenue__c;
                    tempRecord.Require_Integration__c = True;
                    cfdiUpdateList.add(tempRecord);
                }else{
                    Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                    tempRecord = tempMap.get(tempMapKey);
                    tempRecord.Require_Integration__c = True;
                    cfdiInsertList.add(tempRecord);
                }
            }
        }
        else{
            for(String tempMapKey : tempMap.KeySet()){
                Corporate_Finance_Deals_Information__c tempRecord = new Corporate_Finance_Deals_Information__c();
                    
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
            CorporateFinanceRevenueIntegrationBatch obj1 = new CorporateFinanceRevenueIntegrationBatch();
            DataBase.executeBatch(obj1,1); 
        }  
          
    }
   
 
}