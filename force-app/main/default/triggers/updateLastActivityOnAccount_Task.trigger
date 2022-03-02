//Test Class : updateLastActivityOnAccount_Test
trigger updateLastActivityOnAccount_Task on Task (after insert) {
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && Trigger_Custom_Setting__c.getValues('Default').Disable_updateLastActivityOnAccount_Task__c == True)
    return; 
    
    //get obj id of Opportunity to see if task was created against Opportunity
    Schema.DescribeSObjectResult acc_DSR = Account.SObjectType.getDescribe();
    String AccId = acc_DSR.getKeyPrefix();
    
    //set of opportunity ids
    set<id> setAccIds = new set<id>();
    list<Account> accUpdateList = new List<Account>();
    
    for(Task aTask: trigger.new){
        //if task is created against oppty then capture oppty id
        if(aTask.WhatId != null && String.valueof(aTask.WhatId).startswith(AccId)){
            setAccIds.add(aTask.WhatId);
        } 
    }  
    
    if(setAccIds.size()>0){
        //query opportunities and update last activity date
        For(Account acc : [Select id, Last_Activity_Date__c from Account where ID IN: setAccIds AND RecordType.Name =: 'Business Development']){
            acc.Last_Activity_Date__c = DateTime.now();
            accUpdateList.add(acc);
        }
        
        if(accUpdateList.size()>0)
            update accUpdateList ;
    }  
}