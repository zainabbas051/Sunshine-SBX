/*
    this trigger is for updating last activity date on oppty
    author: Huma
    modified: 7/30/2016
*/
trigger TrgTaskUpdateLastActivityDate on Task (after insert) {
    
    //get obj id of Opportunity to see if task was created against Opportunity
    Schema.DescribeSObjectResult Oppty_DSR = Opportunity.SObjectType.getDescribe();
    String OpptyId = Oppty_DSR.getKeyPrefix();
    
    //set of opportunity ids
    set<id> setOpptyIds = new set<id>();
    
    
    for(Task aTask: trigger.new){
        //if task is created against oppty then capture oppty id
        if(aTask.WhatId != null && String.valueof(aTask.WhatId).startswith(OpptyId )){
            
            if(aTask.subject=='Call'){
                setOpptyIds.add(aTask.WhatId);
            }
            
        } 
    }  
    
    if(setOpptyIds.size()>0){
        //query opportunities and update last activity date
        list<Opportunity> lstOpportunities = [select id, Last_Activity_Date__c from Opportunity where id in: setOpptyIds ];
        
        for(Opportunity opp : lstOpportunities ){
            opp.Last_Activity_Date__c = DateTime.now();
        }
        if(lstOpportunities.size()>0)
            update lstOpportunities ;
    }  
}