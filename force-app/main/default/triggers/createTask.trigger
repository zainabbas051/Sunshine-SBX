trigger createTask on INVOCA_FOR_SF__Invoca_Call_Log__c (after insert, after update) {
    
    List<Task> taskList = new List<Task>();
    
    for(INVOCA_FOR_SF__Invoca_Call_Log__c callLog : Trigger.New){
        Boolean Flag = False;
        if(trigger.isInsert){
            if((callLog.INVOCA_FOR_SF__pool_referrer_param5_value__c != null || callLog.INVOCA_FOR_SF__Customer_String_Value_2__c != null) && callLog.INVOCA_FOR_SF__Lead__c != null){
                Flag = True;
            }
            if((callLog.INVOCA_FOR_SF__pool_referrer_param5_value__c != null || callLog.INVOCA_FOR_SF__Customer_String_Value_2__c != null) && callLog.INVOCA_FOR_SF__Opportunity__c != null){
                Flag = True;
            }
        }
        if(trigger.isUpdate){
            if(((callLog.INVOCA_FOR_SF__pool_referrer_param5_value__c != trigger.oldMap.get(callLog.id).INVOCA_FOR_SF__pool_referrer_param5_value__c) || (callLog.INVOCA_FOR_SF__Customer_String_Value_2__c != trigger.oldMap.get(callLog.id).INVOCA_FOR_SF__Customer_String_Value_2__c)) && callLog.INVOCA_FOR_SF__Lead__c != null){
                 Flag = True;
            }
            if(((callLog.INVOCA_FOR_SF__pool_referrer_param5_value__c != null || callLog.INVOCA_FOR_SF__Customer_String_Value_2__c != null)) && callLog.INVOCA_FOR_SF__Lead__c != trigger.oldMap.get(callLog.id).INVOCA_FOR_SF__Lead__c && callLog.INVOCA_FOR_SF__Lead__c != null){
                 Flag = True;
            }
            if(((callLog.INVOCA_FOR_SF__pool_referrer_param5_value__c != trigger.oldMap.get(callLog.id).INVOCA_FOR_SF__pool_referrer_param5_value__c) || (callLog.INVOCA_FOR_SF__Customer_String_Value_2__c != trigger.oldMap.get(callLog.id).INVOCA_FOR_SF__Customer_String_Value_2__c)) && callLog.INVOCA_FOR_SF__Opportunity__c != null){
                Flag = True;
            }
            if((callLog.INVOCA_FOR_SF__pool_referrer_param5_value__c != null || callLog.INVOCA_FOR_SF__Customer_String_Value_2__c != null) && callLog.INVOCA_FOR_SF__Opportunity__c != null && callLog.INVOCA_FOR_SF__Opportunity__c != trigger.oldMap.get(callLog.id).INVOCA_FOR_SF__Opportunity__c){
                Flag = True;
            }
        }
        
        if(Flag == True){
            Task t = new Task();
            t.Subject = 'Invoca Call Log';
            t.Type = 'Call';
            if(callLog.INVOCA_FOR_SF__Lead__c != null)
                t.whoId = callLog.INVOCA_FOR_SF__Lead__c;
            if(callLog.INVOCA_FOR_SF__Opportunity__c != null){
                t.whoId = null;
                t.whatId = callLog.INVOCA_FOR_SF__Opportunity__c;
            }
            if(callLog.INVOCA_FOR_SF__pool_referrer_param5_value__c != null)
                t.bizible2__BizibleId__c = callLog.INVOCA_FOR_SF__pool_referrer_param5_value__c;
            else if(callLog.INVOCA_FOR_SF__Customer_String_Value_2__c != null)
                t.bizible2__BizibleId__c = callLog.INVOCA_FOR_SF__Customer_String_Value_2__c;
            t.Status = 'Completed';
            t.Priority = 'Normal';
            taskList.add(t);
        }
    }
    
    if(!taskList.isEmpty())
        insert taskList;
    
    
}