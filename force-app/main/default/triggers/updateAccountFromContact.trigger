//Test Class : updateAccountFromContactTest
trigger updateAccountFromContact on INVOCA_FOR_SF__Invoca_Call_Log__c (after update) {
    
    if(checkRecursive_updateAccountFromContact.runOnce())
    {
        Id msRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();//Getting the id of Monarch Shore Opportunity Record Type
        Id erpRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId();//Getting the id of Monarch Shore Opportunity Record Type
     
     
        list<INVOCA_FOR_SF__Invoca_Call_Log__c> callLogList = new List<INVOCA_FOR_SF__Invoca_Call_Log__c>();
        List<Id> contactIdList = new List<id>();
        Map<Id, INVOCA_FOR_SF__Invoca_Call_Log__c> contactCallMap = new Map<Id, INVOCA_FOR_SF__Invoca_Call_Log__c>();
        List<Id> accountIdList = new List<id>();
        
        for(INVOCA_FOR_SF__Invoca_Call_Log__c  call : Trigger.New){
            if(call.INVOCA_FOR_SF__Contact__c != null && call.INVOCA_FOR_SF__Contact__c != trigger.oldMap.get(call.id).INVOCA_FOR_SF__Contact__c && call.INVOCA_FOR_SF__Account__c == null){
                contactIdList.add(call.INVOCA_FOR_SF__Contact__c);    
                contactCallMap.put(call.INVOCA_FOR_SF__Contact__c, call);    
            }
        }
        
        for(Contact cont : [select id, AccountId from Contact where id IN: contactIdList]){
            if(contactCallMap.containsKey(cont.id)){
                INVOCA_FOR_SF__Invoca_Call_Log__c tempCall = new INVOCA_FOR_SF__Invoca_Call_Log__c();
                tempCall.id = contactCallMap.get(cont.id).id;
                tempCall.INVOCA_FOR_SF__advertiser_name__c = contactCallMap.get(cont.id).INVOCA_FOR_SF__advertiser_name__c;
                tempCall.INVOCA_FOR_SF__Account__c = cont.AccountId;
                callLogList.add(tempCall);
                
                accountIdList.add(cont.AccountId);
            }
        }
        
        for(Opportunity opp : [Select id, RecordTypeId, AccountId from Opportunity Where accountId IN: accountIdList]){
            for(INVOCA_FOR_SF__Invoca_Call_Log__c  call : callLogList){
                if(call.INVOCA_FOR_SF__Account__c == opp.AccountId){
                    if((call.INVOCA_FOR_SF__advertiser_name__c == 'Monarch Shores' || call.INVOCA_FOR_SF__advertiser_name__c == 'Willow Springs' || call.INVOCA_FOR_SF__advertiser_name__c == 'Chapters Capistrano') && opp.recordTypeId == msRecTypeId){
                        call.INVOCA_FOR_SF__Opportunity__c = opp.id;
                    }
                    if(call.INVOCA_FOR_SF__advertiser_name__c != 'Monarch Shores' && call.INVOCA_FOR_SF__advertiser_name__c != 'Willow Springs' && call.INVOCA_FOR_SF__advertiser_name__c != 'Chapters Capistrano' && opp.recordTypeId == erpRecTypeId){
                        call.INVOCA_FOR_SF__Opportunity__c = opp.id;
                    }
                }
            }
        }
        
        if(callLogList.size() != null){
            update callLogList;
        }
    }
}