//Test CLass : collectionsAuditExtTest
trigger caseAuditUpdate on Case (after insert, after update){
    List<case> caseUpdateList = new List<Case>();
    Set<id> oppIdSet = new set<id>();
    set<id> openOppSet = new set<Id>();
    set<id> closeOppSet = new set<Id>();
    List<Opportunity> closeOppUpdateList = new List<Opportunity>();
    List<Opportunity> openOppUpdateList = new List<Opportunity>();
    Map<id,List<Case>> oppIdCaseMap = new Map<id,List<Case>>();
    
    for(Case c : Trigger.New){
        if(c.RecordTypeId ==Constants.insuranceClaimRecordTypeId){
            if(trigger.isInsert){
                if(c.Audit_Status__c == 'Closed'){
                    Case tempCase = new Case(id = c.id);
                    tempCase.Audit_Completed_By__c = userInfo.getUserId();
                    tempCase.Audit_Completed_Time_Stamp__c = dateTime.Now();
                    caseUpdateList.add(tempCase);
                    oppIdSet.add(c.Opportunity__c);
                }else{
                    openOppSet.add(c.Opportunity__c);
                }
            }else{
                if(c.Audit_Status__c == 'Closed' && trigger.OldMap.get(c.id).Audit_Status__c != c.Audit_Status__c){
                    Case tempCase = new Case(id = c.id);
                    tempCase.Audit_Completed_By__c = userInfo.getUserId();
                    tempCase.Audit_Completed_Time_Stamp__c = dateTime.Now();
                    caseUpdateList.add(tempCase);
                    oppIdSet.add(c.Opportunity__c);
                }
                
                if(c.Audit_Status__c == 'Open' && trigger.OldMap.get(c.id).Audit_Status__c == 'Closed'){
                    openOppSet.add(c.Opportunity__c);
                }
            }
        }
    }
    
    if(oppIdSet.size()>0){
        for(Case c : [Select id, Audit_Status__c, Opportunity__c from case where Opportunity__c IN: oppIdSet AND RecordTypeId =:Constants.insuranceClaimRecordTypeId]){
            if(oppIdCaseMap.containsKey(c.Opportunity__c)){
                List<case> tempCaseList = new List<Case>();
                tempCaseList = oppIdCaseMap.get(c.Opportunity__c);
                tempCaseList.add(c);
                oppIdCaseMap.put(c.Opportunity__c, tempCaseList);
            }else{
                List<case> tempCaseList = new List<Case>();
                tempCaseList.add(c);
                oppIdCaseMap.put(c.Opportunity__c, tempCaseList);
            }
        }
        
        if(oppIdCaseMap.keySet().size()>0){
            for(Id oppId : oppIdCaseMap.keySet()){
                boolean OpenCaseFlag = False;
                for(Case c : oppIdCaseMap.get(oppId)){
                    if(c.Audit_Status__c == 'Open'){
                        OpenCaseFlag = True;
                    }
                }
                if(OpenCaseFlag == False){
                    closeOppSet.add(oppId);
                }
            }
        }
    }
    
    if(closeOppSet.size()>0){
        for(id oppId : closeOppSet){
            Opportunity opp = new Opportunity();
            opp.id = oppId;
            opp.All_Cases_Audit_Completed__c = True;
            closeOppUpdateList.add(opp);
        }
    }
    
    if(closeOppUpdateList.size()>0){
        update closeOppUpdateList;
    }
    
    if(openOppSet.size()>0){
        for(id oppId : openOppSet){
            Opportunity opp = new Opportunity();
            opp.id = oppId;
            opp.All_Cases_Audit_Completed__c = False;
            openOppUpdateList.add(opp);
        }
    }
    
    if(openOppUpdateList.size()>0){
        update openOppUpdateList;
    }
    
    if(caseUpdateList.size()>0){
        update caseUpdateList;
    }
}