//Test Class : KIPUChartAudit_Test
trigger updateWeekLineItemReference_cpn on KIPU_Audit_Clinical_Progress_Note__c (before insert) {

    list<Id> auditIdList = new List<Id>();
    list<KIPU_Audit_Clinical_Progress_Note__c> cpnInsertList = new List<KIPU_Audit_Clinical_Progress_Note__c>();
    Map<Id,List<KIPU_Audit_Week_Line_Item__c>> auditWLIMap = new Map<Id,List<KIPU_Audit_Week_Line_Item__c>>();
    List<KIPU_Audit_Week_Line_Item__c> wliUpdateList = new List<KIPU_Audit_Week_Line_Item__c>();
    for(KIPU_Audit_Clinical_Progress_Note__c cpn : Trigger.New){
        if(cpn.KIPU_Chart_Audit__c != null){
            auditIdList.add(cpn.KIPU_Chart_Audit__c);
        }
    }
    
    if(auditIdList.size()>0){
        for(KIPU_Audit_Week_Line_Item__c wli : [Select id, Week_Start_Date__c, Week_End_Date__c, KIPU_Chart_Audit__c, Number_of_Clinical_Progress_Note__c from KIPU_Audit_Week_Line_Item__c where KIPU_Chart_Audit__c IN: auditIdList]){
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
        for(KIPU_Audit_Clinical_Progress_Note__c cpn : Trigger.New){
            if(cpn.KIPU_Chart_Audit__c != null && auditWLIMap.containsKey(cpn.KIPU_Chart_Audit__c)){
                Boolean wliFlag = False;
                for(KIPU_Audit_Week_Line_Item__c wli : auditWLIMap.get(cpn.KIPU_Chart_Audit__c)){
                    if(cpn.Start_Date_Time__c.date() >= wli.Week_Start_Date__c && cpn.Start_Date_Time__c.date() <= wli.Week_End_Date__c){
                        cpn.KIPU_Audit_Week_Line_Item__c = wli.id;
                        wliFlag = True;
                        
                        if(wli.Number_of_Clinical_Progress_Note__c != null){
                            wli.Number_of_Clinical_Progress_Note__c = wli.Number_of_Clinical_Progress_Note__c+1;
                            wliUpdateList.add(wli);
                        }else{
                            wli.Number_of_Clinical_Progress_Note__c = 1;
                            wliUpdateList.add(wli);
                        }
                    }
                }
                if(wliFlag == False){
                    cpn.addError('No Weekly Line Item Related to the KIPU Audit Record Found');
                }
            }
        }
    }
    
    if(wliUpdateList.size()>0){
        update wliUpdateList;
    }
}