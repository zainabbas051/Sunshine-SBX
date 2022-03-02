//Test Class : KIPUChartAudit_Test
trigger updateWLIReference_oc_delete on KIPU_Audit_Outside_Contact__c (after delete) {

    list<Id> wliIdList = new List<Id>();
    Map<Id,KIPU_Audit_Week_Line_Item__c> wliIdMap = new Map<id,KIPU_Audit_Week_Line_Item__c>();
    List<KIPU_Audit_Week_Line_Item__c> wliUpdateList = new List<KIPU_Audit_Week_Line_Item__c>();
    
    for(KIPU_Audit_Outside_Contact__c oc : Trigger.Old){
        if(oc.KIPU_Audit_Week_Line_Item__c != null){
            wliIdList.add(oc.KIPU_Audit_Week_Line_Item__c);
        }
    }
    
    if(wliIdList.size()>0){
        for(KIPU_Audit_Week_Line_Item__c wli : [Select id, Number_of_Outside_Contact__c from KIPU_Audit_Week_Line_Item__c where ID IN: wliIdList]){
            wliIdMap.put(wli.id,wli);
        }
    }
    
    if(wliIdMap.keySet().size()>0){
        for(KIPU_Audit_Outside_Contact__c oc : Trigger.Old){
            if(oc.KIPU_Audit_Week_Line_Item__c != null){
                if(wliIdMap.containsKey(oc.KIPU_Audit_Week_Line_Item__c)){
                    KIPU_Audit_Week_Line_Item__c temp = new KIPU_Audit_Week_Line_Item__c(id=oc.KIPU_Audit_Week_Line_Item__c);
                    temp.Number_of_Outside_Contact__c = wliIdMap.get(oc.KIPU_Audit_Week_Line_Item__c).Number_of_Outside_Contact__c - 1;
                    wliIdMap.put(oc.KIPU_Audit_Week_Line_Item__c,temp);
                }
            }
        }
    }
    if(wliIdMap.keySet().size()>0){
        for(Id wliId : wliIdMap.keySet()){
            wliUpdateList.add(wliIdMap.get(wliId));
        }
    }
    
    
    if(wliUpdateList.size()>0){
        update wliUpdateList;
    }
}