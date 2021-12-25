//Test Class : ReimbursementRate_Batches_Test
global class ReimbursementRate_Analytics_Batch_Old implements Database.Batchable<sObject>{
    
    string query;
    
    global ReimbursementRate_Analytics_Batch_Old(){
        query = 'select id from Account where Reimbursement_Rate_Temp_Flag__c = False AND Type = \'Insurance Provider\'';
        if(Test.isRunningTest())
            query += ' limit 200';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('test');
        
        List<Id> accIdList = new List<Id>();
        Map<Id,Boolean> accIdAlphaPrefixMap = new Map<Id,Boolean>();
        Set<Id> accIdSet = new Set<Id>();
        List<Id> oppListId = new List<Id>();
        Map<Id,List<Case>> accountIdCaseListMap = new Map<Id,List<Case>>();
        List<Account> accUpdateList = new List<Account>();
        
        for(Account acc : (list<Account>) scope){
            accIdList.add(acc.id);
        }
        
        for(Opportunity opp : [Select id from Opportunity where Insurance_Provider__c IN: accIdList]){
            oppListId.add(opp.id);
        }
        
        if(oppListId.size()>0){
            //Date sixMonthsOldDate = date.Today().addMonths(-6);
            Date sixMonthsOldDate = date.newinstance(2019, 10, 1);
            for(Case c : [Select id, Opportunity__r.Insurance_Provider__c, Sunshine_Center__c, isClosed, Total_Collected_Amount__c, Billed_Amount__c from Case where Opportunity__c IN: oppListId AND isClosed =: True AND Bill_From_Date__c >=: sixMonthsOldDate AND Level_of_Care__c !=: 'Lab Requests']){
                if(c.Opportunity__r.Insurance_Provider__c!=null){
                    if(accountIdCaseListMap.containsKey(c.Opportunity__r.Insurance_Provider__c)){
                        List<Case> tempList = new List<Case>();
                        tempList = accountIdCaseListMap.get(c.Opportunity__r.Insurance_Provider__c);
                        tempList.add(c);
                        accountIdCaseListMap.put(c.Opportunity__r.Insurance_Provider__c,tempList);
                    }else{
                        List<Case> tempList = new List<Case>();
                        tempList.add(c);
                        accountIdCaseListMap.put(c.Opportunity__r.Insurance_Provider__c,tempList);
                    }
                }
            } 
            if(accountIdCaseListMap.keySet().size()>0){
                
                for(id accId : accountIdCaseListMap.keySet()){
                        
                    double ccTotalCollectedAmount=0.0;
                    double ccTotalBilledAmount=0.0;
                    double msTotalCollectedAmount=0.0;
                    double msTotalBilledAmount=0.0;
                    double wsTotalCollectedAmount=0.0;
                    double wsTotalBilledAmount=0.0;
                    double msrTotalCollectedAmount=0.0;
                    double msrTotalBilledAmount=0.0;
                    
                    for(Case c : accountIdCaseListMap.get(accId)){
                        if(c.Sunshine_Center__c.contains('Chapter')){
                            if(c.Total_Collected_Amount__c != null && c.isClosed == True){
                                ccTotalCollectedAmount = ccTotalCollectedAmount+c.Total_Collected_Amount__c;
                            }
                            if(c.Billed_Amount__c != null){
                                ccTotalBilledAmount = ccTotalBilledAmount+c.Billed_Amount__c;
                            }
                        }
                        if(c.Sunshine_Center__c.contains('Monarch')){
                            if(c.Total_Collected_Amount__c != null && c.isClosed == True){
                                msTotalCollectedAmount = msTotalCollectedAmount+c.Total_Collected_Amount__c;
                            }
                            if(c.Billed_Amount__c != null){
                                msTotalBilledAmount = msTotalBilledAmount+c.Billed_Amount__c;
                            }
                        }
                        if(c.Sunshine_Center__c.contains('Willow')){
                            if(c.Total_Collected_Amount__c != null && c.isClosed == True){
                                wsTotalCollectedAmount = wsTotalCollectedAmount+c.Total_Collected_Amount__c;
                            }
                            if(c.Billed_Amount__c != null){
                                wsTotalBilledAmount = wsTotalBilledAmount+c.Billed_Amount__c;
                            }
                        }
                        if(c.Sunshine_Center__c.contains('Mountain')){
                            if(c.Total_Collected_Amount__c != null && c.isClosed == True){
                                msrTotalCollectedAmount = msrTotalCollectedAmount+c.Total_Collected_Amount__c;
                            }
                            if(c.Billed_Amount__c != null){
                                msrTotalBilledAmount = msrTotalBilledAmount+c.Billed_Amount__c;
                            }
                        }             
                    }
                    
                    Account acc = new Account(id=accId, Reimbursement_Rate_Temp_Flag__c = True);
                    acc.Chapters_Total_Billed_Amount__c = ccTotalBilledAmount;
                    acc.Chapters_Total_Collected_Amount__c = ccTotalCollectedAmount;
                    acc.Willow_Total_Billed_Amount__c = wsTotalBilledAmount;
                    acc.Willow_Total_Collected_Amount__c = wsTotalCollectedAmount;
                    acc.Monarch_Total_Billed_Amount__c = msTotalBilledAmount;
                    acc.Monarch_Total_Collected_Amount__c = msTotalCollectedAmount;
                    acc.Mountain_Total_Billed_Amount__c = msrTotalBilledAmount;
                    acc.Mountain_Total_Collected_Amount__c = msrTotalCollectedAmount;
                    accUpdateList.add(acc); 
                    accIdSet.add(acc.id);
                }
            }
        }
        
        
        for(Id accId : accIdList){
            if(!accIdSet.contains(accId)){
                Account acc = new Account(id=accId, Reimbursement_Rate_Temp_Flag__c = True, Chapters_Total_Billed_Amount__c = 0.0,Chapters_Total_Collected_Amount__c = 0.0,
                                            Willow_Total_Billed_Amount__c = 0.0, Willow_Total_Collected_Amount__c = 0.0, Monarch_Total_Billed_Amount__c = 0.0,
                                            Monarch_Total_Collected_Amount__c = 0.0,Mountain_Total_Billed_Amount__c = 0.0,Mountain_Total_Collected_Amount__c = 0.0);
                accUpdateList.add(acc); 
            }
        }
        if(accUpdateList.size()>0)
            update accUpdateList;
        
        
    
    }
    
    global void finish(Database.BatchableContext BC){
        ReimbursementRate_Analytics_HelperBatch b = new ReimbursementRate_Analytics_HelperBatch();
        database.executebatch(b,200);
    }
}