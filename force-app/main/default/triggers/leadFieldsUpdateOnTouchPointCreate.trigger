//Test Class : leadFieldsUpdateOnTouchPointCreateTest
trigger leadFieldsUpdateOnTouchPointCreate on bizible2__Bizible_Touchpoint__c (after insert) {
    
    list<id> personIdlist = new List<id>();
    List<Opportunity> oppUpdateList = new List<Opportunity>();
    List<Opportunity> oppUpdateList2 = new List<Opportunity>();
    Map<String,Id> personIdOppIdMap = new Map<String,Id>();
    Map<String,Id> personIdContactIdMap = new Map<String,Id>();
    Map<Id,Id> contactIdOppIdMap = new Map<Id,Id>();
    Set<Id> contactIdSet= new Set<id>(); 
    
    for(bizible2__Bizible_Touchpoint__c bBT : Trigger.New){
        system.debug('Bizible Person ID :::'+bBT.bizible2__Bizible_Person__c);
        system.debug('Bizible Touchpoint Position :::'+bBT.bizible2__Touchpoint_Position__c);
        system.debug('FT Values :::'+bBT.bizible2__Touchpoint_Position__c.contains('FT'));
        if(bBT.bizible2__Bizible_Person__c != null && bBT.bizible2__Touchpoint_Position__c.contains('FT'))
            personIdList.add(bBT.bizible2__Bizible_Person__c);
    }
    
    system.debug('personIdList size:::'+personIdList.size());
    if(personIdList.size()>0){
        for(bizible2__Bizible_Person__c bp : [Select id, bizible2__Lead__c, bizible2__Lead__r.isConverted, bizible2__Lead__r.ConvertedOpportunityId, bizible2__Contact__c from bizible2__Bizible_Person__c where id IN: personIdList]){
            if(bp.bizible2__Lead__c != null && bp.bizible2__Lead__r.isConverted == True){//Incase the Lead Has been converted, Update the Data on Opps
                personIdOppIdMap.put(bp.id,bp.bizible2__Lead__r.ConvertedOpportunityId);
            }else if(bp.bizible2__Lead__c == null && bp.bizible2__Contact__c != null){//Incase the Lead ID Doesnt Exist, Use Contact ID to Update the Data on Opps
                contactIdSet.add(bp.bizible2__Contact__c);
                personIdContactIdMap.put(bp.id,bp.bizible2__Contact__c);    
            }
        }
    }
    
    system.debug('contactIdSet :::'+contactIdSet);
    
    if(contactIdSet.size()>0){
        for(OpportunityContactRole ocr : [Select id, ContactId, OpportunityId from OpportunityContactRole where contactId IN: contactIdSet]){
            contactIdOppIdMap.put(ocr.ContactId, ocr.OpportunityId);
        }
    }
    
    system.debug('contactIdOppIdMap :::'+contactIdOppIdMap);
    
    if(!contactIdOppIdMap.keySet().isEmpty()){//This Loop is if Lead ID is Blank and Contact ID is not blank on Bizible Person
        for(bizible2__Bizible_Touchpoint__c bt : Trigger.New){
            if(personIdContactIdMap.containsKey(bt.bizible2__Bizible_Person__c)){
                if(contactIdOppIdMap.containsKey(personIdContactIdMap.get(bt.bizible2__Bizible_Person__c))){
                    if(BizibleTouchpointUtility.updateOpp(contactIdOppIdMap.get(personIdContactIdMap.get(bt.bizible2__Bizible_Person__c)),bt) != null){
                        oppUpdateList2.add(BizibleTouchpointUtility.updateOpp(contactIdOppIdMap.get(personIdContactIdMap.get(bt.bizible2__Bizible_Person__c)),bt)); 
                    }    
                }
            }
        }
    }
    
    system.debug('personIdOppIdMap :::'+personIdOppIdMap);
    
    if(personIdOppIdMap.keySet().size()>0){//This Loop is for
        for(bizible2__Bizible_Touchpoint__c bt : Trigger.New){
            system.debug('BT Bizible Person :::'+bt.bizible2__Bizible_Person__c);
            system.debug('contains key :::'+personIdOppIdMap.containsKey(bt.bizible2__Bizible_Person__c));
            if(personIdOppIdMap.containsKey(bt.bizible2__Bizible_Person__c)){
                if(BizibleTouchpointUtility.updateOpp(personIdOppIdMap.get(bt.bizible2__Bizible_Person__c),bt) != null){
                    oppUpdateList.add(BizibleTouchpointUtility.updateOpp(personIdOppIdMap.get(bt.bizible2__Bizible_Person__c),bt)); 
                }
            }
        }
    }
    
    system.debug('oppUpdateList :::'+oppUpdateList);
    if(!oppUpdateList.isEmpty()){
        update oppUpdateList;
    }
    system.debug('oppUpdateList 2:::'+oppUpdateList2);
    
    if(!oppUpdateList2.isEmpty()){
        update oppUpdateList2;
    }
}