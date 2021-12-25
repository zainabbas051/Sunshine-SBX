//Test Class : TestSummarizeCases
global class SummarizeCases implements Database.Batchable<sObject>{
    
    string query;
    
    global SummarizeCases(){
        //query = 'select id, Last_Activity_on_Cases_Date__c, (select id, Billed_Amount__c, Total_Collected_Amount__c, Deductible_Amount__c, Co_Pay_Amounselect id from Account where Type =: 'Insurance Provider' AND Temp_Flag__c =: Falset__c, Last_Modified_Date_Time__c, Status, Level_of_Care__c, Total_Number_of_Days_Billed__c, Bill_From_Date__c, Bill_To_Date__c  from Cases__r) from Opportunity where RecordType.Name = \'Monarch Shores\'';
        query = 'select id from Account where Temp_Flag__c = False AND Type = \'Insurance Provider\'';
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
        List<Id> caseIdList = new List<Id>();
        Map<Id,List<Collection_Line_Item__c>> caseCLIMap = new Map<Id,List<Collection_Line_Item__c>>();
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
            for(Case c : [Select id, ClosedDate, Collection_Date__c, Bill_Date__c, Billed_Amount__c, Opportunity__c, Opportunity__r.Insurance_Provider__c from Case where Opportunity__c IN: oppListId AND isClosed =: True]){
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
                caseIdList.add(c.id);
            } 
            if(caseIdList.size()>0){
                for(Collection_Line_Item__c cli : [Select id, Case__c, Collection_Amount__c, Type_of_Collection__c, Collection_Date__c from Collection_Line_Item__c 
                                                   where Case__c IN: caseIdList AND (Type_of_Collection__c =: 'Original bill' OR Type_of_Collection__c =: 'Re-bill' OR Type_of_Collection__c =: 'Forwarded Recoupment' OR Type_of_Collection__c =: 'Appeal for adjustment')]){
                    if(caseCLIMap.containsKey(cli.Case__c)){
                        List<Collection_Line_Item__c> tempList = new List<Collection_Line_Item__c>();
                        tempList = caseCLIMap.get(cli.Case__c);
                        tempList.add(cli);
                        caseCLIMap.put(cli.Case__c,tempList);
                    }else{
                        List<Collection_Line_Item__c> tempList = new List<Collection_Line_Item__c>();
                        tempList.add(cli);
                        caseCLIMap.put(cli.Case__c,tempList);
                    }
                }
                for(id accId : accountIdCaseListMap.keySet()){
                    double tier30Numerator=0.0;
                    double tier30Denominator=0.0;
                    double tier60Numerator=0.0;
                    double tier60Denominator=0.0;
                    double tier90Numerator=0.0;
                    double tier90Denominator=0.0;
                    double tier120Numerator=0.0;
                    double tier120Denominator=0.0;
                    double tier150Numerator=0.0;
                    double tier150Denominator=0.0;
                    double tier180Numerator=0.0;
                    double tier180Denominator=0.0;
                    double tier210Numerator=0.0;
                    double tier210Denominator=0.0;
                    double tier240Numerator=0.0;
                    double tier240Denominator=0.0;
                    double tier270Numerator=0.0;
                    double tier270Denominator=0.0;
                    double tier300Numerator=0.0;
                    double tier300Denominator=0.0;
                    double tier330Numerator=0.0;
                    double tier330Denominator=0.0;
                    double tier360Numerator=0.0;
                    double tier360Denominator=0.0;
                    
                    for(Case c : accountIdCaseListMap.get(accId)){
                        if(caseCLIMap.containsKey(c.id)){//Checking to see if CLI Exists for a Case, which means that Collection Actually took place for it.
                            for(Collection_Line_Item__c cli : caseCLIMap.get(c.id)){
                                 If((c.ClosedDate != null || cli.Collection_Date__c != null) && c.Billed_Amount__c != Null && c.Billed_Amount__c != 0 && cli.Collection_Amount__c != Null && cli.Collection_Amount__c != 0){
                                    //double percentageOfCollected = (cli.Collection_Amount__c / c.Billed_Amount__c)*100;
                                    
                                    integer collectionTier = 0;
                                    if(cli.Collection_Date__c != null)//Checking to see if the collection date is available
                                        collectionTier = c.Bill_Date__c.daysBetween(cli.Collection_Date__c);
                                    else//If no collection Date is present, then we will be using the case closed date
                                        collectionTier = c.Bill_Date__c.daysBetween(date.ValueOf(c.ClosedDate));
                                        
                                    if(collectionTier >=0 && collectionTier <= 30){
                                        tier30Numerator = tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator = tier30Denominator + c.Billed_Amount__c;
                                       
                                        //tier30 = tier30+percentageOfCollected;
                                        //tier30Timer++;
                                        system.debug('Tier 30 Numerator :::'+tier30Numerator);
                                        system.debug('Tier 30 Denominator :::'+tier30Denominator);
                                    }
                                    else if(collectionTier >30 && collectionTier <= 60){
                                        tier30Numerator = tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator = tier30Denominator + c.Billed_Amount__c;
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        
                                    }
                                    else if(collectionTier >60 && collectionTier <= 90){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        
                                    }
                                    else if(collectionTier >90 && collectionTier <= 120){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        
                                        tier120Numerator = tier120Numerator + cli.Collection_Amount__c;
                                        tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                        
                                    }
                                    else if(collectionTier >120 && collectionTier <= 150){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        
                                        tier120Numerator = tier120Numerator + cli.Collection_Amount__c;
                                        tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                        
                                        tier150Numerator = tier150Numerator + cli.Collection_Amount__c;
                                        tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                        
                                    }
                                    else if(collectionTier >150 && collectionTier <= 180){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        
                                        tier120Numerator = tier120Numerator + cli.Collection_Amount__c;
                                        tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                        
                                        tier150Numerator = tier150Numerator + cli.Collection_Amount__c;
                                        tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                        
                                        tier180Numerator = tier180Numerator + cli.Collection_Amount__c;
                                        tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                        
                                    }
                                     if(collectionTier >180 && collectionTier <= 210){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        
                                        tier120Numerator = tier120Numerator + cli.Collection_Amount__c;
                                        tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                        
                                        tier150Numerator = tier150Numerator + cli.Collection_Amount__c;
                                        tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                        
                                        tier180Numerator = tier180Numerator + cli.Collection_Amount__c;
                                        tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                        
                                        tier210Numerator = tier210Numerator + cli.Collection_Amount__c;
                                        tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                    }
                                    else if(collectionTier >210 && collectionTier <= 240){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        
                                        tier120Numerator = tier120Numerator + cli.Collection_Amount__c;
                                        tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                        
                                        tier150Numerator = tier150Numerator + cli.Collection_Amount__c;
                                        tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                        
                                        tier180Numerator = tier180Numerator + cli.Collection_Amount__c;
                                        tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                        
                                        tier210Numerator = tier210Numerator + cli.Collection_Amount__c;
                                        tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                        
                                        tier240Numerator = tier240Numerator + cli.Collection_Amount__c;
                                        tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                        
                                    }
                                    else if(collectionTier >240 && collectionTier <= 270){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        
                                        tier120Numerator = tier120Numerator + cli.Collection_Amount__c;
                                        tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                        
                                        tier150Numerator = tier150Numerator + cli.Collection_Amount__c;
                                        tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                        
                                        tier180Numerator = tier180Numerator + cli.Collection_Amount__c;
                                        tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                        
                                        tier210Numerator = tier210Numerator + cli.Collection_Amount__c;
                                        tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                        
                                        tier240Numerator = tier240Numerator + cli.Collection_Amount__c;
                                        tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                        
                                        tier270Numerator = tier270Numerator + cli.Collection_Amount__c;
                                        tier270Denominator = tier270Denominator + c.Billed_Amount__c;
                                    }
                                    else if(collectionTier >270 && collectionTier <= 300){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        
                                        tier120Numerator = tier120Numerator + cli.Collection_Amount__c;
                                        tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                        
                                        tier150Numerator = tier150Numerator + cli.Collection_Amount__c;
                                        tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                        
                                        tier180Numerator = tier180Numerator + cli.Collection_Amount__c;
                                        tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                        
                                        tier210Numerator = tier210Numerator + cli.Collection_Amount__c;
                                        tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                        
                                        tier240Numerator = tier240Numerator + cli.Collection_Amount__c;
                                        tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                    
                                        tier270Numerator = tier270Numerator + cli.Collection_Amount__c;
                                        tier270Denominator = tier270Denominator + c.Billed_Amount__c;
                                        
                                        tier300Numerator = tier300Numerator + cli.Collection_Amount__c;
                                        tier300Denominator = tier300Denominator + c.Billed_Amount__c;
                                    }
                                    else if(collectionTier >300 && collectionTier <= 330){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        
                                        tier120Numerator = tier120Numerator + cli.Collection_Amount__c;
                                        tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                        
                                        tier150Numerator = tier150Numerator + cli.Collection_Amount__c;
                                        tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                        
                                        tier180Numerator = tier180Numerator + cli.Collection_Amount__c;
                                        tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                        
                                        tier210Numerator = tier210Numerator + cli.Collection_Amount__c;
                                        tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                        
                                        tier240Numerator = tier240Numerator + cli.Collection_Amount__c;
                                        tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                        
                                        tier270Numerator = tier270Numerator + cli.Collection_Amount__c;
                                        tier270Denominator = tier270Denominator + c.Billed_Amount__c;
                                        
                                        tier300Numerator = tier300Numerator + cli.Collection_Amount__c;
                                        tier300Denominator = tier300Denominator + c.Billed_Amount__c;
                                        
                                        tier330Numerator = tier330Numerator + cli.Collection_Amount__c;
                                        tier330Denominator = tier330Denominator + c.Billed_Amount__c;
                                    }
                                    else if(collectionTier >330){
                                        tier30Numerator=tier30Numerator + cli.Collection_Amount__c;
                                        tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                        
                                        tier60Numerator = tier60Numerator + cli.Collection_Amount__c;
                                        tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                        
                                        tier90Numerator = tier90Numerator + cli.Collection_Amount__c;
                                        tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                        
                                        tier120Numerator = tier120Numerator + cli.Collection_Amount__c;
                                        tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                        
                                        tier150Numerator = tier150Numerator + cli.Collection_Amount__c;
                                        tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                        
                                        tier180Numerator = tier180Numerator + cli.Collection_Amount__c;
                                        tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                        
                                        tier210Numerator = tier210Numerator + cli.Collection_Amount__c;
                                        tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                        
                                        tier240Numerator = tier240Numerator + cli.Collection_Amount__c;
                                        tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                        
                                        tier270Numerator = tier270Numerator + cli.Collection_Amount__c;
                                        tier270Denominator = tier270Denominator + c.Billed_Amount__c;
                                        
                                        tier300Numerator = tier300Numerator + cli.Collection_Amount__c;
                                        tier300Denominator = tier300Denominator + c.Billed_Amount__c;
                                        
                                        tier330Numerator = tier330Numerator + cli.Collection_Amount__c;
                                        tier330Denominator = tier330Denominator + c.Billed_Amount__c;
                                        
                                        tier360Numerator = tier360Numerator + cli.Collection_Amount__c;
                                        tier360Denominator = tier360Denominator + c.Billed_Amount__c;
                                    }    
                                }   
                            }    
                        }else{//If No CLI Exists for a Case, that means $0 Collection was collected on it. In these Cases, We still need to include the Denominator value for collection.
                            If((c.ClosedDate != null || c.Collection_Date__c != null) && c.Billed_Amount__c != Null ){
                                 
                                integer collectionTier = 0;
                                if(c.Collection_Date__c != null)//Checking to see if the Collection Date is available on the Case
                                    collectionTier = c.Bill_Date__c.daysBetween(c.Collection_Date__c);
                                else//If no Collection Date is available on the case, then we will simply use the Case Close Date
                                    collectionTier = c.Bill_Date__c.daysBetween(date.ValueOf(c.ClosedDate));
                                
                                if(collectionTier >=0 && collectionTier <= 30){
                                    tier30Denominator = tier30Denominator + c.Billed_Amount__c;
                                   
                                }
                                else if(collectionTier >30 && collectionTier <= 60){
                                    tier30Denominator = tier30Denominator + c.Billed_Amount__c;
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    
                                }
                                else if(collectionTier >60 && collectionTier <= 90){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    
                                }
                                else if(collectionTier >90 && collectionTier <= 120){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    
                                    tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                    
                                }
                                else if(collectionTier >120 && collectionTier <= 150){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    
                                    tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                    
                                    tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                    
                                }
                                else if(collectionTier >150 && collectionTier <= 180){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    
                                    tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                    
                                    tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                    
                                    tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                    
                                }
                                 if(collectionTier >180 && collectionTier <= 210){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    
                                    tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                    
                                    tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                    
                                    tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                    
                                    tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                }
                                else if(collectionTier >210 && collectionTier <= 240){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    
                                    tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                    
                                    tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                    
                                    tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                    
                                    tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                    
                                    tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                    
                                }
                                else if(collectionTier >240 && collectionTier <= 270){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    
                                    tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                    
                                    tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                    
                                    tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                    
                                    tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                    
                                    tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                    
                                    tier270Denominator = tier270Denominator + c.Billed_Amount__c;
                                }
                                else if(collectionTier >270 && collectionTier <= 300){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    
                                    tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                    
                                    tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                    
                                    tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                    
                                    tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                    
                                    tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                
                                    tier270Denominator = tier270Denominator + c.Billed_Amount__c;
                                    
                                    tier300Denominator = tier300Denominator + c.Billed_Amount__c;
                                }
                                else if(collectionTier >300 && collectionTier <= 330){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    
                                    tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                    
                                    tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                    
                                    tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                    
                                    tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                    
                                    tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                    
                                    tier270Denominator = tier270Denominator + c.Billed_Amount__c;
                                    
                                    tier300Denominator = tier300Denominator + c.Billed_Amount__c;
                                    
                                    tier330Denominator = tier330Denominator + c.Billed_Amount__c;
                                }
                                else if(collectionTier >330){
                                    tier30Denominator=tier30Denominator + c.Billed_Amount__c;
                                    
                                    tier60Denominator = tier60Denominator + c.Billed_Amount__c;
                                    
                                    tier90Denominator = tier90Denominator + c.Billed_Amount__c;
                                    
                                    tier120Denominator = tier120Denominator + c.Billed_Amount__c;
                                    
                                    tier150Denominator = tier150Denominator + c.Billed_Amount__c;
                                    
                                    tier180Denominator = tier180Denominator + c.Billed_Amount__c;
                                    
                                    tier210Denominator = tier210Denominator + c.Billed_Amount__c;
                                    
                                    tier240Denominator = tier240Denominator + c.Billed_Amount__c;
                                    
                                    tier270Denominator = tier270Denominator + c.Billed_Amount__c;
                                    
                                    tier300Denominator = tier300Denominator + c.Billed_Amount__c;
                                    
                                    tier330Denominator = tier330Denominator + c.Billed_Amount__c;
                                    
                                    tier360Denominator = tier360Denominator + c.Billed_Amount__c;
                                }  
                            }  
                        }
                    }
                    
                    Account acc = new Account(id=accId, Temp_Flag__c = True);
                    if(tier30Numerator != 0.0)
                        acc.X0_to_30_Days_Collection__c = (tier30Numerator/tier30Denominator)*100;
                    else
                        acc.X0_to_30_Days_Collection__c = 0.0;
                    if(tier60Numerator != 0.0)
                        acc.X30_to_60_Days_Collection__c = (tier60Numerator/tier60Denominator)*100;
                    else
                        acc.X30_to_60_Days_Collection__c = 0.0;
                    if(tier90Numerator != 0.0)
                        acc.X60_to_90_Days_Collection__c = (tier90Numerator/tier90Denominator)*100; 
                    else
                        acc.X60_to_90_Days_Collection__c = 0.0; 
                    if(tier120Numerator != 0.0)
                        acc.X90_to_120_Days_Collection__c = (tier120Numerator/tier120Denominator)*100;
                    else
                        acc.X90_to_120_Days_Collection__c = 0.0;
                    if(tier150Numerator != 0.0)
                        acc.X120_to_150_Days_Collection__c = (tier150Numerator/tier150Denominator)*100; 
                    else
                        acc.X120_to_150_Days_Collection__c = 0.0; 
                    if(tier180Numerator != 0.0)
                        acc.X150_to_180_Days_Collection__c = (tier180Numerator/tier180Denominator)*100;
                    else
                        acc.X150_to_180_Days_Collection__c = 0.0;
                    if(tier210Numerator != 0.0)
                        acc.X180_to_210_Days_Collection__c = (tier210Numerator/tier210Denominator)*100; 
                    else
                        acc.X180_to_210_Days_Collection__c = 0.0; 
                    if(tier240Numerator != 0.0)
                        acc.X210_to_240_Days_Collection__c = (tier240Numerator/tier240Denominator)*100;
                    else
                        acc.X210_to_240_Days_Collection__c = 0.0;
                    if(tier270Numerator != 0.0)
                        acc.X240_to_270_Days_Collection__c = (tier270Numerator/tier270Denominator)*100; 
                    else
                        acc.X240_to_270_Days_Collection__c = 0.0; 
                    if(tier300Numerator != 0.0)    
                        acc.X270_to_300_Days_Collection__c = (tier300Numerator/tier300Denominator)*100;
                    else
                        acc.X270_to_300_Days_Collection__c = 0.0;
                    if(tier330Numerator != 0.0)
                        acc.X300_to_330_Days_Collection__c = (tier330Numerator/tier330Denominator)*100; 
                    else
                        acc.X300_to_330_Days_Collection__c = 0.0; 
                    if(tier360Numerator != 0.0)
                        acc.X330_Days_and_Above_Collection__c = (tier360Numerator/tier360Denominator)*100;
                    else
                        acc.X330_Days_and_Above_Collection__c = 0.0;
                    
                    accUpdateList.add(acc); 
                    accIdSet.add(acc.id);
                    
                    
                }
            }       
           
        }
        
        for(Id accId : accIdList){
            if(!accIdSet.contains(accId)){
                Account acc = new Account(id=accId, Temp_Flag__c = True, X0_to_30_Days_Collection__c = 0.0, X30_to_60_Days_Collection__c = 0.0,
                                             X60_to_90_Days_Collection__c = 0.0, X90_to_120_Days_Collection__c = 0.0,
                                             X120_to_150_Days_Collection__c = 0.0, X150_to_180_Days_Collection__c = 0.0,
                                             X180_to_210_Days_Collection__c = 0.0, X210_to_240_Days_Collection__c = 0.0,
                                             X240_to_270_Days_Collection__c = 0.0, X270_to_300_Days_Collection__c = 0.0,
                                             X300_to_330_Days_Collection__c = 0.0, X330_Days_and_Above_Collection__c = 0.0);
                accUpdateList.add(acc); 
            }
        }
        if(accUpdateList.size()>0)
            update accUpdateList;  
    
    }
    
    global void finish(Database.BatchableContext BC){

    }
}