//Test Class : insuranceCaseHelpObjectsTriggerTest

trigger updateCaseStatus on Insurance_Claim_Medical_Records_Request__c (after Update) {
    List<Id> caseIdList = new List<Id>();
    List<Case> caseUpdateList = new List<Case>();
    for(Insurance_Claim_Medical_Records_Request__c  mrr : Trigger.New){
        if(mrr.Status__c == 'Closed')
            caseIdList.add(mrr.Related_Case__c);
    }
    
    if(caseIdList.size()>0){
        for(Case c : [select id, status from Case where Id IN: caseIdList]){
            for(Insurance_Claim_Medical_Records_Request__c  mrr : Trigger.New){
                if(c.id == mrr.Related_Case__c){
                    if(c.Status == 'Requesting Medical Records'){
                        c.Status='Processing';
                        caseUpdateList.add(c);
                    }
                }
            }
        }
    }
    
    if(caseUpdateList.size()>0){
        update caseUpdateList;
    }
}