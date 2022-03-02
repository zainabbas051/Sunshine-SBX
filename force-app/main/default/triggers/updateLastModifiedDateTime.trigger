//Test Class : msInsuranceCaseOwnerUpdateTest
trigger updateLastModifiedDateTime on Case (before insert, before update) {
    if(trigger.isInsert){
        for(Case c : Trigger.New){
            c.Last_Modified_Date_Time__c = dateTime.Now();
        }
    }else{
        for(Case c : Trigger.New){
            if(c.Status != trigger.oldMap.get(c.id).Status){
                c.Last_Modified_Date_Time__c = dateTime.Now();
            }
        }    
    }
}