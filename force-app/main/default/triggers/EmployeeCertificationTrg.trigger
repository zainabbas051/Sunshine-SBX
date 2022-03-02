trigger EmployeeCertificationTrg on Employee_Certifications__c (after insert,after delete,after update) {
    
    if(trigger.isInsert){
        
        if(trigger.isAfter){
            EmployeeCertification_Handler.updateEmployeeBudget(Trigger.New);
        }
    }
    
     if(trigger.isUpdate){
        
        if(trigger.isAfter){
            EmployeeCertification_Handler.updateEmployeeMandatoryTrainingsInfo(Trigger.New);
        }
    }
    
    if(trigger.isDelete){
        if(trigger.isAfter){
            EmployeeCertification_Handler.addAmountInEmpBudget(Trigger.Old);
        }
    }
    
     if(trigger.isUpdate){
        if(trigger.isAfter){
            if(Trigger.New[0].Status__c == 'Request Denied')
                EmployeeCertification_Handler.addAmountInEmpBudget(Trigger.New);
        }
    }
}