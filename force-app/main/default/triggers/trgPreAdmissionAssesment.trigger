trigger trgPreAdmissionAssesment on Pre_Admission_Assessment__c (after insert,after update) {
    
    
    if((trigger.isInsert || trigger.isUpdate) && trigger.isAfter){
        
        AssesmentTrgHandler.onAfterUpdate(trigger.New);
    }
}