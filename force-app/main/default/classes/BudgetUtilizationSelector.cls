public Inherited sharing class BudgetUtilizationSelector{

    public static List< Budget_Utilization__c > getCurrentBudget(Set<string> setOfEmpIds){
        
        return [Select ID FROM Budget_Utilization__c
                 WHERE RelatedEmployee__c IN : setOfEmpIds
                 and YEAR__C =: Date.today().year() limit 1];
        
    }
    
}