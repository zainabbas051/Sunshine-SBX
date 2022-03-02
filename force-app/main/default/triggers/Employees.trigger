trigger Employees on Employee__c (before insert,after insert,before update,after update,after delete) {
    
    if(trigger.isBefore){
        
       
        
        EmployeeService.updateEmpTierFields(trigger.New);
        
        if(trigger.isUpdate){
            EmployeeService.resetUltimateParent(trigger.New[0],Trigger.oldMap.get(trigger.New[0].Id));
        }
       
        
    }
    
    if(trigger.isAfter){
        if(trigger.isInsert){
           EmployeeService.createBudgetRecord(trigger.New);
           EmployeeService.updateCompleteEmployeeHeirarchy(trigger.New[0],null);
           
        }
        if(trigger.isUpdate){
           EmployeeService.updateCompleteEmployeeHeirarchy(trigger.New[0],Trigger.oldMap.get(trigger.New[0].Id));
           
        }
        
         if(trigger.isDelete){
          
             EmployeeService.updateCompleteEmployeeHeirarchy(trigger.Old[0],null);
             return;
           
        }
        
       
     
        
    
    }
}