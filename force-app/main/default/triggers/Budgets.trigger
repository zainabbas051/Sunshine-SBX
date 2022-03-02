trigger Budgets on Budget_Utilization__c (after insert,after update) {
    
    BudgetUtlizationService.updateEmployeeRecord(Trigger.New[0]);
}