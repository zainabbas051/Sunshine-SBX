//Test Class : KIPUChartAudit_Test
trigger updateWLIReference_mpn_delete on KIPU_Audit_Medical_Progress_Note__c (after delete) {

    list<Id> wliIdList = new List<Id>();
    Map<Id,KIPU_Audit_Week_Line_Item__c> wliIdMap = new Map<id,KIPU_Audit_Week_Line_Item__c>();
    List<KIPU_Audit_Week_Line_Item__c> wliUpdateList = new List<KIPU_Audit_Week_Line_Item__c>();
    
    for(KIPU_Audit_Medical_Progress_Note__c mpn : Trigger.Old){
        if(mpn.KIPU_Audit_Week_Line_Item__c != null){
            wliIdList.add(mpn.KIPU_Audit_Week_Line_Item__c);
        }
    }
    
    if(wliIdList.size()>0){
        for(KIPU_Audit_Week_Line_Item__c wli : [Select id, Number_of_Medical_Progress_Note__c from KIPU_Audit_Week_Line_Item__c where ID IN: wliIdList]){
            wliIdMap.put(wli.id,wli);
        }
    }
    
    if(wliIdMap.keySet().size()>0){
        for(KIPU_Audit_Medical_Progress_Note__c mpn : Trigger.Old){
            if(mpn.KIPU_Audit_Week_Line_Item__c != null){
                if(wliIdMap.containsKey(mpn.KIPU_Audit_Week_Line_Item__c)){
                    KIPU_Audit_Week_Line_Item__c temp = new KIPU_Audit_Week_Line_Item__c(id=mpn.KIPU_Audit_Week_Line_Item__c);
                    temp.Number_of_Medical_Progress_Note__c = wliIdMap.get(mpn.KIPU_Audit_Week_Line_Item__c).Number_of_Medical_Progress_Note__c - 1;
                    wliIdMap.put(mpn.KIPU_Audit_Week_Line_Item__c,temp);
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