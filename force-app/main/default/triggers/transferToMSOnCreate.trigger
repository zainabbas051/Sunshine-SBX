//Test Class :  TransfertoMSNewCtrlTest
trigger transferToMSOnCreate on Opportunity (After Insert){
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && Trigger_Custom_Setting__c.getValues('Default').transferToMSOnCreate_Disable__c== True)
        return;
    
    Id erpRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId();
    
    for(Opportunity opp : Trigger.New){
        if(opp.recordTypeId == erpRecTypeId && opp.LeadSource != 'Monarch Shores'){
            TransfertoMSNewCtrl tMS = new TransfertoMSNewCtrl(opp.id, True);
        }
    }
}