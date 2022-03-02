//Test Class : updateGCLID_OnLeadsTest
trigger updateGCLID_OnLeads on INVOCA_FOR_SF__Invoca_Call_Log__c (after insert, after update){
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && Trigger_Custom_Setting__c.getValues('Default').Disable_updateGCLID_OnLeads__c == True)
    return;    
    
    Map<Id,String> leadIdMap = new Map<id,String>();   
    Map<Id,String> leadIdMap2 = new Map<id,String>();
    Map<Id,String> OppIdMap = new Map<id,String>();
    
    List<Lead> leadUpdateList = new List<Lead>();
    List<Lead> leadUpdateList2 = new List<Lead>();
    List<Opportunity> OpportunityList = new List<Opportunity>();
    
    for(INVOCA_FOR_SF__Invoca_Call_Log__c invoca : Trigger.New){
        if(invoca.INVOCA_FOR_SF__Lead__c != null && invoca.INVOCA_FOR_SF__Customer_String_Name_4__c != null && 
           invoca.INVOCA_FOR_SF__Customer_String_Name_4__c == 'gclid' && invoca.INVOCA_FOR_SF__Customer_String_Value_4__c != null){
            
            if(leadIdMap.containsKey(invoca.INVOCA_FOR_SF__Lead__c) == False){
                leadIdMap.put(invoca.INVOCA_FOR_SF__Lead__c,invoca.INVOCA_FOR_SF__Customer_String_Value_4__c);
            }
        }  
    }

    InvocaCallLogService.updateCustomerBusinessObjectValue(Trigger.New,Trigger.OldMap);
    
    if(leadIdMap.keySet().isEmpty() == False){
        for(Lead l : [Select id,gclid__c from lead where id IN: leadIdMap.keySet()]){
            if(l.gclid__c == null && leadIdMap.containsKey(l.id)){
                l.gclid__c = leadIdMap.get(l.id);
                leadUpdateList.add(l);
            }
        }
    }
    if(leadUpdateList.isEmpty() == False){
        update leadUpdateList;
    }  
}