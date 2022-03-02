//Test Class : KIPUChartAudit_Test
trigger updateWeekLineItemReference_oc on KIPU_Audit_Outside_Contact__c (before insert, before update) {
    
    list<Id> auditIdList = new List<Id>();
    Map<Id,List<KIPU_Audit_Week_Line_Item__c>> auditWLIMap = new Map<Id,List<KIPU_Audit_Week_Line_Item__c>>();
    List<KIPU_Audit_Week_Line_Item__c> wliUpdateList = new List<KIPU_Audit_Week_Line_Item__c>();
    for(KIPU_Audit_Outside_Contact__c oc : Trigger.New){
        if(trigger.isInsert){
            if(oc.KIPU_Chart_Audit__c != null && (oc.Live_Call__c == True || oc.Client_Refused_Outside_Contact__c)){
                auditIdList.add(oc.KIPU_Chart_Audit__c);
            }
        }else{
            if(oc.KIPU_Chart_Audit__c != null && ((oc.Live_Call__c == True && trigger.oldMap.get(oc.id).Live_Call__c == False) || (oc.Client_Refused_Outside_Contact__c == True && trigger.oldMap.get(oc.id).Client_Refused_Outside_Contact__c == False))){
                auditIdList.add(oc.KIPU_Chart_Audit__c);
            }
        }
    }
    
    if(auditIdList.size()>0){
        for(KIPU_Audit_Week_Line_Item__c wli : [Select id, Week_Start_Date__c, Week_End_Date__c, KIPU_Chart_Audit__c, Number_of_Outside_Contact__c from KIPU_Audit_Week_Line_Item__c where KIPU_Chart_Audit__c IN: auditIdList]){
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
        for(KIPU_Audit_Outside_Contact__c oc : Trigger.New){
            if(oc.KIPU_Chart_Audit__c != null && auditWLIMap.containsKey(oc.KIPU_Chart_Audit__c)){
                Boolean wliFlag = False;
                for(KIPU_Audit_Week_Line_Item__c wli : auditWLIMap.get(oc.KIPU_Chart_Audit__c)){
                    if(oc.Date_Disclosed__c >= wli.Week_Start_Date__c && oc.Date_Disclosed__c <= wli.Week_End_Date__c){
                        oc.KIPU_Audit_Week_Line_Item__c = wli.id;
                        wliFlag = True;
                        
                        if(wli.Number_of_Outside_Contact__c != null){
                            wli.Number_of_Outside_Contact__c = wli.Number_of_Outside_Contact__c+1;
                            wliUpdateList.add(wli);
                        }else{
                            wli.Number_of_Outside_Contact__c = 1;
                            wliUpdateList.add(wli);
                        }
                    }
                }
                if(wliFlag == False){
                    oc.addError('No Weekly Line Item Related to the KIPU Audit Record Found');
                }
            }
        }
    }
    
    if(wliUpdateList.size()>0){
        update wliUpdateList;
    }
}