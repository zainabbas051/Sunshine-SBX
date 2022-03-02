//Test Class : msInsuranceCaseOwnerUpdateTest
trigger msInsuranceCaseOwnerUpdate on Opportunity (after update) {
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && 
    Trigger_Custom_Setting__c.getValues('Default').Disable_msInsuranceCaseOwnerUpdate__c == True)
    return;
    
    Id recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();//Getting the id of Monarch Shore Opportunity Record Type
    List<id> oppIdList = new List<Id>();
    Map<Id,List<Case>> oppIdCaseMap = new Map<Id,List<Case>>();
    Map<Id,Id> oppIdCollectorIdMap = new Map<Id,Id>();
    List<Id> oldCollectorIdList = new List<Id>();
    List<Case> caseUpdateList = new List<Case>();
    List<OpportunityShare> oppShareList = new List<OpportunityShare>();
    List<OpportunityShare> oppShareDeleteList = new List<OpportunityShare>();
    
    for(Opportunity opp : Trigger.New){
        if(opp.recordTypeId == recTypeId){
            If(opp.Insurance_Collector__c != null && (trigger.oldMap.get(opp.id).Insurance_Collector__c == Null || (trigger.oldMap.get(opp.id).Insurance_Collector__c != Null && trigger.oldMap.get(opp.id).Insurance_Collector__c != opp.Insurance_Collector__c))){
                oppIdList.add(opp.id);
                oppIdCollectorIdMap.put(opp.id,opp.Insurance_Collector__c);  
                oldCollectorIdList.add(trigger.oldMap.get(opp.id).Insurance_Collector__c);
                
                OpportunityShare os = new OpportunityShare(OpportunityId=opp.id, OpportunityAccessLevel='Edit', UserOrGroupId=opp.Insurance_Collector__c, RowCause='Manual');
                oppShareList.add(os);  
            }
        }
    }
    
    if(oppIdList.size()>0){
        for(Case c : [Select id, OwnerId, Opportunity__c from Case where Opportunity__c IN: oppIdList AND status !=: 'Closed' AND Level_of_Care__c !=: 'Lab Requests' AND OwnerId !=: label.Abdul_User_ID]){
            if(oppIdCaseMap.containsKey(c.Opportunity__c)){
                List<Case> tempList = new List<Case>();
                tempList = oppIdCaseMap.get(c.Opportunity__c);
                tempList.add(c);
                oppIdCaseMap.put(c.Opportunity__c, tempList);
            }else{
                List<Case> tempList = new List<Case>();
                tempList.add(c);
                oppIdCaseMap.put(c.Opportunity__c, tempList);
            }
        }
    }
    
    if(oppIdCaseMap.keySet().size()>0){
        for(Id oppId : oppIdCaseMap.KeySet()){
            for(Case c : oppIdCaseMap.get(oppId)){
                if(oppIdCollectorIdMap.containsKey(oppId)){
                    c.OwnerId = oppIdCollectorIdMap.get(oppId);
                    caseUpdateList.add(c);
                    
                    
                }
            }
        }
    }
    
    if(oldCollectorIdList.size() != null && oppIdList.size() != null){
        for(OpportunityShare os : [Select id from OpportunityShare where OpportunityId IN: oppIdList AND UserOrGroupId IN: oldCollectorIdList AND RowCause='Manual']){
            oppShareDeleteList.add(os);
        }
    }
    
    if(caseUpdateList.size()>0){
        update caseUpdateList;
    }
    if(oppShareList.size()>0){
        insert oppShareList;
    }
    if(oppShareDeleteList.size()!=null){
        delete oppShareDeleteList;
    }
}