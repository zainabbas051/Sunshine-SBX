/*
    this trigger is to update last activity date on oppty
    author: Huma
    modified: 7/30/2016
*/
//Test Class : MSinsuranceCollectorRoundRobinTest
trigger TrgOpportunity on Opportunity (before insert, before update) {
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && 
    Trigger_Custom_Setting__c.getValues('Default').Disable_TrgOpportunity__c == True)
    return;
    
    for(Opportunity opp : trigger.new){
        if(trigger.isInsert)
            opp.Last_Activity_Date__c = Datetime.now();
        else if(trigger.isUpdate && opp.StageName != trigger.oldmap.get(opp.id).StageName)
            opp.Last_Activity_Date__c = Datetime.now();                
    }    
}