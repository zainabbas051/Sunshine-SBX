//Test Class : msInsuranceCaseOwnerUpdateTest
trigger attachInsurance on Case (before insert, before update) {
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && 
    Trigger_Custom_Setting__c.getValues('Default').Disable_attachInsurance__c == True)
    return;
    
    set<Id> oppIdList = new set<Id>();
    List<Insurance_Information__c> iiList = new List<Insurance_Information__c>();
    
    for(Case c : Trigger.New){
        if(c.Insurance_Information__c == null && c.Opportunity__c != null && c.RecordTypeId ==Constants.insuranceClaimRecordTypeId)
            oppIdList.add(c.Opportunity__c);
    }
    
    if(oppIdList.size()>0){
        for(Insurance_Information__c ii : [Select id, Opportunity__c from Insurance_information__c where Opportunity__c IN : oppIdList AND Insurance_Status__c =: 'Primary']){
            for(Case c : Trigger.New){
                if(c.Insurance_Information__c == null && c.Opportunity__c != null && c.RecordTypeId ==Constants.insuranceClaimRecordTypeId){
                    if(ii.Opportunity__c == c.Opportunity__c){
                        c.Insurance_Information__c = ii.id;
                    }
                }
            }
        }
    }
}