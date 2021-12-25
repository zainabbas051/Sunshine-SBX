//Test Class : Utilities_Analytics_Batches_Test
global class Utilities_Analytics_AllOpenCasesBatch implements Database.Batchable<sObject>{
    
    string query;
    
    global Utilities_Analytics_AllOpenCasesBatch(){
        query = 'select id from Account where Temp_Flag__c = True AND Type = \'Insurance Provider\'';
        if(Test.isRunningTest())
            query += ' limit 200';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('test');
        
        List<Id> accIdList = new List<Id>();
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
            //Date oneYearOldDate = date.Today().addYears(-1);
            for(Case c : [Select id, Bill_Date__c, Billed_Amount__c, Opportunity__c, Opportunity__r.Insurance_Provider__c from Case where Opportunity__c IN: oppListId AND isClosed =: False]){
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
            if(accountIdCaseListMap.keySet().size()>0){
                for(id accId : accountIdCaseListMap.keySet()){
                    double tier30Denominator=0.0;
                    double tier60Denominator=0.0;
                    double tier90Denominator=0.0;
                    double tier120Denominator=0.0;
                    double tier150Denominator=0.0;
                    double tier180Denominator=0.0;
                    double tier210Denominator=0.0;
                    double tier240Denominator=0.0;
                    double tier270Denominator=0.0;
                    double tier300Denominator=0.0;
                    double tier330Denominator=0.0;
                    double tier360Denominator=0.0;
                    
                    for(Case c : accountIdCaseListMap.get(accId)){
                        If(c.Bill_Date__c != null && c.Billed_Amount__c != Null){
                            
                            integer collectionTier = c.Bill_Date__c.daysBetween(Date.today());
                            if(collectionTier >=0 && collectionTier <= 30){
                                tier30Denominator = tier30Denominator + c.Billed_Amount__c;
                               
                            }
                            else if(collectionTier >30 && collectionTier <= 60){
                                tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                
                            }
                            else if(collectionTier >60 && collectionTier <= 90){
                                tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                            }
                            else if(collectionTier >90 && collectionTier <= 120){
                                tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                            }
                            else if(collectionTier >120 && collectionTier <= 150){
                                tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                            }
                            else if(collectionTier >150 && collectionTier <= 180){
                                tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                            }
                             if(collectionTier >180 && collectionTier <= 210){
                                tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                            }
                            else if(collectionTier >210 && collectionTier <= 240){
                                tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                            }
                            else if(collectionTier >240 && collectionTier <= 270){
                                tier270Denominator = tier270Denominator + c.Billed_Amount__c;
                            }
                            else if(collectionTier >270 && collectionTier <= 300){
                                tier300Denominator = tier300Denominator + c.Billed_Amount__c;
                            }
                            else if(collectionTier >300 && collectionTier <= 330){
                                tier330Denominator = tier330Denominator + c.Billed_Amount__c;
                            }
                            else if(collectionTier >330){
                                tier360Denominator = tier360Denominator + c.Billed_Amount__c;
                            }  
                        }
                                 
                    }
                        
                    Account acc = new Account(id=accId, Temp_Flag__c = False);
                    acc.X0_to_30_Days_Open_Claims__c = tier30Denominator    ;
                    acc.X30_to_60_Days_Open_Claims__c = tier60Denominator;
                    acc.X60_to_90_Days_Open_Claims__c = tier90Denominator; 
                    acc.X90_to_120_Days_Open_Claims__c = tier120Denominator;
                    acc.X120_to_150_Days_Open_Claims__c = tier150Denominator; 
                    acc.X150_to_180_Days_Open_Claims__c = tier180Denominator;
                    acc.X180_to_210_Days_Open_Claims__c = tier210Denominator; 
                    acc.X210_to_240_Days_Open_Claims__c = tier240Denominator;
                    acc.X240_to_270_Days_Open_Claims__c = tier270Denominator; 
                    acc.X270_to_300_Days_Open_Claims__c = tier300Denominator;
                    acc.X300_to_330_Days_Open_Claims__c = tier330Denominator; 
                    acc.X330_Days_and_Above_Open_Claims__c = tier360Denominator;
                    
                    accUpdateList.add(acc); 
                    accIdSet.add(acc.id);
                
                }
            }
        }
        
        
        
        for(Id accId : accIdList){
            if(!accIdSet.contains(accId)){
                Account acc = new Account(id=accId, Temp_Flag__c = False);
                acc.X0_to_30_Days_Open_Claims__c = 0.0;
                acc.X30_to_60_Days_Open_Claims__c = 0.0;
                acc.X60_to_90_Days_Open_Claims__c = 0.0; 
                acc.X90_to_120_Days_Open_Claims__c = 0.0;
                acc.X120_to_150_Days_Open_Claims__c = 0.0; 
                acc.X150_to_180_Days_Open_Claims__c = 0.0;
                acc.X180_to_210_Days_Open_Claims__c = 0.0; 
                acc.X210_to_240_Days_Open_Claims__c = 0.0;
                acc.X240_to_270_Days_Open_Claims__c = 0.0; 
                acc.X270_to_300_Days_Open_Claims__c = 0.0;
                acc.X300_to_330_Days_Open_Claims__c = 0.0; 
                acc.X330_Days_and_Above_Open_Claims__c = 0.0;
                accUpdateList.add(acc); 
            }
        }
        if(accUpdateList.size()>0)
            update accUpdateList;
    
    }
    
    global void finish(Database.BatchableContext BC){
        Utilities_Analytics_1YRClosedCasesBatch b = new Utilities_Analytics_1YRClosedCasesBatch();
        database.executebatch(b,75);
    }
}