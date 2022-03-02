//Test Class : msInsuranceCaseOwnerUpdateTest
trigger updateFirstBilled on Case (before Insert) {

    if(Trigger_Custom_Setting__c.getValues('Default') != null && 
    Trigger_Custom_Setting__c.getValues('Default').Disable_OpportunityupdateFirstBilledTrig__c == True)
    return;
    
    List<Opportunity> lstOppty = new List<Opportunity>();
    Set<ID> setOpptyID = new Set<ID>();
    Map<ID,Case> oppIdCaseMap = new Map<Id,Case>();
    
     for(Case c : Trigger.New){
        if(c.Opportunity__c != null && c.RecordTypeId == Constants.insuranceClaimRecordTypeId)
            
            setOpptyID.add(c.Opportunity__c );
            oppIdCaseMap.put(c.Opportunity__c,c);
     
    }
    
    if(setOpptyID.isEmpty())
        return;
    
    lstOppty = [Select ID,Date_of_First_Billed__c FROM Opportunity WHERE Billing_Intitiated__c = false AND ID IN : setOpptyID];
    
    if(lstOppty.isEmpty())
        return;
    
    
    
    for(Opportunity iOppty : lstOppty){
        if(oppIdCaseMap.get(iOppty.ID).Bill_Date__c != null){
            iOppty.Date_of_First_Billed__c = oppIdCaseMap.get(iOppty.ID).Bill_Date__c;
        }else{
            iOppty.Date_of_First_Billed__c = Date.Today();
        }
    }
   
    update lstOppty;

}