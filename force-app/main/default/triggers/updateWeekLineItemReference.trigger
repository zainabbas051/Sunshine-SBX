//Test Class : KIPUChartAudit_Test
trigger updateWeekLineItemReference on KIPU_Audit_Medical_Progress_Note__c (before insert){
    
    list<Id> auditIdList = new List<Id>();
    list<KIPU_Audit_Medical_Progress_Note__c> mpnInsertList = new List<KIPU_Audit_Medical_Progress_Note__c>();
    Map<Id,List<KIPU_Audit_Week_Line_Item__c>> auditWLIMap = new Map<Id,List<KIPU_Audit_Week_Line_Item__c>>();
    List<KIPU_Audit_Week_Line_Item__c> wliUpdateList = new List<KIPU_Audit_Week_Line_Item__c>();
    for(KIPU_Audit_Medical_Progress_Note__c mpn : Trigger.New){
        if(mpn.KIPU_Chart_Audit__c != null){
            auditIdList.add(mpn.KIPU_Chart_Audit__c);
        }
    }
    
    if(auditIdList.size()>0){
        for(KIPU_Audit_Week_Line_Item__c wli : [Select id, Week_Start_Date__c, Week_End_Date__c, KIPU_Chart_Audit__c, Number_of_Medical_Progress_Note__c from KIPU_Audit_Week_Line_Item__c where KIPU_Chart_Audit__c IN: auditIdList]){
            if(auditWLIMap.containsKey(wli.KIPU_Chart_Audit__c)){
                List<KIPU_Audit_Week_Line_Item__c> tempList = new List<KIPU_Audit_Week_Line_Item__c>();
                tempList = auditWLIMap.get(wli.KIPU_Chart_Audit__c);
                tempList.add(wli);
                auditWLIMap.put(wli.KIPU_Chart_Audit__c,tempList);
            }else{
                List<KIPU_Audit_Week_Line_Item__c> tempList = new List<KIPU_Audit_Week_Line_Item__c>();
                tempList.add(wli);
                auditWLIMap.put(wli.KIPU_Chart_Audit__c,tempList);
            }
        }
    }
    
    if(auditWLIMap.keySet().size()>0){
        for(KIPU_Audit_Medical_Progress_Note__c mpn : Trigger.New){
            if(mpn.KIPU_Chart_Audit__c != null && auditWLIMap.containsKey(mpn.KIPU_Chart_Audit__c)){
                Boolean wliFlag = False;
                for(KIPU_Audit_Week_Line_Item__c wli : auditWLIMap.get(mpn.KIPU_Chart_Audit__c)){
                    if(mpn.Date_of_Visit__c >= wli.Week_Start_Date__c && mpn.Date_of_Visit__c <= wli.Week_End_Date__c){
                        mpn.KIPU_Audit_Week_Line_Item__c = wli.id;
                        wliFlag = True;
                        
                        if(wli.Number_of_Medical_Progress_Note__c != null){
                            wli.Number_of_Medical_Progress_Note__c = wli.Number_of_Medical_Progress_Note__c+1;
                            wliUpdateList.add(wli);
                        }else{
                            wli.Number_of_Medical_Progress_Note__c = 1;
                            wliUpdateList.add(wli);
                        }
                    }
                }
                if(wliFlag == False){
                    mpn.addError('No Weekly Line Item Related to the KIPU Audit Record Found');
                }
            }
        }
    }
    if(wliUpdateList.size()>0){
        update wliUpdateList;
    }
}