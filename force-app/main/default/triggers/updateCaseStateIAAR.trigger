//Test Class : insuranceCaseHelpObjectsTriggerTest
trigger updateCaseStateIAAR on Insurance_Appeal_for_Adjustment_Request__c (after update) {
    List<Id> caseIdList = new List<Id>();
    List<Case> caseUpdateList = new List<Case>();
    for(Insurance_Appeal_for_Adjustment_Request__c aar: Trigger.New){
        if(aar.Status__c == 'Closed')
            caseIdList.add(aar.Related_Case__c);
    }
    
    if(caseIdList.size()>0){
        for(Case c : [select id, status from Case where Id IN: caseIdList]){
            for(Insurance_Appeal_for_Adjustment_Request__c aar : Trigger.New){
                if(c.id == aar.Related_Case__c){
                    c.Status='Appeal Receipt Confirmation Pending';
                    caseUpdateList.add(c);
                }
            }
        }
    }
    
    if(caseUpdateList.size()>0){
        update caseUpdateList;
    }
}