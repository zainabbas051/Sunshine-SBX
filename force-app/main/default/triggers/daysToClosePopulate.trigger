//Test Class : daysToClosePopulate_Test
trigger daysToClosePopulate on Opportunity (after update) {
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && 
    Trigger_Custom_Setting__c.getValues('Default').Disable_daysToClosePopulate__c == True)
    return;
    
    list<opportunity> updateOpp = new List<Opportunity>();
    
    for(Opportunity opp : Trigger.New){
        if(opp.StageName == 'Closed' && Trigger.OldMap.get(opp.id).StageName != 'Closed' && opp.Days_to_Close__c == Null){
            Opportunity temp_opp = New Opportunity(id = opp.id);
            temp_opp.Days_to_Close__c = decimal.valueOf(dateTime.Now().getTime() - opp.CreatedDate.getTime())/1000/60/60/24;
            
            updateOpp.add(temp_opp);
        }  
    }
    
    if(updateOpp.isEmpty() == false)
        update updateOpp;
    
}