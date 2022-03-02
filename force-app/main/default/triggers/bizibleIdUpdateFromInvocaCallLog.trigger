//Test Class : bizibleIdUpdateFromInvocaCallLogTest
trigger bizibleIdUpdateFromInvocaCallLog on Task (after insert, after update) {
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && 
    Trigger_Custom_Setting__c.getValues('Default').Disable_bizibleIdUpdate__c == True)
    return;
    
    if(checkRecursive_bizibleIdUpdate.runOnce())
    {
        List<Task> updateTaskList = new List<Task>();
        DateTime startDateTime;
        DateTime endDateTime;
        
        for(Task t : trigger.new){
            if(t.Subject == 'Invoca Call Log' && t.bizible2__BizibleId__c == null && (t.WhatId != null || t.WhoId != null)){
                startDateTime = dateTime.Now().addHours(-1);
                endDateTime = dateTime.Now().addHours(1);
            }
        }
        
        if(startDateTime != null && endDateTime != null){
            for(INVOCA_FOR_SF__Invoca_Call_Log__c icl : [Select id, INVOCA_FOR_SF__pool_referrer_param5_value__c, CreatedDate, INVOCA_FOR_SF__Lead__c, INVOCA_FOR_SF__Opportunity__c from INVOCA_FOR_SF__Invoca_Call_Log__c where CreatedDate >=: startDateTime AND CreatedDate <=: endDateTime]){
                for(Task t :trigger.New){
                    if(t.Subject == 'Invoca Call Log'){
                        if(t.CreatedDate.Minute() == icl.CreatedDate.Minute() && t.createdDate.Date() == icl.CreatedDate.Date()){
                            if(t.WhoId == icl.INVOCA_FOR_SF__Lead__c || t.WhatId == icl.INVOCA_FOR_SF__Opportunity__c){
                                if(t.bizible2__BizibleId__c == null){
                                    task tempTask = new Task(id=t.id, bizible2__BizibleId__c = icl.INVOCA_FOR_SF__pool_referrer_param5_value__c);
                                    updateTaskList.add(tempTask);
                                }
                            }
                        }
                    }    
                }
            }
        }
        
        if(updateTaskList.size()>0)
            update updateTaskList;
    }
}