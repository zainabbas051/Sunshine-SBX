//Test Class : ClaimLeadOwnershipTest
trigger stateUpdateInvocaLead on Lead (before insert, before update){
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && 
    Trigger_Custom_Setting__c.getValues('Default').stateUpdateInvocaLead_Disable__c == True)
    return;
    
    Map<String,String> stateCodeMap = new Map<String,String>();
    for(State_Abbreviation_Mapping__c sam : State_Abbreviation_Mapping__c.getAll().values()){
        stateCodeMap.put(sam.State_Code__c, sam.Name);
    }
    
    if(stateCodeMap.keySet().size() != null){
        for(Lead l : Trigger.New){
            if(Trigger.isInsert){
                if(l.Invoca_State__c != ''){
                    if(stateCodeMap.containsKey(l.Invoca_State__c)){
                        l.State__c = stateCodeMap.get(l.Invoca_State__c);  
                    }
                    if(l.LeadSource == 'Invoca Call' && l.Call_Routing__c != null){
                        l.LeadSource = l.Call_Routing__c;
                        l.Phone_Web__c = 'Call';
                    }          
                }
            }else{
                if(l.Invoca_State__c != '' && l.Invoca_State__c != trigger.oldMap.get(l.id).Invoca_State__c){
                    if(stateCodeMap.containsKey(l.Invoca_State__c))
                        l.State__c = stateCodeMap.get(l.Invoca_State__c);           
                }
            }
            
        }
    }
    
}