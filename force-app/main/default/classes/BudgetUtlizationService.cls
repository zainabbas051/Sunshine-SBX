public class BudgetUtlizationService{

      public static void updateEmployeeRecord(Budget_Utilization__c budgetObj){
         
         if(budgetObj.Year__c != Date.today().Year()){
             return;
         }
         Employee__c emp = new Employee__c();
         emp.Id = budgetObj.RelatedEmployee__c;
         emp.Certificate_Budget_Utilized__c =  budgetObj.Utilized_Budget__c;
         update emp;
    }

}