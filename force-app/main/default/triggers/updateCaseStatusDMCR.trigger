//Test Class : insuranceCaseHelpObjectsTriggerTest
trigger updateCaseStatusDMCR on Data_Missing_in_Claim_Request__c(after Update) {
    List<Id> caseIdList = new List<Id>();
    List<Case> caseUpdateList = new List<Case>();
    for(Data_Missing_in_Claim_Request__c dmcr: Trigger.New){
        if(dmcr.Status__c == 'Closed')
            caseIdList.add(dmcr.Related_Case__c);
    }
    
    if(caseIdList.size()>0){
        for(Case c : [select id, status from Case where Id IN: caseIdList]){
            for(Data_Missing_in_Claim_Request__c dmcr : Trigger.New){
                if(c.id == dmcr.Related_Case__c){
                    if(c.Status == 'Data Missing in Claim'){
                        c.Status='Missing Data Updated In Claims';
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