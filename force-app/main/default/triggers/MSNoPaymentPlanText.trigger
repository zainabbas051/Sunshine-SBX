//Test Class : MSNoPaymentPlanTextTest
trigger MSNoPaymentPlanText on Opportunity (after insert, after update) {
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && 
    Trigger_Custom_Setting__c.getValues('Default').Disable_MSNoPaymentPlanText__c == True)
    return;
    
    Id recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();//Getting the id of Monarch Shore Opportunity Record Type
    Map<String,String> userSMSMap = new Map<String,String>();
    for(Opportunity opp : Trigger.New){
        if(opp.RecordTypeId == recTypeId && opp.StageName == 'Admitted' && opp.StageName != trigger.OldMap?.get(opp.id).StageName && opp.No_of_Related_Payment_Plans__c == 0){
            String smsBody = opp.Name+', has been Admitted with a Payment Plan on '+date.Today();
            userSMSMap.put(label.Tahil_User_Id,smsBody);
            userSMSMap.put(label.Jenny_User_Id,smsBody);
            userSMSMap.put(label.Lynelle_Smith_Id,smsBody);
            userSMSMap.put(label.Tori_User_Id,smsBody);
        }
    } 
    system.debug('userSMSMap :::'+userSMSMap);
    if(userSMSMap.keySet().size()>0){
        Utilities.sendSMS(userSMSMap);
    }
}